//
//  SchoolTime.swift
//  isdust_ios
//
//  Created by wzq on 8/25/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class SchoolTime{
    static func num2week(num:Int) -> String {
        switch num {
        case 1:
            return "周一"
        case 2:
            return "周二"
        case 3:
            return "周三"
        case 4:
            return "周四"
        case 5:
            return "周五"
        case 6:
            return "周六"
        case 7:
            return "周日"
            
        default:
            return "error"
        }
    }
    static func num2jieci(num:Int)->String{
        switch num {
        case 1:
            return "1-2"
            break
        case 2:
            return "3-4"
            break
        case 3:
            return "5-6"
            break
        case 4:
            return "7-8"
            break
        case 5:
            return "9-10"
            break
        case 6:
            return "10-12"
            break

        default:
            return "error"
        }
    
    
    }

}
