//
//  ViewSchoolCardRecord.swift
//  isdust_ios
//
//  Created by wzq on 8/2/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation

class ViewSchoolCardReportLoss: UITableViewController {
    var mschoolcard:SchoolCard!
    var thread_pass:String!
    var thread_identity:String!
    var serialQueue:DispatchQueue!
    let key_password="schoolcard_password"
    
    @IBOutlet weak var textfield_identity: UITextField!
    
    @IBOutlet weak var textfield_pass: UITextField!

    
    @IBAction func button_changepass(_ sender: AnyObject) {
        
        if(textfield_identity.text==""||textfield_pass.text==""){
            ShowMessage("校园卡-挂失","请输入完整信息",self)
            return
            
        }
        if(textfield_identity.text != mschoolcard.mPersonInfo.identity){
            textfield_identity.text=""
            ShowMessage("校园卡-挂失","身份证号码验证失败，请重试",self)
            
            
            return
        }
        if(textfield_pass.text != mschoolcard.mPersonInfo.password){
            textfield_pass.text=""
            ShowMessage("校园卡-挂失","密码验证失败，请重试",self)
            return
        }
        

        thread_pass=textfield_pass.text
        thread_identity=textfield_identity.text
        serialQueue.async(execute: thread_reportloss)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show()
    }
    
    func thread_reportloss() {
        do{
            let result=try mschoolcard.ReportLoss(thread_pass, identity: thread_identity)
            self.performSelector(onMainThread: Selector(("reportloss")), with: result as AnyObject, waitUntilDone: false)
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
            alert.title = "校园卡-挂失"
            alert.addButton(withTitle: "确定")
            switch aSelector {
            case Selector(("reportloss")):
                
                let message=arg as! String
                if(message=="操作成功"||message=="持卡人已挂失，无需再次挂失"){
                    alert.message = message
                    alert.show()
                    self.navigationController?.popViewController(animated: true)
                    
                    return
                    
                }
                alert.message = message
                alert.show()
                
                break
            case Selector(("ErrorNetwork")):
                SVProgressHUD.dismiss()
                ShowMessage("错误","网络超时",self)
                break
            default:
                break
                
            }
            print(aSelector)}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serialQueue = DispatchQueue(label: "SchoolCardReportLoss", attributes: [])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
