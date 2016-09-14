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
    
    @IBAction func button_plus(_ sender: AnyObject) {
        let menuArray:[AnyObject] = [
            KxMenuItem.init("注销", image: UIImage(named: "item_logout"), target: self, action:#selector(self.logout))
            ]
        
        //配置一：基础配置
        KxMenu.setTitleFont(UIFont(name: "HelveticaNeue", size: 15))
        
        //配置二：拓展配置
        let options = OptionalConfiguration(arrowSize: 9,  //指示箭头大小
            marginXSpacing: 7,  //MenuItem左右边距
            marginYSpacing: 9,  //MenuItem上下边距
            intervalSpacing: 25,  //MenuItemImage与MenuItemTitle的间距
            menuCornerRadius: 6.5,  //菜单圆角半径
            maskToBackground: true,  //是否添加覆盖在原View上的半透明遮罩
            shadowOfMenu: false,  //是否添加菜单阴影
            hasSeperatorLine: true,  //是否设置分割线
            seperatorLineHasInsets: false,  //是否在分割线两侧留下Insets
            textColor: Color(R: 0, G: 0, B: 0),  //menuItem字体颜色
            menuBackgroundColor: Color(R: 1, G: 1, B: 1)  //菜单的底色
        )
        var a=self.navigationController?.view.frame
        a?.size.height=60
        a?.size.width*=2
        a?.size.width-=60
        KxMenu.show(in: self.navigationController?.view, from: a!, menuItems:menuArray, withOptions: options)
    }
    var mzhengfang:Zhengfang!
    var serialQueue:DispatchQueue!
    var score_section:[String]=[String]()
    var score_detail:[[String]]=[[String]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor=UIColor.white
        table_score.delegate=self
        table_score.dataSource=self
        serialQueue = DispatchQueue(label: "queuename", attributes: [])
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show(withStatus: "正在加载成绩信息")
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

                ShowMessage("错误","网络超时",self)
                break
            default:
                break
                
            }
            print(aSelector)}
    }
    func logout(){

        
        
        let alertController = UIAlertController(title: "提示", message: "确定注销正方账号?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let key_user="zhengfang_user"
            let key_password="zhengfang_password"
            UserDefaults.standard.set("", forKey:key_password)
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }


}
