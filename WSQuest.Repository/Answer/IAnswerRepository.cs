using System.Collections.Generic;

namespace WSQuest.Repository.Answer
{
    public interface IAnswerRepository
    {
        //load from data source.
        List<Entity.Answer> GetAnswers(AnswerParameter p = null);
        
        //update data source
        void SyncAnswers(List<Entity.Answer> uiAnswers, int userID);
    }
}
