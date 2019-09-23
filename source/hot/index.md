---
title: 热度排行榜
date: 2019-09-23 10:25:26
---

<div id="hot"></div>
<script src="https://cdn1.lncld.net/static/js/av-core-mini-0.6.9.js"></script>
<script>AV.initialize("o4QxN6nbiMgINL8f7fMM9q22-gzGzoHsz", "Q1rChcNWoBbKCLoAMShDheQW");</script>
<script type="text/javascript">
setTimeout(function(){
    var time = 0
    var title = ""
    var url = ""
    var query = new AV.Query('Counter');
    query.notEqualTo('id', 0);
    query.descending('time');
    query.limit(1000);
    query.find().then(function (todo) {
        for (var i = 0; i < 1000; i++) {
            var result = todo[i].attributes;
            var time = result.time;
            var title = result.title;
            var url = result.url;
            var content = "<p>" + 
                "<font color='#1C1C1C'>" + "【文章热度:" + time + "℃】" + "</font>" + 
                "<a href='" + "https://xwltz.github.io/" + url + "'>" + title + "</a>" + 
                "</p>";
            document.getElementById("hot").innerHTML += content
        }
    }, function (error) {
        console.log("error");
    });
}, 1000)
</script>