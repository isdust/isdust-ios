//
//  ViewSchoolCardMain.swift
//  isdust_ios
//
//  Created by wzq on 7/31/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class ViewSchoolCardMain: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var UITableView_detail: UITableView!
    var purchase_detail:[[String]]=[[String]]()
    var purchase_section:[String]=[String]()
    var loadingData = false

    var refreshControl = UIRefreshControl()
    var mschoolcard:SchoolCard!
    let key_user="schoolcard_user"
    let key_password="schoolcard_password"
    var loadMoreText = UILabel()

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var serialQueue:DispatchQueue!
    var thread_user:String?
    var thread_password:String?
    func refreshData()  {
        serialQueue.async(execute: thread_getdetail)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var total:Float=0
        
        for i in purchase_detail{
            if(i[0].contains(self.purchase_section[section ])==true){
                total+=Float(i[4])!
            }
        
        }
        
        
        return self.purchase_section[section ] + "     收入:" + String(total)
        
    }
    
func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return self.purchase_section.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count=0
        for i in purchase_detail{
            if(i[0].contains(purchase_section[section])==true){
                count+=1
            }
        
        }
        
        return count
    }
//    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
//    {
//        return purchase_detail.count
//    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !loadingData && indexPath.section == purchase_section.count - 1 {
            spinner.startAnimating()
            loadingData = true
            refreshData()
            //refreshResults2()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        let cell:TableViewSchoolCard=tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewSchoolCard
        var record=0
        for j in  0..<purchase_detail.count{
            if(purchase_detail[j][0].contains(purchase_section[indexPath.section])==true) {
                record=j
                break
            }
        }

        cell.label_detail.text=purchase_detail[indexPath.row+record][1]
        cell.label_type.text=purchase_detail[indexPath.row+record][2].replacingOccurrences(of: "(可备..", with: "楼")
        
        
        cell.label_deposit.text=purchase_detail[indexPath.row+record][4]
        cell.label_balance.text=purchase_detail[indexPath.row+record][5]
        
        var i=purchase_detail[indexPath.row+record]
        var index=i[0].index(i[0].endIndex, offsetBy: -8)
        
        var date=i[0].substring(from: index)
        cell.label_time.text=date
        
        
        return cell
    }
    func menu_changepass() {
        self.performSegue(withIdentifier: "SchoolCardChangePass", sender: nil)
    }
    func menu_reportloss() {
        self.performSegue(withIdentifier: "SchoolCardReportLoss", sender: nil)
    }
    func menu_logout()  {
        
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: "校园卡-注销", message: "是否确认注销?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.mschoolcard=SchoolCard()
            self.purchase_detail=[[String]]()
            self.purchase_section=[String]()
            self.UITableView_detail.reloadData()
            self.navigationItem.title="校园卡登录"
            
            self.edit_user.text=self.thread_user
            self.thread_password=""
            UserDefaults.standard.set(self.thread_password, forKey: self.key_password)
            self.view_table.isHidden=true
            self.view_login.isHidden=false
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        

    }

    @IBAction func menu_plus_click(_ sender: UIBarButtonItem) {
        let menuArray:[AnyObject] = [
            KxMenuItem.init("修改密码", image: UIImage(named: "item_key"), target: self, action: "menu_changepass"),
            KxMenuItem.init("挂失", image: UIImage(named: "item_heartbroken"), target: self, action: "menu_reportloss"),
            KxMenuItem.init("注销", image: UIImage(named: "item_logout"), target: self, action: "menu_logout")
        ]
        
        //配置一：基础配置
        KxMenu.setTitleFont(UIFont(name: "HelveticaNeue", size: 15))
        
        //配置二：拓展配置
        let options = OptionalConfiguration(arrowSize: 9,  //指示箭头大小
            marginXSpacing: 7,  //MenuItem左右边距
            marginYSpacing: 9,  //MenuItem上下边距
            intervalSpacing: 25,  //MenuItemImage与MenuItemTitle的间距
            menuCornerRadius: 6.5,  //菜单圆角半径
            maskToBackground: true,  //是否添加覆盖在原View上的半透明遮罩
            shadowOfMenu: false,  //是否添加菜单阴影
            hasSeperatorLine: true,  //是否设置分割线
            seperatorLineHasInsets: false,  //是否在分割线两侧留下Insets
            textColor: Color(R: 0, G: 0, B: 0),  //menuItem字体颜色
            menuBackgroundColor: Color(R: 1, G: 1, B: 1)  //菜单的底色
        )
        let barButtonItem = self.navigationItem.rightBarButtonItem!
        let buttonItemView = barButtonItem.value(forKey: "view")
        var a=self.view.frame
        a.size.height=60
        a.size.width*=2
        a.size.width-=60
        //let temp = sender.accessibilityFrame
        //var frame = (buttonItemView as AnyObject).frame
        //frame?.origin.y+=30
        KxMenu.show(in: self.navigationController?.view, from: a, menuItems:menuArray, withOptions: options)
        
        
        
    }
    

    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool, modes array: [String]?) {
        DispatchQueue.main.async(){
        switch aSelector {
        case Selector("login"):
            let message=arg as! String
            SVProgressHUD.dismiss()
            self.view_login.isHidden=false
            if(message=="登陆成功"){
                
                self.view_login.isHidden=true
                self.view_table.isHidden=false
                self.navigationItem.title="余额:"+String(self.mschoolcard.mPersonInfo.balance_total)
                UserDefaults.standard.set(self.thread_user, forKey: self.key_user)
                UserDefaults.standard.set(self.thread_password, forKey: self.key_password)
                self.serialQueue.async(execute: self.thread_getdetail)
                self.serialQueue.async(execute: self.thread_getdetail)
                


            }else if(message=="无此用户名称"){


                let alert = UIAlertView()
                alert.title = "校园卡-登录"
                alert.message = message
                alert.addButton(withTitle: "确定")
                alert.delegate=self
                alert.show()
                self.edit_user.text=""
                self.edit_pass.text=""
            }else if(message=="密码错误"){
                let alert = UIAlertView()
                alert.title = "校园卡-登录"
                alert.message = message
                alert.addButton(withTitle: "确定")
                alert.delegate=self
                alert.show()
                self.edit_pass.text=""
                UserDefaults.standard.set("", forKey: self.key_password)
            }else if(message=="未知错误"){
                let alert = UIAlertView()
                alert.title = "校园卡-登录"
                alert.message = message
                alert.addButton(withTitle: "确定")
                alert.delegate=self
                alert.show()
            }
            break
        case Selector(("detail")):
            let message=arg as! [[String]]
            for i in message{
               // var index=i[0][startIndex...string.index(startIndex, offsetBy: 4)]
                var date=i[0][i[0].startIndex...i[0].index(i[0].startIndex, offsetBy: 9)]

                if !self.purchase_section.contains(date){
                    self.purchase_section.append(date)
                }
            }
            self.purchase_detail.append(contentsOf: message)
            self.UITableView_detail.reloadData()
            self.refreshControl.endRefreshing()
            self.spinner.stopAnimating()
            self.loadingData = false

            break
        case #selector(ViewSchoolCardMain.menu_changepass):
            self.menu_changepass()
            break
        case #selector(ViewSchoolCardMain.menu_reportloss):
            self.menu_reportloss()
            break
        case #selector(ViewSchoolCardMain.menu_logout):
            self.menu_logout()
            break
        default:
            break
            
        }
            print(aSelector)}
    }

    func thread_login() {
        let result=mschoolcard.login(thread_user!, password: thread_password!)
        self.performSelector(onMainThread: Selector(("login")), with: result as AnyObject, waitUntilDone: false, modes: nil)
    }
    func thread_getdetail()  {
        let data=mschoolcard.NextPage()
        self.performSelector(onMainThread: Selector(("detail")), with: data as AnyObject, waitUntilDone: false, modes: nil)
    }
    @IBOutlet weak var view_login: UIView!
    @IBOutlet var view_main: UIView!
    @IBOutlet weak var edit_user: UITextField!
    @IBOutlet weak var edit_pass: UITextField!

    @IBOutlet weak var view_table: UITableView!

    @IBAction func button_login_click(_ sender: AnyObject) {
        if(edit_pass.text != "" && edit_user.text != ""){
            thread_user=edit_user.text!
            thread_password=edit_pass.text!
            edit_user.endEditing(true)
            edit_pass.endEditing(true)
            serialQueue.async(execute: thread_login)
            SVProgressHUD.show()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        UITableView_detail.delegate = self
        UITableView_detail.dataSource = self
        mschoolcard=SchoolCard()
        serialQueue = DispatchQueue(label: "queuename", attributes: [])
        thread_user = UserDefaults.standard.string(forKey: key_user)
        thread_password = UserDefaults.standard.string(forKey: key_password)
        if(thread_user==""||thread_password==""||thread_user==nil||thread_password==nil){
            title="校园卡登录"
            view_table.isHidden=true
            view_login.isHidden=false

        }else{
            view_login.isHidden=true
            view_table.isHidden=false
            serialQueue.async(execute: thread_login)
            SVProgressHUD.show()
        
        }
                //let storedUsername = NSUserDefaults.standardUserDefaults().stringForKey(StrUsernameKey)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="SchoolCardChangePass" {
            
            let SchoolCardChangePassController=segue.destination as! SchoolCardChangePass
            SchoolCardChangePassController.mschoolcard=self.mschoolcard
            
        }
    }
    
}
