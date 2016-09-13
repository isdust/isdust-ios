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

    var mschoolcard:SchoolCard!

    let key_user="schoolcard_user"
    let key_password="schoolcard_password"


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
            if(SchoolTime.date2month(date: i[0])==purchase_section[section]){
                if(Float(i[4])!<0){
                total+=Float(i[4])!
                }
            }
        
        }
        return self.purchase_section[section ] + "月      总支出:" + String(-total)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return self.purchase_section.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count=0
        for i in purchase_detail{
            
            if(SchoolTime.date2month(date: i[0])==purchase_section[section]){
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
        let count=UITableView_detail.numberOfRows(inSection: indexPath.section)
        let num=UITableView_detail.indexPathsForVisibleRows?.last
        if !loadingData && indexPath.section == purchase_section.count - 1 && count-1 == num?.row {
            spinner.startAnimating()
            spinner.isHidden=false
            loadingData = true
            refreshData()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:TableViewSchoolCard=tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewSchoolCard
        var record=0
        for j in  0..<purchase_detail.count{
            
            if(SchoolTime.date2month(date: purchase_detail[j][0])==purchase_section[indexPath.section]) {
                record=j
                break
            }
        }        
        
        cell.label_deposit.text=purchase_detail[indexPath.row+record][4]
        cell.label_balance.text="￥"+purchase_detail[indexPath.row+record][5]
        cell.label_time_week.text=SchoolTime.date2day_card(date:purchase_detail[indexPath.row+record][0])
        cell.label_time_date.text=SchoolTime.date2time_card(date: purchase_detail[indexPath.row+record][0])
        cell.label_time_date.sizeToFit()
        let temp_location=purchase_detail[indexPath.row+record][2].replacingOccurrences(of: "(可备..", with: "楼")

        cell.image_location.image=SchoolCard.getlocationimage(location: temp_location)
        cell.label_location.text=temp_location
        
        var i=purchase_detail[indexPath.row+record]
        var index=i[0].index(i[0].endIndex, offsetBy: -8)
        
        var date=i[0].substring(from: index)
        //cell.label_time.text=date
        
        
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
            
            UserDefaults.standard.set("", forKey: self.key_password)
            self.navigationController?.popViewController(animated: true)
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
            KxMenuItem.init("修改密码", image: UIImage(named: "item_key"), target: self, action: #selector(ViewSchoolCardMain.menu_changepass)),
            KxMenuItem.init("挂失", image: UIImage(named: "item_heartbroken"), target: self, action: #selector(ViewSchoolCardMain.menu_reportloss)),
            KxMenuItem.init("注销", image: UIImage(named: "item_logout"), target: self, action: #selector(ViewSchoolCardMain.menu_logout))
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

        var a=self.navigationController?.view.frame
        a?.size.height=60
        a?.size.width*=2
        a?.size.width-=60
        KxMenu.show(in: self.navigationController?.view, from: a!, menuItems:menuArray, withOptions: options)
        
        
        
    }
    

    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool, modes array: [String]?) {
        DispatchQueue.main.async(){
        switch aSelector {
  
        case Selector(("detail")):
            let message=arg as! [[String]]
            for i in message{
                var date=SchoolTime.date2month(date: i[0])
                if !self.purchase_section.contains(date){
                    self.purchase_section.append(date)
                }
            }
            self.purchase_detail.append(contentsOf: message)
            self.UITableView_detail.reloadData()
            self.spinner.isHidden=true
            self.spinner.stopAnimating()
            self.loadingData = false
            SVProgressHUD.dismiss()

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


    func thread_getdetail()  {
        do{
        var data =  try mschoolcard.GetTransaction()
        self.performSelector(onMainThread: Selector(("detail")), with: data as AnyObject, waitUntilDone: false, modes: nil)
        }catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
        
        
        }
        

    }
    @IBOutlet var view_main: UIView!
    @IBOutlet weak var view_table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor=UIColor.white
        UITableView_detail.delegate = self
        UITableView_detail.dataSource = self
        serialQueue = DispatchQueue(label: "queuename", attributes: [])
        self.navigationItem.title="余额:"+String(self.mschoolcard.mPersonInfo.balance_total)
        self.serialQueue.async(execute: self.thread_getdetail)
        self.serialQueue.async(execute: self.thread_getdetail)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show(withStatus: "正在加载交易记录")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="SchoolCardChangePass" {
            let mcontroller=segue.destination as! ViewSchoolCardChangePass
            mcontroller.mschoolcard=self.mschoolcard
        }
        if segue.identifier=="SchoolCardReportLoss" {
            let mcontroller=segue.destination as! ViewSchoolCardReportLoss
            mcontroller.mschoolcard=self.mschoolcard
        }
    }
    
}
