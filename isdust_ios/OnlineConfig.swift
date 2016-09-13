//
//  OnlineConfig.swift
//  isdust_ios
//
//  Created by wzq on 9/11/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class OnlineConfig{
    static let version_current:Int=1
    static let default_config:String="{    \"schedule_xuenian\": \"2016-2017\",    \"schedule_xueqi\": \"1\",    \"system_broadcast\": \"1.学校快通服务器已经崩溃，请去J1圈存机操作\n2.iOS版爱山科即将发布，敬请期待\n---WZQ\",    \"school_date\": \"2016-09-0500: 00: 00\",    \"advertisement\": [        {            \"title\": \"新生入校\",            \"image\": \"http: //app.isdust.com/ad/ad1.jpg\",            \"url\": \"http: //www.wzq.hk\"        }    ],    \"install\": \"true\"}"
    static var current_config:String!
    static var json:NSDictionary!
    static var mhttp:Http=Http()
    static func load(){
        let localstorage=UserDefaults.standard.string(forKey: "OnlineConfig")
        if(localstorage == nil||localstorage == ""){
            current_config=default_config
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
    static func update(){
        var remote_config:String!
        do{
            remote_config = try mhttp.get("http://app.isdust.com/config.php")
            let data = remote_config.data(using: String.Encoding.utf8) //data  是json格式字符串

            let test = try? JSONSerialization.jsonObject(with: data!) as! NSDictionary
            let temp=test?.object(forKey: "install")
            if(temp==nil ){
                load()
                return
            }
        }
        catch{
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
            var temp_image:UIImage=UIImage.init(data: UserDefaults.standard.data(forKey: "OnlineConfig_AD_"+temp_md5)!)!
            var temp_url:String=(ad_array[i] as! NSDictionary)["url"] as! String
            var temp_title:String=(ad_array[i] as! NSDictionary)["title"] as! String
            temp=AdInfo.init(index: i, imagea: temp_image, title: temp_title, url: temp_url)
            result.append(temp)
            
            
        
        }
        return result
        
    }
}
