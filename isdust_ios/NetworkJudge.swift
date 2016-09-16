//
//  NetworkJudge.swift
//  isdust_ios
//
//  Created by wzq on 9/16/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
class NetworkJudge{
    static var mHttp=Http()
    static func getSSID() ->  String {
        var currentSSID = ""
        
        
        
    
        if let interfaces:CFArray = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as NSDictionary!
                    currentSSID = interfaceData?["SSID"] as! String
                }
            }
        }
        return currentSSID
    }
    static func JudgeType()->Int{
        var ssid=getSSID()
        switch ssid {
        case "CMCC":
            return 1
            break
        case "ChinaUnicom":
            return 2
            break
        
        default:
            return 4
        }
    
    }
    static func cmcc_judge()->Int{
        var text:String!
        
        do{
            mHttp.setencoding(1)
            text=try mHttp.get("http://172.16.0.86/")
            //var a=1
            
            if(text.contains("已使用时间")){
                do{
                    mHttp.setencoding(0)
                    text = try mHttp.get("http://baidu.com")
                    if(text.contains("<meta http-equiv=\"refresh\" content=\"0;url=http://www.baidu.com/\">")){
                        return 2;
                    
                    }
                    
                
                }
                catch{
                    
                }
                return 1;
            
            
            }
            
        }catch{
            return -1
        
        
        }
        return 0
        
    }
    
    static func chinaunicom_judge()->Int{
        var text:String!
        do{
            mHttp.setencoding(1)
            text = try mHttp.get("http://10.249.255.253/")
            if (text.contains("已使用时间")){
                return 1;
            }
        }catch{
            return -1
        }
        return 0
        
    
    }
    
}
