//
//  ViewAbout.swift
//  isdust_ios
//
//  Created by wzq on 9/7/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation

class ViewAbout:UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableview_about: UITableView!
    override func viewDidLoad() {
        tableview_about.dataSource=self
        tableview_about.delegate=self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableview_about.dequeueReusableCell(withIdentifier: "cell")!
        
    }

}
