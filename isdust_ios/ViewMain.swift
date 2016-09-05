//
//  ViewController.swift
//  isdust_ios
//
//  Created by wzq on 7/23/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit
class ViewMain: UIViewController,AdBarDelegate {
    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(SchoolTime.date2month(date: "2016/09/01 15:00:00"))
        let width=view.frame.size.width
        var mframe=CGRect.init(x: 0, y: 64, width: width, height: 172)
//        var imagesURL=[
//            "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//             "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
//              "http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"
//        ]
//        var titles = ["感谢您的支持，如果下载的",
//        "代码在使用过程中出现问题",
//        "您可以发邮件到qzycoder@163.com",
//        ]
//        var adView:AdView=AdView.adScroll(withFrame: mframe, imageLinkURL: imagesURL, placeHoderImageName: "placeHoder.jpg", pageControlShowStyle: UIPageControlShowStyle.left) as! AdView
//       adView.setAdTitleArray(titles, with: .right)
        let a=AdBar.init(frame: mframe, num: 2)
        a.load(index: 0, imagea: #imageLiteral(resourceName: "ad_1"), title: "新生入校", url: "http://www.wzq.hk")
        a.delegate=self
        //a.backgroundColor=UIColor.blue
       // a.bringSubview(toFront: a.mUIPageControl)
        
        
//        adView.adTitleArray=titles
//        adView.adTitleStyle = .right
        //adView.setAdTitleArray(titles, with: 0)
        view.addSubview(a)
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="webview"){
            var mcontroller = segue.destination as! ViewWeb
            mcontroller.title=(sender as! [String])[1]
            mcontroller.murl=(sender as! [String])[0]
            
        
        }
    }

 
}

