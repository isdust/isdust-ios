//
//  ViewControllerEducationSchedule.swift
//  isdust_ios
//
//  Created by wzq on 8/22/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class ViewControllerEducationSchedule: UIViewController {
    var mainview:UIView!

    override func viewDidLoad() {

        super.viewDidLoad()
        mainview=UIView(frame:self.view.frame)
        
        drawtable_head()
        self.view.addSubview(mainview)
//myView.gest

        // Do any additional setup after loading the view.
    }
    func drawtable()  {
        
        
        var myView = UIView(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))

        
        myView.backgroundColor=UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        mainview.addSubview(myView)
        
        self.view.addSubview(mainview)
        
        
        // 3. add action to myView
        myView.isUserInteractionEnabled=true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction))
        
        //self.myView.addGestureRecognizer(gesture)
        myView.addGestureRecognizer(gesture)
    }
    func drawtable_head() {
        //画月份格子
        var base=CGRect.init(x: 0, y: 0, width: 20, height: 40)
        drawtable_head_cell(frame: CGRect.init(x: 0, y: 0, width: base.width, height: base.height))
        drawtable_head_label(frame: CGRect.init(x: 3, y: 4, width: 20, height: 40),text:"8月")
        var extraheight = UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height+self.tabBarController!.tabBar.frame.height
        
        //画节次格子
        var jieci_height=(self.view.frame.height-base.height-extraheight)/12
        for i in 0 ..< 12{
            drawtable_head_cell(frame: CGRect.init(x: 0, y: jieci_height*CGFloat(i)+base.height, width: base.width, height: jieci_height))
            drawtable_head_label(frame: CGRect.init(x: 7, y: jieci_height*CGFloat(i)+base.height+14, width: base.width, height: jieci_height),text:String(i+1))//周次
        }
        
        
        //画星期格子
        var xingqi_width=(self.view.frame.width-base.width)/7
        for i in 0..<7{
            drawtable_head_cell(frame: CGRect.init(x: xingqi_width*CGFloat(i)+base.width, y: 0, width: xingqi_width, height: base.height))
            drawtable_head_label(frame:CGRect.init(x: xingqi_width*CGFloat(i)+base.width+xingqi_width/3, y: base.height/2+5, width: xingqi_width, height: base.height),text:num2week(num: i+1))//周次
            drawtable_head_label(frame:CGRect.init(x: xingqi_width*CGFloat(i)+base.width+xingqi_width/2-5, y: base.height/4, width: xingqi_width, height: base.height),text:String(i+1))//日期

            
        }
        drawtable_schedule_cell()

        
    }
    func drawtable_schedule_cell(){
        var base=CGRect.init(x: 0, y: 0, width: 20, height: 40)
        var extraheight = UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height+self.tabBarController!.tabBar.frame.height
        
        var cell_height=(self.view.frame.height-base.height-extraheight)/12
        cell_height*=2
        
        var cell_width=(self.view.frame.width-base.width)/7
        let radius:CGFloat=5
        
        
        let layer = CAShapeLayer()
        var path = UIBezierPath()
        
//        path.start
        path.move(to: CGPoint.init(x: radius, y: 0))
        
        
        
        
        
        drawtable_schedule_arc(path: path, location: CGPoint.init(x: radius, y: radius), angle: 180)//左上角圆弧
        path.move(to: CGPoint.init(x: radius, y: 0))
        path.addLine(to: CGPoint.init(x: cell_width-radius*2, y: 0))//上边
        drawtable_schedule_arc(path: path, location: CGPoint.init(x: cell_width-radius*2, y: radius), angle: 270)//右上角圆弧
        path.move(to: CGPoint.init(x: cell_width-radius, y: radius))
        path.addLine(to: CGPoint.init(x: cell_width-radius, y: cell_height-radius))//右边
        drawtable_schedule_arc(path: path, location: CGPoint.init(x: cell_width-radius*2, y: cell_height-radius), angle: 360)//右下角圆弧
        path.move(to: CGPoint.init(x: cell_width-radius*2, y: cell_height))
        path.addLine(to: CGPoint.init(x: radius, y: cell_height))//底边
        drawtable_schedule_arc(path: path, location: CGPoint.init(x: radius, y: cell_height-radius), angle: 90)//左下角圆弧
        path.move(to: CGPoint.init(x: 0, y: cell_height-radius))
        path.addLine(to: CGPoint.init(x: 0, y: radius))//左边
        
        
        
        
        path.move(to: CGPoint.init(x: radius, y: 0))
        path.close()
//        UIColor.black.setStroke()
//        path.stroke()
        
layer.fillMode=kCAFillModeBoth
        
        layer.frame=CGRect.init(x: 100, y: 100, width: 100, height: 100)
        //var a=UIBezierPath.init(cgPath: path)
        
        //a.close()
        layer.path = path.cgPath
        layer.fillColor=UIColor(red:0, green: 1, blue: 1, alpha: 0.5).cgColor
        
        layer.strokeColor = UIColor(red:125/255, green: 184/255, blue: 215/255, alpha: 1).cgColor
        layer.lineWidth=0.5
        
        mainview.layer.addSublayer(layer)
        
        
    }
    func drawtable_schedule_arc(path:UIBezierPath,location:CGPoint,angle:CGFloat)  {
        let radius:CGFloat=5
        path.move(to: CGPoint.init(x: location.x+sin(CGFloat(M_PI)/180*(angle+90))*radius, y: location.y-cos(CGFloat(M_PI)/180*(angle+90))*radius))
        
        
        
        path.addArc(withCenter: location, radius: radius, startAngle: CGFloat(M_PI)/180*angle, endAngle: (CGFloat(M_PI)/180)*(angle+90), clockwise: true)
        
        
    }
    func drawtable_head_cell(frame:CGRect) {
        let layer = CAShapeLayer()
        layer.frame=frame
        //layer.frame = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        //layer.backgroundColor = UIColor.black.cgColor
        let path = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        layer.path = path.cgPath
        layer.fillColor=UIColor(red:1, green: 1, blue: 1, alpha: 0.5).cgColor
        layer.strokeColor = UIColor(red:125/255, green: 184/255, blue: 215/255, alpha: 1).cgColor
        layer.lineWidth=0.5
        
        mainview.layer.addSublayer(layer)
    
    }
    func num2week(num:Int) -> String {
        switch num {
        case 1:
            return "周一"
        case 2:
            return "周二"
        case 3:
            return "周三"
        case 4:
            return "周四"
        case 5:
            return "周五"
        case 6:
            return "周六"
        case 7:
            return "周日"
            
        default:
            return "error"
        }
    }
    func drawtable_head_label(frame:CGRect,text:String) {
        let label = UILabel()
        label.frame=frame
        label.font = UIFont.systemFont(ofSize: 9, weight: UIFontWeightBold)
        label.textColor=UIColor(red:52/255, green: 109/255, blue: 183/255, alpha: 1)
        label.text=text
        label.sizeToFit()
        mainview.addSubview(label)
    }
    func someAction(sender:UITapGestureRecognizer){
        print("test")
        // do other task
    }
    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool) {
        print(1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
