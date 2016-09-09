//
//  ViewController.swift
//  isdust_ios
//
//  Created by wzq on 7/23/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit
class ViewMain: UIViewController,AdBarDelegate {
    var isdraw=0
    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(SchoolTime.date2month(date: "2016/09/01 15:00:00"))



        

    }
    override func viewDidAppear(_ animated: Bool) {
        if(isdraw==1){
            return
        }
        isdraw=1
        let width=view.frame.size.width
        var mframe=CGRect.init(x: 0, y: 0, width: width, height: 172)
        
        
        let mAdBar=AdBar.init(frame: mframe, num: 2)
        mAdBar.load(index: 0, imagea: #imageLiteral(resourceName: "ad_1"), title: "新生入校", url: "http://www.wzq.hk")
        mAdBar.delegate=self
        view.addSubview(mAdBar)
        
        mframe=CGRect.init(x: 0, y: 172, width: width, height: 200)
        let mModuleCard=ModuleCard.init(frame: mframe,viewcontroller:self)
        view.addSubview(mModuleCard)
    }
    override func viewDidDisappear(_ animated: Bool) {

    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        //return UIModalPresentationStyle.fullScreen
//        return UIModalPresentationStyle.none
//    }

//    override var preferredContentSize: CGSize{
//        
//        get {
//            
//            return CGSize.init(width: view.frame.width, height: 200)
//
//        }
//        set { super.preferredContentSize = newValue }
//    }
    func AdImageClick(urla: String,titlea:String) {
        performSegue(withIdentifier: "webview", sender: [urla,titlea])
        
//        var mcontroller=ViewWeb()
//        mcontroller.mtitle=titlea
//        mcontroller.murl=urla
//        present(mcontroller, animated: true, completion: nil)
        
        print(urla)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Login(_ sender: AnyObject) {

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="webview"){
            var mcontroller = segue.destination as! ViewWeb
            mcontroller.title=(sender as! [String])[1]
            mcontroller.murl=(sender as! [String])[0]
            
        
        }
    }

 
}

