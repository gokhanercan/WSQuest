using System;

namespace WSQuest.Entity
{
    public class Answer
    {
        public int AnswerId { get; set; }
        public int QuestionId { get; set; }
        public int UserId { get; set; }

        public int? Value { get; set; }         //Nullable type. User is allowed to left the answers blank.

        public DateTime InsertionDate { get; set; }
        public DateTime UpdateDate { get; set; }
    }
}
