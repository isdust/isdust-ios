//
//  Base.swift
//  isdust_ios
//
//  Created by wzq on 9/6/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
func ShowMessage(_ title:String,_ message:String,_ delegate:AnyObject){
    let alert = UIAlertView()
    alert.title = "正方教务系统-登录"
    alert.message = message
    alert.addButton(withTitle: "确定")
    alert.delegate=delegate
    alert.show()

}
