//
//  DataType.swift
//  isdust_ios
//
//  Created by wzq on 7/24/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
struct Kebiao {
    var zhoushu:String
    var xingqi:String
    var jieci:String
    var kecheng:String
    init(){
        zhoushu=""
        xingqi=""
        jieci=""
        kecheng=""
    }
}
struct Transaction{
    var time:String
    var address:String
    var balance:String
    var money:String
    var detail:String
    init(){
        time=""
        address=""
        balance=""
        money=""
        detail=""
    }
    mutating func FormatFromString(_ data:[String]) {
        detail = data[1]
        address = data[2]
        time = data[0]
        balance = data[5]
        money = data[4]
        
        let index=money.index(money.startIndex, offsetBy: 0)
        if(money[index]=="-"){
            return
        }
        balance=String(Float(balance)!+Float(money)!)
        
    }
    
    
    
}
