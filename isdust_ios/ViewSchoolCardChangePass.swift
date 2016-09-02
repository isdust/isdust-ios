//
//  ViewSchoolCardRecord.swift
//  isdust_ios
//
//  Created by wzq on 8/2/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation

class SchoolCardChangePass: UITableViewController {
    var mschoolcard:SchoolCard!
    var thread_rawpass:String!
    var thread_newpass:String!
    var thread_identity:String!
    var serialQueue:DispatchQueue!
    let key_password="schoolcard_password"
    
    @IBOutlet weak var textfield_identity: UITextField!
   
    @IBOutlet weak var textfield_rawpass: UITextField!
    
    @IBOutlet weak var textfield_newpass: UITextField!
    
    @IBOutlet weak var textfield_newpass_re: UITextField!
    
    @IBAction func button_changepass(_ sender: AnyObject) {
        let alert = UIAlertView()
        alert.title = "校园卡-修改密码"
        alert.addButton(withTitle: "确定")
        
        alert.delegate=self
        if(textfield_identity.text==""||textfield_rawpass.text==""||textfield_newpass.text==""||textfield_newpass_re.text==""){
            alert.message = "请输入完整信息"
            alert.show()
            return
        
        }
        if(textfield_identity.text != mschoolcard.mPersonInfo.identity){
            alert.message = "身份证号码验证失败，请重试"
            textfield_identity.text=""
            alert.show()
            return
        }
        if(textfield_rawpass.text != mschoolcard.mPersonInfo.password){
            alert.message = "原始密码验证失败，请重试"
            textfield_rawpass.text=""
            alert.show()
            return
        }
        
        if(textfield_newpass.text != textfield_newpass_re.text){
            alert.message = "两次密码输入不一致失败，请重试"
            alert.show()
            return
        }
        thread_rawpass=textfield_rawpass.text
        thread_newpass=textfield_newpass.text
        thread_identity=textfield_identity.text
        serialQueue.async(execute: thread_changepass)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show()
    }
    
    func thread_changepass() {
        do{
            let result=try mschoolcard.ChangePassword(thread_rawpass, newpassword: thread_newpass, identity: thread_identity)
            self.performSelector(onMainThread: Selector(("changepass")), with: result as AnyObject, waitUntilDone: false)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
            
            
        }

    }
    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool, modes array: [String]?) {
        DispatchQueue.main.async(){
            SVProgressHUD.dismiss()
            
            let alert = UIAlertView()
            alert.title = "校园卡-修改密码"
            alert.addButton(withTitle: "确定")
            switch aSelector {
            case Selector(("changepass")):
                
                let message=arg as! String
                if(message=="修改密码成功"){
                    UserDefaults.standard.set(self.thread_newpass, forKey: self.key_password)
                    alert.message = "密码修改成功"
                    alert.show()
                    self.navigationController?.popViewController(animated: true)

                    return
                    
                }
                alert.message = message
                alert.show()
                
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
        serialQueue = DispatchQueue(label: "SchoolCardChangePass", attributes: [])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
