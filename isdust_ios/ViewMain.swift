//
//  ViewController.swift
//  isdust_ios
//
//  Created by wzq on 7/23/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit
import MessageUI

class ViewMain: UIViewController,AdBarDelegate,MFMessageComposeViewControllerDelegate {
    @available(iOS 4.0, *)
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
        print(result)
    }
    var isdraw=0
    var mAdBar:AdBar!
    var mModuleCard:ModuleCard!
    var mBroadcast:Broadcast!
    var mScheduleCard:ScheduleCard!
    
    @IBOutlet weak var mscrollview: UIScrollView!
    
    override func viewDidLoad() {
        //var a=NetworkJudge.fetchSSIDInfo()
        OnlineConfig.update()
        OnlineConfig.downloadad()
        
        NetworkJudge.cmcc_judge()
        var a=NetworkCMCC()
        //try? a.first_login(user: "1501060225", password: "960826wang")
        //try?a.second_init()
        //try?a.second_login(user: "15762284638", password: "741852")
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isdraw==1){
            return
        }
        
        //var a=NetworkCMCC()
        //a.setcontroller(viewcontroller: self)
        //a.second_changepass()
 //*/
        /*
        var smscontroller = MFMessageComposeViewController.init()
        smscontroller.body = "806"
        smscontroller.recipients=["10086"]
        smscontroller.messageComposeDelegate = self
        //controller.action
        if MFMessageComposeViewController.canSendText() {
            self.present(smscontroller, animated: true, completion: nil)
        }
        */
        
        isdraw=1
        mscrollview.contentSize=view.frame.size
        mscrollview.backgroundColor=UIColor.init(red: 236/255, green: 235/255, blue: 241/255, alpha: 1)
        let width=view.frame.size.width
        var mframe=CGRect.init(x: 0, y: 0, width: width, height: 172)
        
        
        //广告
        let mAdInfo=OnlineConfig.getad()
        mAdBar=AdBar.init(frame: mframe, num: mAdInfo.count)
        
        for i in mAdInfo{
            mAdBar.load(info: i)
        }
        mAdBar.delegate=self
        mscrollview.addSubview(mAdBar)
        
        //快捷栏目
        mframe=CGRect.init(x: 0, y: mframe.origin.y+mframe.size.height, width: width, height: 200)
        mModuleCard=ModuleCard.init(frame: mframe,viewcontroller:self)
        mscrollview.addSubview(mModuleCard)
        
        //print(mModuleCard.frame)
        
        
        
        //系统公告栏
        mframe=CGRect.init(x: 0, y: mModuleCard.frame.origin.y+mModuleCard.frame.size.height+20, width: width, height: 80)

        mBroadcast=Broadcast.init(frame: mframe)
        mBroadcast.setContent(content: OnlineConfig.get(key: "system_broadcast"))
        mscrollview.addSubview(mBroadcast)
        
        //今日课程表
        mframe=CGRect.init(x: 0, y: mBroadcast.frame.origin.y+mBroadcast.frame.size.height+20, width: width, height: 80)
        mScheduleCard=ScheduleCard.init(frame: mframe)
        mscrollview.addSubview(mScheduleCard)

        
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {

    }
    
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

