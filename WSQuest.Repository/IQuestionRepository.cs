using System.Collections.Generic;
using WSQuest.Entity;

namespace WSQuest.Repository
{
    public interface IQuestionRepository
    {
        Dictionary<int, Question> LoadQuestions();
    }
}