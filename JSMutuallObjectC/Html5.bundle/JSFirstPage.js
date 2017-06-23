/**
 * Created by Wang Sheng Kui on 2017/6/23.
 */
$(function(){
   setTimeout(function(){
        $("#id_1").click(function(){
            window.iOS.TestNOParameter();
        });
       $("#id_2").click(function(){
           window.iOS.TestOneParameter("OneParameter");

       });
       $("#id_3").click(function(){
           window.iOS.TestTowParameterSecondParameter("OneParameter","TwoParameter");

       });
       $("#id_4").click(function(){
           var dict = {};
           dict.first = "1";
           dict.second = "2";
           window.iOS.getDataWithDic(dict);
       });
       $("#id_5").click(function(){
           var data =  window.iOS.getSomeData();
           var jsonObject = JSON.parse(data);//json字符串转换json对象

           alert("first1"+jsonObject.first1);
       });
   },100);
});
function OCTransferJS(OCdata){
    alert(OCdata.dataOne+"--------"+OCdata.dataTwo);
}
