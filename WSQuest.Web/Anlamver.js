
$(function () {
    FastClick.attach(document.body);
});

var Answers = new Array(NrOfQuestions+1);

$(document).ready(function () {
    $("a.qbtn").click(function () {
        var t = $(this);
        var qIndex = parseInt(t.attr("qindex"));
        var qid = parseInt(t.attr("q"));
        var cid = t.attr("c");      //choice id

        //aynı seçeneğe bir daha tıkladıysa
        if (cid == Answers[qIndex]) {
            ClearChoices(qid);
            t.blur();
            $(this).addClass("no-hover");
            t.removeAttr("choice");
            Answers[qIndex] = null;
        }
        else {      //update.
            Answers[qIndex] = cid;
            ClearChoices(qid);
            t.attr("choice", "1");
            t.removeClass("no-hover");
        }

        //finally.
        log(GetAnswersJSONStr(Answers));
        var autoScroll = $("input#chkAutoScroll").is(":checked");
        if (autoScroll && qIndex != NrOfQuestions) ScrollToQuestion(qid + 1);
        UpdateValidator();
    });

    //Set existing values
    var selChoices = $("a.qbtn[choice='1']");
    log(selChoices.length);
    $.each(selChoices, function (index, value) {
        var t = $(this);
        var qIndex = parseInt(t.attr("qindex"));
        var qid = t.attr("q");
        var cid = t.attr("c");
        Answers[qIndex] = cid;
    });
    log(GetAnswersJSONStr(Answers));

    UpdateValidator();
});
function UpdateValidator() {
    var answers = Answers;
    var emptyQues = 0;
    $.each(answers, function (index, value) {
        if (index != 0) {
            if (value == null) {
                emptyQues++;
            }
        }
    });
    var divVal = $("div.validator");
    var spanVal = $("span.validator");
    if (emptyQues > 0)
    {
        spanVal.text(emptyQues + " soruyu boş bırakıyorsunuz!");
        spanVal.css("color", "red");
        divVal.show();
    }
    else {
        spanVal.text("Ekrandaki tüm sorular puanlandı.");
        spanVal.css("color", "green");
    }
}
function OnNextButton() {
    var hf = $("input#hfAnswers");
    var json = GetAnswersJSONStr(Answers);
    hf.val(json);
    log(json);
    return true;
}
function ClearChoices(qid) {
    var query = "div.btn-group a[q='" + qid + "']";
    var aa = $(query);
    aa.removeAttr("choice");
    aa.removeClass("no-hover");
}
function log(msg) {
    console.log(msg);
}
function GetAnswersJSONStr(obj) {
    var str = JSON.stringify(obj);
    return str;
}
function IsCompleted() {
    for (i = 1; i <= NrOfQuestions; i++) {
        var a = Answers[i];
        if (a == null) return false;
    }
    return true;
}
function ScrollToQuestion(q) {
    query = "div#div" + q;
    var div = $(query);
    $('html,body').animate({
        scrollTop: div.offset().top
    }, 250);
    div.addClass("highlight");
    setTimeout(function () {
        div.removeClass("highlight")
    }, 2500);
}
