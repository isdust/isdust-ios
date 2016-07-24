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
    var StandardPicture:[ImageProcess]=[ImageProcess]()
    var relation:[Int]=[Int]()
    init(){
        mhttp=Http()
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
        relation=[Int]()
        image_split=tmp_image.split(image_split_detail)//未识别图片
        for(var i=0;i<10;i++){//
            var tmp_single=image_split[i].recognize(StandardPicture)
            relation.append(tmp_single)
        }
    }
    func translate(rawpass:String) -> String {
        var result=""
        for(var i=0;i<rawpass.characters.count;i++){
            let index=rawpass.startIndex.advancedBy(i)
            let char=Int(String(rawpass[index]))
            for(var j=0;j<10;j++){
                if(relation[j]==char){
                    result+=String(j)
                    continue
                    
                }
            }
            
            
        }
        return result;
        
    }
    func login(username:String,password:String) -> String {
        
        recognize(mhttp.get_picture(location+"getpasswdPhoto.action"))
        mhttp.get_picture(location+"getCheckpic.action?rand=6520.280869641985");
        mhttp.setencoding(1)
        var mpassword=translate(password);
        var text_web=mhttp.post(location+"loginstudent.action", "name=" + username + "&userType=1&passwd=" + mpassword + "&loginType=2&rand=6520&imageField.x=39&imageField.y=10")
        return ""
        
    }
    
    

}