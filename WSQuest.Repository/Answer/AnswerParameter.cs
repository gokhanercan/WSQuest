using System.Collections.Generic;

namespace WSQuest.Repository.Answer
{
    public class AnswerParameter
    {
        public List<int> QuestionIDs = new List<int>();
        public int? UserID { get; set; }
    }
}
