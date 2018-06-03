using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using OfficeOpenXml;
using WSQuest.Entity;

namespace WSQuest.Repository
{
    public class ExcelQuestionRepository : IQuestionRepository
    {
        public string ExcelDataPath { get; set; }

        public ExcelQuestionRepository(string excelDataPath)
        {
            if (excelDataPath == null) throw new ArgumentNullException("ExcelDataPath must be provided!");
            ExcelDataPath = excelDataPath;
        }

        public Dictionary<int, Question> LoadQuestions()
        {
            var package = new ExcelPackage(new FileInfo(ExcelDataPath));
            ExcelWorksheet workSheet = package.Workbook.Worksheets[1];

            var dict = new Dictionary<int, Question>();

            for (int i = workSheet.Dimension.Start.Row+1;
                i <= workSheet.Dimension.End.Row;
                i++)
            {
                try
                {
                    int qid = Convert.ToInt32(workSheet.Cells[i, 1].Value);
                    string word1 = ((string)workSheet.Cells[i, 2].Value).Trim().ToLower(new CultureInfo("tr-TR"));
                    string word2 = ((string)workSheet.Cells[i, 3].Value).Trim().ToLower(new CultureInfo("tr-TR"));
                    string qtype = ((string)workSheet.Cells[i, 4].Value).Trim().ToLowerInvariant();
                    Question q = new Question(qid, word1, word2, qtype == "sim" ? QuestionTypes.Similarity : QuestionTypes.Relatedness);
                    dict.Add(qid, q);
                }
                catch (Exception)
                {
                    //
                }

            }
            return dict;
        }
    }
}