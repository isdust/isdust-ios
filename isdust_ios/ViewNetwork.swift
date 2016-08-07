//
//  ViewNetwork.swift
//  isdust_ios
//
//  Created by wzq on 8/6/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class ViewNetwork: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func respondOfMenu(sender: AnyObject) {
        
        print(sender)
    }
    @IBAction func button_click(_ sender: AnyObject) {
        
        var a=#selector(self.respondOfMenu(sender:))
        let menuArray:[AnyObject] = [KxMenuItem.init("扫一扫", image: UIImage(named: "Touch"), target: self, action: a),
                                     KxMenuItem.init("加好友", image: UIImage(named: "Touch"), target: self, action: Selector(("respondOfMenu:"))),
                                     KxMenuItem.init("创建讨论组", image: UIImage(named: "Touch"), target: self, action: Selector(("respondOfMenu:"))),
                                     KxMenuItem.init("发送到电脑", image: UIImage(named: "Touch"), target: self, action: "respondOfMenu:"),
                                     KxMenuItem.init("面对面快传", image: UIImage(named: "Touch"), target: self, action: "respondOfMenu:"),
                                     KxMenuItem.init("收钱", image: UIImage(named: "Touch"), target: self, action: "respondOfMenu:")]
        
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
        var barButtonItem = self.navigationItem.rightBarButtonItem!
        var buttonItemView = barButtonItem.value(forKey: "view")
        var frame = buttonItemView?.frame
        frame?.origin.y+=30
        KxMenu.show(in: self.navigationController?.view, from: frame!, menuItems:menuArray, withOptions: options)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        

        
        
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 0
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count=0

        return count
    }
    //    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    //    {
    //        return purchase_detail.count
    //    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        let cell:TableViewSchoolCard=tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewSchoolCard
        
        
        return cell
    }

}
