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
    var isjump:Bool=false
    init(){
        method_score_lookup="xuanke"
        mhttp=Http();
        mhttp.setencoding(1);
    }
    
    
    func JumpToSelectClass()throws {
        if(isjump==true){
            
            return
        }
        mhttp.setencoding(1)
        let text_web=try mhttp.get(mhttp.urlencode(url_xuanke) )
        let temp_url=try mhttp.getMiddleText(text_web, "<a target=\"_top\" href=\"", "\">如果您的浏览器没有跳转，请点这里</a>")
        mhttp.setencoding(0)
        try mhttp.get(temp_url);
        isjump=true
    }
    func Login(_ username:String,password:String)throws->String{
        isjump=false
        mhttp.setencoding(1);
        var text_web=try mhttp.get(location_zhengfang+"default_ysdx.aspx");
        var VIEWSTATE=try mhttp.getMiddleText(text_web, "<input type=\"hidden\" name=\"__VIEWSTATE\" value=\"", "\" />")
        VIEWSTATE=mhttp.postencode(VIEWSTATE);
        //        VIEWSTATE=VIEWSTATE?.replacingOccurrences(of: <#T##String#>, with: "%3D")
        var submit="__VIEWSTATE=" + VIEWSTATE + "&TextBox1=" + username + "&TextBox2=" + mhttp.postencode(password)
        submit=submit+"&RadioButtonList1=%d1%a7%c9%fa&Button1=++%b5%c7%c2%bc++"
        text_web=try mhttp.post(location_zhengfang+"default_ysdx.aspx",submit)
        if((text_web.contains("<script>window.open('xs_main.aspx?xh=2")) == true){
            var url_login_zhengfang=try mhttp.getMiddleText(text_web,  "<script>window.open('","','_parent');</script>")
            url_login_zhengfang=location_zhengfang+url_login_zhengfang;
            text_web=try mhttp.get(url_login_zhengfang)
            url_xuanke=try mhttp.getMiddleText(text_web, "信息员意见反馈</a></li><li><a href=\"", "\" target='zhuti' onclick=\"GetMc('激活选课平台帐户');");
            url_xuanke=location_zhengfang+url_xuanke;
            url_xuanke=url_xuanke.replacingOccurrences(of: "192.168.109.142", with: "xuanke.proxy.isdust.com:3100")
            if(text_web.contains("个人成绩查询")==true){
                url_chengji=try mhttp.getMiddleText(text_web,"学生个人课表</a></li><li><a href=\"","\" target='zhuti' onclick=\"GetMc('个人成绩查询');\">")
                url_chengji=location_zhengfang+url_chengji
                method_score_lookup="zhengfang"
            }else{
                method_score_lookup="xuanke"
            }


            return "登录成功";
            
            
        }
        else if((text_web.contains("密码错误")) == true){
            return "密码错误"
            
        }
        else if((text_web.contains("用户名不存在")) == true){
            return "用户名不存在"
            
        }
        //print(text_web)
        return "未知错误"
    }
    
    func AllScoreLookUp()throws->[[String]]{
        mhttp.setencoding(1);
        if(method_score_lookup=="xuanke"){
            return try ScoreLookUp("", semester: "")
        
        }
        var text_web="";
        var submit=""
        var result:[[String]]
        text_web=try mhttp.get(mhttp.urlencode(url_chengji) );
        var VIEWSTATE=try mhttp.getMiddleText(text_web, "<input type=\"hidden\" name=\"__VIEWSTATE\" value=\"", "\" />")
        VIEWSTATE=mhttp.postencode(VIEWSTATE);
        submit = "__VIEWSTATE=" + VIEWSTATE+"&ddlXN=&ddlXQ=&btn_zcj=C0%FA%C4%EA%B3%C9%BC%A8"
        text_web=try mhttp.post(mhttp.urlencode(url_chengji), submit);
        return try ScoreAnalyzeZhengfang(text_web)
        
        
    }
    func ScoreLookUp(_ year:String,semester:String)throws->[[String]]{
        mhttp.setencoding(1);
        var text_web="";
        var submit=""
        var result:[[String]]
        switch method_score_lookup {
        case "zhengfang":
            text_web=try mhttp.get(mhttp.urlencode(url_chengji) );
            var VIEWSTATE=try mhttp.getMiddleText(text_web, "<input type=\"hidden\" name=\"__VIEWSTATE\" value=\"", "\" />")
            VIEWSTATE=mhttp.postencode(VIEWSTATE);
            submit = "__VIEWSTATE=" + VIEWSTATE+"&ddlXN=" + year + "&ddlXQ=" + semester + "&btn_xq=%d1%a7%c6%da%b3%c9%bc%a8"
            text_web=try mhttp.post(mhttp.urlencode(url_chengji), submit);
            return try ScoreAnalyzeZhengfang(text_web)
            break;
        case "xuanke":
            try JumpToSelectClass()
            text_web=try mhttp.get(location_xuanke+"Home/About");
            text_web=text_web.replacingOccurrences(of: "class=\"selected\"", with: "")
            return ScoreAnalyzeXuanke(text_web)
            break;
        default:
            break;
        }
        return [[""]]
        
    }
    func ScoreAnalyzeZhengfang(_ text:String)throws -> [[String]] {
        let expression = "<tr[\\s\\S]*?>[\\s\\S]*?<td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td><td>([\\s\\S]*?)</td>[\\S\\s]*?</tr>"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.caseInsensitive)
        var result=[[String]]()
        let res = regex.matches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text.characters.count))
        for i in 1 ..< res.count{
            var temp=[String]()
            for j in 1 ..< res[i].numberOfRanges{
                
                let str = (text as NSString).substring(with: res[i].rangeAt( j))
                temp.append(str)
                
            }
            result.append(temp)
        }
        
        return result
    }
    func ScoreAnalyzeXuanke(_ text:String) -> [[String]] {
        let expression = "<tr>([\\S\\s]*?)<td>([\\S\\s]*?)</td>[\\S\\s]*?<td>([\\S\\s]*?)</td>[\\S\\s]*?<td>([\\S\\s]*?)</td>[\\S\\s]*?<td>([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?</tr>"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.caseInsensitive)
        var result=[[String]]()
        let res = regex.matches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text.characters.count))
        for i in 1 ..< res.count{
            var temp=[String](repeating: "", count:15)
            temp[0]=(text as NSString).substring(with: res[i].rangeAt( 2))
            temp[1]=(text as NSString).substring(with: res[i].rangeAt( 3))
            temp[3]=(text as NSString).substring(with: res[i].rangeAt( 4))
            temp[6]=(text as NSString).substring(with: res[i].rangeAt( 5))
            temp[8]=(text as NSString).substring(with: res[i].rangeAt( 6))
//            for j in 1 ..< res[i].numberOfRanges{
//                
//                let str = (text as NSString).substring(with: res[i].rangeAt( j))
//                temp.append(str)
//                
//            }
            result.append(temp)
        }
        return result
    }
    func ScheduleLookup(_ week:String,year:String,semester:String) throws-> [Kebiao] {
        mhttp.setencoding(0);
        var text_web = try mhttp.get(location_xuanke+"?zhou="+week+"&xn="+year+"&xq="+semester)
        text_web=text_web.replacingOccurrences(of: " rowspan=\"2\" ", with: "")
        let expression="<td  class=\"leftheader\">第[1,3,5,7,9]节</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>[\\S\\s]*?<td >([\\S\\s]*?)</td>"
        // - 2、创建正则表达式对象
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.caseInsensitive)
        // - 3、开始匹配
        var result=[Kebiao]();
        let res = regex.matches(in: text_web, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, (text_web.characters.count)))
        for i in 0 ..< res.count{
            //print((text_web as NSString).substringWithRange(res[i].rangeAtIndex(0)))
            for j in 1 ..< 7{
                
                
                var str = (text_web as NSString).substring(with: res[i].rangeAt(j))
                if(!(str=="&nbsp;")){
                    var temp=Kebiao()
                    temp.jieci=String(i+1)
                    temp.xingqi=String(j)
                    str=str.replacingOccurrences(of: "<b class=\"newCourse\">", with: "").replacingOccurrences(of: "</b>", with: "")
                    str=str.replacingOccurrences(of: " ", with: "")
                    temp.raw=str
                    let temp_array=str.components(separatedBy: "<br>")
                    temp.kecheng=temp_array[0]
                    temp.teacher=temp_array[2]
                    temp.location=temp_array[3]
                    temp.zhoushu=week
                    result.append(temp)
                    
                    
                    
                }
                
            }
        }
        return result
        
    }
    func JidianLookup()throws->[String] {
        mhttp.setencoding(1);
        if(method_score_lookup=="xuanke"){
        return ["NULL","NULL"]
        }
        var text_web="";
        var submit=""
        var result:[String] = [String] ()
        text_web=try mhttp.get(mhttp.urlencode(url_chengji) );
        var VIEWSTATE = try mhttp.getMiddleText(text_web, "<input type=\"hidden\" name=\"__VIEWSTATE\" value=\"", "\" />")
        VIEWSTATE=mhttp.postencode(VIEWSTATE);
        submit = "__VIEWSTATE=" + VIEWSTATE+"&ddlXN=&ddlXQ=&Button1=%B3%C9%BC%A8%CD%B3%BC%C6"
        text_web=try mhttp.post(mhttp.urlencode(url_chengji), submit);
        var temp:String
        
        temp=try mhttp.getMiddleText(text_web,"<span id=\"pjxfjd\"><b>所有课程平均学分绩点：" , "</b></span>")
        result.append(temp)
        temp=try mhttp.getMiddleText(text_web,"<span id=\"xfjdzh\"><b>学分绩点总和：" , "</b></span>")
        result.append(temp)
        return result
        
    }
}
