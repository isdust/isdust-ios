//
//  Common.swift
//  isdust_ios
//
//  Created by wzq on 9/16/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
func md5(data:String) -> String {
    let cs = (data as NSString).utf8String
    let buffer = UnsafeMutablePointer<Int8>.init(mutating: cs)
    let b = String.init(cString: openssl_md5(buffer))
    return b;
}
func ShowMessage(_ title:String,_ message:String,_ delegate:AnyObject){
    let alert = UIAlertView()
    alert.title = "正方教务系统-登录"
    alert.message = message
    alert.addButton(withTitle: "确定")
    alert.delegate=delegate
    alert.show()
    
}
func encodepassword(rawpassword:String) -> String {
    let pid="1"
    let calg="12345678"
    let mmd5=md5(data: pid+rawpassword+calg)
    let result=mmd5+calg+pid
    return result
}
func getMiddleText(_ text:String,_ start:String,_ end:String) throws -> String {
    let range_start=(text as NSString).range(of: start)
    
    
    let range_end=((text as NSString).substring(from: range_start.length+range_start.location)as NSString).range(of: end)
    
    let range_result=NSRange.init(location: range_start.length+range_start.location, length: range_end.location)
    
    var result=try (text as NSString).substring(with: range_result) as String!
    return result!
    
}
