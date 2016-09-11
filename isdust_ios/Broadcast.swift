//
//  Broadcast.swift
//  isdust_ios
//
//  Created by wzq on 9/10/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class Broadcast:UIView{
    var label_info:UILabel!
    var image_item:UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        draw()
        
    }
    
    func draw(){
        self.backgroundColor=UIColor.white
        image_item=UIImageView()
        image_item.frame=CGRect.init(x: 15, y: 8, width: 45, height: 45)
        image_item.image = #imageLiteral(resourceName: "menu_broadcast")
        image_item.contentMode = .scaleToFill
        
        
        var title:UILabel = UILabel()
        title.frame=CGRect.init(x: 60+10, y: 8, width: 10, height: 10)
        title.text="系统通告"
        title.font=UIFont.boldSystemFont(ofSize: 18)
        title.sizeToFit()
        
        
        label_info=UILabel()
        label_info.frame=CGRect.init(x: 60+10, y: title.frame.origin.y+title.frame.size.height, width: frame.size.width-(60+10), height: 12)
        label_info.textColor=UIColor.init(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
        label_info.font=label_info.font.withSize(12)
        label_info.numberOfLines=3
        label_info.lineBreakMode = .byClipping
        
        
        self.addSubview(title)
        self.addSubview(image_item)
        self.addSubview(label_info)
        
    }
    func setContent(content:String) {
        label_info.text=content
        label_info.sizeToFit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
