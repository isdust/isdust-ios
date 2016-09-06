//
//  ViewLogin.swift
//  isdust_ios
//
//  Created by wzq on 7/31/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class ViewLogin:UIView{
    let contentview:UIView=UIView()
    let view_head=UINavigationBar()
    var maskview:UIView!
    var frame_self:CGRect!
    
    var textfield_user:UITextField!
    var textfield_pass:UITextField!
    
    var channel:String!
    
    var offset_head:CGRect!
    let head_height:CGFloat=50
    
    var delegate:ViewLoginDelegate!
    
    
//    var hint_user=""
//    var hint_password=""
    
   // var title_delegate="校园卡"
    var message_delegate=""
    
    var finished=0

    override init(frame:CGRect){
        super.init(frame: frame)
        //frame_self=frame
        frame_self=CGRect.init(x: frame.width/8, y: frame.height/2-200, width: frame.width-frame.width/4, height: 200)
        contentview.frame=CGRect.init(x: frame.width/8, y: frame.height, width: frame.width-frame.width/4, height: 200)
        contentview.backgroundColor=UIColor.white
        maskview=UIView.init(frame: frame)
        maskview.backgroundColor=UIColor.black.withAlphaComponent(0.7)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.disappear))
        maskview.addGestureRecognizer(gesture)
        
        draw_head()
        drawarc()
        drawcontent()
        self.addSubview(maskview)
        self.addSubview(contentview)
    }
    func sethint(user:String,pass:String) {
        textfield_user.placeholder=user
        textfield_pass.placeholder=pass
    }
    func settitle(title:String) {
        view_head.items?[0].title=title
    }
    func setchannel(mchannel:String) {
        channel=mchannel
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        if(finished==1){
            return
        }

        UIView.animate(withDuration: 0.6, animations: {
            self.contentview.frame=self.frame_self
        })

    
    }
    func draw_head() {
        let radius:CGFloat=10
        view_head.frame=CGRect.init(x: 0, y: 0, width: frame_self.width-radius, height: head_height)
        view_head.isTranslucent=false
        offset_head=view_head.frame
        view_head.titleTextAttributes=[NSForegroundColorAttributeName : UIColor.white]
        view_head.barTintColor=UIColor.init(red: 1/255, green: 169/255, blue: 244/255, alpha: 1)

        let navItem = UINavigationItem(title: "")
        let button_login=UIBarButtonItem.init(title: "登录", style: .done, target: nil, action: #selector(self.button_login_click))
        let button_cancel=UIBarButtonItem.init(title: "取消", style: .done, target: nil, action: #selector(self.button_cancel_click))
        button_login.tintColor=UIColor.white
        button_cancel.tintColor=UIColor.white
        navItem.rightBarButtonItem=button_login
        navItem.leftBarButtonItem=button_cancel
        
        view_head.setItems([navItem], animated: false)
        contentview.addSubview(view_head)
    }
    func button_login_click()  {
        delegate.login(channel: channel, user: textfield_user.text!, pass: textfield_pass.text!)
        disappear()
        
    }
    func button_cancel_click()  {
        disappear()
    }
    func drawcontent() {
        let offset_text_x:CGFloat=5
        textfield_user=UITextField()
//        textfield_user.placeholder=hint_user
        textfield_user.keyboardType = .numberPad

        textfield_user.frame=CGRect.init(x: offset_text_x, y: offset_head.height+20, width: frame_self.width-offset_text_x*2, height: 30)
        
        let border_user = CALayer()
        let width = CGFloat(1)
        border_user.borderColor = UIColor.init(red: 188/255, green: 188/255, blue: 188/255, alpha: 1).cgColor
        border_user.frame = CGRect(x: 0, y: textfield_user.frame.size.height - width, width:  textfield_user.frame.size.width, height: textfield_user.frame.size.height)
        
        border_user.borderWidth = width
        
        textfield_user.layer.addSublayer(border_user)
        textfield_user.layer.masksToBounds = true
        contentview.addSubview(textfield_user)
        
        
        textfield_pass=UITextField()
        textfield_pass.isSecureTextEntry=true
//        textfield_pass.placeholder=hint_password
        textfield_pass.frame=CGRect.init(x: offset_text_x, y: 20+textfield_user.frame.origin.y+textfield_user.frame.height, width: frame_self.width-offset_text_x*2, height: 30)
        
        let border_pass = CALayer()
        border_pass.borderColor = UIColor.init(red: 188/255, green: 188/255, blue: 188/255, alpha: 1).cgColor
        border_pass.frame = CGRect(x: 0, y: textfield_pass.frame.size.height - width, width:  textfield_pass.frame.size.width, height: textfield_pass.frame.size.height)
        
        border_pass.borderWidth = width
        textfield_pass.layer.addSublayer(border_pass)
        textfield_pass.layer.masksToBounds = true
        contentview.addSubview(textfield_pass)
        
        
        
    }
    func disappear()  {
        UIView.animate(withDuration: 0.6, animations: {
//            self.contentview.frame=CGRect.init(x: 0, y: self.frame_self.height, width: self.frame_self.width, height: 320)
                    self.contentview.frame=CGRect.init(x: self.frame.width/8, y: self.frame.height, width: self.frame.width-self.frame.width/4, height: 200)
            },completion:{(finished: Bool) -> Void in
                if(finished==true){
                    self.removeFromSuperview()
                }
        })
        finished=1
        
    }
    func drawarc() {
        let layer = CAShapeLayer()
        var path = UIBezierPath()
        
        
        
        
        //        drawtable_schedule_arc(path: path, location: CGPoint.init(x: radius, y: radius), angle: 180, radius: radius)
        var angle:CGFloat!
        let radius:CGFloat=10
        var location:CGPoint=CGPoint()
        
        angle = 180
        location = CGPoint.init(x: radius, y: radius)
        var cell_width=contentview.frame.width
        var cell_height=contentview.frame.height
        
        path.move(to: CGPoint.init(x: cell_width-2*radius, y: 0))
        path.addArc(withCenter: location, radius: radius, startAngle: CGFloat(M_PI)/180*(angle+90), endAngle: (CGFloat(M_PI)/180)*(angle+0), clockwise: false)
        path.addLine(to: CGPoint.init(x: cell_width-radius, y: cell_height-radius))
        
        
        angle = 270
        location =  CGPoint.init(x: cell_width-radius*2, y: radius)
        path.move(to: CGPoint.init(x: cell_width-radius, y: cell_height-radius))
        path.addArc(withCenter: location, radius: radius, startAngle: CGFloat(M_PI)/180*(angle+90), endAngle: (CGFloat(M_PI)/180)*(angle+0), clockwise: false)
        path.addLine(to: CGPoint.init(x: cell_width-radius*2, y: cell_height-radius))
        
        
        
        
        angle = 360
        
        location =   CGPoint.init(x: cell_width-radius*2, y: cell_height-radius)
        path.move(to: CGPoint.init(x: radius, y: cell_height))
        path.addArc(withCenter: location, radius: radius, startAngle: CGFloat(M_PI)/180*(angle+90), endAngle: (CGFloat(M_PI)/180)*(angle+0), clockwise: false)
        path.addLine(to: CGPoint.init(x: 0, y: radius))
        
        
        angle = 90
        location = CGPoint.init(x: radius, y: cell_height-radius)
        path.move(to: CGPoint.init(x: 0, y: radius))
        path.addArc(withCenter: location, radius: radius, startAngle: CGFloat(M_PI)/180*(angle+90), endAngle: (CGFloat(M_PI)/180)*(angle+0), clockwise: false)
        path.addLine(to: CGPoint.init(x: 0, y: radius))
        
        path.close()
        
        
        layer.frame=CGRect.init(x: 0, y: 0, width: cell_width, height: cell_height)
        
        layer.path = path.cgPath
        layer.fillColor=UIColor.white.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth=0
        
        contentview.layer.mask=layer

    }

}
public protocol ViewLoginDelegate{
    func login(channel:String,user:String,pass:String)

}
