//
//  ViewControllerEducationSchedule.swift
//  isdust_ios
//
//  Created by wzq on 8/22/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class ViewControllerEducationSchedule: UIViewController,UIScrollViewDelegate,ViewControllerEducationScheduleDelegate {
    var serialQueue:DispatchQueue!
    var info_year="2016-2017"
    var info_semester="1"
    var manager=ScheduleManage()
    func thread_downloadtable()  {
        mzhengfang.JumpToSelectClass()
        manager.droptable()
        for i in 1..<23{
            self.performSelector(onMainThread: Selector(("schedule_download_progress")), with: i, waitUntilDone: false, modes: nil)
            var kecheng=mzhengfang.ScheduleLookup(String(i), year: info_year, semester: info_semester)
            manager.importclass(course: kecheng)
        }
        self.performSelector(onMainThread: Selector(("schedule_download_finish")), with: nil, waitUntilDone: false, modes: nil)

        
    }
    
    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool, modes array: [String]?) {
        DispatchQueue.main.async(){
            switch aSelector {
            case Selector("schedule_download_progress"):
                let result=arg as! Int
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)

                SVProgressHUD.showProgress(Float(result)/22, status: "正在下载课表")
                break
            case Selector("schedule_download_finish"):
//                let result=arg as! Int
                SVProgressHUD.dismiss()
                //self.table_emptyclassroom.reloadData()
                break
                
                
            default:
                break
                
            }
            print(aSelector)}
    }
    
    
    let scrollView = UIScrollView(frame: UIScreen.main.bounds)

    
    var mainview:[UIView]=[UIView]()
    var mzhengfang:Zhengfang!
    var result_schedule:[Kebiao]!
    var cell_color:[UIColor]!
    override func viewDidLoad() {
        cell_color=[
            UIColor(red:132/255, green: 213/255, blue: 148/255, alpha: 0.7),
            UIColor(red:250/255, green: 158/255, blue: 125/255, alpha: 0.7),
            UIColor(red:129/255, green: 204/255, blue: 201/255, alpha: 0.7),
            UIColor(red:241/255, green: 143/255, blue: 146/255, alpha: 0.7),
            UIColor(red:248/255, green: 191/255, blue: 103/255, alpha: 0.7),
            UIColor(red:204/255, green: 156/255, blue: 143/255, alpha: 0.7),
            UIColor(red:101/255, green: 182/255, blue: 223/255, alpha: 0.7),
            UIColor(red:147/255, green: 206/255, blue: 90/255, alpha: 0.7),
            UIColor(red:144/255, green: 172/255, blue: 205/255, alpha: 0.7),
            UIColor(red:133/255, green: 156/255, blue: 228/255, alpha: 0.7),
            UIColor(red:116/255, green: 183/255, blue: 159/255, alpha: 0.7),
            UIColor(red:227/255, green: 132/255, blue: 167/255, alpha: 0.7),
            UIColor(red:223/255, green: 189/255, blue: 131/255, alpha: 0.7),
            UIColor(red:168/255, green: 146/255, blue: 210/255, alpha: 0.7)
        
        ]

        super.viewDidLoad()
        

        
        scrollView.contentSize=CGSize.init(width: view.frame.size.width*22, height: view.frame.size.height)
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled=true
        scrollView.delegate=self
        scrollView.alwaysBounceHorizontal=true
        serialQueue = DispatchQueue(label: "queuename", attributes: [])
        if(manager.getcount()==0){
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)

            SVProgressHUD.show(withStatus: "正在登录选课平台")
            serialQueue.async(execute: thread_downloadtable)
        
        
        
        }
        
        schedule_table_all()
//myView.gest

        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var week=scrollView.bounds.origin.x/scrollView.bounds.width
        self.navigationItem.title="第"+"\(week )"+"周"
        //print(scrollView.bounds)
    }
    func schedule_table_all()  {
        for i in 1..<23{
            reloadschedule(week: i)
//            let mview=UIView(frame:self.view.frame)
//            let course=manager.getcourse(week: i)
//            mview.frame=CGRect.init(x: view.frame.size.width*CGFloat(i-1), y: 0, width: view.frame.size.width, height: view.frame.size.height)
//            schedule_draw_head(mview: mview)
//            schedule_cell_print(mview: mview,course: course)
//            scrollView.addSubview(mview)
//            mview.tag=i
            //mainview.append(mview)
        }
        
        //scrollView.didMoveToWindow()
        //mainview=UIView(frame:self.view.frame)
        
        self.view.addSubview(scrollView)
    }
    
    func schedule_cell_print(mview:UIView,course:[Kebiao]) {
                for i in 0..<course.count{
                    schedule_cell_generate(mview:mview,color: cell_color[(i%cell_color.count)],course:course[i])
                }
    }
    func drawtable()  {
        
        
        var myView = UIView(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))

        
        myView.backgroundColor=UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        
//        mainview.addSubview(myView)
//        
//        self.view.addSubview(mainview)
        
        
        // 3. add action to myView
        myView.isUserInteractionEnabled=true
        
        //let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction))
        
        //self.myView.addGestureRecognizer(gesture)
        
        //myView.addGestureRecognizer(gesture)
    }
    func schedule_draw_head(mview:UIView) {
        //画月份格子
        var base=CGRect.init(x: 0, y: 0, width: 20, height: 40)
        schedule_head_cell_draw(mview:mview,frame: CGRect.init(x: 0, y: 0, width: base.width, height: base.height))
        schedule_head_label(mview:mview,frame: CGRect.init(x: 3, y: 4, width: 20, height: 40),text:"8月")
        var extraheight = UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height+self.tabBarController!.tabBar.frame.height
        
        //画节次格子
        var jieci_height=(self.view.frame.height-base.height-extraheight)/12
        for i in 0 ..< 12{
            schedule_head_cell_draw(mview:mview,frame: CGRect.init(x: 0, y: jieci_height*CGFloat(i)+base.height, width: base.width, height: jieci_height))
            schedule_head_label(mview:mview,frame: CGRect.init(x: 7, y: jieci_height*CGFloat(i)+base.height+14, width: base.width, height: jieci_height),text:String(i+1))//周次
        }
        
        
        //画星期格子
        var xingqi_width=(self.view.frame.width-base.width)/7
        for i in 0..<7{
            schedule_head_cell_draw(mview:mview,frame: CGRect.init(x: xingqi_width*CGFloat(i)+base.width, y: 0, width: xingqi_width, height: base.height))
            schedule_head_label(mview:mview,frame:CGRect.init(x: xingqi_width*CGFloat(i)+base.width+xingqi_width/3, y: base.height/2+5, width: xingqi_width, height: base.height),text:SchoolTime.num2week(num: i+1))//周次
            schedule_head_label(mview:mview,frame:CGRect.init(x: xingqi_width*CGFloat(i)+base.width+xingqi_width/2-5, y: base.height/4, width: xingqi_width, height: base.height),text:String(i+1))//日期

            
        }
        
        //画叉叉
        for i in 1..<7{
            for j in 1..<12{
                schedule_cross_draw(mview:mview,location: CGPoint.init(x: xingqi_width*CGFloat(i)+base.width-3, y: jieci_height*CGFloat(j)+base.height-3))
            }
        
        }
//        mzhengfang.JumpToSelectClass()
//        result_schedule=mzhengfang.ScheduleLookup("1", year: "2016-2017", semester: "1")
//
//        for i in 0..<result_schedule.count{
//            schedule_cell_generate(week: Int(result_schedule[i].xingqi!)!,jieci: Int(result_schedule[i].jieci!)!, color: cell_color[(i%cell_color.count)],course: result_schedule[i].kecheng!+"\n  @"+result_schedule[i].location!)
//        }
        
        
    }
    func schedule_cell_generate(mview:UIView,color:UIColor,course:Kebiao) {
        var view_single=ViewCourseCell()
        
        let interval:CGFloat=2
        var base=CGRect.init(x: 0, y: 0, width: 20, height: 40)
        var extraheight = UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height+self.tabBarController!.tabBar.frame.height
        
        var cell_height=(self.view.frame.height-base.height-extraheight)/12
        cell_height*=2
        var cell_width=(self.view.frame.width-base.width)/7
        view_single.frame=CGRect.init(x: (CGFloat(Int(course.xingqi!)!)-1)*cell_width+base.width+interval, y: (CGFloat(Int(course.jieci!)!)-1)*cell_height+base.height+interval, width: cell_width, height: cell_height)
        
        
        schedule_cell_draw(mview: view_single, color: color)//画背景格子
        
        //显示课表文字
        var label_single=UILabel()
        let label_interval_y:CGFloat=5
        let label_interval_x:CGFloat=2
        label_single.textColor=UIColor.white
        label_single.frame=CGRect.init(x: label_interval_x, y: label_interval_y, width: cell_width-2*label_interval_x-interval*2, height: cell_height-2*label_interval_y-interval*2)
        label_single.font = UIFont.systemFont(ofSize: 9, weight: UIFontWeightBold)
        label_single.textColor=UIColor.white
        label_single.text=course.kecheng!+"\n@"+course.location!
        label_single.adjustsFontSizeToFitWidth=true
        label_single.numberOfLines=9
        label_single.sizeToFit()
        
        view_single.addSubview(label_single)
        
        
        
        //添加
        view_single.course=course
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.ViewCourseClick))
        view_single.addGestureRecognizer(gesture)
        
        mview.addSubview(view_single)
        
    }
    func ViewCourseClick(sender:UITapGestureRecognizer){
        
        let view_course=sender.view as! ViewCourseCell
        self.performSegue(withIdentifier: "coursedetail", sender: view_course.course)
        
        //print("test")
        // do other task
    }
    func schedule_cell_label(mview:UIView,week:Int,jieci:Int,course:String) {
        
        
        
        
    }
    func schedule_cross_draw(mview:UIView,location:CGPoint) {
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
        
        mview.layer.addSublayer(layer)
        
    }
    func schedule_cell_draw(mview:UIView,color:UIColor){
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
        
        mview.layer.addSublayer(layer)
        
    }
    func schedule_head_cell_draw(mview:UIView,frame:CGRect) {
        let layer = CAShapeLayer()
        layer.frame=frame
        //layer.frame = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        //layer.backgroundColor = UIColor.black.cgColor
        let path = UIBezierPath(rect: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height))
        layer.path = path.cgPath
        layer.fillColor=UIColor(red:1, green: 1, blue: 1, alpha: 0.5).cgColor
        layer.strokeColor = UIColor(red:125/255, green: 184/255, blue: 215/255, alpha: 1).cgColor
        layer.lineWidth=0.5
        
        mview.layer.addSublayer(layer)
    
    }

    func schedule_head_label(mview:UIView,frame:CGRect,text:String) {
        let label = UILabel()
        label.frame=frame
        label.font = UIFont.systemFont(ofSize: 9, weight: UIFontWeightBold)
        label.textColor=UIColor(red:52/255, green: 109/255, blue: 183/255, alpha: 1)
        label.text=text
        label.sizeToFit()
        mview.addSubview(label)
    }

    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool) {
        print(1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="coursedetail" {
            let mViewControllerCourseDetail=segue.destination as! ViewControllerCourseDetail
            mViewControllerCourseDetail.course=sender as! Kebiao
            mViewControllerCourseDetail.delegate = self
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func reloadschedule(week: Int) {
        let viewWithTag = scrollView.viewWithTag(week)
        viewWithTag?.removeFromSuperview()
        let mview=UIView(frame:self.view.frame)
        let course=manager.getcourse(week: week)
        mview.frame=CGRect.init(x: view.frame.size.width*CGFloat(week-1), y: 0, width: view.frame.size.width, height: view.frame.size.height)
        schedule_draw_head(mview: mview)
        schedule_cell_print(mview: mview,course: course)
        scrollView.addSubview(mview)
        mview.tag=week
    }

}
public protocol ViewControllerEducationScheduleDelegate:class{
    func reloadschedule(week:Int)
}