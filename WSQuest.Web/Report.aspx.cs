using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using MoreLinq;
using OfficeOpenXml;
using Services;
using WSQuest.Entity;
using WSQuest.Repository.Answer;

public partial class Works_Report : Page
{
    public List<Answer> Answers;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            IAnswerRepository repo = new DataService().GetAnswerRepository();
            Answers = repo.GetAnswers();

            grdDistinctUsers.DataSource = GetUserIds();
            grdDistinctUsers.DataBind();
        }
        DataBind();
    }

    public List<int> GetUserIds()
    {
        var useridsToExclude = new[] { 16, 23 };      //Tamamlamadıkları için exclude edilen anketler.
        var userids = Answers.DistinctBy(a => a.UserId).Select(a => a.UserId).OrderBy(a => a).ToList();
        useridsToExclude.ForEach(a => userids.Remove(a));
        return userids;
    }

    private void BindReport()
    {
        var dataService = new DataService();
        IAnswerRepository repo = dataService.GetAnswerRepository();
        Answers = repo.GetAnswers();
        
        var qRepo = dataService.GetQuestionRepository();
        var questions = qRepo.LoadQuestions();

        var userids = GetUserIds();

        ExcelPackage pck = new ExcelPackage();
        var wsSim = pck.Workbook.Worksheets.Add("Answers");
        wsSim.Cells[1, 1].Value = "QID";
        wsSim.Cells[1, 2].Value = "W1";
        wsSim.Cells[1, 3].Value = "W2";
        int columnId = 4;
        foreach (int userid in userids)
        {
            wsSim.Cells[1, columnId].Value = "U"+ userid;
            columnId++;
        }

        columnId = 4;
        for (int qid = 1; qid <= questions.Count; qid++)
        {
            //Sim
            wsSim.Cells[qid + 1, 1].Value = qid;
            
            //user answers
            foreach (int userid in userids)
            {
                //paid
                string w1 = questions[qid].Word1;
                string w2 = questions[qid].Word2;
                wsSim.Cells[qid + 1, 2].Value = w1;
                wsSim.Cells[qid + 1, 3].Value = w2;

                //sim
                var answer = Answers.SingleOrDefault(a=>a.QuestionId == qid && a.UserId == userid);
                if (answer != null)
                {
                    wsSim.Cells[qid + 1, columnId].Value = answer.Value;
                }
                columnId++;
            }
            columnId = 4;
        }

        //freeze
        wsSim.View.FreezePanes(2,4);

        //Output
        const string filename = "WSQuestResults.xlsx";
        Response.Clear();
        Response.AddHeader("content-disposition", string.Format("attachment;  filename={0}", filename));
        Response.BinaryWrite(pck.GetAsByteArray());
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        Response.End();

    }
    protected void btnExport_Click(object sender, EventArgs e)
    {
        BindReport();
    }
}