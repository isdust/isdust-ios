//
//  Cmcc.swift
//  isdust_ios
//
//  Created by wzq on 9/16/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
import MessageUI

class NetworkCMCC{

    var mhttp=Http()
    var wlanuserip:String!
    var wlanacname:String!
    var CSRFToken_HW:String!
    
    
    var second_logout_address:String!
    
    var mcontroller:UIViewController!
    var smscontroller:MFMessageComposeViewController!
    
    func setcontroller(viewcontroller:UIViewController) {
        mcontroller=viewcontroller
    }
    func first_login(user:String,password:String) throws -> String{
        let submit="DDDDD="+user+"&upass="+encodepassword(rawpassword: password)+"&R1=0&R2=1&para=00&0MKKey=123456"
        mhttp.setencoding(1)
        var html = try mhttp.post("http://172.16.0.86/", submit);
        //var a=1
        if(html.contains("登录成功窗")){
            return "登录成功"
        }
        if(html.contains("Msg=01")&&html.contains("msga=''")){
            return "密码错误"
        }
        return "err_chengshiredian_login"
        
    }
    func first_logout(){
        do{
            try mhttp.get("http://172.16.0.86/F.htm")
        }catch{
        
        }
    
    }
    
    func second_init() throws{
        mhttp.setencoding(0)
        let html = try mhttp.get("http://baidu.com/")
        wlanuserip=try getMiddleText(html, "<input type=\"hidden\" name=\"wlanuserip\" id=\"wlanuserip\" value=\"", "\"/>")
        wlanacname=try getMiddleText(html,"<input type=\"hidden\" name=\"wlanacname\" id=\"wlanacname\" value=\"","\"/>")
        CSRFToken_HW=try getMiddleText(html,"<input type='hidden' name='CSRFToken_HW' value='","' /></form>")
    }
    func second_login(user:String,password:String)throws->String{
        let submit="username="+user+"&password="+password+"&cmccdynapw=&unreguser=&wlanuserip="+wlanuserip+"&wlanacname="+wlanacname+"&wlanparameter=null&wlanuserfirsturl=http%3A%2F%2Fwww.baidu.com&ssid=cmcc&loginpage=%2Fcmccpc.jsp&indexpage=%2Fcmccpc_index.jsp&CSRFToken_HW="+CSRFToken_HW
        mhttp.setencoding(0)
        
        let text = try mhttp.post("https://cmcc.sd.chinamobile.com:8443/mobilelogin.do", submit);
        if (text.contains("用户名或密码输入有误，请重新输入！")){
            return "CMCC用户名或密码错误";
        }
        if (text.contains("用户名或密码错误！")){
            return "CMCC用户名或密码错误";
        }
        if (text.contains("动态密码有效期已过期，请您重新获取动态密码。")){
            return "动态密码有效期已过期，请您重新获取动态密码。";
        }
        if (text.contains("下线成功")){
            second_logout_address=try getMiddleText(text,"var gurl = \"","\";");
            second_logout_address=second_logout_address + (try getMiddleText(text,"gurl = gurl + \"","\" + removeCookie")) + "1";
            second_logout_address="http://cmcc.sd.chinamobile.com:8001"+second_logout_address;
            
            return "登录成功";
        }
        return "未知错误";
    
    }
    func second_getVerificationCode(user:String)->String{
        mhttp.setencoding(0)
        let submit="username="+user+"&password=&cmccdynapw=cmccdynapw&unreguser=&wlanuserip="+wlanuserip+"&wlanacname="+wlanacname+"&wlanparameter=null&wlanuserfirsturl=http%3A%2F%2Fwww.baidu.com&ssid=cmcc&loginpage=%2Fcmccpc.jsp&indexpage=%2Fcmccpc_index.jsp&CSRFToken_HW="+CSRFToken_HW
        var text:String
        do{
            text = try mhttp.post("https://cmcc.sd.chinamobile.com:8443/mobilelogin.do",submit)

        }catch{
            return "cmcc_geyanzheng:未知错误";
        }
        if (text.contains("动态密码已经发往手机号码")){
            return "动态密码已经发往手机号码";
        }
        if (text.contains("申请动态密码成功")){
            return "动态密码已经发往手机号码";
        }
        if (text.contains("申请密码过于频繁！")){
            return "申请密码过于频繁！";
        }
        return "cmcc_geyanzheng:未知错误";

        
    }
    /*
    func second_changepass(){
        smscontroller = MFMessageComposeViewController.init()
        smscontroller.body = "806"
        smscontroller.recipients=["10086"]
        smscontroller.messageComposeDelegate = self
        //controller.action
        if MFMessageComposeViewController.canSendText() {
            mcontroller.present(smscontroller, animated: true, completion: nil)
        }
    
    }
    */
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //smscontroller.dismiss(animated: true, completion: nil)
        print(result)
    }
    

}
