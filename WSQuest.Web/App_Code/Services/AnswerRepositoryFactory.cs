using WSQuest.Repository.Answer;

namespace Services
{
    public static class AnswerRepositoryFactory
    {
        private static InMemoryAnswerRepository _SingletonRepo = new InMemoryAnswerRepository(1000);      //TODO: Get from appsettings.
        private static readonly object _Objectlock = new object();

        public static IAnswerRepository CreateAnswerRepository(int nrOfQuestions)
        {
            if (_SingletonRepo == null)
                lock(_Objectlock)
                {
                    if (_SingletonRepo == null)
                    {
                        _SingletonRepo = new InMemoryAnswerRepository(nrOfQuestions);    
                    }
                }
            return _SingletonRepo;
        }
    }
}