<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Admin.aspx.cs" Inherits="Admin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>WSQuest - Admin</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h2>Admin Guidelines</h2>
        <h3>1. Questionnaire Links</h3>
        <ul>
            <li>
                Send following links to a participant with a userid of 1. Please keep in mind that <i style="color:orange">userid(u)</i> can easily alter userid value via url querystring.
                <br/>
                <span style="color:Red;">You can consider hashing querystrings, or setup authentication mechanisms to provide secure login isolation!</span>
                <br/><br/>
                <a runat="server" href='<%# UrlCreator.BuildUrl(1,0) %>'>Questionnaire of user 1: (Welcome page first)</a>
                Ex: ~/Default.aspx?pn=0&<i style="color:orange">u=1</i>&s=1&lp=0
                <br/>
                <a runat="server" href='<%# UrlCreator.BuildUrl(1,1) %>'>Questionnaire of user 1: (Questions page directly)</a>
                <br/>
                <a runat="server" href='<%# UrlCreator.BuildUrl(2,0) %>'>Questionnaire of user 2: (Welcome page first)</a>
            </li>
        </ul>
        
        <hr/>
        <div>
            <h3>2. Data storage</h3>
            <b>QuestionRepository: </b>
            Default questions (from AnlamVer dataset) are located in the AppData folder. You can change path of the excel file from web.config file or alternatively you can fetch questions from alternative IQuestionsRepository data provider. Modify DataService.cs class to register your custom data providers(repositories). 
            <br/><br/>

            <b>AnswerRepository:</b>
            Users' answers will be stored in the server memory via InMemoryAnswerRepository class. <span style="color:red">Note that InMemoryAnswerRepository stores information temporarily and the server memory releases on every application restart.</span>Implement your own IAnswerRepository for a more reliable and persistent data storage solution. 
        </div>
        
        <hr/>
        <div>
            <h3>3. User Interface and Guidelines</h3>
            All user interface texts and questionnaire guidelines are from the original AnlamVer dataset. Therefore, all text elements are Turkish.<br/>
            AnlamVer dataset asks for 1000 word-pair questions in total. Questionnaire consists of two sections (Similarity and Relatedness). Every section includes 500 questions in 25 pages where every page include 20 word-pair questions. 
            Some implementations include hardcoded pagesizes(20), or number-of-pages=25 which you might need to alter manually based on your own Questionnaire setup.
        </div>

        <hr/>
        <div>
            <h3>4. Results</h3>
            You can download all answers of all users from the report page below.<br/>
            <asp:HyperLink runat="server" NavigateUrl='<%# UrlCreator.Report() %>'>REPORTS</asp:HyperLink>
        </div>
        
        <hr/>
        <div>
            <h3>5. Security</h3>
            <span style="color:red;">
            You may want to block access to Admin.aspx and Report.aspx pages on production!
            </span>
        </div>
    </div>
    </form>
</body>
</html>
