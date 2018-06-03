
using System;

namespace WSQuest.Entity
{
    [Serializable]
    public class Question
    {
        public int QID { get; set; }
        public string Word1 { get; set; }
        public string Word2 { get; set; }
        public QuestionTypes QType { get; set; }

        //optional.
        public int? AnswerValue { get; set; }

        public Question(int qid, string word1, string word2, QuestionTypes qType)
        {
            QID = qid;
            Word1 = word1;
            Word2 = word2;
            QType = qType;
        }

        #region Overrides of Object

        public override string ToString()
        {
            return string.Format("{0} - {1} ({2})", Word1, Word2, QType);
        }

        #endregion
    }
}