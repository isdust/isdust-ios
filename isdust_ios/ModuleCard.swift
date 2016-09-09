//
//  ModuleCard.swift
//  isdust_ios
//
//  Created by wzq on 9/7/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class ModuleCard:UIView{
    let cell_width:CGFloat=60
    let cell_height:CGFloat=80
    var mviewcontroller:UIViewController!
    init(frame: CGRect,viewcontroller:UIViewController) {
        super.init(frame: frame)
        //mviewcontroller=ModuleInterface.init()
        mviewcontroller=viewcontroller
        drawcell()
    }

    func drawcell()  {
        var mdata:[Module]=ModuleGetByShortcut()
        let num_horizon=Int(frame.width)/Int(cell_width)
        print(frame.width/7)
        for i in 0..<mdata.count{
            let pos_x=CGFloat(i%num_horizon)*cell_width
            let pos_y=CGFloat(i/num_horizon)*cell_height
            
            let singlecard=ModuleSingleCard.init(frame: CGRect.init(x: pos_x, y: pos_y, width: cell_width, height: cell_height), viewcontroller: mviewcontroller)
            if(i%2==0){
                singlecard.backgroundColor=UIColor.init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
            }
            
            singlecard.draw(data: mdata[i])
            self.addSubview(singlecard)
            
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
class ModuleSingleCard:UIView{
    var image_icon:UIImageView!
    var label_title:UILabel!
    var mdata:Module!
    var interface:ModuleInterface!
    init(frame: CGRect,viewcontroller:UIViewController) {
        super.init(frame: frame)
        interface=ModuleInterface.init()
        interface.mviewcontroller=viewcontroller
        
    }
    func draw(data:Module) {
        mdata=data
        image_icon=UIImageView()
        image_icon.image=mdata.micon
        image_icon.frame=CGRect.init(x: 5, y: 8, width: 50, height: 50)
        label_title=UILabel()
        label_title.text=mdata.mtitle
        label_title.font=label_title.font.withSize(10)

        
        label_title.sizeToFit()
        
        label_title.frame=CGRect.init(x: (frame.size.width-label_title.frame.size.width)/2, y: image_icon.frame.origin.y+image_icon.frame.size.height, width: label_title.frame.size.width, height: 19.5)
        //label_title.textColor=UIColor.init(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        self.addSubview(image_icon)
        self.addSubview(label_title)
        let getsure=UITapGestureRecognizer.init(target: self, action: #selector(self.cardclick))
        self.addGestureRecognizer(getsure)
        
    }
    func cardclick(){
        interface.enter(withIdentifier: mdata.midentifier, sender: self)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
