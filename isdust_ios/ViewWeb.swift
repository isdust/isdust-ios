//
//  ViewWeb.swift
//  isdust_ios
//
//  Created by wzq on 9/5/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class  ViewWeb:UIViewController{
    
    @IBOutlet weak var mwebview: UIWebView!
    var mtitle:String!
    var murl:String!
    
    override func viewDidLoad() {
        let temp_url=URL.init(string: murl)!
        var mrequest=URLRequest.init(url: temp_url)
        mwebview.loadRequest(mrequest)
        
        
    }

}
