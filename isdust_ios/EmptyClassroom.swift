//
//  EmptyClassroom.swift
//  isdust_ios
//
//  Created by wzq on 7/27/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class EmptyClassroom{
    var mhttp:Http
    init() {
        mhttp=Http()
    }
    func rsa_encrypt(data:String) -> String {
        let cs = (data as NSString).utf8String
        
        let buffer = UnsafeMutablePointer<Int8>.init(mutating: cs)
        let b = String.init(cString: openssl_rsa_encrypt(buffer))
        return b;
    }
    func md5(data:String) -> String {
        let cs = (data as NSString).utf8String
        let buffer = UnsafeMutablePointer<Int8>.init(mutating: cs)
        let b = String.init(cString: openssl_md5(buffer))
        return b;
    }
    func getEmptyClassroom(building:String,schooldate:Int,week:Int,jieci:Int) throws -> [Kebiao] {
        let id="ios"
    
        var time=String(Int(NSDate().timeIntervalSince1970))
        var mmd5=md5(data: id+"wzq123"+time).lowercased()
        var submit_pre="{\"time\":"+time+",\"key\":\""+mmd5+"\",\"id\":\""+id+"\",\"building\":\""+building+"\",\"location\":\"\",\"zhoushu\":\""+String(schooldate)+"\",\"xingqi\":\""+String(week)+"\",\"jieci\":\""+String(jieci)+"\",\"method\":4}"
        var submit=rsa_encrypt(data: submit_pre)
        var mmd5_2=md5(data: submit+"dsfwedsdv"+time).lowercased()
        submit=mhttp.postencode(submit)
        var text_web=try mhttp.post("http://kzxs.isdust.com/chaxun_new.php","data="+submit+"&verification="+mmd5_2+"&time="+time)
        
        return analyze(text_web: text_web)
    }
    func analyze(text_web:String) -> [Kebiao] {
        var result=[Kebiao]()
        let data = text_web.data(using: String.Encoding.utf8) //data  是json格式字符串
        let json = try? JSONSerialization.jsonObject(with: data!)
        for i in json as? [AnyObject] ?? []{
            var temp=Kebiao()
            temp.location=i["location"] as! String
            temp.zhoushu=i["zhoushu"] as! String
            temp.xingqi=String( i["xingqi"] as! Int)
            temp.jieci=String(i["jieci"] as! Int)
            result.append(temp)
        
        }
        return result
    }
    
    


}
