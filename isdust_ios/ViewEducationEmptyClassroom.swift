//
//  ViewEducationEmptyClassroom.swift
//  isdust_ios
//
//  Created by wzq on 8/7/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation

class ViewEducationEmptyClassroom: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate, UITableViewDataSource {
    let data_building:[String]=["J1", "Js1","J3","J5","J7","J11","J14","J15"]
    var data_schooldate:[String] = [String]()
    let data_week:[String]=["周一", "周二","周三","周四","周五","周六","周日"]
    let data_jici:[String]=["第一、二节", "第三、四节","第五、六节","第七、八节","第九、十节"]
    var serialQueue:DispatchQueue!
    var thread_building:String!
    var thread_schooldate:Int!
    var thread_week:Int!
    var thread_jieci:Int!
    var emtpyclassroom_detail:[Kebiao]!=[Kebiao]()
    @IBOutlet weak var picker_data: UIPickerView!
    
    @IBOutlet weak var table_emptyclassroom: UITableView!
    var memptyclassroom=EmptyClassroom()
    
    @IBAction func button_search(_ sender: AnyObject) {
        thread_building=data_building[picker_data.selectedRow(inComponent: 0)]
        thread_schooldate=picker_data.selectedRow(inComponent: 1)+1
        thread_week=picker_data.selectedRow(inComponent: 2)+1
        thread_jieci=picker_data.selectedRow(inComponent: 3)+1
        serialQueue.async(execute: thread_search)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.show(withStatus: "正在查找空教室信息")
    }

    func thread_search() {
        do{
            var result:[Kebiao] = try memptyclassroom.getEmptyClassroom(building: thread_building, schooldate: thread_schooldate, week: thread_week, jieci: thread_jieci)
            self.emtpyclassroom_detail=result
            //        self.performSelector(onMainThread: Selector(("emptyclassroom_search")), with:nil, waitUntilDone: false)
            self.performSelector(onMainThread: Selector(("emptyclassroom_search")), with: nil, waitUntilDone: false, modes: nil)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
            
            
        }


    }
    
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return data_building.count
            break
        case 1:
            return data_schooldate.count
            break
        case 2:
            return data_week.count
            break
        case 3:
            return data_jici.count
            break
        default:
            break
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 50
        case 1:
            return 60
        case 2:
            return 60
        case 3:
            return 130
        default:
            return 0
        }
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return data_building[row]
            break
        case 1:
            return data_schooldate[row]
            break
        case 2:
            return data_week[row]
            break
        case 3:
            return data_jici[row]
            break
        default:
            break
        }
        return ""
    }
    
    //TableView start
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        
        return emtpyclassroom_detail.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:TableViewEmptyClassroom=tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewEmptyClassroom
        cell.label_location.text=emtpyclassroom_detail[indexPath.row].location
        cell.label_schooldate.text="第"+emtpyclassroom_detail[indexPath.row].zhoushu!+"周"
        cell.label_week.text=data_week[Int(emtpyclassroom_detail[indexPath.row].xingqi!)!-1]
        cell.label_jieci.text=data_jici[Int(emtpyclassroom_detail[indexPath.row].jieci!)!-1]
   
        return cell
    }
    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool, modes array: [String]?) {
        DispatchQueue.main.async(){
            switch aSelector {
            case Selector("emptyclassroom_search"):
                SVProgressHUD.dismiss()
                self.table_emptyclassroom.reloadData()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor=UIColor.white
        //print(picker_data.subviews.count)
        self.picker_data.delegate = self
        self.picker_data.dataSource = self
        
        self.table_emptyclassroom.delegate=self
        self.table_emptyclassroom.dataSource=self
        picker_data.autoresizingMask = .flexibleWidth
        serialQueue = DispatchQueue(label: "queuename", attributes: [])

        for i in 1..<22{
            data_schooldate.append(String(i)+"周")
        }
        picker_data.reloadAllComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

