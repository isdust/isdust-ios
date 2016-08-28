//
//  ViewCourseEditJieci.swift
//  isdust_ios
//
//  Created by wzq on 8/27/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class ViewCourseEditJieci:UIView,UIPickerViewDelegate,UIPickerViewDataSource{
    let contentview:UIView=UIView()
    var maskview:UIView!
    
    
    var frame_self:CGRect!
    var offset_head:CGRect!
    let head_height:CGFloat=50
    var view_picker:UIPickerView!
    
    var xingqi:Int!
    var jieci:Int!
    var delegate:ViewCourseEditJieciDelegate!
    
    
    let datasource_week:[String]=["周一","周二","周三","周四","周五","周六","周日"]
    let datasource_jieci:[String]=["第一、二节","第三、四节","第五、六节","第七、八节","第九、十节"]
    
    
    var finished=0
    init(){
        super.init(frame: CGRect.zero)
        xingqi=1
        jieci=1
        
        

        
        
    }
    func draw_head() {
        let view_head=UINavigationBar()
        view_head.frame=CGRect.init(x: 0, y: 0, width: frame_self.width, height: head_height)
        offset_head=view_head.frame
        view_head.backgroundColor=UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        //view_head.topItem=UINavigationItem()
        let navItem = UINavigationItem(title: "选择上课节次")
        let doneItem=UIBarButtonItem.init(title: "完成", style: .done, target: nil, action: #selector(self.button_click))
        navItem.rightBarButtonItem = doneItem;
        view_head.setItems([navItem], animated: false)
        
        contentview.addSubview(view_head)
        
    }
    func button_click()  {
        delegate.editjieci(jieci: jieci)
        delegate.editxingqi(xingqi: xingqi)
        delegate.reload_jieci_xingqi()
        disappear()
        
    }
    override func didMoveToSuperview() {
        if(finished==1){
            return
        }
        self.frame=(self.window?.rootViewController?.view.frame)!
        frame_self=self.frame
        
        
        contentview.frame=CGRect.init(x: 0, y: frame_self.height, width: frame_self.width, height: 320)
        contentview.backgroundColor=UIColor.white
        
        maskview=UIView.init(frame: frame)
        maskview.backgroundColor=UIColor.black.withAlphaComponent(0.7)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.disappear))
        maskview.addGestureRecognizer(gesture)
        draw_head()
        draw_pickerview()
        
        self.backgroundColor=UIColor.init(red: 1, green: 1, blue: 1, alpha: 0)
        
        self.addSubview(maskview)
        self.addSubview(contentview)
        
        
        
        UIView.animate(withDuration: 0.6, animations: {
            self.contentview.frame=CGRect.init(x: 0, y: self.frame_self.height-320, width: self.frame_self.width, height: 320)
        })
        
        view_picker.selectRow(jieci-1, inComponent: 1, animated: false)
        view_picker.selectRow(xingqi-1, inComponent: 0, animated: false)
    }

    func disappear()  {
        UIView.animate(withDuration: 0.6, animations: {
            self.contentview.frame=CGRect.init(x: 0, y: self.frame_self.height, width: self.frame_self.width, height: 320)
            },completion:{(finished: Bool) -> Void in
                if(finished==true){
                    self.removeFromSuperview()
                }
        })
        finished=1
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw_head_background() {
        

        
    }

    func draw_pickerview(){
        view_picker=UIPickerView()
        view_picker.delegate=self
        view_picker.dataSource=self
        view_picker.frame=CGRect.init(x: 0, y: offset_head.height, width: frame_self.width, height: 300)
        print(view_picker.subviews.count)
        contentview.addSubview(view_picker)
//        view_picker.subviews[1].isHidden=false
//        view_picker.subviews[0].isHidden=false
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return datasource_week.count
        case 1:
            return datasource_jieci.count
        default:
            return -1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return datasource_week[row]
        case 1:
            return datasource_jieci[row]
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 75
        case 1:
            return 150
        default:
            return -1
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            xingqi=row+1
            break
        case 1:
            jieci=row+1
            break
        default:
            break
        }
    }
    
}
public protocol ViewCourseEditJieciDelegate{
    func editjieci(jieci:Int)
    func editxingqi(xingqi:Int)
    func reload_jieci_xingqi()
}
