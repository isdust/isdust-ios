//
//  ViewControllerCourseEdit.swift
//  isdust_ios
//
//  Created by wzq on 8/26/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class ViewControllerCourseEdit: UIViewController,UIPopoverPresentationControllerDelegate ,ViewCourseEditWeekDelegate{
    var course:Kebiao!
    var weeks:[Int]!

    @IBOutlet weak var textfield_kecheng: UITextField!
    
    @IBOutlet weak var textfield_teacher: UITextField!
    
    @IBOutlet weak var button_zhoushu: UIButton!
    @IBOutlet weak var button_jieci: UIButton!
    @IBOutlet weak var textfield_location: UITextField!
    
    @IBAction func button_jieci_click(_ sender: AnyObject) {
    }

    
    @IBAction func button_zhoushu_click(_ sender: AnyObject) {
        let vc = ViewCourseEditWeek.init(frame: (self.view.window?.rootViewController?.view.frame)!)
//        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.weeks=weeks
        vc.delegate=self
        vc.config()
        view.window?.rootViewController?.view.addSubview(vc)
        //present(vc, animated: true, completion:nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfield_kecheng.text=course.kecheng
        textfield_teacher.text=course.teacher
        textfield_location.text=course.location
        weeks=getweek()
        button_zhoushu.setTitle(judegweek(nums: weeks), for: .normal)
        
        

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
        if(nums.count==num_even.count){
            return "\(nums[0])-\(nums[nums.count-1])周(双周)"
        }
        if(nums.count==num_odd.count){
            return "\(nums[0])-\(nums[nums.count-1])周(单周)"
        }
        let sum_even=num_even.reduce(0, {$0+$1})
        let sum_odd=num_odd.reduce(0, {$0+$1})
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

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //return UIModalPresentationStyle.fullScreen
        return UIModalPresentationStyle.none
    }
    func reloadschedule(week:[Int]){
        weeks=week
        button_zhoushu.setTitle(judegweek(nums: weeks), for: .normal)

    
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
