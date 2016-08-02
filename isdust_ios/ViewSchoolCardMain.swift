//
//  ViewSchoolCardMain.swift
//  isdust_ios
//
//  Created by wzq on 7/31/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class ViewSchoolCardMain: UIViewController {
    var mschoolcard:SchoolCard!
    let key_user="schoolcard_user"
    let key_password="schoolcard_password"
    
    //for multi-thread
    var serialQueue:DispatchQueue!
    var thread_user:String=""
    var thread_password:String=""
  
    override func performSelector(onMainThread aSelector: Selector, with arg: AnyObject?, waitUntilDone wait: Bool) {
        DispatchQueue.main.async(){
        switch aSelector {
        case "login":
            var message=arg as! String
            if(message=="登陆成功"){
                
                var alert = UIAlertView()
                alert.title = "校园卡-登录"
                alert.message = message
                alert.addButton(withTitle: "确定")
                alert.delegate=self
                alert.show()
            }else if(message=="无此用户名称"){


                var alert = UIAlertView()
                alert.title = "校园卡-登录"
                alert.message = message
                alert.addButton(withTitle: "确定")
                alert.delegate=self
                alert.show()
                self.edit_user.text=""
                self.edit_pass.text=""
            }else if(message=="密码错误"){
                var alert = UIAlertView()
                alert.title = "校园卡-登录"
                alert.message = message
                alert.addButton(withTitle: "确定")
                alert.delegate=self
                alert.show()
                self.edit_pass.text=""
            }else if(message=="未知错误"){
                var alert = UIAlertView()
                alert.title = "校园卡-登录"
                alert.message = message
                alert.addButton(withTitle: "确定")
                alert.delegate=self
                alert.show()
            }
            break
        default:
            break
            
        }
            print(aSelector)}
    }

    func thread_login() {
        var result=mschoolcard.login(thread_user, password: thread_password)
        self.performSelector(onMainThread: "login", with: result as! AnyObject, waitUntilDone: false)
        //self.performSelector(inBackground: "login", with: result as! AnyObject)
    }
    
    @IBOutlet weak var label_user: UILabel!
    @IBOutlet weak var label_password: UILabel!
    @IBOutlet weak var button_login: UIButton!
    @IBOutlet weak var edit_pass: UITextField!
    @IBOutlet weak var edit_user: UITextField!
    @IBAction func button_login_click(_ sender: AnyObject) {
        if(edit_pass.text != "" && edit_user.text != ""){
            thread_user=edit_user.text!
            thread_password=edit_pass.text!
            edit_pass.text=""
            serialQueue.async(execute: thread_login)
            
            
            
        
        }
    }
    func view_login_hide(){
        edit_pass.isHidden=true
        edit_user.isHidden=true
        label_user.isHidden=true
        label_password.isHidden=true
        button_login.isHidden=true
        
    }
    func view_login_show(){
        edit_pass.isHidden=false
        edit_user.isHidden=false
        label_user.isHidden=false
        label_password.isHidden=false
        button_login.isHidden=false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mschoolcard=SchoolCard()
        serialQueue = DispatchQueue(label: "queuename", attributes: .serial)
        
        let save_user = UserDefaults.standard().string(forKey: key_user)
        let save_password = UserDefaults.standard().string(forKey: key_password)
        if(save_user==""||save_password==""||save_user==nil||save_password==nil){
//            let alert = UIAlertController(title: "Video", message: "You have played all videos", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            self.performSegue(withIdentifier: "login", sender: nil)
            //self.performSegue(withIdentifier: "login", sender: nil)

            //self.performSegue(withIdentifier: "login", sender: nil)
            //self.tabBarController?.performSegue(withIdentifier: "login", sender: self)
        //
           // var vcs=NSMutableArray.init(array: self.presentedViewController)
            
           // self.view.present
            
            //let myStoryBoard = self.storyboard
           // let anotherView:ViewLogin = myStoryBoard?.instantiateViewController(withIdentifier: "login") as! ViewLogin
            

            //self.present(anotherView, animated: true, completion: nil)
        }else{
            view_login_hide()
        
        }
                //let storedUsername = NSUserDefaults.standardUserDefaults().stringForKey(StrUsernameKey)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier=="login" {
//            let LoginController=segue.destinationViewController as! ViewLogin
//            //LoginController.transitioni=self
//            LoginController.hint_user="校园卡号码"
//            LoginController.hint_password="校园卡密码(默认为校园卡后6位)"
//            LoginController.titlename="校园卡登录"
//            
//        }
    }
    
}
