//
//  ViewControllerCourseDetail.swift
//  isdust_ios
//
//  Created by wzq on 8/25/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class ViewControllerCourseDetail: UIViewController {
    var course:Kebiao!
    public weak var delegate: ViewControllerEducationScheduleDelegate?

    
    @IBOutlet weak var label_zhoushu: UILabel!
    @IBOutlet weak var label_jieci: UILabel!
    @IBOutlet weak var label_teacher: UILabel!
    @IBOutlet weak var label_location: UILabel!
    @IBOutlet weak var label_kecheng: UILabel!
    override func viewDidLoad() {
        label_kecheng.text=course.kecheng
        label_location.text=course.location
        label_teacher.text=course.teacher
        label_jieci.text=SchoolTime.num2week(num: Int(course.xingqi!)!)+"  "+SchoolTime.num2jieci(num: Int(course.jieci!)!)+"节"
        self.navigationItem.title=course.kecheng
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func button_delete_click(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "提示", message: "确认删除该课程?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) {
            UIAlertAction in
            ScheduleManage().deleteclass(couser: self.course)
            self.delegate?.reloadschedule(week: Int(self.course.zhoushu!)!)
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

        


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "CourseEdit":
            var controllerl=segue.destination as! ViewControllerCourseEdit
            controllerl.course=course
            break
        default:
            break
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

}
