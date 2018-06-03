<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="Report.aspx.cs" Inherits="Works_Report" %>

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, user-scalable=no"/>
    <meta charset="UTF-8"/>
    <title>WSQuest - Reports</title>    
</head>

<body>
    <form id="form1" runat="server" style="display:inline !important;">

    <asp:HyperLink runat="server" id="hyp" style="float:right;" NavigateUrl='<%# UrlCreator.Admin() %>'>ADMIN</asp:HyperLink>
    <b>Users</b>
    <asp:GridView runat="server" ID="grdDistinctUsers" AutoGenerateColumns="false" EmptyDataText="No users participated yet!">
        <Columns>
            <asp:TemplateField HeaderText="#">
                <ItemTemplate>
                    <%# Container.DataItemIndex+1 %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="UserId">
                <ItemTemplate>
                    <%# Container.DataItem %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Survey">
                <ItemTemplate>
                    <asp:HyperLink runat="server" NavigateUrl='<%# UrlCreator.BuildUrl((int) Container.DataItem) %>' Target="_blank">
                        Goto Questionnaire
                    </asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Answers / Blanks">
                <ItemTemplate>
                    <%# Answers.Count(a=>a.UserId == (int) Container.DataItem && a.Value != null) %>
                    /
                    <%# Answers.Count(a=>a.UserId == (int) Container.DataItem && a.Value == null) %>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    
    <hr/>
    
    <asp:Button ID="btnExport" runat="server" Text="ExportResults.xlsx" OnClick="btnExport_Click" />

</form>
</body>
</html>
