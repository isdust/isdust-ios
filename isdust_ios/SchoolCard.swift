//
//  SchoolCard.swift
//  isdust_ios
//
//  Created by wzq on 7/24/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class SchoolCard{
    struct PersonInfo{
        var name:String=""
        var identity:String=""//身份证
        var classs:String=""
        var schoolid:String=""//校园卡号码
        var id:String=""
        var password:String=""
        var xuegongid:String=""
        var balance_total:Float=0
        var balance_split:[Float]=[Float]()
    }

    var mPersonInfo:PersonInfo=PersonInfo()
    let location="http://card.proxy.isdust.com:3100/"
    var mhttp:Http
    var StandardPicture:[ImageProcess]=[ImageProcess]()
    var relation:[Int]=[Int]()//密码映射关系
    var mkey:String=""
    
    var page_total:Int=0;
    var page_current:Int=0;
    var day_current:String="";
    var day_last:String="";
    
    var date:NSDate
    var DateFormatter:NSDateFormatter
    let D_DAY:Double = 86400
    
    var flag_first=0
    
    //var PersonInfo:[String]=[String]()
    init(){
        mhttp=Http()
        for(var i=0;i<10;i++){
            var temp=ImageProcess()
            temp.loadimage(UIImage(named:"yzm"+String(i)+".png")!)
            StandardPicture.append(temp)        
        }
        DateFormatter=NSDateFormatter()
        DateFormatter.dateFormat = "yyyyMMdd"
        date=NSDate()
    }
    func day_minus() {
        date=date.dateByAddingTimeInterval(-D_DAY*31)
        
    }
    func day_get() -> String {
        return DateFormatter.stringFromDate(date)
    }
    func recognize(image:UIImage) -> Void {
        var tmp_image=ImageProcess();
        tmp_image.loadimage(image)
        tmp_image.binarize()
        var image_split:[ImageProcess]
        var image_split_detail:[CGRect]
        image_split_detail=[
        CGRect(x: 10,y: 36,width: 23,height: 23),
        CGRect(x: 46,y: 36,width: 23,height: 23),
        CGRect(x: 82,y: 36,width: 23,height: 23),
        CGRect(x: 10,y: 72,width: 23,height: 23),
        CGRect(x: 46,y: 72,width: 23,height: 23),
        CGRect(x: 82,y: 72,width: 23,height: 23),
        CGRect(x: 10,y: 108,width: 23,height: 23),
        CGRect(x: 46,y: 108,width: 23,height: 23),
        CGRect(x: 82,y: 108,width: 23,height: 23),
        CGRect(x: 10,y: 144,width: 23,height: 23)
        ]
        relation=[Int]()
        image_split=tmp_image.split(image_split_detail)//未识别图片
        for(var i=0;i<10;i++){//
            var tmp_single=image_split[i].recognize(StandardPicture)
            relation.append(tmp_single)
        }
    }
    func translate(rawpass:String) -> String {
        var result=""
        for(var i=0;i<rawpass.characters.count;i++){
            let index=rawpass.startIndex.advancedBy(i)
            let char=Int(String(rawpass[index]))
            for(var j=0;j<10;j++){
                if(relation[j]==char){
                    result+=String(j)
                    continue
                    
                }
            }
            
            
        }
        return result;
        
    }
    func login(username:String,password:String) -> String {
        
        recognize(mhttp.get_picture(location+"getpasswdPhoto.action"))
        mhttp.get_picture(location+"getCheckpic.action?rand=6520.280869641985");
        mhttp.setencoding(1)
        var mpassword=translate(password);
        var text_web=mhttp.post(location+"loginstudent.action", "name=" + username + "&userType=1&passwd=" + mpassword + "&loginType=2&rand=6520&imageField.x=39&imageField.y=10")
        if(text_web.containsString("持卡人")){
            mhttp.setencoding(0)
            text_web=mhttp.get(location+"accountcardUser.action")
            var expression="<div align=\"left\">([\\S\\s]*?)</div>"
            var regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpressionOptions.CaseInsensitive)
            var res = regex.matchesInString(text_web, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, text_web.characters.count))
            var temp_stuinfo=[String]()
            
            for(var i=0;i<res.count;i++){
                let temp_string=(text_web as NSString).substringWithRange(res[i].rangeAtIndex(1))
                temp_stuinfo.append(temp_string)
            }
            mPersonInfo=PersonInfo()
            mPersonInfo.name=temp_stuinfo[0]
            mPersonInfo.schoolid=temp_stuinfo[3]
            mPersonInfo.id=temp_stuinfo[1]
            mPersonInfo.classs=temp_stuinfo[13]
            mPersonInfo.identity=temp_stuinfo[9]
            mPersonInfo.xuegongid=temp_stuinfo[3]
            mPersonInfo.password=password
            expression="<td class=\"neiwen\">([-]*?[0-9]*.[0-9]*)元\\（卡余额\\）([-]*?[0-9]*.[0-9]*)元\\(当前过渡余额\\)([-]*?[0-9]*.[0-9]*)元\\(上次过渡余额\\)</td>"
            regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpressionOptions.CaseInsensitive)
            res = regex.matchesInString(text_web, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, text_web.characters.count))
            mPersonInfo.balance_split.append(Float((text_web as NSString).substringWithRange(res[0].rangeAtIndex(1)))!)
            mPersonInfo.balance_split.append(Float((text_web as NSString).substringWithRange(res[0].rangeAtIndex(2)))!)
            mPersonInfo.balance_split.append(Float((text_web as NSString).substringWithRange(res[0].rangeAtIndex(3)))!)
            mPersonInfo.balance_total=mPersonInfo.balance_split[0]+mPersonInfo.balance_split[1]
            mkey=getkey()
            return "登陆成功"
        }else if(text_web.containsString("登陆失败，无此用户名称")){
            return "无此用户名称"
            
        }else if(text_web.containsString("登陆失败，密码错误")){
            return "密码错误"
        }
        return "未知错误"
    }
    func getkey() -> String {
        mhttp.setencoding(1)
        var text_web=mhttp.get(location+"accounthisTrjn.action")
        var expression="\"/accounthisTrjn.action\\?__continue=([\\s\\S]*?)\""
        var regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpressionOptions.CaseInsensitive)
        var res = regex.matchesInString(text_web, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, text_web.characters.count))
        
        var key_init=(text_web as NSString).substringWithRange(res[0].rangeAtIndex(1))
        text_web=mhttp.post(location+"accounthisTrjn.action?__continue="+key_init, "account="+mPersonInfo.id+"&inputObject=all&Submit=+%C8%B7+%B6%A8+")
        res = regex.matchesInString(text_web, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, text_web.characters.count))
        var result=(text_web as NSString).substringWithRange(res[0].rangeAtIndex(1))
        return result
        
        
    }
    func LookUpHistory(inputStartDate:String,inputEndDate:String,page:Int) -> [[String]] {
        mhttp.setencoding(1)
        mkey=getkey()
        var text_web = mhttp.post(location+"accounthisTrjn.action?__continue=" + mkey, "inputStartDate=" + inputStartDate + "&inputEndDate=" + inputEndDate + "&pageNum="+String(page))
        var expression="<form id=\"\\?__continue=([\\S\\s]*?)\" name=\"form1\" "
        var regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpressionOptions.CaseInsensitive)
        var res = regex.matchesInString(text_web, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, text_web.characters.count))
        page_current=page;
        day_current=inputStartDate;
        
        var msearchkey=(text_web as NSString).substringWithRange(res[0].rangeAtIndex(1))
        var result:[[String]]=AnalyzeHistory(mhttp.get(location+"accounthisTrjn.action?__continue=" + msearchkey))

        return result
        
    }
    
    func AnalyzeHistory(text:String) -> [[String]] {
        var result:[[String]]=[[String]]()
        var expression="<tr class=\"listbg[\\s\\S]*?\">[\\s\\S]*?<td  align=\"center\">([\\s\\S]*?)</td>[\\s\\S]*?<td   align=\"center\">([\\s\\S]*?)</td>[\\s\\S]*?<td  align=\"center\" >([\\s\\S]*?)</td>[\\s\\S]*?<td  align=\"center\" >([\\s\\S]*?)</td>[\\s\\S]*?<td  align=\"right\">([\\s\\S]*?)</td>[\\s\\S]*?<td align=\"right\">([\\s\\S]*?)</td>[\\s\\S]*?<td  align=\"center\">([\\s\\S]*?)</td>[\\s\\S]*?<td  align=\"center\" >([\\s\\S]*?)</td>[\\s\\S]*?</tr>"
        var regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpressionOptions.CaseInsensitive)
        var res = regex.matchesInString(text, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, text.characters.count))
        
        for(var i=0;i<res.count;i++){
            var temp:[String]=[String]()
            for(var j=1;j<res[i].numberOfRanges;j++)
            {
                temp.append((text as NSString).substringWithRange(res[i].rangeAtIndex(j)))
            }
            result.append(temp)
            
        }
        page_total = Int(mhttp.GetMiddleText(text, "&nbsp;&nbsp;共", "页&nbsp;&nbsp;"))!;
        return result
        
        
    }
    func LookUpToday() -> [[String]] {
        mhttp.setencoding(1)
        page_current=0
        var text_temp=mhttp.post(location+"accounttodatTrjnObject.action", "account=" + mPersonInfo.id + "&inputObject=all&Submit=+%C8%B7+%B6%A8+")
        var result:[[String]]=AnalyzeToday(text_temp)
        return result
        
    }
    func AnalyzeToday(text:String) -> [[String]] {
        var result:[[String]]=[[String]]()
        var expression="<tr class=\"listbg[\\s\\S]*?\">[\\s\\S]*?<td  align=\"center\">([\\s\\S]*?)</td>[\\s\\S]*?<td   align=\"center\">([\\s\\S]*?)</td>[\\s\\S]*?<td  align=\"center\" >([\\s\\S]*?)</td>[\\s\\S]*?<td  align=\"center\" >([\\s\\S]*?)</td>[\\s\\S]*?<td  align=\"right\">([\\s\\S]*?)</td>[\\s\\S]*?<td  align=\"right\">([\\s\\S]*?)</td>[\\s\\S]*?<td  align=\"center\">([\\s\\S]*?)</td>[\\s\\S]*?<td  align=\"center\" >([\\s\\S]*?)</td>[\\s\\S]*?</tr>"
        
        var regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpressionOptions.CaseInsensitive)
        var res = regex.matchesInString(text, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, text.characters.count))
        
        for(var i=0;i<res.count;i++){
            var temp:[String]=[String]()
            for(var j=1;j<res[i].numberOfRanges;j++)
            {
                temp.append((text as NSString).substringWithRange(res[i].rangeAtIndex(j)))
            }
            result.append(temp)
            
        }
        page_total=0
        
        return result
        
    }
    
    func LookUpHistoryNext(inputStartDate:String,inputEndDate:String,page:Int) -> [[String]] {
        var text_web=mhttp.post(location+"accountconsubBrows.action", "inputStartDate="+inputStartDate+"&inputEndDate="+inputEndDate+"&pageNum="+String(page))
        var result:[[String]]=AnalyzeHistory(text_web)
        return result
        
    }
    
    func ChangePassword(oldpassword:String,newpassword:String,identity:String) -> String {
        if(identity != mPersonInfo.identity){
            return "身份证号码错误"
        }
        recognize(mhttp.get_picture(location+"getpasswdPhoto.action"))
        var moldpassword=translate(oldpassword)
        var mnewpassword=translate(newpassword)
        var submit="account=" +  mPersonInfo.id + "&passwd=" + moldpassword + "&newpasswd="+mnewpassword + "&newpasswd2=" + mnewpassword
        var text_web=mhttp.post(location+"accountDocpwd.action",submit)
        if(text_web.containsString("操作成功")){
            return "修改密码成功"
            
        }else if(text_web.containsString("密码错误")){
            return "原始密码错误"
            
        }else if(text_web.containsString("本日业务已结束")){
            return "本日业务已结束"
        }
        return "未知错误"
    }
    func ReportLoss(password:String,identity:String) -> String {
        if(identity != mPersonInfo.identity){
            return "身份证号码错误"
        }
        recognize(mhttp.get_picture(location+"getpasswdPhoto.action"))
        var mpassword=translate(password)
        var submit="account=" + mPersonInfo.id + "&passwd=" + mpassword
        var text_web=mhttp.post(location+"accountDoLoss.action",submit)
        if(text_web.containsString("持卡人已挂失")){
            return "持卡人已挂失，无需再次挂失"
            
        }else if(text_web.containsString("密码错误")){
            return "密码错误"
            
        }else if(text_web.containsString("操作成功")){
            return "操作成功"
        }
        return "未知错误"
    }
    func NextPage() -> [[String]] {
        page_current=page_current+1
        if (page_current>page_total){
            
            page_current=1
            day_last=day_get()
            day_minus()
            day_current=day_get()
            
            return LookUpHistory(day_current,inputEndDate: day_last,page: page_current)
        }
        return LookUpHistoryNext(day_current, inputEndDate: day_last, page: page_current);
    }
    func ResetFlag()  {
        flag_first=0
        date=NSDate()
    }
    func GetTransaction() -> [Transaction] {
        var result:[Transaction]=[Transaction]()
        if(flag_first==0){
            var data_today=LookUpToday()
            var data_history=NextPage()
            for i in data_today{
                var temp_transaction:Transaction=Transaction()
                temp_transaction.FormatFromString(i)
                result.append(temp_transaction)
            
            }
            for i in data_history{
                var temp_transaction:Transaction=Transaction()
                temp_transaction.FormatFromString(i)
                result.append(temp_transaction)
                
            }
            flag_first=1
        
        }else{
            var data_history=NextPage()
            for i in data_history{
                var temp_transaction:Transaction=Transaction()
                temp_transaction.FormatFromString(i)
                result.append(temp_transaction)
                
            }
        
        }
        return result
    }
    
    

}