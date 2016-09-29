//
//  ViewCMCC.swift
//  isdust_ios
//
//  Created by wzq on 9/20/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class ViewCMCC:UIViewController,ViewLoginDelegate{
    var onlinetype:Int!
    var mCMCC:NetworkCMCC!
    var serialQueue:DispatchQueue!
    
    var thread_first_user:String!
    var thread_first_pass:String!
    
    
    var thread_second_user:String!
    var thread_second_pass:String!
    
    let key_fitst_user="key_cmcc_first_user"
    let key_first_pass="key_cmcc_first_password"
    
    let key_second_user="key_cmcc_second_user"
    let key_second_pass="key_cmcc_second_password"
    
    @IBOutlet weak var image_condition: UIImageView!
    
    override func viewDidLoad() {
        serialQueue = DispatchQueue(label: "queuename", attributes: [])
        
        mCMCC=NetworkCMCC()
        
        
    }
    func thread_judgetype(entry:Int){
        var type=NetworkJudge.cmcc_judge()
        self.performSelector(onMainThread: Selector(("NetworkJudge")), with: type, waitUntilDone: false, modes: nil)
    }
    func thread_login_first(){
        do{
            var result=try mCMCC.first_login(user: thread_first_user, password: thread_first_pass)
            var message:Int!
            if(result.contains("登录成功")){
                message=0//1层登录成功
                self.performSelector(onMainThread: Selector(("CMCCFirstLogin")), with: message, waitUntilDone: false, modes: nil)

                return
            }
            else if(result.contains("密码错误")){
                message=1//1层登录失败（密码错误）
                self.performSelector(onMainThread: Selector(("CMCCFirstLogin")), with: message, waitUntilDone: false, modes: nil)
                return
            }
            message=2//1层登录失败（原因未知）
            self.performSelector(onMainThread: Selector(("CMCCFirstLogin")), with: message, waitUntilDone: false, modes: nil)
            return
        }catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
            
            
        }

    }
    func thread_login_second(){
        var message:Int!

        do{
            try mCMCC.second_init()
            var result=try mCMCC.second_login(user: thread_second_user, password: thread_second_pass)
            if(result.contains("登录成功")){
                message=0//2层登录成功
                self.performSelector(onMainThread: Selector(("CMCCSecondLogin")), with: message, waitUntilDone: false, modes: nil)
                return
            }
            else if(result.contains("CMCC用户名或密码错误")){
                message=1//2层登录失败（密码错误）
                self.performSelector(onMainThread: Selector(("CMCCSecondLogin")), with: message, waitUntilDone: false, modes: nil)
                return
            }
            else if(result.contains("动态密码有效期已过期")){
                message=2//2层登录失败（密码错误）
                self.performSelector(onMainThread: Selector(("CMCCSecondLogin")), with: message, waitUntilDone: false, modes: nil)
                return
            }
            onlinetype=NetworkJudge.cmcc_judge()
            if(onlinetype==2){
                message=0//2层登录成功
                self.performSelector(onMainThread: Selector(("CMCCSecondLogin")), with: message, waitUntilDone: false, modes: nil)
                self.performSelector(onMainThread: Selector(("Condition")), with: onlinetype, waitUntilDone: false, modes: nil)
                return
            }
            self.performSelector(onMainThread: Selector(("Condition")), with: onlinetype, waitUntilDone: false, modes: nil)

            message=4//2层登录失败（原因未知）
            self.performSelector(onMainThread: Selector(("CMCCSecondLogin")), with: message, waitUntilDone: false, modes: nil)
            return
        }catch IsdustError.Network{
            message=3//网络信号不好

            self.performSelector(onMainThread: Selector(("CMCCSecondLogin")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
            
            
        }
        
    }
    func thread_autologin(){
        onlinetype=NetworkJudge.cmcc_judge()
        if(onlinetype==0){
            thread_first_user = UserDefaults.standard.string(forKey: key_fitst_user)
            thread_first_pass = UserDefaults.standard.string(forKey: key_first_pass)
            if(thread_first_user==nil||thread_first_pass==nil||thread_first_user==""||thread_first_pass==""){
                let mviewlogin=ViewLogin.init(frame: (self.view.window?.rootViewController?.view.frame)!)
                mviewlogin.settitle(title: "CMCC一层登录")
                mviewlogin.sethint(user: "学号(10位)", pass: "CMCC一层账号")
                mviewlogin.setchannel(mchannel: "CMCC_first")
                mviewlogin.delegate=self
                self.view.window?.rootViewController?.view.addSubview(mviewlogin)
                return
            
            }
            serialQueue.async(execute: thread_login_first)
            let message="正在登录第一层..."
            
            self.performSelector(onMainThread: Selector(("ShowMessage")), with: message, waitUntilDone: false, modes: nil)
            return
        }else if(onlinetype==1){
            thread_second_user = UserDefaults.standard.string(forKey: key_second_user)
            thread_second_pass = UserDefaults.standard.string(forKey: key_second_pass)
            if(thread_second_user==nil||thread_second_user==nil||thread_second_user==""||thread_second_user==""){
                let mviewlogin=ViewLogin.init(frame: (self.view.window?.rootViewController?.view.frame)!)
                mviewlogin.settitle(title: "CMCC二层登录")
                mviewlogin.sethint(user: "手机号码", pass: "密码")
                mviewlogin.setchannel(mchannel: "CMCC_second")
                mviewlogin.delegate=self
                self.view.window?.rootViewController?.view.addSubview(mviewlogin)
                return
            }
            serialQueue.async(execute: thread_login_second)
            let message="正在登录第二层..."
            self.performSelector(onMainThread: Selector(("ShowMessage")), with: message, waitUntilDone: false, modes: nil)
        }else if(onlinetype==2){
            self.performSelector(onMainThread: Selector(("Condition")), with: onlinetype, waitUntilDone: false, modes: nil)
        
        }
        
    }
    func thread_get_pass() {
        do{
            
            var result=try mCMCC.second_getVerificationCode(user: thread_second_user)
            self.performSelector(onMainThread: Selector(("CMCCGetPass")), with: result, waitUntilDone: false, modes: nil)
        }catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
            
            
        }
    }
    func settype(type:Int){
        switch type {
        case 0:
            image_condition.image=#imageLiteral(resourceName: "CMCC_0")
            break
        case 1:
            image_condition.image=#imageLiteral(resourceName: "CMCC_1")
            break
        case 2:
            image_condition.image=#imageLiteral(resourceName: "CMCC_2")
            break
        default:
            break
        }
    }
    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool, modes array: [String]?) {
        DispatchQueue.main.async(){
            switch aSelector {
            case Selector(("ShowMessage")):
                
                break
            case Selector(("Condition")):
                let message=arg as! Int
                self.settype(type: message)
                SVProgressHUD.dismiss()
                
                
                break
            case Selector(("CMCCFirstLogin")):
                let message=arg as! Int
                SVProgressHUD.dismiss()
                switch(message){
                case 0:
                    UserDefaults.standard.set(self.thread_first_user, forKey: self.key_fitst_user)
                    UserDefaults.standard.set(self.thread_first_pass, forKey: self.key_first_pass)
                    SVProgressHUD.showInfo(withStatus: "正在登录CMCC二层")
                    self.serialQueue.async(execute: self.thread_autologin)
                    
                    break
                case 1:
                    UserDefaults.standard.set(self.thread_first_user, forKey: self.key_fitst_user)
                    UserDefaults.standard.set("", forKey: self.key_first_pass)
                    ShowMessage("CMCC一层登录", "密码错误", self)

                    break
                case 2:
                    ShowMessage("CMCC一层登录", "未知错误", self)
                    break
                default:
                    break
                }
                
                
                break
            case Selector(("CMCCSecondLogin")):
                let message=arg as! Int
                switch(message){
                case 0:
                    UserDefaults.standard.set(self.thread_second_user, forKey: self.key_second_user)
                    UserDefaults.standard.set(self.thread_second_pass, forKey: self.key_second_pass)
                    
                    break
                case 1:
                    UserDefaults.standard.set(self.thread_second_user, forKey: self.key_second_user)
                    UserDefaults.standard.set("", forKey: self.key_second_pass)
                    ShowMessage("CMCC二层登录", "密码错误", self)
                    break
                case 2:
                    UserDefaults.standard.set(self.thread_second_user, forKey: self.key_second_user)
                    UserDefaults.standard.set("", forKey: self.key_second_pass)
                    ShowMessage("CMCC二层登录", "密码错误", self)
                    break
                case 3:
                    ShowMessage("CMCC二层登录", "网络信号不好", self)
                    break
                case 4:
                    ShowMessage("CMCC二层登录", "登录失败（原因未知）", self)
                    break
                default:
                    break
                    
                }
                
                
                break
            case Selector(("CMCCGetPass")):
                let message=arg as! Int
                
                break
            case Selector(("ErrorNetwork")):
                break
            default:
                break
            }
        
        
        }

    }
    func login(channel: String, user: String, pass: String) {

        
    }
    
}
