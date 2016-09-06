//
//  ViewControllerLibraryPersonal.swift
//  isdust_ios
//
//  Created by wzq on 8/21/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class ViewControllerLibraryPersonal: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var mlibrary:Library!
    let key_user="library_user"
    let key_password="library_password"
    var serialQueue:DispatchQueue!
    var thread_user:String?
    var thread_password:String?
    var thread_borrowdetail:[[String]]=[[String]]()

    func thread_borrwingdetail()  {
        do{
            thread_borrowdetail=try mlibrary.get_borrwingdetail()
            self.performSelector(onMainThread: Selector(("borrwingdetail")), with: nil, waitUntilDone: false, modes: nil)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
            
            
        }

    }
    func thread_renewall()  {
        do{
            let data=try mlibrary.renew_all()
            self.performSelector(onMainThread: Selector(("renewall")), with: data as AnyObject, waitUntilDone: false, modes: nil)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
            
            
        }

    }
//    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool) {
//        print(arg)
//    }
    

    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool, modes array: [String]?) {
        print(1)
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            switch(aSelector){
            case Selector(("borrwingdetail")):
                self.UITableView_detail.reloadData()
                break

            case Selector(("renewall")):
                let result=arg as! String
                let alert = UIAlertView()
                alert.title = "图书馆"
                alert.message = result
                alert.addButton(withTitle: "确定")
                alert.delegate=self
                alert.show()
                break
            case #selector(ViewControllerLibraryPersonal.menu_renew):
                self.menu_renew()
                break
            case #selector(ViewControllerLibraryPersonal.menu_logout):
                self.menu_logout()
                
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
        }
    }
    
    
    @IBOutlet weak var view_table: UIView!
    
    
    @IBOutlet weak var UITableView_detail: UITableView!

    
    @IBOutlet weak var textfield_user: UITextField!
    
    @IBOutlet weak var textfield_pass: UITextField!
    
    @IBOutlet weak var label_user: UILabel!
    
    @IBOutlet weak var label_condition: UILabel!
    @IBOutlet weak var label_name: UILabel!
    
    @IBAction func menu_plus_click(_ sender: AnyObject) {
        let menuArray:[AnyObject] = [
            KxMenuItem.init("一键续借", image: UIImage(named: "item_heartbroken"), target: self, action: #selector(ViewControllerLibraryPersonal.menu_renew)),
            KxMenuItem.init("注销", image: UIImage(named: "item_logout"), target: self, action: #selector(ViewControllerLibraryPersonal.menu_logout))
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
        a.size.height=30
        a.size.width*=2
        a.size.width-=60
        KxMenu.show(in: self.navigationController?.view, from: a, menuItems:menuArray, withOptions: options)
    }
    
    


    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return thread_borrowdetail.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCellBorrowedBook=tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCellBorrowedBook
        
        cell.label_bookrecno.text=thread_borrowdetail[indexPath.row][0]
        cell.label_bookname.text=thread_borrowdetail[indexPath.row][1]
        cell.label_borrowtime.text=thread_borrowdetail[indexPath.row][2]
        cell.label_duetime.text=thread_borrowdetail[indexPath.row][3]

        return cell
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        UITableView_detail.delegate = self
        UITableView_detail.dataSource = self
        serialQueue = DispatchQueue(label: "queuename", attributes: [])

        self.label_name.text=self.mlibrary.mPersonalInfo.name
        self.label_user.text=self.mlibrary.mPersonalInfo.id
        self.label_condition.text=self.mlibrary.mPersonalInfo.state
        self.serialQueue.async(execute: self.thread_borrwingdetail)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show(withStatus: "正在加载书本借阅信息")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func menu_renew()  {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show(withStatus: "正在续借借阅书本")
        self.serialQueue.async(execute: self.thread_renewall)
    }
    func menu_logout()  {
        // Create the alert controller
        let alertController = UIAlertController(title: "图书馆-注销", message: "是否确认注销?", preferredStyle: .alert)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
