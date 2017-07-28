/**
 * Created by Wang Sheng Kui on 2017/7/28.
 */
$(function() {
    setTimeout(function() {
        $("#id_2_1").click(function(){
            alert("测试页面2提示框");
        });
        $("#id_2_2").click(function(){
            if (confirm("是否返回上一页面")){
                window.location.href = "JSFirstPage.html";
            }
        });
    },100);
});