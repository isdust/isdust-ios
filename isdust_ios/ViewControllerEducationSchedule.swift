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
        
        schedule_draw_head()
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
    func schedule_draw_head() {
        //画月份格子
        var base=CGRect.init(x: 0, y: 0, width: 20, height: 40)
        schedule_head_cell_draw(frame: CGRect.init(x: 0, y: 0, width: base.width, height: base.height))
        schedule_head_label(frame: CGRect.init(x: 3, y: 4, width: 20, height: 40),text:"8月")
        var extraheight = UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height+self.tabBarController!.tabBar.frame.height
        
        //画节次格子
        var jieci_height=(self.view.frame.height-base.height-extraheight)/12
        for i in 0 ..< 12{
            schedule_head_cell_draw(frame: CGRect.init(x: 0, y: jieci_height*CGFloat(i)+base.height, width: base.width, height: jieci_height))
            schedule_head_label(frame: CGRect.init(x: 7, y: jieci_height*CGFloat(i)+base.height+14, width: base.width, height: jieci_height),text:String(i+1))//周次
        }
        
        
        //画星期格子
        var xingqi_width=(self.view.frame.width-base.width)/7
        for i in 0..<7{
            schedule_head_cell_draw(frame: CGRect.init(x: xingqi_width*CGFloat(i)+base.width, y: 0, width: xingqi_width, height: base.height))
            schedule_head_label(frame:CGRect.init(x: xingqi_width*CGFloat(i)+base.width+xingqi_width/3, y: base.height/2+5, width: xingqi_width, height: base.height),text:num2week(num: i+1))//周次
            schedule_head_label(frame:CGRect.init(x: xingqi_width*CGFloat(i)+base.width+xingqi_width/2-5, y: base.height/4, width: xingqi_width, height: base.height),text:String(i+1))//日期

            
        }
        
        //画叉叉
        for i in 1..<7{
            for j in 1..<12{
                schedule_cross_draw(location: CGPoint.init(x: xingqi_width*CGFloat(i)+base.width-3, y: jieci_height*CGFloat(j)+base.height-3))
            }
        
        }
        
        schedule_cell_generate(week: 4,jieci: 5, color: UIColor(red:132/255, green: 213/255, blue: 148/255, alpha: 0.7),course: "大学生心理健康教育\n@J14-321室")
        
    }
    func schedule_cell_generate(week:Int,jieci:Int,color:UIColor,course:String) {
        var view_single=UIView()
        let interval:CGFloat=2
        var base=CGRect.init(x: 0, y: 0, width: 20, height: 40)
        var extraheight = UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height+self.tabBarController!.tabBar.frame.height
        
        var cell_height=(self.view.frame.height-base.height-extraheight)/12
        cell_height*=2
        var cell_width=(self.view.frame.width-base.width)/7
        view_single.frame=CGRect.init(x: (CGFloat(week)-1)*cell_width+base.width+interval, y: (CGFloat(jieci)-1)*cell_height+base.height+interval, width: cell_width, height: cell_height)
        
        
        schedule_cell_draw(view: view_single, color: color)
        
        
        var label_single=UILabel()
        let label_interval_y:CGFloat=5
        let label_interval_x:CGFloat=2
        label_single.textColor=UIColor.white
        label_single.frame=CGRect.init(x: label_interval_x, y: label_interval_y, width: cell_width-2*label_interval_x, height: cell_height-2*label_interval_y)
        label_single.font = UIFont.systemFont(ofSize: 9, weight: UIFontWeightBold)
        label_single.textColor=UIColor.white
        label_single.text=course
        label_single.adjustsFontSizeToFitWidth=true
        label_single.numberOfLines=9
        label_single.sizeToFit()
        
        view_single.addSubview(label_single)
        
        
        
        mainview.addSubview(view_single)
        
    }
    func schedule_cell_label(view:UIView,week:Int,jieci:Int,course:String) {
        
        
        
        
    }
    func schedule_cross_draw(location:CGPoint) {
        var length:CGFloat=6
        let layer = CAShapeLayer()
        var path = UIBezierPath()
        
        path.move(to: CGPoint.init(x: length/2, y: 0))
        path.addLine(to: CGPoint.init(x: length/2, y: length))
        path.move(to: CGPoint.init(x: 0, y: length/2))
        path.addLine(to: CGPoint.init(x: length, y: length/2))
        layer.path=path.cgPath
        layer.frame=CGRect.init(x: location.x, y: location.y, width: length, height: length)
        
        
        layer.fillColor=UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.strokeColor = UIColor(red:125/255, green: 184/255, blue: 215/255, alpha: 1).cgColor

        layer.lineWidth=0.5
        
        mainview.layer.addSublayer(layer)
        
    }
    func schedule_cell_draw(view:UIView,color:UIColor){
        var base=CGRect.init(x: 0, y: 0, width: 20, height: 40)
        var extraheight = UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height+self.tabBarController!.tabBar.frame.height
        
        let interval:CGFloat=2
        var cell_height=(self.view.frame.height-base.height-extraheight)/12
        cell_height*=2
        cell_height=cell_height-2*interval
        var cell_width=(self.view.frame.width-base.width)/7
        cell_width=cell_width-2*interval
        let radius:CGFloat=3
        var angle:CGFloat
        var location:CGPoint=CGPoint()
       
        
        
        let layer = CAShapeLayer()
        var path = UIBezierPath()
        
        
        
        
//        drawtable_schedule_arc(path: path, location: CGPoint.init(x: radius, y: radius), angle: 180, radius: radius)
        
        angle = 180
        location = CGPoint.init(x: radius, y: radius)
        
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
        
//        path.move(to:  CGPoint.init(x: cell_width-2*radius, y: 0))
        path.close()
        
//        cell_height=cell_height+2*interval
//        cell_width=cell_width+2*interval
        layer.frame=CGRect.init(x: 0, y: 0, width: cell_width, height: cell_height)

        layer.path = path.cgPath
        layer.fillColor=color.cgColor
        layer.strokeColor = color.cgColor
        layer.lineWidth=0
        
        view.layer.addSublayer(layer)
        
    }
    func schedule_head_cell_draw(frame:CGRect) {
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
    func schedule_head_label(frame:CGRect,text:String) {
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
