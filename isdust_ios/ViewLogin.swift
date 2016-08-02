//
//  ViewLogin.swift
//  isdust_ios
//
//  Created by wzq on 7/31/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class ViewLogin:UIViewController{
    var key_user=""
    var key_password=""
    
    var hint_user=""
    var hint_password=""
    
    var titlename=""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title=titlename
        
        
        

    }
    
    @IBAction func button_login_inside() {
                navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="SchoolCardMain" {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SchoolCardMain") as! ViewSchoolCardMain
            
            // here you pass parameter to ViewController A
//            
//            nextViewController.user =  YourVaribleWhichStrore[Int:String]
//            
//            self.presentViewController(nextViewController, animated:true, completion:nil)
        }
        
    }

}
