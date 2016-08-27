//
//  ViewCourseEditJieci.swift
//  isdust_ios
//
//  Created by wzq on 8/27/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class ViewCourseEditJieci:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    
    var frame_self:CGRect!
    var offset_head:CGRect!
    let head_height:CGFloat=50
    var view_picker:UIPickerView!
    
    
    let datasource_week:[String]=["周一","周二","周三","周四","周五","周六","周日"]
    let datasource_jieci:[String]=["第一、二节","第三、四节","第五、六节","第七、八节","第九、十节"]
    
    
    override func viewDidAppear(_ animated: Bool) {
        draw_head_background()
        draw_head_title(text: "test")
        draw_pickerview()
        
        
        
    }
    init(frame:CGRect){
        super.init(nibName: nil, bundle: nil)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw_head_background() {
        
        let layer = CAShapeLayer()
        var path = UIBezierPath()
        path.move(to: CGPoint.init(x: 0, y: 0))
        path.addLine(to: CGPoint.init(x: frame_self.width, y: 0))
        path.addLine(to: CGPoint.init(x: frame_self.width, y: head_height))
        path.addLine(to: CGPoint.init(x: 0, y: head_height))
        path.addLine(to: CGPoint.init(x: 0, y: 0))
        
        
        path.close()
        layer.path=path.cgPath
        layer.frame=CGRect.init(x: 0, y: 0, width: frame_self.width, height: head_height)
        offset_head = layer.frame
        
        layer.fillColor=UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1).cgColor
        
        //        layer.strokeColor = UIColor.black.cgColor
        layer.strokeColor = UIColor(red:214/255, green: 214/255, blue: 214/255, alpha: 1).cgColor
        //        layer.backgroundColor=UIColor.black.cgColor
        
        layer.lineWidth=1
        self.view.layer.addSublayer(layer)
        
    }
    func draw_head_title(text:String){
        var label_title=UILabel()
        label_title.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightBold)
        label_title.textColor=UIColor(red:83/255, green: 83/255, blue: 83/255, alpha: 1)
        label_title.text=text
        
        label_title.sizeToFit()
        let location_x=(self.view.frame.size.width-label_title.frame.size.width)/2
        label_title.frame=CGRect.init(x: location_x-15, y: 10, width: label_title.frame.size.width, height: label_title.frame.size.height)
        view.addSubview(label_title)
        
    }
    func draw_pickerview(){
        view_picker.delegate=self
        view_picker.dataSource=self
        view_picker.frame=CGRect.init(x: 0, y: offset_head.height, width: frame_self.width, height: 300)
    
    
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
            return 50
        case 1:
            return 50
        default:
            return -1
        }
        
    }
    
    
}
