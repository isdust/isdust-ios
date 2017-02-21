//
//  OnlineConfig.swift
//  isdust_ios
//
//  Created by wzq on 9/11/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class OnlineConfig{
    static let key="D89475D32EA8BBE933DBD299599EEA3E"
    static let version_current:Int=1
    static let default_config:String="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"
    static var current_config:String!
    static var json:NSDictionary!
    static var mhttp:Http=Http()
    static func load(){
        let localstorage=UserDefaults.standard.string(forKey: "OnlineConfig")
        if(localstorage == nil||localstorage == ""){
            current_config=default_config
            current_config=decode(data:current_config)
        }else{
            current_config=localstorage
        }
        var data = current_config.data(using: String.Encoding.utf8) //data  是json格式字符串
        do{
            json = try? JSONSerialization.jsonObject(with: data!) as! NSDictionary
            let temp=json?.object(forKey: "install")
            if(temp==nil){
                data = default_config.data(using: String.Encoding.utf8)
                json = try? JSONSerialization.jsonObject(with: data!) as! NSDictionary
            }
            
        }
        
    }
    static func decode(data:String)->String{
        let key_bytes: [UInt8] = Array(self.key.utf8)
        let key_len=key_bytes.count

        var temp:NSData=NSData(base64Encoded: data)!
        var content_byte:[UInt8] = [UInt8](repeating: 0, count: temp.length)
        temp.getBytes(&content_byte)
        let data_len=content_byte.count
        
        
        
        for i in 0..<data_len{
            content_byte[i]^=key_bytes[i%key_len];
            
        }
        let res = NSString(bytes: content_byte, length:
            content_byte.count, encoding: String.Encoding.utf8.rawValue) as! String
        
        return res
        
        
        
    
    }
    static func update(){
        var remote_config:String!
        do{
            remote_config = try mhttp.get("http://app.isdust.com/sysconfig.php?platform=iOS")
            remote_config=decode(data:remote_config)
            let data = remote_config.data(using: String.Encoding.utf8) //data  是json格式字符串

            let test = try? JSONSerialization.jsonObject(with: data!) as! NSDictionary
            let temp=test?.object(forKey: "install")
            if(temp==nil ){
                load()
                return
            }
        }
        catch{
            load()
            return
        }
        UserDefaults.standard.set(remote_config, forKey: "OnlineConfig")
        load()
    }
    static func get(key:String)->String{
        return json[key] as! String
    
    }

    static func get(key:String)->NSArray{
        return json[key] as! NSArray
        
    }
    static func downloadad(){
        let ad_array:NSArray = get(key: "advertisement")
        
        DispatchQueue.init(label: "ad").async(){() -> Void in
            var temp_image:String!
            var temp_md5:String!
            do{

                for i in ad_array{
                    temp_image=(i as! NSDictionary)["image"] as! String
                    temp_md5=(i as! NSDictionary)["md5"] as! String
                    print(temp_md5)
                    if(UserDefaults.standard.data(forKey: "OnlineConfig_AD_"+temp_md5) != nil){
                        continue
                    }
                    var image=try mhttp.get_picture(temp_image)
                    UserDefaults.standard.set(UIImageJPEGRepresentation(image!, 1)!, forKey: "OnlineConfig_AD_"+temp_md5)
//                    let b=UIImageJPEGRepresentation(image!, 1)!
                    //var a=UserDefaults.standard.data(forKey: "OnlineConfig_AD_"+temp_md5)
                    
                }
            }catch{
                UserDefaults.standard.set(nil, forKey: "OnlineConfig_AD_"+temp_md5)
            }
            
        }

    }
    static func getad()-> [AdInfo]{
        var result:[AdInfo]=[AdInfo]()

        
        let ad_array:NSArray = get(key: "advertisement")
        for i in 0..<ad_array.count{
            var temp:AdInfo!
            
            var temp_md5:String!=(ad_array[i] as! NSDictionary)["md5"] as! String
            var image_data=UserDefaults.standard.data(forKey: "OnlineConfig_AD_"+temp_md5)
            var temp_image:UIImage!
            if(image_data==nil){
                temp_image=#imageLiteral(resourceName: "ad_default")
            }else{
                temp_image=UIImage.init(data: image_data!)!
            }
            var temp_url:String=(ad_array[i] as! NSDictionary)["url"] as! String
            var temp_title:String=(ad_array[i] as! NSDictionary)["title"] as! String
            temp=AdInfo.init(index: i, imagea: temp_image!, title: temp_title, url: temp_url)
            result.append(temp)
            
            
        
        }
        return result
        
    }
}
