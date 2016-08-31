//
//  ViewEducation.swift
//  isdust_ios
//
//  Created by wzq on 8/7/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation

class ViewEducation: UIViewController {
    @IBOutlet weak var edit_user: UITextField!
    @IBOutlet weak var edit_pass: UITextField!
    
    @IBAction func button_lookupscore(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ScoreLookUp", sender: nil)
    }
    
    @IBAction func button_emptyclassroom(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "EmptyClassroom", sender: nil)
    }
    
    let key_user="zhengfang_user"
    let key_password="zhengfang_password"
    
    var mzhengfang:Zhengfang!
    var serialQueue:DispatchQueue!
    var thread_user:String?
    var thread_password:String?
    
    func thread_login() {
        
        do{
            let result=try mzhengfang.Login(thread_user!, password: thread_password!)
            
            self.performSelector(onMainThread: Selector(("zhengfang_login")), with: result as AnyObject, waitUntilDone: false, modes: nil)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
            
        }
        catch{
            
        }
        

//        self.performSelector(onMainThread: Selector(("zhengfang_login")), with: result as AnyObject, waitUntilDone: false)
    }
    func thread_AllScoreLookup() {
        do{
            let result=try mzhengfang.AllScoreLookUp()
            self.performSelector(onMainThread: Selector(("zhengfang_scorelookup")), with: result as AnyObject, waitUntilDone: false, modes: nil)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
            
        }
        catch{
            
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="ScoreLookUp" {
            let SchoolCardChangePassController=segue.destination as! ViewEducationScore
            SchoolCardChangePassController.mzhengfang=self.mzhengfang
            
        }
        if segue.identifier=="schedule" {
            let mViewControllerEducationSchedule=segue.destination as! ViewControllerEducationSchedule
            mViewControllerEducationSchedule.mzhengfang=self.mzhengfang
            
        }
        
        
    }

    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool, modes array: [String]?) {
        DispatchQueue.main.async(){
            switch aSelector {
            case Selector(("zhengfang_login")):
                let message=arg as! String
                SVProgressHUD.dismiss()
                //self.view_login.isHidden=false
                if(message=="登录成功"){
                    //self.serialQueue.async(execute: self.thread_AllScoreLookup)
//                    self.view_login.isHidden=true
//                    self.view_table.isHidden=false
//                    self.navigationItem.title="余额:"+String(self.mschoolcard.mPersonInfo.balance_total)
                    UserDefaults.standard.set(self.thread_user, forKey: self.key_user)
                    UserDefaults.standard.set(self.thread_password, forKey: self.key_password)
                   
//                    self.serialQueue.async(execute: self.thread_getdetail)
                    
                    
                    
                }else if(message=="用户名不存在"){
                    
                    
                    let alert = UIAlertView()
                    alert.title = "正方教务系统-登录"
                    alert.message = message
                    alert.addButton(withTitle: "确定")
                    alert.delegate=self
                    alert.show()
                    self.edit_user.text=""
                    self.edit_pass.text=""
                }else if(message=="密码错误"){
                    let alert = UIAlertView()
                    alert.title = "正方教务系统-登录"
                    alert.message = message
                    alert.addButton(withTitle: "确定")
                    alert.delegate=self
                    alert.show()
                    self.edit_pass.text=""
                    UserDefaults.standard.set("", forKey: self.key_password)
                }else if(message=="未知错误"){
                    let alert = UIAlertView()
                    alert.title = "正方教务系统-登录"
                    alert.message = message
                    alert.addButton(withTitle: "确定")
                    alert.delegate=self
                    alert.show()
                }
                break
            case Selector("zhengfang_scorelookup"):
                
                let message=arg as! [[String]]
                //print(message)
                break
            case Selector(("ErrorNetwork")):
                SVProgressHUD.dismiss()
                let alert = UIAlertView()
                alert.title = "错误"
                alert.message = "网络超时"
                alert.addButton(withTitle: "确定")
                alert.delegate=self
                alert.show()
                break
            default:
                break
                
            }
            print(aSelector)}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mzhengfang=Zhengfang()
        serialQueue = DispatchQueue(label: "queuename", attributes: [])
        thread_user = UserDefaults.standard.string(forKey: key_user)
        thread_password = UserDefaults.standard.string(forKey: key_password)
        
        if(thread_user==""||thread_password==""||thread_user==nil||thread_password==nil){
            self.navigationItem.title="正方教务系统登录"
//            view_table.isHidden=true
//            view_login.isHidden=false
            
            
            //self.present(anotherView, animated: true, completion: nil)
        }else{
//            view_login.isHidden=true
//            view_table.isHidden=false
            serialQueue.async(execute: thread_login)
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.show()
            
        }
        
    }
    
    
    @IBAction func button_login_click(_ sender: AnyObject) {
        if(edit_pass.text != "" && edit_user.text != ""){
            thread_user=edit_user.text!
            thread_password=edit_pass.text!
            edit_user.endEditing(true)
            edit_pass.endEditing(true)
            serialQueue.async(execute: thread_login)
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            //let alert = UIAlertController(title: nil, message: "正在登录", preferredStyle: .alert)
            SVProgressHUD.show()
            
            
            
            
            
        }
    }
    
}
