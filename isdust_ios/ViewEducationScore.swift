//
//  ViewEducationScore.swift
//  isdust_ios
//
//  Created by wzq on 8/7/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation

class ViewEducationScore: UIViewController,UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var table_score: UITableView!
    
    @IBOutlet weak var textfield_Averagejidian: UILabel!
    
    @IBOutlet weak var textfield_Totaljidian: UILabel!
    var mzhengfang:Zhengfang!
    var serialQueue:DispatchQueue!
    var score_section:[String]=[String]()
    var score_detail:[[String]]=[[String]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        table_score.delegate=self
        table_score.dataSource=self
        serialQueue = DispatchQueue(label: "queuename", attributes: [])
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show()
        self.serialQueue.async(execute: self.thread_AllScoreLookup)
        self.serialQueue.async(execute: self.thread_jidianLookup)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.score_section[section ]
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return self.score_section.count
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count=0
        for i in score_detail{
            if(score_section[section]==i[0]+"-"+i[1]){
                count+=1
            }
            
        }
        
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        let cell:TableViewScore=tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewScore
        var record=0
        for j in  0..<score_detail.count{
            if(score_detail[j][0]+"-"+score_detail[j][1] == (score_section[indexPath.section])) {
                
                
                
                record=j
                break
            }
        }
        
        cell.label_subject.text=score_detail[indexPath.row+record][3]
        cell.label_score.text="成绩:"+score_detail[indexPath.row+record][8]
        cell.label_credit.text="学分:"+score_detail[indexPath.row+record][6]
//        var i=score_detail[indexPath.row+record]
//        var index=i[0].index(i[0].endIndex, offsetBy: -8)
//        
//        var date=i[0].substring(from: index)
//        cell.label_time.text=date
        
        
        return cell
    }
    func thread_AllScoreLookup() {
        do{
            let result = try mzhengfang.AllScoreLookUp()
            self.performSelector(onMainThread: Selector(("zhengfang_scorelookup")), with: result as AnyObject, waitUntilDone: false, modes: nil)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
            
        }
        catch{
            
        }


        
    }
    func thread_jidianLookup() {
        do{
            let result=try mzhengfang.JidianLookup()
            self.performSelector(onMainThread: Selector(("zhengfang_jidianlookup")), with: result as AnyObject, waitUntilDone: false, modes: nil)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
            
        }
        catch{
            
        }


    }
    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool, modes array: [String]?) {
        DispatchQueue.main.async(){
            switch aSelector {
            case Selector("zhengfang_scorelookup"):
                let message=arg as! [[String]]
                self.score_detail=message
                for i in self.score_detail{
                    var date=i[0]+"-"+i[1]
                    
                    if !self.score_section.contains(date){
                        self.score_section.append(date)
                    }
                }
                self.table_score.reloadData()
                print(message)
                break
            case Selector("zhengfang_jidianlookup"):
                let message=arg as! [String]
                self.textfield_Averagejidian.text=message[0]
                self.textfield_Totaljidian.text=message[1]
                SVProgressHUD.dismiss()
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
            print(aSelector)}
    }


}
