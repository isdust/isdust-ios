//
//  Http.swift
//  isdust_ios
//
//  Created by wzq on 8/30/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
enum IsdustError: Error {
    case Network
    
}
class Http{

    var session:URLSession!
    var data_encoding:Int!
    init(){
        session=URLSession.init(configuration: .default)
        data_encoding=0
    
    }
    func setencoding(_ num:Int) {
        data_encoding=num
    }
    func get(_ url:String)  -> String {
        let murl=URL.init(string: url)!
        let sem=DispatchSemaphore.init(value: 0)
        var result:Data!
        var merror:Error!
        var task=session.dataTask(with: murl, completionHandler: {
        data, response, error in
            result=data
            merror=error!
            sem.signal()
        })
        task.resume()
        sem.wait()
        if result==nil{
            //throw merror
        }
        var enc2:UInt!
        switch data_encoding {
        case 0:
        enc2=CFStringConvertEncodingToNSStringEncoding(CFStringBuiltInEncodings.UTF8.rawValue)            
            break
        case 1:
            enc2=CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
            
            break
        case 2:
            enc2=CFStringConvertEncodingToNSStringEncoding(CFStringBuiltInEncodings.ASCII.rawValue)

            break
        default:
            break
        }
        let str:String=NSString.init(data: result, encoding: enc2)! as String
        return str
        
    }
    func post(_ url:String,_ data:String) -> String {
        var enc2:UInt!
        switch data_encoding {
        case 0:
            enc2=CFStringConvertEncodingToNSStringEncoding(CFStringBuiltInEncodings.UTF8.rawValue)
            break
        case 1:
            enc2=CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
            
            break
        case 2:
            enc2=CFStringConvertEncodingToNSStringEncoding(CFStringBuiltInEncodings.ASCII.rawValue)
            
            break
        default:
            break
        }
        
        let murl=URL.init(string: url)!
        let sem=DispatchSemaphore.init(value: 0)
        var result:Data!
        var request=URLRequest.init(url: murl)
        request.httpBody=(data as NSString).data(using: enc2)
        request.httpMethod="POST"

        
        var task=session.dataTask(with: request, completionHandler:  {
            data, response, error in
            result=data
            sem.signal()
            }
        )
        
        task.resume()
        sem.wait()
        if result==nil{
            
        }

        let str:String=NSString.init(data: result, encoding: enc2)! as String
        return str
        
    }
    func get_picture(_ url:String) throws  -> UIImage {
        let murl=URL.init(string: url)!
        let sem=DispatchSemaphore.init(value: 0)
        var result:Data!
        var merror:Error!
        var task=session.dataTask(with: murl, completionHandler: {
            data, response, error in
            result=data
            merror=error
            sem.signal()
        })
        task.resume()
        sem.wait()
        if result==nil{
            throw IsdustError.Network
        }
        let image=UIImage.init(data: result)!
        return image
    }
    func getMiddleText(_ text:String,_ start:String,_ end:String) -> String {
        let range_start=(text as NSString).range(of: start)
        
        
        let range_end=((text as NSString).substring(from: range_start.length+range_start.location)as NSString).range(of: end)
        
        let range_result=NSRange.init(location: range_start.length+range_start.location, length: range_end.location)
        return (text as NSString).substring(with: range_result) as String!
        
    }
    func urlencode(_ encoding:String) -> String {
        var enc2:UInt!
        switch data_encoding {
        case 0:
            enc2=CFStringConvertEncodingToNSStringEncoding(CFStringBuiltInEncodings.UTF8.rawValue)
            break
        case 1:
            enc2=CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
            
            break
        case 2:
            enc2=CFStringConvertEncodingToNSStringEncoding(CFStringBuiltInEncodings.ASCII.rawValue)
            
            break
        default:
            break
        }
        return (encoding as NSString).addingPercentEscapes(using: enc2)!
    }
    func postencode(_ encoding:String) -> String  {
        
        var enc2:UInt!
        switch data_encoding {
        case 0:
            enc2=CFStringConvertEncodingToNSStringEncoding(CFStringBuiltInEncodings.UTF8.rawValue)
            break
        case 1:
            enc2=CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
            
            break
        case 2:
            enc2=CFStringConvertEncodingToNSStringEncoding(CFStringBuiltInEncodings.ASCII.rawValue)
            
            break
        default:
            break
        }
        var URLBase64CharacterSet=NSCharacterSet.init(charactersIn: "/+\n \"#%/:<>?@[\\]^`{|}").inverted
        return (encoding as NSString).addingPercentEncoding(withAllowedCharacters: URLBase64CharacterSet)! as String!
    }
    
    
}
