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
    var mAdBar:AdBar!
    var mModuleCard:ModuleCard!
    var mBroadcast:Broadcast!
    var mScheduleCard:ScheduleCard!
    
    @IBOutlet weak var mscrollview: UIScrollView!
    
    override func viewDidLoad() {
        var a=SchoolTime.getTodayWeek()
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isdraw==1){
            return
        }
        isdraw=1
        mscrollview.contentSize=view.frame.size
        mscrollview.backgroundColor=UIColor.init(red: 236/255, green: 235/255, blue: 241/255, alpha: 1)
        let width=view.frame.size.width
        var mframe=CGRect.init(x: 0, y: 0, width: width, height: 172)
        
        
        //广告
        mAdBar=AdBar.init(frame: mframe, num: 2)
        mAdBar.load(index: 0, imagea: #imageLiteral(resourceName: "ad_1"), title: "新生入校", url: "http://www.wzq.hk")
        mAdBar.delegate=self
        mscrollview.addSubview(mAdBar)
        
        //快捷栏目
        mframe=CGRect.init(x: 0, y: mframe.origin.y+mframe.size.height, width: width, height: 200)
        mModuleCard=ModuleCard.init(frame: mframe,viewcontroller:self)
        mscrollview.addSubview(mModuleCard)
        
        
        
        //系统公告栏
        mframe=CGRect.init(x: 0, y: mModuleCard.frame.origin.y+mModuleCard.frame.size.height+20, width: width, height: 80)

        mBroadcast=Broadcast.init(frame: mframe)
        mBroadcast.setContent(content: "此版本为爱山科ios版本测试版，仍然还有一些未知的bug，遇见后在关于->意见反馈提交")
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

