
public static class UrlCreator
{
    public static string BuildUrl(int userID, int? pn = 1, bool? landingPage = false, bool? autoScroll = true)
    {
        string url = "~/Default.aspx";
        if (pn.HasValue) url = AddQuerystring(url, "pn", pn.Value.ToString());
        url = AddQuerystring(url, "u", userID.ToString());
        if (autoScroll.HasValue) url = AddQuerystring(url, "s", autoScroll.Value ? "1" : "0");
        if (landingPage.HasValue) url = AddQuerystring(url, "lp", landingPage.Value ? "1" : "0");
        return url;
    }

    public static string Admin()
    {
        return "~/Admin.aspx";
    }
    public static string Report()
    {
        return "~/Report.aspx";
    }

    #region Helpers
    private static string AddQuerystring(string url, string key, string value)
    {
        return url + GetQuerystringKeyValueToAdd(url, key, value);
    }
    private static string GetQuerystringKeyValueToAdd(string url, string key, object value)
    {
        if (value != null)
        {
            return string.Format("{0}{1}={2}", GetFirstQuerystringPrefix(url), key, value);
        }
        else
        {
            return "";
        }
    }
    private static string GetFirstQuerystringPrefix(string url)
    {
        return url.Contains("?") ? "&" : "?";
    }
    #endregion

}