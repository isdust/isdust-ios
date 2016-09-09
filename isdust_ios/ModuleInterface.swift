//
//  ViewSchoolLife.swift
//  isdust_ios
//
//  Created by wzq on 9/5/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
struct Module{
    var midentifier:String!
    var micon:UIImage!
    var mtitle:String!
    var mdescription:String!
    var mclassification:String!
    var mshortcut:Bool!
    init(identifier:String,icon:UIImage,title:String,description:String,classification:String){
        midentifier=identifier
        micon=icon
        mtitle=title
        mdescription=description
        mclassification=classification
        
        mshortcut = UserDefaults.standard.string(forKey: "shortcut_"+identifier)=="0" ? false : true
    }
}
var module_all:[Module] = [
//校园卡
Module.init(identifier: "SchoolCard", icon: #imageLiteral(resourceName: "menu_card"), title: "一卡通", description: "提供校园一卡通余额查询，消费情况查询，以及挂失与修改密码服务", classification: "校园卡"),
    
//教务
Module.init(identifier: "Schedule", icon: #imageLiteral(resourceName: "menu_schedule"), title: "课程表", description: "提供课程表查看，课程表下载，还能自定义课表", classification: "教务"),
Module.init(identifier: "ScoreLookUp", icon: #imageLiteral(resourceName: "menu_mark"), title: "成绩查询", description: "提供所有考试成绩查询，GPA查询", classification: "教务"),
Module.init(identifier: "EmptyClassroom", icon: #imageLiteral(resourceName: "menu_classroom"), title: "空教室查询", description: "提供指定时间内的空教室信息查询服务", classification: "教务"),

//图书馆
Module.init(identifier: "LibraryStorage", icon: #imageLiteral(resourceName: "menu_library"), title: "馆藏查询", description: "提供图书馆馆藏状态查询，书本位置查询", classification: "图书馆"),
Module.init(identifier: "PersonalLibrary", icon: #imageLiteral(resourceName: "menu_person"), title: "个人中心", description: "提供书本续借，还书日期查询", classification: "图书馆"),

]
func ModuleGetByIdenitifer(idenitifer:String) -> [Module]{
    return module_all.filter({$0.midentifier==idenitifer})
}
func ModuleGetByClass(classification:String)-> [Module]{
    return module_all.filter({$0.mclassification==classification})
}
func ModuleGetByShortcut()-> [Module]{
    return module_all.filter({$0.mshortcut==true})
}
func ModuleGetClass()->[String]{
    var result:[String]=[String]()
    for i in module_all{
        if result.contains(i.mclassification)==false{
            result.append(i.mclassification)
        }
    }
    return result

}
class ModuleInterface:ViewLoginDelegate,ViewSchoolLifeDelegate{

    var mviewcontroller:UIViewController!
    var mzhengfang:Zhengfang!
    var mschoolcard:SchoolCard!
    var mlibrary:Library!
    var mscheduledelegate:ViewControllerEducationScheduleDelegate!
    
    var serialQueue:DispatchQueue!
    var thread_user:String?
    var thread_password:String?
    init() {
        serialQueue = DispatchQueue(label: "queuename", attributes: [])

    }
    func enter(withIdentifier identifier: String, sender: Any?){
    
        if(identifier=="ScoreLookUp"){
            if(sender==nil){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! ViewEducationScore
                vc.mzhengfang=mzhengfang
                mviewcontroller.navigationController?.pushViewController(vc, animated: false)
                return
            }
            
            let key_user="zhengfang_user"
            let key_password="zhengfang_password"
            thread_user = UserDefaults.standard.string(forKey: key_user)
            thread_password = UserDefaults.standard.string(forKey: key_password)
            mzhengfang=Zhengfang()
            if(thread_user==""||thread_password==""||thread_user==nil||thread_password==nil){
                //print(mviewcontroller.view.window?.rootViewController?.view.frame)
                let mviewlogin=ViewLogin.init(frame: (mviewcontroller.view.window?.rootViewController?.view.frame)!)
                mviewlogin.settitle(title: "正方教务系统")
                mviewlogin.sethint(user: "学号(12位)", pass: "正方教务平台密码")
                mviewlogin.setchannel(mchannel: "zhengfang")
                mviewlogin.delegate=self
                mviewcontroller.view.window?.rootViewController?.view.addSubview(mviewlogin)
                
            }else{
                
                serialQueue.async(execute: thread_login_zf)
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
                SVProgressHUD.show(withStatus: "正在登录正方教务系统")
                
            }
            return
        }
        if(identifier=="SchoolCard"){
            if(sender==nil){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! ViewSchoolCardMain
                vc.mschoolcard=mschoolcard
                mviewcontroller.navigationController?.pushViewController(vc, animated: false)
                return
            }
            
            let key_user="schoolcard_user"
            let key_password="schoolcard_password"
            mschoolcard=SchoolCard()
            thread_user = UserDefaults.standard.string(forKey: key_user)
            thread_password = UserDefaults.standard.string(forKey: key_password)
            if(thread_user==""||thread_password==""||thread_user==nil||thread_password==nil){
                //title="校园卡登录"
                let mviewlogin=ViewLogin.init(frame: (mviewcontroller.view.window?.rootViewController?.view.frame)!)
                mviewlogin.settitle(title: "校园卡")
                mviewlogin.sethint(user: "校园卡号码(10位)", pass: "默认为校园卡号码后六位")
                mviewlogin.setchannel(mchannel: "schoolcard")
                mviewlogin.delegate=self
                mviewcontroller.view.window?.rootViewController?.view.addSubview(mviewlogin)
                
            }else{
                serialQueue.async(execute: thread_login_schoolcard)
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
                SVProgressHUD.show(withStatus: "正在登录校园卡系统")
                
            }
            return
        }
        if(identifier=="PersonalLibrary"){
            if(sender==nil){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! ViewControllerLibraryPersonal
                vc.mlibrary=mlibrary
                mviewcontroller.navigationController?.pushViewController(vc, animated: false)
                return
            }
            
            let key_user="library_user"
            let key_password="library_password"
            thread_user = UserDefaults.standard.string(forKey: key_user)
            thread_password = UserDefaults.standard.string(forKey: key_password)
            mlibrary=Library()
            if(thread_user==""||thread_password==""||thread_user==nil||thread_password==nil){
                let mviewlogin=ViewLogin.init(frame: (mviewcontroller.view.window?.rootViewController?.view.frame)!)
                mviewlogin.settitle(title: "图书馆个人中心")
                mviewlogin.sethint(user: "校园卡号码(10位)", pass: "默认为校园卡号码")
                mviewlogin.setchannel(mchannel: "librarypersonal")
                mviewlogin.delegate=self
                mviewcontroller.view.window?.rootViewController?.view.addSubview(mviewlogin)
                
            }else{
                
                serialQueue.async(execute: thread_login_library)
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
                SVProgressHUD.show(withStatus: "正在登录图书馆系统")
                
            }
            return
        }
        if(identifier=="Schedule"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! ViewControllerEducationSchedule
            vc.mViewSchoolLifeDelegate=self
            mviewcontroller.navigationController?.pushViewController(vc, animated: false)
            return
        
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        mviewcontroller.navigationController?.pushViewController(vc, animated: false)
        

        return
    
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
    
     func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool, modes array: [String]?) {
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
//                    self.performSegue(withIdentifier: "ScoreLookUp", sender: nil)
                    let identifier="ScoreLookUp"
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! ViewEducationScore
                    vc.mzhengfang=self.mzhengfang
                    self.mviewcontroller.navigationController?.pushViewController(vc, animated: false)
                    
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
//                    self.performSegue(withIdentifier: "SchoolCard", sender: nil)
                    let identifier="SchoolCard"
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! ViewSchoolCardMain
                    vc.mschoolcard=self.mschoolcard
                    self.mviewcontroller.navigationController?.pushViewController(vc, animated: false)
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
                    UserDefaults.standard.set(self.thread_user, forKey: key_user)
                    UserDefaults.standard.set(self.thread_password, forKey: key_password)
                    
//                    self.performSegue(withIdentifier: "PersonalLibrary", sender: nil)
                    let identifier="PersonalLibrary"
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! ViewControllerLibraryPersonal
                    vc.mlibrary=self.mlibrary
                    self.mviewcontroller.navigationController?.pushViewController(vc, animated: false)
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
//protocol ViewSchoolLifeDelegate{
//    func schedule_login(delegate:ViewControllerEducationScheduleDelegate,mview:UIView)
//}
