//
//  ViewSchoolLife.swift
//  isdust_ios
//
//  Created by wzq on 9/5/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class ViewSchoolLife:UITableViewController,ViewLoginDelegate,ViewSchoolLifeDelegate,ModuleCardClick{
//    internal func schedule_login(delegate: ViewControllerEducationScheduleDelegate) {
//        
//    }
    func ModuleMneuChoose() {
        performSegue(withIdentifier: "PersonalLibrary", sender:nil)
    }
    var ModuleCardDelegate:ModuleCard!
    var mzhengfang:Zhengfang!
    var mschoolcard:SchoolCard!
    var mlibrary:Library!
    var mscheduledelegate:ViewControllerEducationScheduleDelegate!

    var serialQueue:DispatchQueue!
    var thread_user:String?
    var thread_password:String?
    override func viewDidLoad() {
        
        serialQueue = DispatchQueue(label: "queuename", attributes: [])
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="ScoreLookUp"){
            var mcontroller=segue.destination as! ViewEducationScore
            mcontroller.mzhengfang=mzhengfang
        }
        if(segue.identifier=="SchoolCard"){
            var mcontroller=segue.destination as! ViewSchoolCardMain
            mcontroller.mschoolcard=mschoolcard
        }
        if(segue.identifier=="PersonalLibrary"){
            var mcontroller=segue.destination as! ViewControllerLibraryPersonal
            mcontroller.mlibrary=mlibrary
        }
        if(segue.identifier=="Schedule"){
            var mcontroller=segue.destination as! ViewControllerEducationSchedule
            mcontroller.mViewSchoolLifeDelegate=self
        }
        

        

    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier=="ScoreLookUp"){
            if(sender==nil){
                return true
            }
            
            let key_user="zhengfang_user"
            let key_password="zhengfang_password"
            thread_user = UserDefaults.standard.string(forKey: key_user)
            thread_password = UserDefaults.standard.string(forKey: key_password)
            mzhengfang=Zhengfang()
            if(thread_user==""||thread_password==""||thread_user==nil||thread_password==nil){
                let mviewlogin=ViewLogin.init(frame: (view.window?.rootViewController?.view.frame)!)
                mviewlogin.settitle(title: "正方教务系统")
                mviewlogin.sethint(user: "学号(12位)", pass: "正方教务平台密码")
                mviewlogin.setchannel(mchannel: "zhengfang")
                mviewlogin.delegate=self
                view.window?.rootViewController?.view.addSubview(mviewlogin)
                
            }else{
                
                serialQueue.async(execute: thread_login_zf)
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
                SVProgressHUD.show(withStatus: "正在登录正方教务系统")
                
            }
            return false
        }
        if(identifier=="SchoolCard"){
            if(sender==nil){
                return true
            }
            
            let key_user="schoolcard_user"
            let key_password="schoolcard_password"
            mschoolcard=SchoolCard()
            thread_user = UserDefaults.standard.string(forKey: key_user)
            thread_password = UserDefaults.standard.string(forKey: key_password)
            if(thread_user==""||thread_password==""||thread_user==nil||thread_password==nil){
                //title="校园卡登录"
                let mviewlogin=ViewLogin.init(frame: (view.window?.rootViewController?.view.frame)!)
                mviewlogin.settitle(title: "校园卡")
                mviewlogin.sethint(user: "校园卡号码(10位)", pass: "默认为校园卡号码后六位")
                mviewlogin.setchannel(mchannel: "schoolcard")
                mviewlogin.delegate=self
                view.window?.rootViewController?.view.addSubview(mviewlogin)
                
            }else{
                serialQueue.async(execute: thread_login_schoolcard)
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
                SVProgressHUD.show(withStatus: "正在登录校园卡系统")
                
            }
            return false
        }
        if(identifier=="PersonalLibrary"){
            if(sender==nil){
                return true
            }
            
            let key_user="library_user"
            let key_password="library_password"
            thread_user = UserDefaults.standard.string(forKey: key_user)
            thread_password = UserDefaults.standard.string(forKey: key_password)
            mlibrary=Library()
            if(thread_user==""||thread_password==""||thread_user==nil||thread_password==nil){
                let mviewlogin=ViewLogin.init(frame: (self.navigationController?.view.window?.rootViewController?.view.frame)!)
                mviewlogin.settitle(title: "图书馆个人中心")
                mviewlogin.sethint(user: "校园卡号码(10位)", pass: "默认为校园卡号码")
                mviewlogin.setchannel(mchannel: "librarypersonal")
                mviewlogin.delegate=self
                view.window?.rootViewController?.view.addSubview(mviewlogin)
                
            }else{
                
                serialQueue.async(execute: thread_login_library)
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
                SVProgressHUD.show(withStatus: "正在登录图书馆系统")
                
            }
            return false
        }
        return true
    }
    func thread_login_zf() {
        do{
            let result=try mzhengfang.Login(thread_user!, password: thread_password!)
            self.performSelector(onMainThread: Selector(("zhengfang_login")), with: result as AnyObject, waitUntilDone: false, modes: nil)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
            
        }
        catch{
            
        }
    }
    func thread_login_schedule() {
        do{
            let result=try mzhengfang.Login(thread_user!, password: thread_password!)
            self.performSelector(onMainThread: Selector(("schedule_login")), with: result as AnyObject, waitUntilDone: false, modes: nil)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
            
        }
        catch{
            
        }
    }
    func thread_login_schoolcard() {
        
        do{
            var result:String!
            result=try mschoolcard.login(thread_user!, password: thread_password!)
            self.performSelector(onMainThread: Selector(("schoolcard_login")), with: result as AnyObject, waitUntilDone: false, modes: nil)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
            
            
        }
    }
    func thread_login_library() {
        do{
            let result=try mlibrary.login(user: thread_user!, password: thread_password!)
            self.performSelector(onMainThread: Selector(("librarypersonal_login")), with: result as AnyObject, waitUntilDone: false, modes: nil)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
            
            
        }
    }
    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool, modes array: [String]?) {
        DispatchQueue.main.async(){
            switch aSelector {
            case Selector(("zhengfang_login")):
                let key_user="zhengfang_user"
                let key_password="zhengfang_password"
                let message=arg as! String
                SVProgressHUD.dismiss()
                if(message=="登录成功"){
                    UserDefaults.standard.set(self.thread_user, forKey: key_user)
                    UserDefaults.standard.set(self.thread_password, forKey: key_password)
                    self.performSegue(withIdentifier: "ScoreLookUp", sender: nil)
                    
                    return
                }else if(message=="用户名不存在"){
                    ShowMessage("正方教务系统-登录",message,self)
                }else if(message=="密码错误"){
                    ShowMessage("正方教务系统-登录",message,self)
                    UserDefaults.standard.set("", forKey: key_password)
                }else if(message=="未知错误"){
                    ShowMessage("正方教务系统-登录",message,self)
                }
                break
                
            case Selector("schoolcard_login"):
                let key_user="schoolcard_user"
                let key_password="schoolcard_password"
                let message=arg as! String
                
                SVProgressHUD.dismiss()
                if(message=="登陆成功"){
                    UserDefaults.standard.set(self.thread_user, forKey: key_user)
                    UserDefaults.standard.set(self.thread_password, forKey: key_password)
                    self.performSegue(withIdentifier: "SchoolCard", sender: nil)
                }else if(message=="无此用户名称"){
                    ShowMessage("校园卡-登录",message,self)
                }else if(message=="密码错误"){
                    ShowMessage("校园卡-登录",message,self)
                    UserDefaults.standard.set("", forKey: key_password)
                }else if(message=="未知错误"){
                    ShowMessage("校园卡-登录",message,self)
                }
                break
            case Selector(("librarypersonal_login")):
                let key_user="library_user"
                let key_password="library_password"
                let message=arg as! String
                SVProgressHUD.dismiss()
                if(message=="登录成功"){
//                    self.menu_plus.isEnabled = true
//                    self.view_login.isHidden=true
//                    self.view_table.isHidden=false
                    UserDefaults.standard.set(self.thread_user, forKey: key_user)
                    UserDefaults.standard.set(self.thread_password, forKey: key_password)
                    
                    self.performSegue(withIdentifier: "PersonalLibrary", sender: nil)
                    return
                    
                    
                }
                ShowMessage("图书馆-登录",message,self)
                UserDefaults.standard.set("", forKey: key_password)
                break
            case Selector(("schedule_login")):
                let key_user="zhengfang_user"
                let key_password="zhengfang_password"
                let message=arg as! String
                SVProgressHUD.dismiss()
                if(message=="登录成功"){
                    UserDefaults.standard.set(self.thread_user, forKey: key_user)
                    UserDefaults.standard.set(self.thread_password, forKey: key_password)
                    //UserDefaults.standard.set("", forKey: key_password)
                    self.mscheduledelegate.finishlogin(zhengfang: self.mzhengfang)
                    
                    return
                }else if(message=="用户名不存在"){
                    ShowMessage("正方教务系统-登录",message,self)
                }else if(message=="密码错误"){
                    ShowMessage("正方教务系统-登录",message,self)
                    UserDefaults.standard.set("", forKey: key_password)
                }else if(message=="未知错误"){
                    ShowMessage("正方教务系统-登录",message,self)
                }
                break
            case Selector(("ErrorNetwork")):
                SVProgressHUD.dismiss()
                ShowMessage("错误","网络超时",self)
                break
            default:
                break
                
            }
            print(aSelector)
        }
    }
    
    func login(channel: String, user: String, pass: String) {
        switch channel {
        case "zhengfang":
            thread_user = user
            thread_password = pass
            serialQueue.async(execute: thread_login_zf)
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.show(withStatus: "正在登录正方教务系统")
            break
        case "schoolcard":
            thread_user = user
            thread_password = pass
            serialQueue.async(execute: thread_login_schoolcard)
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.show(withStatus: "正在登录校园卡系统")
            break
        case "librarypersonal":
            thread_user = user
            thread_password = pass
            serialQueue.async(execute: thread_login_library)
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.show(withStatus: "正在登录图书馆系统")
            break
        case "schedule":
            thread_user = user
            thread_password = pass
            serialQueue.async(execute: thread_login_schedule)
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.show(withStatus: "正在登录正方教务系统")
            break
        default:
            break
        }
    }
    internal func schedule_login(delegate:ViewControllerEducationScheduleDelegate,mview:UIView) {
        let key_user="zhengfang_user"
        let key_password="zhengfang_password"
        mscheduledelegate=delegate
        thread_user = UserDefaults.standard.string(forKey: key_user)
        thread_password = UserDefaults.standard.string(forKey: key_password)
        mzhengfang=Zhengfang()
        if(thread_user==""||thread_password==""||thread_user==nil||thread_password==nil){
            
            let mviewlogin=ViewLogin.init(frame: (mview.frame))
            mviewlogin.settitle(title: "正方教务系统")
            mviewlogin.sethint(user: "学号(12位)", pass: "正方教务平台密码")
            mviewlogin.setchannel(mchannel: "schedule")
            mviewlogin.delegate=self
            mview.addSubview(mviewlogin)
            
        }else{
            
            serialQueue.async(execute: thread_login_schedule)
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.show(withStatus: "正在登录正方教务系统")
            
        }
    }

}
protocol ViewSchoolLifeDelegate{
    func schedule_login(delegate:ViewControllerEducationScheduleDelegate,mview:UIView)
}
