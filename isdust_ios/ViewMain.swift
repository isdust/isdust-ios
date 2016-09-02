//
//  ViewController.swift
//  isdust_ios
//
//  Created by wzq on 7/23/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit
class ViewMain: UIViewController {
    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(SchoolTime.date2month(date: "2016/09/01 15:00:00"))
//        let location="http://card.proxy.isdust.com:3100/"
//        var a=Http()
//        a.setencoding(1)
//        print(a.get(location+"loginstudent.action"))
//        for i in 1..<22{
//            print(SchoolTime.gettodayweek())
//
//        }
//        
//        var d=ScheduleManage()
//        d.droptable()
//        //var test:[Kebiao]=[
////            Kebiao(mzhoushu: "1",mxingqi: "1",mjieci: "1",mraw: "1"),
////            Kebiao(mzhoushu: "1",mxingqi: "2",mjieci: "1",mraw: "tests")
//        ]
//        //d.importclass(course: test)
//        var a=d.getcourse(week: 1)
//        print(d.getcount())
//        var d=Library()
//        d.getStorage(bookrecno: "1900605908")
//        var a = d.findBookByName(Name: "swift")
//        var a=Zhengfang();
//        a.Login("201501060225", password: "960826wang")
    }
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        //return UIModalPresentationStyle.fullScreen
//        return UIModalPresentationStyle.none
//    }
    override func viewDidAppear(_ animated: Bool) {
//        let vc = ViewCourseEditJieci()
//        view.window?.rootViewController?.view.addSubview(vc)
        
        //vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        //vc.view.bounds=CGRect.init(x: 0, y: 0, width: 100, height: 100)
//        vc.preferredContentSize=CGSize.init(width: 200, height: 200)
//        vc.presentedViewController?.view.frame.size=CGSize.init(width: 200, height: 200)

        //view.addSubview(vc)
        
    }
//    override var preferredContentSize: CGSize{
//        
//        get {
//            
//            return CGSize.init(width: view.frame.width, height: 200)
//
//        }
//        set { super.preferredContentSize = newValue }
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Login(_ sender: AnyObject) {
    //    var mhttp=Http();
        //imageview.image=mhttp.get_picture("http://card.proxy.isdust.com:3100/getpasswdPhoto.action")
//        var image : UIImage = UIImage(named:"yzm1.png")!
//        //var image1:CIImage=image.CIImage
//        var test=ImageProcess()
//        test.loadimage(image)
//        test.binarize()
        

//        a.JumpToSelectClass()
//        a.ScheduleLookup("1", year: "2016-2017", semester: "1")
//        var test=SchoolCard()
//        //741852
//        test.login("1501060225", password: "960826")
//        var a=test.GetTransaction()
//        test.LookUpToday()
//        test.LookUpHistory("20160601", inputEndDate: "20160625", page: 1)
        
        
//        var c=EmptyClassroom()
//        c.getEmptyClassroom(building: "J7", schooldate: 2, week: 2, jieci: 2)
        

//        d.getStorage(bookrecno: "1900768652")
      //  d.xml_getSuoshuhao(raw: "<records><record><bookrecno>1900802816</bookrecno><callno><![CDATA[ TN929.53/450 ]]></callno></record><record><bookrecno>1900786499</bookrecno><callno><![CDATA[ TP312/265 ]]></callno><callno><![CDATA[ TP312SW/1 ]]></callno></record></records>", bookrecno: "1900802816")
//        d.login(user: "1501060225", password: "1501060225")
//        d.get_borrwingdetail()
    }

 
}

