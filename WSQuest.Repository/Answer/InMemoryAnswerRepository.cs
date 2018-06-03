
using System;
using System.Collections.Generic;
using System.Linq;

namespace WSQuest.Repository.Answer
{
    /// <summary>
    /// Stores user's answers on application session instead of a persistent data storage.
    /// </summary>
    public class InMemoryAnswerRepository : IAnswerRepository
    {
        private readonly int NrOfQuestions;
        private readonly Dictionary<int, List<Entity.Answer>> _UserAnswers = new Dictionary<int, List<Entity.Answer>>();

        public InMemoryAnswerRepository(int nrOfQuestions)
        {
            NrOfQuestions = nrOfQuestions;
        }

        #region Implementation of IAnswerRepository

        public List<Entity.Answer> GetAnswers(AnswerParameter p = null)
        {
            if (p==null)p=new AnswerParameter();

            //User's answers.
            if (p.UserID.HasValue)
            {
                List<Entity.Answer> answers = null;
                if (_UserAnswers.ContainsKey(p.UserID.Value))
                {
                    answers = _UserAnswers[p.UserID.Value];
                }
                else
                {
                    answers = new List<Entity.Answer>();
                    //Add null answr
                    for (int i = 0; i < NrOfQuestions; i++)
                    {
                        int qid = i + 1;
                        answers.Add(new Entity.Answer(){QuestionId = qid, Value = null, UserId = p.UserID.Value} );
                    }
                    _UserAnswers.Add(p.UserID.Value, answers);
                }
                return answers;
            }
            else
            {
                //return all answers of all users.
                return _UserAnswers.SelectMany(i => i.Value).ToList();
            }
        }

        public void SyncAnswers(List<Entity.Answer> uiAnswers, int userID)
        {
            AnswerParameter p = new AnswerParameter();
            p.UserID = userID;
            uiAnswers.ForEach(a => p.QuestionIDs.Add(a.QuestionId));
            var dbAnswers = GetAnswers(p);
            foreach (Entity.Answer uiAnswer in uiAnswers)
            {
                var dbAnswer = dbAnswers.SingleOrDefault(a => a.QuestionId == uiAnswer.QuestionId);
                if (dbAnswer == null)
                {
                    //new
                    dbAnswer = new Entity.Answer() { InsertionDate = DateTime.Now };
                    dbAnswers.Add(dbAnswer);
                }
                SetAnswerEntity(uiAnswer, dbAnswer);        //Sets changing values to inmemory storage.
                dbAnswer.UpdateDate = DateTime.Now;
            }
        }

        protected virtual void SetAnswerEntity(Entity.Answer fromAnswer, Entity.Answer toAnswer)
        {
            toAnswer.QuestionId = fromAnswer.QuestionId;
            toAnswer.Value = fromAnswer.Value;
            toAnswer.UserId = fromAnswer.UserId;
        }

        #endregion
    }
}
