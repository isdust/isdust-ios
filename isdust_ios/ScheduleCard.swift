//
//  ScheduleCard.swift
//  isdust_ios
//
//  Created by wzq on 9/11/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class ScheduleCard:UIView,UITableViewDelegate,UITableViewDataSource{
    var label_info:UILabel!
    var image_item:UIImageView!
    var mdata:[Kebiao]!
    var mdb:ScheduleManage!
    var mtableview:UITableView!
    
    
    let cell_height:CGFloat=100/3+6
    func draw(){
        self.backgroundColor=UIColor.white
        image_item=UIImageView()
        image_item.frame=CGRect.init(x: 15, y: 8, width: 45, height: 45)
        image_item.image = #imageLiteral(resourceName: "menu_schedule")
        image_item.contentMode = .scaleToFill
        
        
        var title:UILabel = UILabel()
        title.frame=CGRect.init(x: 60+10, y: 8, width: 10, height: 10)
        title.text="课程表"
        title.font=UIFont.boldSystemFont(ofSize: 18)
        title.sizeToFit()
        
        
        label_info=UILabel()
        label_info.frame=CGRect.init(x: 60+10, y: title.frame.origin.y+title.frame.size.height, width: frame.size.width-(60+10), height: 12)
        label_info.textColor=UIColor.init(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
        label_info.font=label_info.font.withSize(12)
        label_info.numberOfLines=3
        label_info.lineBreakMode = .byClipping
        
        
        self.addSubview(title)
        self.addSubview(image_item)
        self.addSubview(label_info)
        
    }
    func setContent(content:String) {
        label_info.text=content
        label_info.sizeToFit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        mdb=ScheduleManage()
        draw()
        mdata=ScheduleManage().getTodaySchedule()
        if(mdb.getcount()==0){
            setContent(content: "还没有导入课表，请先进入课程表功能导入课表")
            return
        }
        if(mdata.count == 0){
            setContent(content: "今天"+SchoolTime.num2week(num: SchoolTime.getTodayWeek())+",没有课程")
            return
        }
        setContent(content: "今天"+SchoolTime.num2week(num: SchoolTime.getTodayWeek())+",有"+String(mdata.count)+"节课")
        
        
        
        
        mtableview=UITableView()
        mtableview.dataSource=self
        mtableview.delegate=self
        mtableview.separatorColor=UIColor.clear
        mtableview.allowsSelection=false
        mtableview.frame=CGRect.init(x: 0, y: image_item.frame.origin.y+image_item.frame.size.height+10, width: frame.width, height: cell_height*CGFloat(mdata.count)+10)
        
        self.addSubview(mtableview)
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mdata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=ScheduleCardCell.init(style: .default, reuseIdentifier: "cell")
        cell.setdata(data: mdata[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100/3+10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
class ScheduleCardCell:UITableViewCell{
    var course:UILabel!
    var jieci:UILabel!
    var location:UILabel!
    
    var view_left:UIView!
    var view_right:UIView!
    var image_location:UIImageView!
    let radius:CGFloat=5
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let screenSize: CGRect = UIScreen.main.bounds
        accessoryType = .none
        
        
        
        view_left=UIView()
        view_left.frame=CGRect.init(x: 2, y: 0, width: 120/3, height: 100/3)
        let path_left = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 120/3, height: 100/3), cornerRadius: radius)
        
        let layer_left = CAShapeLayer()
        layer_left.path=path_left.cgPath
        layer_left.fillColor=UIColor.init(red: 235/255, green: 249/255, blue: 254/255, alpha: 1).cgColor
        layer_left.frame=view_left.frame
        view_left.layer.addSublayer(layer_left)
        
        
        view_left.frame=CGRect.init(x: 2, y: 0, width: 120/3, height: 100/3)
        
        view_right=UIView()
        view_right.frame=CGRect.init(x: view_left.frame.size.width+view_left.frame.origin.x+10, y: 0, width: screenSize.width-(view_left.frame.size.width+view_left.frame.origin.x+10)-radius, height: 100/3)
        let path_right = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: view_right.frame.width, height: view_right.frame.height), cornerRadius: radius)
        let layer_right = CAShapeLayer()
        layer_right.path=path_right.cgPath
        layer_right.fillColor=UIColor.init(red: 235/255, green: 249/255, blue: 254/255, alpha: 1).cgColor
        layer_right.frame=view_left.frame
        view_right.layer.addSublayer(layer_right)
        //view_right.layer.mask=layer_right
        
        course=UILabel()
        jieci=UILabel()
        location=UILabel()
        

        jieci.textColor=UIColor.init(red: 95/255, green: 147/255, blue: 175/255, alpha: 1)
        course.textColor=UIColor.init(red: 36/255, green: 106/255, blue: 150/255, alpha: 1)
        location.textColor=UIColor.init(red: 36/255, green: 106/255, blue: 150/255, alpha: 1)
        
        
        jieci.font=jieci.font.withSize(11)
        course.font=UIFont.boldSystemFont(ofSize: 14)
        
        
        
        image_location=UIImageView()
        image_location.image=#imageLiteral(resourceName: "ic_detail_course_classroom_icon")
        image_location.frame=CGRect.init(x: view_right.frame.width-100, y: (view_right.frame.height-24)/2, width: 24, height: 24)
//        var path = UIBezierPath()
        
        view_left.addSubview(jieci)
        view_right.addSubview(course)
        view_right.addSubview(location)
        view_right.addSubview(image_location)
        
        self.addSubview(view_left)
        self.addSubview(view_right)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setdata(data:Kebiao) {
        jieci.text=SchoolTime.num2jieci(num: Int(data.jieci!)!)
        jieci.sizeToFit()
        jieci.frame.origin=CGPoint.init(x: (view_left.frame.width-jieci.frame.width+radius*2)/2, y: (view_left.frame.height-jieci.frame.height)/2)
        
        course.text=data.kecheng!
        course.sizeToFit()
        course.frame.origin=CGPoint.init(x: 5, y: (view_right.frame.height-course.frame.height)/2)
        

        
        location.text=data.location
        location.sizeToFit()
        location.frame.origin=CGPoint.init(x: image_location.frame.width+image_location.frame.origin.x, y: (view_right.frame.height-location.frame.height)/2)

        
    }
    

}
