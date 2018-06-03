using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.Web;
using WSQuest.Entity;
using WSQuest.Repository;
using WSQuest.Repository.Answer;

namespace Services
{
    public class DataService
    {
        #region Repositories

        public virtual IQuestionRepository GetQuestionRepository()
        {
            //set your questions data provider here..
            var path = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["ExcelDataPath"]);
            return new ExcelQuestionRepository(path);
        }

        public virtual IAnswerRepository GetAnswerRepository()
        {
            // BEWARE!: Do not use this on production. Consider implementing your own data storage.  
            return AnswerRepositoryFactory.CreateAnswerRepository(1000);
        }

        #endregion
        
        public Dictionary<int, Question> GetQuestions()
        {
            var s = HttpContext.Current.Session;
            if (s["ExcelData"] == null)
            {
                var repo = GetQuestionRepository();
                var questions = repo.LoadQuestions();
                s["ExcelData"] = questions;
                return (Dictionary<int, Question>) CloneObject(questions);
            }
            else
            {
                return (Dictionary<int, Question>) CloneObject((Dictionary<int, Question>) s["ExcelData"]);
            }
        }

        protected virtual object CloneObject(object o)
        {
            MemoryStream ms = new MemoryStream();
            BinaryFormatter bf = new BinaryFormatter(null, new StreamingContext(StreamingContextStates.Clone));
            bf.Serialize(ms, o);
            ms.Seek(0, SeekOrigin.Begin);
            object oOut = bf.Deserialize(ms);
            ms.Close();
            return oOut;
        }
    }
}