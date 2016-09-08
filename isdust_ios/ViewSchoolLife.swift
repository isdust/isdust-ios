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
    override func viewDidDisappear(_ animated: Bool) {
        minterface.mviewcontroller=self as UIViewController
        
    }
    
    

}
protocol ViewSchoolLifeDelegate{
    func schedule_login(delegate:ViewControllerEducationScheduleDelegate,mview:UIView)
}
