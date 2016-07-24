//
//  SchoolCard.swift
//  isdust_ios
//
//  Created by wzq on 7/24/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class SchoolCard{
    
    let location="http://card.proxy.isdust.com:3100/"
    var mhttp:Http
    var StandardPicture:[ImageProcess]
    init(){
        mhttp=Http()

        StandardPicture=[ImageProcess]()
        for(var i=0;i<10;i++){
            var temp=ImageProcess()
            temp.loadimage(UIImage(named:"yzm"+String(i)+".png")!)
            StandardPicture.append(temp)        
        }
    }
    func recognize(image:UIImage) -> Void {
        var tmp_image=ImageProcess();
        tmp_image.loadimage(image)
        tmp_image.binarize()
        var image_split:[ImageProcess]
        var image_split_detail:[CGRect]
        image_split_detail=[
        CGRect(x: 10,y: 36,width: 23,height: 23),
        CGRect(x: 46,y: 36,width: 23,height: 23),
        CGRect(x: 82,y: 36,width: 23,height: 23),
        CGRect(x: 10,y: 72,width: 23,height: 23),
        CGRect(x: 46,y: 72,width: 23,height: 23),
        CGRect(x: 82,y: 72,width: 23,height: 23),
        CGRect(x: 10,y: 108,width: 23,height: 23),
        CGRect(x: 46,y: 108,width: 23,height: 23),
        CGRect(x: 82,y: 108,width: 23,height: 23),
        CGRect(x: 10,y: 144,width: 23,height: 23)
        ]
        image_split=tmp_image.split(image_split_detail)
        for(var i=0;i<10;i++){
        
            image_split[i].printbit()
            print("")
        }
        
        
        
    }
    func login(username:String,password:String) -> String {
        
        recognize(mhttp.get_picture(location+"getpasswdPhoto.action"))
        
        return ""
    }
    
    

}