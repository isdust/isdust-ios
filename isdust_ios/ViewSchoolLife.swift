//
//  ViewSchoolLife.swift
//  isdust_ios
//
//  Created by wzq on 9/5/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class ViewSchoolLife:UITableViewController{
    var minterface=ModuleInterface()
    var module_classification:[String]!
    override func viewDidLoad() {
        minterface.mviewcontroller=self as UIViewController
        module_classification=ModuleGetClass()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return module_classification.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModuleGetByClass(classification: module_classification[section]).count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var data:Module = ModuleGetByClass(classification: module_classification[indexPath.section])[indexPath.row]
        
        let cell:ViewSchoolLifeCell=tableView.dequeueReusableCell(withIdentifier: "cell") as! ViewSchoolLifeCell
        cell.item_image.image=data.micon
        cell.item_title.text=data.mtitle
        cell.item_description.text=data.mdescription
        cell.item_description.numberOfLines=2
        cell.item_description.frame=CGRect.init(x: 68, y: 25, width: cell.frame.width-cell.item_description.frame.origin.x, height: 36)
        cell.item_description.adjustsFontSizeToFitWidth=true
        cell.item_description.lineBreakMode = .byClipping
        cell.accessoryType = .none
        cell.data=data
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.CellClick))
        cell.addGestureRecognizer(gesture)
        
        
        return cell
        
        
    }
    func CellClick(sender:UITapGestureRecognizer){
        
        let view_course=sender.view as! ViewSchoolLifeCell
        minterface.enter(withIdentifier: view_course.data.midentifier, sender: self)
        //self.performSegue(withIdentifier: "coursedetail", sender: view_course.course)
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return module_classification[section]
    }


    
    

}
protocol ViewSchoolLifeDelegate{
    func schedule_login(delegate:ViewControllerEducationScheduleDelegate,mview:UIView)
}
