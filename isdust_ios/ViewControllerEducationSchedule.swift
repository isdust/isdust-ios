//
//  ViewControllerEducationSchedule.swift
//  isdust_ios
//
//  Created by wzq on 8/22/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class ViewControllerEducationSchedule: UIViewController,UIScrollViewDelegate,ViewControllerEducationScheduleDelegate,ViewControllerCourseDetailDelegate {
    var isdraw=0

    var serialQueue:DispatchQueue!
    var info_year="2016-2017"
    var info_semester="1"
    var manager=ScheduleManage()
    
    @IBAction func testa(_ sender: AnyObject) {
        for i in 1..<23{
            reloadschedule(week: i)
            
        }
    }
    @IBAction func button_menu_click(_ sender: AnyObject) {
        let menuArray:[AnyObject] = [
            KxMenuItem.init("添加课程", image: UIImage(named: "item_key"), target: self, action:#selector(ViewControllerEducationSchedule.menu_addcourse)),
            KxMenuItem.init("重新加载课程", image: UIImage(named: "item_heartbroken"), target: self, action: #selector(ViewControllerEducationSchedule.menu_reload)),
        ]
        
        //配置一：基础配置
        KxMenu.setTitleFont(UIFont(name: "HelveticaNeue", size: 15))
        
        //配置二：拓展配置
        let options = OptionalConfiguration(arrowSize: 9,  //指示箭头大小
            marginXSpacing: 7,  //MenuItem左右边距
            marginYSpacing: 9,  //MenuItem上下边距
            intervalSpacing: 25,  //MenuItemImage与MenuItemTitle的间距
            menuCornerRadius: 6.5,  //菜单圆角半径
            maskToBackground: true,  //是否添加覆盖在原View上的半透明遮罩
            shadowOfMenu: false,  //是否添加菜单阴影
            hasSeperatorLine: true,  //是否设置分割线
            seperatorLineHasInsets: false,  //是否在分割线两侧留下Insets
            textColor: Color(R: 0, G: 0, B: 0),  //menuItem字体颜色
            menuBackgroundColor: Color(R: 1, G: 1, B: 1)  //菜单的底色
        )
        var a=self.navigationController?.view.frame
        a?.size.height=60
        a?.size.width*=2
        a?.size.width-=60
        KxMenu.show(in: self.navigationController?.view, from: a!, menuItems:menuArray, withOptions: options)
    }
    func menu_addcourse() {
        self.performSegue(withIdentifier: "CourseEditAdd", sender: nil)
    }
    func menu_reload() {
        let alertController = UIAlertController(title: "提示", message: "重新加载课表，原课表将会清除，重新加载?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.downloadschedule()
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func thread_downloadtable()  {


        
        
        do{
        try mzhengfang.JumpToSelectClass()
        manager.droptable()
        
        for i in 1..<23{
            var kecheng=try mzhengfang.ScheduleLookup(String(i), year: info_year, semester: info_semester)
            manager.importclass(course: kecheng)
            self.performSelector(onMainThread: Selector(("schedule_download_progress")), with: i, waitUntilDone: false, modes: nil)

        }
        self.performSelector(onMainThread: Selector(("schedule_download_finish")), with: nil, waitUntilDone: false, modes: nil)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)

        }
        catch{
            
        }
    }
    
    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool, modes array: [String]?) {
        DispatchQueue.main.async(){
            switch aSelector {
            case Selector("schedule_download_progress"):
                let result=arg as! Int
               //self.reloadschedule(week: result)
                
                
                self.reloadschedule(week: result)
                    
                
                SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
                SVProgressHUD.showProgress(Float(result)/22, status: "正在下载课表")
                //self.schedule_table_all()
                break
            case Selector("schedule_download_finish"):

//                let result=arg as! Int
                SVProgressHUD.dismiss()
                //self.table_emptyclassroom.reloadData()
                break
            case Selector(("ErrorNetwork")):
                SVProgressHUD.dismiss()
                ShowMessage("错误","网络超时",self)
                break


                
            default:
                break
                
            }
        
        
        }
    }
    
    
    let scrollView = UIScrollView(frame: UIScreen.main.bounds)

    
    var mainview:[UIView]=[UIView]()
    var mzhengfang:Zhengfang!
    var mViewSchoolLifeDelegate:ViewSchoolLifeDelegate!
    var result_schedule:[Kebiao]!
    var cell_color:[UIColor]!
    override func viewDidLoad() {
        cell_color=[
            UIColor(red:132/255, green: 213/255, blue: 148/255, alpha: 0.5),
            UIColor(red:250/255, green: 158/255, blue: 125/255, alpha: 0.5),
            UIColor(red:129/255, green: 204/255, blue: 201/255, alpha: 0.5),
            UIColor(red:241/255, green: 143/255, blue: 146/255, alpha: 0.5),
            UIColor(red:248/255, green: 191/255, blue: 103/255, alpha: 0.5),
            UIColor(red:204/255, green: 156/255, blue: 143/255, alpha: 0.5),
            UIColor(red:101/255, green: 182/255, blue: 223/255, alpha: 0.5),
            UIColor(red:147/255, green: 206/255, blue: 90/255, alpha: 0.5),
            UIColor(red:144/255, green: 172/255, blue: 205/255, alpha: 0.5),
            UIColor(red:133/255, green: 156/255, blue: 228/255, alpha: 0.5),
            UIColor(red:116/255, green: 183/255, blue: 159/255, alpha: 0.5),
            UIColor(red:227/255, green: 132/255, blue: 167/255, alpha: 0.5),
            UIColor(red:223/255, green: 189/255, blue: 131/255, alpha: 0.5),
            UIColor(red:168/255, green: 146/255, blue: 210/255, alpha: 0.5)
        
        ]

        super.viewDidLoad()
        navigationController?.navigationBar.tintColor=UIColor.white
        

        
        scrollView.contentSize=CGSize.init(width: view.frame.size.width*22, height: view.frame.size.height)
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled=true
        scrollView.delegate=self
        //scrollView.alwaysBounceHorizontal=true
        
        
        
        //scrollView.alwaysBounceVertical=true
        serialQueue = DispatchQueue(label: "queuename", attributes: [])
        if(manager.getcount()==0){
            
            let alertController = UIAlertController(title: "提示", message: "你还没有下载课表，是否从教务系统下载课表?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) {
                UIAlertAction in
                    self.downloadschedule()
            }
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)

        
        
        
        }
    }
    func finishlogin(zhengfang:Zhengfang) {
        mzhengfang=zhengfang
        downloadschedule()
    }
    func downloadschedule() {
        if(mzhengfang==nil){
            mViewSchoolLifeDelegate.schedule_login(delegate: self,mview:(view.window?.rootViewController?.view)!)
            return
        }
        ScheduleManage().droptable()
        manager=ScheduleManage()
        serialQueue.async(execute: self.thread_downloadtable)
    }
    override func viewWillAppear(_ animated: Bool) {
        if(isdraw==1){
        return }
        isdraw=1
         schedule_table_all()
        schedule_goto(week: SchoolTime.gettodayweek())
    }
    
    @objc(scrollViewDidEndDecelerating:) func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        schedule_settitle()
        
    }
    func schedule_settitle()  {
        var week=Int(scrollView.bounds.origin.x/scrollView.bounds.width)+1
        self.navigationItem.title="第"+"\(week)"+"周"
    }
    func schedule_goto(week:Int) {
        scrollView.bounds.origin.x=(scrollView.bounds.width)*CGFloat(week-1)
        schedule_settitle()
        
    }
    func schedule_table_all()  {
        for i in 1..<23{
            reloadschedule(week: i)

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
    func schedule_draw_head(week: Int,mview:UIView) {
        var date_week=SchoolTime.getdayarray(week: week)
        //画月份格子
        var base=CGRect.init(x: 0, y: 0, width: 25, height: 40)
        schedule_head_cell_draw(mview:mview,frame: CGRect.init(x: 0, y: 0, width: base.width, height: base.height))
        schedule_head_label(mview:mview,frame: CGRect.init(x: 3, y: 4, width: 25, height: 40),text:date_week[0])
        var extraheight = UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height+self.tabBarController!.tabBar.frame.height
        //print(<#T##items: Any...##Any#>)
        //画节次格子
        var jieci_height=(self.view.frame.height-base.height-extraheight+self.view.frame.origin.y)/10
        for i in 0 ..< 10{
            schedule_head_cell_draw(mview:mview,frame: CGRect.init(x: 0, y: jieci_height*CGFloat(i)+base.height, width: base.width, height: jieci_height))
            schedule_head_label(mview:mview,frame: CGRect.init(x: 7, y: jieci_height*CGFloat(i)+base.height+14, width: base.width, height: jieci_height),text:String(i+1))//周次
        }
        
        
        //画星期格子
        var xingqi_width=(self.view.frame.width-base.width)/7
        for i in 0..<7{
            schedule_head_cell_draw(mview:mview,frame: CGRect.init(x: xingqi_width*CGFloat(i)+base.width, y: 0, width: xingqi_width, height: base.height))
            schedule_head_label(mview:mview,frame:CGRect.init(x: xingqi_width*CGFloat(i)+base.width+xingqi_width/3, y: base.height/2+5, width: xingqi_width, height: base.height),text:SchoolTime.num2week(num: i+1))//周次
            schedule_head_label(mview:mview,frame:CGRect.init(x: xingqi_width*CGFloat(i)+base.width+xingqi_width/2-5, y: base.height/4, width: xingqi_width, height: base.height),text:date_week[i+1])//日期

            
        }
        
        //画叉叉
        for i in 1..<7{
            for j in 1..<10{
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
        var base=CGRect.init(x: 0, y: 0, width: 25, height: 40)
        var extraheight = UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height+self.tabBarController!.tabBar.frame.height
        
        var cell_height=(self.view.frame.height+self.view.frame.origin.y-base.height-extraheight)/10
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
        var base=CGRect.init(x: 0, y: 0, width: 25, height: 40)
        var extraheight = UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height+self.tabBarController!.tabBar.frame.height
        
        let interval:CGFloat=2
        var cell_height=(self.view.frame.height+self.view.frame.origin.y-base.height-extraheight)/10
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

//    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool) {
//        print(122)
//    }
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
        if segue.identifier=="CourseEditAdd"{
            let mViewControllerCourseDetail=segue.destination as! ViewControllerCourseEdit
            mViewControllerCourseDetail.type="add"
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
        mview.frame=CGRect.init(x: view.frame.size.width*CGFloat(week-1), y: 0, width: view.frame.size.width, height: scrollView.frame.height)

        
        schedule_draw_head(week:week, mview: mview)
        schedule_cell_print(mview: mview,course: course)
        scrollView.addSubview(mview)
        mview.tag=week
    }
    func saveschedule() {
        for i in 1..<23{
            
            reloadschedule(week: i)
            
        }
        self.navigationController?.popViewController(animated: true)
    
    }

}
protocol ViewControllerEducationScheduleDelegate{
    func reloadschedule(week:Int)
    func finishlogin(zhengfang:Zhengfang)
}
