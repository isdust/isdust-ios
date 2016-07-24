//
//  Zhengfang.swift
//  isdust
//
//  Created by wzq on 7/23/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation

class Zhengfang{
    var mhttp:Http
    let location_zhengfang="http://1.zf.proxy.isdust.com:3100/"
    let location_xuanke="http://xuanke.proxy.isdust.com:3100/"
    var url_xuanke:String=""
    var url_chengji:String=""
    var method_score_lookup:String=""
    init(){
        method_score_lookup="zhengfang"
        mhttp=Http();
        mhttp.setencoding(1);
    }
    func Login(username:String,password:String)->String{
        mhttp.setencoding(1);
        var text_web=mhttp.get(location_zhengfang+"default_ysdx.aspx");
        var VIEWSTATE=mhttp.GetMiddleText(text_web, "<input type=\"hidden\" name=\"__VIEWSTATE\" value=\"", "\" />")
        VIEWSTATE=mhttp.postencode(VIEWSTATE);
        var submit="__VIEWSTATE="+VIEWSTATE+"&TextBox1="+username+"&TextBox2="+mhttp.postencode(password)
        submit=submit+"&RadioButtonList1=%d1%a7%c9%fa&Button1=++%b5%c7%c2%bc++"
        text_web=mhttp.post(location_zhengfang+"default_ysdx.aspx",submit)
        if(text_web.containsString("<script>window.open('xs_main.aspx?xh=2")){
            var url_login_zhengfang=mhttp.GetMiddleText(text_web,  "<script>window.open('","','_parent');</script>")
            url_login_zhengfang=location_zhengfang+url_login_zhengfang;
            text_web=mhttp.get(url_login_zhengfang)
            url_xuanke=mhttp.GetMiddleText(text_web, "信息员意见反馈</a></li><li><a href=\"", "\" target='zhuti' onclick=\"GetMc('激活选课平台帐户');");
            url_xuanke=location_zhengfang+url_xuanke;
            url_xuanke=url_xuanke.stringByReplacingOccurrencesOfString("192.168.109.142", withString: "xuanke.proxy.isdust.com:3100")
            url_chengji=mhttp.GetMiddleText(text_web,"学生个人课表</a></li><li><a href=\"","\" target='zhuti' onclick=\"GetMc('个人成绩查询');\">");
            url_chengji=location_zhengfang+url_chengji;
           return "登录成功";
            
        
        }
        else if(text_web.containsString("密码错误")){
            return "密码错误"
        
        }
        else if(text_web.containsString("用户名不存在")){
            return "用户名不存在"
            
        }
        //print(text_web)
        return "未知错误"
    }
    func JumpToSelectClass() {
        mhttp.setencoding(1);
        var text_web=mhttp.get(mhttp.urlencode(url_xuanke) );
        url_xuanke=mhttp.GetMiddleText(text_web, "<a target=\"_top\" href=\"", "\">如果您的浏览器没有跳转，请点这里</a>");
        mhttp.get(url_xuanke);

    }
    func ScoreLookUp(year:String,semester:String)->[[String]]{
        mhttp.setencoding(1);
        var text_web="";
        var submit=""
        var result:[[String]]
        switch method_score_lookup {
        case "zhengfang":
            text_web=mhttp.get(mhttp.urlencode(url_chengji) );
            var __VIEWSTATE=mhttp.GetMiddleText(text_web, "<input type=\"hidden\" name=\"__VIEWSTATE\" value=\"", "\" />")
            __VIEWSTATE=mhttp.postencode(__VIEWSTATE);
            submit="__VIEWSTATE="+__VIEWSTATE+"&ddlXN="+year+"&ddlXQ="+semester+"&btn_xq=%d1%a7%c6%da%b3%c9%bc%a8" ;
            text_web=mhttp.post(mhttp.urlencode(url_chengji), submit);
            return ScoreAnalyzeZhengfang(text_web)
            break;
        case "xuanke":
            JumpToSelectClass()
            text_web=mhttp.get("http://192.168.109.142/Home/About");
            text_web=text_web.stringByReplacingOccurrencesOfString("class=\"selected\"", withString: "")
            
            break;
        default:
            break;
        }
        return [[""]]
    
    }
    func ScoreAnalyzeZhengfang(text:String) -> [[String]] {
        let expression = "<tr[\\s\\S]*?>[\\s\\S]*?<td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td>[\\S\\s]*?</tr>"
        // - 2、创建正则表达式对象
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpressionOptions.CaseInsensitive)
        // - 3、开始匹配
        var result=[[String]]();
        let res = regex.matchesInString(text, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, text.characters.count))
        for(var i=1;i<res.count;i++){
             var temp=[String]()
            for(var j=1;j<res[i].numberOfRanges;j++){
                
                var str = (text as NSString).substringWithRange(res[i].rangeAtIndex(j))
                temp.append(str)
            
            }
            result.append(temp)
        }
        
        return result
    }
    func ScheduleLookup(week:String,year:String,semester:String) -> [Kebiao] {
        mhttp.setencoding(0);
        var text_web=mhttp.get(location_xuanke+"?zhou="+week+"&xn="+year+"&xq="+semester)
        text_web=text_web.stringByReplacingOccurrencesOfString(" rowspan=\"2\" ", withString: "")
        let expression="<td  class=\"leftheader\">第[1,3,5,7,9]节</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>"
        // - 2、创建正则表达式对象
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpressionOptions.CaseInsensitive)
        // - 3、开始匹配
        var result=[Kebiao]();
        let res = regex.matchesInString(text_web, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, text_web.characters.count))
        for(var i=0;i<res.count;i++){
            print((text_web as NSString).substringWithRange(res[i].rangeAtIndex(0)))
            for(var j=1;j<7;j++){
                
                
                var str = (text_web as NSString).substringWithRange(res[i].rangeAtIndex(j))
                if(!(str=="&nbsp;")){
                    var temp=Kebiao()
                    temp.jieci=String(i+1)
                    temp.xingqi=String(j)
                    str=str.stringByReplacingOccurrencesOfString("<b class=\"newCourse\">", withString: "").stringByReplacingOccurrencesOfString("</b>", withString: "")
                    temp.kecheng=str
                    temp.zhoushu=week
                    result.append(temp)
                    
                
                
                }
                
            }
        }
        return result
        
    }
}