using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using Services;
using WSQuest.Entity;
using WSQuest.Repository.Answer;

// ReSharper disable once InconsistentNaming
// ReSharper disable once CheckNamespace
public partial class Default : Page
{
    private const QuestionTypes DefaultQuestionType = QuestionTypes.Similarity;
    private const int PageSize = 20;

    public QuestionTypes QuestionType
    {
        get
        {
            var val = PageNumberQS > 25 ? QuestionTypes.Relatedness : QuestionTypes.Similarity;
            return (QuestionTypes) Enum.Parse(typeof (QuestionTypes), val.ToString());
        }
    }
    public int PageNumberQS
    {
        get
        {
            return ParseIntQuerystring("pn") ?? 1;
        }
    }
    public bool LandingPageQS
    {
        get
        {
            return ParseBoolQuerystring("lp") ?? false;
        }
    }
    public int UserIDQS
    {
        get
        {
            var userid = ParseIntQuerystring("u");
            if (userid == null) {
                //throw new Exception("Missing questionnaire parameter. Userid.");
                Response.Redirect(UrlCreator.Admin());
            }
            return userid.Value;
        }
    }
    public bool AutoScrollQS
    {
        get
        {
            var userid = ParseBoolQuerystring("s");
            if (userid == null) return true;        //default is 1
            return userid.Value;
        }
    }
    public int NrOfQuestions;

    public int Repeater1QID { get; set; }
    public int Repeater1QIndex { get; set; }
    public int? Repeater1AnswerValue { get; set; }

    private DataService DataService;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            SetControls();
           
            DataService = new DataService();
            var questions = DataService.GetQuestions();       
            var pageQuestions = questions.Skip((PageNumberQS-1)*PageSize).Take(PageSize).ToDictionary(a=>a.Key,b=>b.Value);
            var p = new AnswerParameter() {UserID = UserIDQS};
            var pageIndex = ((PageSize*(PageNumberQS - 1)) + 1);
            p.QuestionIDs = Enumerable.Range(pageIndex, PageSize).ToList();
            var answers = DataService.GetAnswerRepository().GetAnswers(p);
            foreach (Answer answer in answers)
            {
                Question ques;
                if (pageQuestions.TryGetValue(answer.QuestionId, out ques))
                {
                    ques.AnswerValue = answer.Value;
                }
            }
            rptQuestions.DataSource = from q in pageQuestions.Where(q => q.Value.QType == QuestionType) select q;
            rptQuestions.DataBind();
            NrOfQuestions = rptQuestions.Items.Count;
        }
    }

    private void SetControls()
    {
        //common
        chkAutoScroll.Checked = AutoScrollQS;
        navBottom.DataBind();
        divRelatednessLanding.Visible = false;
        divSimilarityLanding.Visible = false;
        divDialogEnding.Visible = false;
        divAutoScroll.Visible = true;

        //BY PAGE NUMBERS
        if (PageNumberQS == 0)          //initial page.
        {
            btnPrev.Enabled = false;
            divDialog.Visible = true;
            divQuestion.Visible = false;
            divPageGuidesSim.Visible = false;
            divPageGuidesRel.Visible = false;
            divValidator.Visible = false;
            btnNext.Text = "Başla";     //start
            btnPrev.Visible = false;
            divAutoScroll.Visible = false;
        }
        else if (PageNumberQS > 50)        //last page
        {
            divDialog.Visible = false;
            divQuestion.Visible = true;
            divPageGuidesSim.Visible = false;
            divPageGuidesRel.Visible = false;
            divDialogEnding.Visible = true;
            divAutoScroll.Visible = false;
            btnPrev.Enabled = true;
            btnNext.Visible = false;
        }
        else                                //other pages.
        {
            divDialog.Visible = false;
            divQuestion.Visible = true;
            divPageGuidesSim.Visible = QuestionType == QuestionTypes.Similarity;
            divPageGuidesRel.Visible = QuestionType == QuestionTypes.Relatedness;
            divValidator.Visible = true;
            btnNext.Text = "İleri";     //Next page.
            btnPrev.Enabled = true;
        }

        //ilk sayfa
        if (PageNumberQS == 1)
        {
            if (LandingPageQS)
            {
                divPageGuidesSim.Visible = false;
                divPageGuidesRel.Visible = false;
                divSimilarityLanding.Visible = true;
                divQuestion.Visible = false;
                divValidator.Visible = false;
                divAutoScroll.Visible = false;
            }
        }

        //2. portion
        if (PageNumberQS == 26)     //TODO: hardcoded pagesize.
        {
            if (LandingPageQS)
            {
                divPageGuidesSim.Visible = false;
                divPageGuidesRel.Visible = false;
                divRelatednessLanding.Visible = true;
                divQuestion.Visible = false;
                divValidator.Visible = false;
                divAutoScroll.Visible = false;
            }
        }
    }

    protected void rptQuestions_ItemCreated(object sender, RepeaterItemEventArgs e)
    {
        var pair = ((KeyValuePair<int, Question>) e.Item.DataItem);
        Repeater1QID = pair.Value.QID;
        if (Repeater1QIndex == 0)
            Repeater1QIndex = 1;
        else
            Repeater1QIndex++;

        if (pair.Value.AnswerValue.HasValue)
        {
            Repeater1AnswerValue = pair.Value.AnswerValue;
        }
        else
        {
            Repeater1AnswerValue = null;
        }
    }
    protected void btnNext_Click(object sender, EventArgs e)
    {
        if (PageNumberQS > 0 && !LandingPageQS)
        {
            SyncPostPage();
        }

        //Redirect
        bool autoScroll = chkAutoScroll.Checked;
        string url = UrlCreator.BuildUrl(UserIDQS, PageNumberQS + 1, false, autoScroll);    
        if (PageNumberQS == 0)     //go to landing page
        {
            url = UrlCreator.BuildUrl(UserIDQS, PageNumberQS + 1, true, autoScroll);
        }
        if (PageNumberQS == 1 && LandingPageQS)
        {
            url = UrlCreator.BuildUrl(UserIDQS, PageNumberQS, false, autoScroll);
        }
        if (PageNumberQS == 25)     //TODO: Hardcoded pagesize.
        {
            url = UrlCreator.BuildUrl(UserIDQS, PageNumberQS + 1, true, autoScroll);
        }
        if (PageNumberQS == 26 && LandingPageQS)        //TODO: hardcoded pagesize.
        {
            url = UrlCreator.BuildUrl(UserIDQS, PageNumberQS, false, autoScroll);
        }

        Response.Redirect(url);
    }
    protected void btnPrev_Click(object sender, EventArgs e)
    {
        //TODO: Son page'den geri dönmek isterse son sayfada update ederek dönme.
        if (PageNumberQS > 0 && !LandingPageQS)
        {
            SyncPostPage();
        }

        //Redirect
        bool autoScroll = chkAutoScroll.Checked;
        var url = UrlCreator.BuildUrl(UserIDQS, PageNumberQS - 1, false, autoScroll);
        if (PageNumberQS == 1 || PageNumberQS == 26)
        {
            if (!LandingPageQS)
            {
                url = UrlCreator.BuildUrl(UserIDQS, PageNumberQS, true, autoScroll);    
            }
        }
        Response.Redirect(url);
    }

    /// <summary>
    /// Writes user's answers to data storage.
    /// </summary>
    public void SyncPostPage()
    {
        //Load answers.
        var str = hfAnswers.Value;
        var arr = JsonConvert.DeserializeObject<string[]>(str);
        List<Answer> answers = new List<Answer>();
        for (int i = 1; i < arr.Length; i++)
        {
            var val = arr[i];
            var qid = ((PageNumberQS - 1) * PageSize) + i;
            var answer = new Answer()
            {
                QuestionId = qid,
                UserId = UserIDQS,
                Value = val == null ? (int?)null : int.Parse(val)
            };
            answers.Add(answer);
        }

        //Save/persist.
        var answerRepo = new DataService().GetAnswerRepository();
        answerRepo.SyncAnswers(answers, UserIDQS);
    }

    #region Querystring Helpers

    public int? ParseIntQuerystring(string key)
    {
        int value;
        bool result = Int32.TryParse(Request.QueryString[key], out value);
        return (result) ? value : (int?)null;
    }
    public bool? ParseBoolQuerystring(string key)
    {
        bool value;
        bool result = Boolean.TryParse(Request.QueryString[key], out value);
        if (!result)
        {
            if (Request.QueryString[key] == "1")
            {
                value = true;
                result = true;
            }
            else if (Request.QueryString[key] == "0")
            {
                value = false;
                result = true;
            }
        }

        return (result) ? value : (bool?)null;
    }

    #endregion
}