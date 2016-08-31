//
//  TableViewControllerLibrarySearchResult.swift
//  isdust_ios
//
//  Created by wzq on 8/20/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class TableViewControllerLibrarySearchResult: UITableViewController {
    var result:[Book]!

    var mlibrary=Library()
    
    var serialQueue:DispatchQueue!
    var thread_bookrecno:String!
    var thread_result_storage:[[String]]!
    func thread_search(){
        do{
            thread_result_storage=try mlibrary.getStorage(bookrecno: thread_bookrecno)
            performSelector(onMainThread: Selector("search"), with: nil, waitUntilDone: false)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
            
            
        }

        
    }
    
    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool) {
        DispatchQueue.main.async {
            switch(aSelector){
            case Selector("search"):
                SVProgressHUD.dismiss()
                if(self.thread_result_storage.count==0){
                    let alert = UIAlertView()
                    alert.title = "图书馆-查询"
                    alert.message = "没有找到该书馆藏"
                    alert.addButton(withTitle: "确定")
                    alert.delegate=self
                    alert.show()
                    return
                }
                self.performSegue(withIdentifier: "StorageSearchResult", sender: nil)
                break
            case Selector(("ErrorNetwork")):
                SVProgressHUD.dismiss()
                let alert = UIAlertView()
                alert.title = "错误"
                alert.message = "网络超时"
                alert.addButton(withTitle: "确定")
                alert.delegate=self
                alert.show()
                break
            default:
                break
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        serialQueue = DispatchQueue(label: "queuename", attributes: [])

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return result.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        let cell:TableViewCellLibrarySearch=tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCellLibrarySearch
        
        cell.texifield_name.text=result[indexPath.row].name
        cell.textfield_bookrecno.text=result[indexPath.row].bookrecno
        cell.textfield_writer.text=result[indexPath.row].writer
        cell.textfield_suoshuhao.text=result[indexPath.row].Suoshuhao
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        thread_bookrecno=(result[indexPath.row].bookrecno)
        SVProgressHUD.show()
        serialQueue.async(execute: thread_search)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="StorageSearchResult"){
            let SchoolCardChangePassController=segue.destination as! TableViewControllerSrorageSearchResult
            SchoolCardChangePassController.result=self.thread_result_storage
        
        }
    }


}
