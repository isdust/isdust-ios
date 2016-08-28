//
//  ViewControllerCourseEdit.swift
//  isdust_ios
//
//  Created by wzq on 8/26/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class ViewControllerCourseEdit: UIViewController,ViewCourseEditWeekDelegate ,ViewCourseEditJieciDelegate{
    var course:Kebiao!
    var weeks:[Int]!
    var jieci_edit = -1
    var xingqi_edit = -1
    var delegate:ViewControllerCourseDetailDelegate!
    var type:String!
    
    @IBOutlet weak var textfield_kecheng: UITextField!
    
    @IBOutlet weak var textfield_teacher: UITextField!
    
    @IBOutlet weak var button_zhoushu: UIButton!
    @IBOutlet weak var button_jieci: UIButton!
    @IBOutlet weak var textfield_location: UITextField!
    
    @IBAction func button_jieci_click(_ sender: AnyObject) {
        view.endEditing(true)
        
        let vc = ViewCourseEditJieci()
        vc.delegate=self
        if(type=="edit"){
            vc.xingqi = Int(course.xingqi!)
            vc.jieci=Int(course.jieci!)
        }
        view.window?.rootViewController?.view.addSubview(vc)

    }

    
    @IBAction func button_zhoushu_click(_ sender: AnyObject) {
        view.endEditing(true)
        let vc = ViewCourseEditWeek()
        if(type=="edit"){
        vc.weeks=weeks
        }
        vc.delegate=self
        vc.config()
        view.window?.rootViewController?.view.addSubview(vc)
        
        //present(vc, animated: true, completion:nil)
        
        
    }
    
    
    @IBAction func button_save_click(_ sender: AnyObject) {
        let alert = UIAlertView()
        alert.title = "提示"
        
        alert.addButton(withTitle: "确定")
        alert.delegate=self
//
        if(textfield_kecheng.text==""){
            alert.message = "请输入课程名称"
            alert.show()
            return
        }
        
        if(type=="add"){
            if(xingqi_edit == -1){
                alert.message = "请选择星期和节次"
                alert.show()
                return
            }
            if(weeks.count==0){
                alert.message = "请选择周次"
                alert.show()
                return
            
            }
            
            update_add()
        }else{
            update_edit()
        }
        
        self.navigationController?.popViewController(animated: true)
        delegate.saveschedule()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(type=="add"){
            return
        }
        textfield_kecheng.text=course.kecheng
        textfield_teacher.text=course.teacher
        textfield_location.text=course.location
        weeks=getweek()
        button_zhoushu.setTitle(judegweek(nums: weeks), for: .normal)
        button_jieci.setTitle(getxingqi(num: Int(course.xingqi!)!)+"  "+getjieci(num: Int(course.jieci!)!), for: .normal)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func iseven(num:Int) -> Bool {
        if(num%2==0){
        return true
        }
        return false
    }
    func isodd(num:Int) -> Bool {
        if(num%2==1){
            return true
        }
        return false
    }
    func judegweek(nums:[Int]) -> String {
        let num_even=nums.filter(iseven)
        let num_odd=nums.filter(isodd)
        let sum_even=num_even.reduce(0, {$0+$1})
        let sum_odd=num_odd.reduce(0, {$0+$1})
        if(nums.count==num_even.count){
            if(sum_even==(num_even[0]*num_even.count+num_even.count*(num_even.count-1))){
                return "\(nums[0])-\(nums[nums.count-1])周(双周)"

            }
        }
        if(nums.count==num_odd.count){
            if(sum_odd==(num_odd[0]*num_odd.count+num_odd.count*(num_odd.count-1))){
                return "\(nums[0])-\(nums[nums.count-1])周(单周)"
            }
        }

        let delta=abs(sum_even-sum_odd)
        if(delta*2==nums.count||(delta*2-1)==nums.count){
            return "\(nums[0])-\(nums[nums.count-1])周"
        }
        var result=""
        nums.map({result+=String($0)+","})
        result+="周"
        return result
        
    }
    func getweek() ->[Int] {
        let result=ScheduleManage().getcourse(xingqi: Int(course.xingqi!)!, jieci: Int(course.jieci!)!, kecheng: course.raw!)
        var weeks=[Int]()
        result.map({weeks.append(Int($0.zhoushu!)!)})
        return weeks
        
    }
    func getxingqi(num:Int) -> String {
        let datasource_week:[String]=["周一","周二","周三","周四","周五","周六","周日"]
        return datasource_week[num-1]
    }
    func getjieci(num:Int) -> String {
        let datasource_jieci:[String]=["第一、二节","第三、四节","第五、六节","第七、八节","第九、十节"]
        return datasource_jieci[num-1]
    }
    func update_edit() {
        let mxingqi:Int = ((xingqi_edit == -1) ? Int(course.xingqi!)! : xingqi_edit)
        let mjieci:Int = ((jieci_edit == -1) ? Int(course.jieci!)! : jieci_edit)
        let mkecheng = textfield_kecheng.text!+"<br>"+""+"<br>"+textfield_teacher.text!+"<br>"+textfield_location.text!

        ScheduleManage().deleteclass(xingqi: Int(course.xingqi!)!, jieci: Int(course.jieci!)!, kecheng: course.raw!)
        var result=[Kebiao]()
        for i in weeks{
            var temp=Kebiao()
            temp.jieci=String(mjieci)
            temp.raw=mkecheng
            temp.xingqi=String(mxingqi)
            temp.zhoushu=String(i)
            result.append(temp)
        
        }
        ScheduleManage().importclass(course: result)
        
        
    }
    func update_add()  {
        let mxingqi:Int = xingqi_edit
        let mjieci:Int = jieci_edit
                let mkecheng = textfield_kecheng.text!+"<br>"+""+"<br>"+textfield_teacher.text!+"<br>"+textfield_location.text!
        var result=[Kebiao]()
        for i in weeks{
            var temp=Kebiao()
            temp.jieci=String(mjieci)
            temp.raw=mkecheng
            temp.xingqi=String(mxingqi)
            temp.zhoushu=String(i)
            result.append(temp)
            
        }
        ScheduleManage().importclass(course: result)

    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //return UIModalPresentationStyle.fullScreen
        return UIModalPresentationStyle.none
    }
    func editweek(week:[Int]){
        weeks=week
        button_zhoushu.setTitle(judegweek(nums: weeks), for: .normal)

    
    }
    func editjieci(jieci: Int) {
        jieci_edit = jieci
    }
    func editxingqi(xingqi: Int) {
        xingqi_edit = xingqi
    }
    func reload_jieci_xingqi() {
        button_jieci.setTitle(getxingqi(num: xingqi_edit)+"  "+getjieci(num: jieci_edit), for: .normal)

    }
    


}
