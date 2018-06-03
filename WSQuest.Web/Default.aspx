<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default"  %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="WSQuest.Entity" %>

<%@ Register Src="~/UserControls/ucTopmenu.ascx" TagPrefix="uc1" TagName="ucTopmenu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, user-scalable=no"/>
    <meta charset="UTF-8"/>
    
    <title>WSQuest - Questionnaire</title>
    
    <script type='application/javascript' src='fastclick.js'></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous"/>
    <link href="Anlamver.css?v=2" rel="stylesheet" runat="server"/>
    <script src="https://code.jquery.com/jquery-1.12.4.js" type="text/javascript"></script>
    <script>
        var NrOfQuestions = <%= NrOfQuestions %>;
    </script>
    <script src="Anlamver.js?v=2" type="text/javascript"></script>

</head>
    
<body>
    <form id="form1" runat="server" style="display:inline !important;">
    <uc1:ucTopmenu runat="server" ID="ucTopmenu" Visible="false" />

    <div class="container-fluid main-content">
      <div class="row">
          
        <div class="col-sm-12 col-sm-offset-0 col-md-12 col-md-offset-0 main">
            
        <%--Core content--%>
        <div class="icerik" style="margin-top:15px;">
            
            <div class="checkbox" style="float:right;" runat="server" id="divAutoScroll" Visible="true">
                    <label><input runat="server" type="checkbox" checked="checked" id="chkAutoScroll"/>Otomatik olarak alttaki soruya geç</label>
            </div>

            <div class="pageGuides" id="divPageGuidesSim" runat="server" Visible="true">
                <div style="text-align:left; font-size:large; display:inline1;" class="lead" >
                    <b><span class="lead" style=""><b><u><%= QuestionType == QuestionTypes.Relatedness ? 
                                                     "İlişkisellik".ToUpper(new CultureInfo("tr-TR")) : 
                                                     "Benzerlik".ToUpper(new CultureInfo("tr-TR")) %>:</u></b></span></b>
                    İki kelime, aynı <u>şey</u>, <u>kişi</u>, <u>kavram</u>, <u>durum</u> ya da <u>eylem</u>i işaret ediyor ise benzerdir.
                    <ul>
                        <li>"kahve" ve "çay" oldukça benzer.</li>
                        <li>"öğrenci" ve "talebe" eş anlamlıdırlar ve çok benzerler.</li>
                        <li>"iyi" ve "kötü" zıt anlamlıdır, hiç benzemez.</li>
                        <li>"araba" ve "benzin" ilişkili olmalarına rağmen benzemezler. Biri taşıt diğeri ise yakıttır.</li>
                    </ul>
                </div>
              
            </div>
            <div class="pageGuides" id="divPageGuidesRel" runat="server" Visible="false">
                <div style="text-align:left; font-size:large; display:inline1;" class="lead" >
                    <b><span class="lead" style=""><b><u><%= QuestionType == QuestionTypes.Relatedness ? 
                                                     "İlişkisellik".ToUpper(new CultureInfo("tr-TR")) : 
                                                     "Benzerlik".ToUpper(new CultureInfo("tr-TR")) %>:</u></b></span></b>
                    Yüksek ilişkili kelimeler birbirleri ile alakalıdırlar ve sıklıkla bir arada kullanılır, birbirlerini hatırlatırlar.
                    <ul>
                        <li>"benzin" ve "araba" kelimeleri sıklıkla benzer bağlamlarda geçerler ve oldukça ilişkilidirler.</li>
                        <li>"kahve" ve "fincan" kelimeleri birbirlerini hatırlatırlar, oldukça ilişkilidirler.</li>
                        <li>"faiz" ve "fincan" kelimeleri oldukça ilişkisizdirler.</li>
                        <li>"iyi" ve "kötü" gibi zıt anlamlı kelimeler oldukça ilişkilidirler.</li>
                        <li>"öğrenci" ve "talebe" gibi yüksek benzerlikte kelimeler genellikle aynı bağlamlarda geçerler ve oldukça ilişkilidirler.</li>
                    </ul>
                </div>
              
            </div>
            <br/>

            <div id="divQuestion" runat="server" Visible="false">
                <asp:Repeater ID="rptQuestions" runat="server" OnItemCreated="rptQuestions_ItemCreated" EnableViewState="false" >
                    
                <ItemTemplate>
                <%--Question--%>
                <div class="well lead" style="" id='div<%# Eval("Key") %>'>
                    <a class="qb"><b class="qb" style="float:left; font-size:large;">Soru <%# Eval("Key") %>)</b></a>
                    <asp:Label ID="lblWord1" CssClass="label1 word" runat="server" Text='<%# Eval("Value.Word1") %>' style="margin-left:-40px;" ></asp:Label>
                    -
                    <asp:Label ID="lblWord2" CssClass="label2 word" runat="server" Text='<%# Eval("Value.Word2") %>' style="" ></asp:Label>
                        
                    <div class="btn-group btn-group-lg btn-group-justified" q='<%# Container.DataItem %>' style="padding-top:10px;" role="button"  data-toggle="buttons" aria-label='g<%# Container.DataItem %>'>
                        <asp:Repeater ID="rptChoices" runat="server" DataSource='<%# new []{0,1,2,3,4,5,6,7,8,9,10} %>' EnableViewState="false">
                            <ItemTemplate>
                                <a href="javascript: void(0);" aria-pressed="true"  class="btn btn-default qbtn" qindex='<%# Repeater1QIndex %>'
                                    c='<%# Container.DataItem %>' q='<%# Repeater1QID != null ? Repeater1QID.ToString() : "0" %>' 
                                    choice='<%# Repeater1AnswerValue == (int)Container.DataItem  ? "1" : "0" %>' >
                                    <%# Container.DataItem %>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
                </ItemTemplate>
                </asp:Repeater>
            </div>
        
            <div class="lead well text-al" id="divDialog" runat="server" Visible="true" style="text-align:left; font-size:large;">
                <p>Merhaba,</p>
                <p>Katılmak üzere olduğunuz veri etiketleme anketi, yapay zeka alanında yapmakta olduğum akademik çalışmama katkı sağlayabilmek için tasarlanmıştır. 
                    Çalışma kapsamı ve kuralları aşağıda özetlenmiştir;</p>
              
                <ol class="guide">
                    <li>Size verilecek kelime çiftlerine 0 ile 10 arasında puan vermeniz istenmektedir.</li>
                    <li>Anket 500'er kelime çiftinden oluşan 2 bölümden oluşmaktadır. Ara vermeden yapıldığında yaklaşık 1 - 1.5 saat sürmesi beklenmektedir. </li>
                    <li>Sorular için süre kısıtlaması yoktur. 3 gün boyunca (30.09.17 - 01.10.17) istediğiniz kadar ara verip kaldığınız yerden devam edebilirsiniz.</li>
                    <li>Size yöneltilen 2 tip sorunun <b>(benzerlik ve ilişkisellik)</b> kavramsal olarak <u> farklarının anlaşılması önemlidir.</u> Bu konu dışında herhangi bir bilgi birikimi ya da ek dikkat gerektirmeyecektir.</li>
                    <li>Hiçbir sorunun doğru cevabı yoktur. Kendi öznel yargılarınıza göre en uygun cevabı vermeniz yeterlidir.</li>
                    <li>Lütfen tüm soruları kendiniz cevaplayınız.</li>
                    <li>Bilmediğiniz kelime çıkması durumunda araştırabilir, sorabilir ya da boş bırakabilirsiniz.</li>
                    <li>Bazı kelimeler ilk bakışta hatalı, garip ve uydurulmuş gibi gelebilir. Ne kadar alışılmadık olsa da önemli olan o kelimeyi okuduğunuzda zihninizde oluşan anlamıdır.</li>
                    <li>Vereceğiniz puanların eşit dağılması gerekmemektedir. Örneğin sürekli olarak yaklaşık düşük puanlar veriyor olmanız normaldir.</li>
                    <li>Geniş ekranlı telefon ya da tablet cihazınızdan soruları dokunmatik olarak daha hızlı cevaplayabilirsiniz.</li>
                    <li>Siz ekranlar arasında ilerlerdikçe her ekran sonunda verdiğiniz cevaplar otomatik olarak kaydedilecektir.</li>
                </ol>
                   
                <br/>
                <p>Sabrınız ve desteğiniz için şimdiden teşekkürler.</p>
                <br/>
                <p style="">Gökhan Ercan</p>
            </div>
            
            <div class="lead well text-al" id="divSimilarityLanding" runat="server" Visible="false" style="text-align:left;">
                <h3><b>BÖLÜM 1: BENZERLİK</b></h3>
                <br/>
                
                <ol class="guide">
                    <li>İki kelime, aynı <b>şey</b>, <b>kişi</b>, <b>kavram</b>, <b>durum</b> ya da <b>eylem</b>i işaret ediyor ise <b>benzer</b>dir.</li>
                    <li>Benzer şeyler ortak soyut ya da somut <b>özniteliklerlere</b> sahiptirler.
                    <br/>
                    Örneğin; <b>"çay"</b> ile <b>"kahve"</b> birbirlerine <u>oldukça</u> benzerler. İkisi de doğadan elde edilen, sıcak içilen, rahatlatıcı, dost sohbetlerinin değişilmez içecekleridir.
                    </li>
                    <li>İki şey birbirine %100 benziyor ise eş anlamlıdır. Eş anlamlılara en <u>yüksek</u> puanlarınızı veriniz.
                        <br/>
                    Örneğin: <b>"öğrenci"</b> ile <b>"talebe"</b> eş anlamlıdır.
                    </li>
                    
                    <li>İki şey birbirlerine zıt anlamlar ifade ediyorlarsa en <u>düşük</u> puanlarınızı veriniz.
                        <br/>
                    Örneğin; <b>"iyi"</b> ile <b>"kötü"</b> birbirlerine hiç <b>benzemezler</b>.
                    </li>
                    
                    <li><b>İpucu:</b> Benzerlik derecesi arttıkça, kelimeler anlamı bozmadan birbirlerinin yerine kullanılabilirler.
                        <br/>
                        Örneğin; <i>"Çok <u>serin</u> burası."</i> &nbsp;  yerine  &nbsp; <i>"Çok <u>soğuk</u> burası."</i> kullanılması cümleyi fazla anlam kaybına uğratmaz.
                    </li>
                    
                    <li><b>Son olarak; kelimelerin birlikte kullanılıyor olması benzer oldukları anlamında gelmez.</b></li>
                    Örneğin; <b>"araba"</b> ile <b>"benzin"</b> birlikte sık kullanılan iki kelime olmalarına rağmen <b>benzer değildirler. </b>
                    <br />
                    <b>"araba"</b>, bir taşıt iken <b>"benzin"</b> bir yakıttır. Benzer olmalarını sağlayacak ortak nitelikleri yok denecek kadar azdır.
                    
                    <li>Verilen örneklere anket sırasında da erişebileceksiniz. Cevaplara emin olamamanız durumunda örnekleri incelemenizi tavsiye ederiz.</li>
                </ol>
            </div>

            <div class="lead well text-al" id="divRelatednessLanding" runat="server" Visible="false" style="text-align:left; font-size:large;">
                <h3><b>BÖLÜM 2: İLİŞKİSELLİK</b></h3>
                
                <ol class="guide">
                    <li>Bu bölümde aynı kelime çiftlerini <u><b>ilişkisellik</b></u> derecesi bakımından değerlendirmeniz beklenmektedir. </li>
                    <li>İlişkisellik bir önceki bölümdeki benzerliğe oranla çok daha kolay belirlenebilmektedir.</li>
                    <li>Yüksek ilişkili kelimeler birbirleri ile alakalıdırlar ve sıklıkla benzer bağlamlar içinde kullanılırlar.
                        <br/>
                        Örneğin; <b>"benzin"</b> ile <b>"araba"</b> kelimeleri benzer bağlamlar içinde kullanıldıklarından oldukça ilişkilidirler.
                    </li>
                    <li>
                        Kelimelerin yüksek ilişkili olabilmesi için ortak özniteliklerinin olmasına ihtiyaç yoktur.
                        <br/>
                        Örneğin; <b>"kahve"</b> ve <b>"fincan"</b> çiftinde, biri içecek diğeri eşya olmasına rağmen çift oldukça ilişkilidir ve hatta birbirlerini hatırlatırlar.
                        <br />
                        Bununla beraber; <b>"faiz"</b> ve <b>"fincan"</b> kelimelerinin ilişkileri oldukça azdır.
                    </li>
                    
                    <li>
                        Benzer ve zıt anlamlı kelimelerin ilişki seviyeleri de genellikle yüksektir.
                        <br/>
                        Örneğin; <i>"<u>İyi</u> <u>kötü</u> ve çirkin."</i> cümlesinden anlaşılacağı gibi "iyi" ve "kötü" benzer bağlamlarda kullanılırlar. <b>"iyi"</b> ve <b>"kötü"</b> oldukça ilişkilidirler.
                        <br/>
                        Aynı şekilde; benzer anlamlı <b>"öğrenci"</b> ve <b>"talebe"</b> kelimeleri de benzer bağlamlarda sık geçerler ve oldukça ilişkilidirler.
                    </li>

                    <li>Verilen örneklere anket sırasında da erişebileceksiniz. Cevaplara emin olamamanız durumunda örnekleri incelemenizi tavsiye ederiz.</li>
                </ol>
            </div>

             <div class="lead well text-al" id="divDialogEnding" runat="server" Visible="false" style="text-align:left; font-size:large;">
                <p>Anket başarıyla tamamlandı. Pencereyi kapatabilirsiniz. </p>
                 <br/>
                <p>Değerli vaktinizi ayırdığınız için sonsuz teşekkürler.</p>  
                 <p>Robotlarımızın günü geldiğinde bilime yaptığınız bu katkılar dikkate alınacaktır ;)</p>
                <br/>

                 Sevgiler,

                 <br/><br/>
                <p style="">Gökhan Ercan</p>
            </div>
            
            <%--Footer navigation--%>
            <div class="div">
                <div class="validator" runat="server" Visible="false" id="divValidator">
                    <span class="validator hidden1" style="font-weight:bold;"></span>
                    <br/><br/>
                </div>
                <asp:Button ID="btnPrev" CssClass="button btn btn-primary btnNext" runat="server" Text="Geri" Visible="true" Enabled="false"  OnClientClick="return OnNextButton();"
                    BorderStyle="Solid" BorderWidth="2px" Height="50px"  Width="200px" Font-Size="X-Large" OnClick="btnPrev_Click"  />

                <asp:Button ID="btnNext" CssClass="button btn btn-primary btnNext" runat="server" Text="İleri" Visible="true"   OnClientClick="return OnNextButton();"
                    BorderStyle="Solid" BorderWidth="2px" Height="50px"  Width="200px" Font-Size="X-Large" OnClick="btnNext_Click" />
                </div>
            <br/><br/><br/>

        </div>

        </div>

      </div>
    </div>
    
    <nav class="navbar navbar-default navbar-fixed-bottom" style="min-height:25px;" id="navBottom" runat="server">
      <div class="container-fluid" style="" >
          <div class="row" style="">
                <p class="text-center text-bottom" style=" padding-top: 14px; font-weight:bold;">
                    <span class='<%# QuestionType == QuestionTypes.Relatedness ? "grayed" : ""  %>' style="padding:0px 15px 0px 15px;">BENZERLİK (<%= Math.Min(PageNumberQS,25) %>/25)</span>
                    <span class='<%# QuestionType == QuestionTypes.Similarity ? "grayed" : ""  %>' style="padding:0px 15px 0px 15px; ">İLİŞKİSELLİK (<%= Math.Max(PageNumberQS,26) %>/50)</span>
                    
                    <a Visible="false" class="navbar-brand1" style="color:black;" href='<%# UrlCreator.BuildUrl(1,1) %>' runat="server">Benzerlik (1/500)</a>
                    <a Visible="false" class="navbar-brand1" style="color:black;" href='<%# UrlCreator.BuildUrl(1,1) %>' runat="server">İlişkisellik (501/1000)</a>
                </p>
          </div>
      </div>
    </nav>
    
    <asp:HiddenField runat="server" ID="hfAnswers"  />

    </form>
</body>
</html>
