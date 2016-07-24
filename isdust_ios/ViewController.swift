//
//  ViewController.swift
//  isdust_ios
//
//  Created by wzq on 7/23/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var imageview: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        var test=Http()
        print(test.urlencode("http://www+")
)        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Login(sender: AnyObject) {
        var mhttp=Http();
   //     imageview.image=mhttp.get_picture("http://card.proxy.isdust.com:3100/getpasswdPhoto.action")
//        var image : UIImage = UIImage(named:"yzm1.png")!
//        //var image1:CIImage=image.CIImage
//        var test=ImageProcess()
//        test.loadimage(image)
//        test.binarize()
        
//        var a=Zhengfang();
//        a.Login("201501060225", password: "960826wang")
//        a.JumpToSelectClass()
//        a.ScheduleLookup("1", year: "2016-2017", semester: "1")
        var test=SchoolCard()
        test.login("1501060225", password: "960826")
    }

 
}

