//
//  ViewCourseEditWeek.swift
//  isdust_ios
//
//  Created by wzq on 8/25/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class ViewCourseEditWeek:UIViewController{
     var weeks:[Int]=[Int]()
     var delegate:ViewCourseEditWeekDelegate!

    var frame_self:CGRect!
    let view_self:UIView=UIView()
     var view_table:UIView!
    let head_height:CGFloat=50
    let back_height:CGFloat=200
    var back_width:CGFloat!
     var back_frame:CGRect!
     var offset_head:CGRect!
     var segment:UISegmentedControl!
     var view_cell:[ViewCourseWeekCell]=[ViewCourseWeekCell]()

     override func viewDidAppear(_ animated: Bool) {
          view_cell.filter(isin).map({$0.choose()})

     }
     func isin(mview:ViewCourseWeekCell) -> Bool {
          
          if( weeks.contains(mview.tag) ){
          
               return true
          }
          return false
     }
     
    init(frame: CGRect){
        super.init(nibName: nil, bundle: nil)
//
        self.modalPresentationStyle = UIModalPresentationStyle.popover
     view.frame=CGRect.init(x: frame.origin.x, y: 0, width: frame.width, height: 400)
     view.backgroundColor=UIColor.white
     self.preferredContentSize = view.frame.size

     frame_self=frame
     draw_head_background()
     draw_head_title(text: "选择上课周数")
     drawcellbackground()
     for i in 0..<25{
          draw_singlecell_back(position: CGFloat(i))
     
     }
     draw_segment()
     draw_button()
    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//    }
    func setframe(frame: CGRect) {
        //super.init(frame: frame)
        
        frame_self=frame
        draw_head_background()

        
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
        label_title.frame=CGRect.init(x: location_x-20, y: 10, width: label_title.frame.size.width, height: label_title.frame.size.height)
        view.addSubview(label_title)
    
    }
     func draw_button()   {
          let button=UIButton()
          button.setTitle("保存", for: .normal)
          button.sizeToFit()
          button.frame.origin.x=offset_head.width-button.frame.width-5-20
          button.frame.origin.y=10
          button.setTitleColor(UIColor.init(red: 10/255, green: 96/255, blue: 255/255, alpha: 1), for: .normal)
          button.addTarget(self, action: #selector(self.button_click), for: .touchUpInside)
          view.addSubview(button)
          
     }
     func button_click(sender:UIButton!) {
          var zhoushu:[Int]=[Int]()
          view_cell.filter(isselect).map({zhoushu.append($0.week)})
          delegate.reloadschedule(week: zhoushu)
          self.dismiss(animated: true, completion: nil)
     }
     func drawcellbackground()  {
          let interval:CGFloat=15
          back_width=view.frame.size.width-2*interval-20
          let layer = CAShapeLayer()
          var path = UIBezierPath()
          view_table=UIView()
          view_table.backgroundColor=UIColor.init(red: 186/255, green: 195/255, blue: 203/255, alpha: 1)
          view_table.frame=CGRect.init(x: interval, y: interval+offset_head.height, width: back_width, height: back_height)

          self.view.addSubview(view_table)
     }
     func draw_singlecell_back(position:CGFloat)  {
          let interval:CGFloat=3
          let singleview=ViewCourseWeekCell()
          let corordinate_x=CGFloat(Int(position)%5)
          let corordinate_y=CGFloat(Int(position)/5)
          let width=(view_table.frame.width-6*interval)/5
          let height=(view_table.frame.height-6*interval)/5
          singleview.frame=CGRect.init(x: corordinate_x*width+(corordinate_x+1)*interval, y: corordinate_y*height+(corordinate_y+1)*(interval), width: width, height: height)
          //singleview.backgroundColor=UIColor(red:242/255, green: 242/255, blue: 242/255, alpha: 1)
          singleview.week=Int(position+1)
          singleview.tag=Int(position+1)

          
          singleview.label.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightThin)
          singleview.label.textColor=UIColor.black
          singleview.label.text="\(Int(position+1))"
          singleview.label.sizeToFit()
          let location_x=(singleview.frame.size.width-singleview.label.frame.size.width)/2
          singleview.label.frame=CGRect.init(x: location_x, y: 10, width: singleview.label.frame.size.width, height: singleview.label.frame.size.height)
          singleview.addSubview(singleview.label)
          singleview.unchoose()
          
          
          
          let gesture = UITapGestureRecognizer(target: self, action: #selector(self.ViewWeekClick))
          singleview.addGestureRecognizer(gesture)
          
          view_cell.append(singleview)
          self.view_table.addSubview(singleview)
          

//
//
          
          
     }
     func draw_segment()  {
          let interval:CGFloat=5
          segment=UISegmentedControl.init(items: ["单周","双周","全部","自定义"])
          segment.selectedSegmentIndex=3
          segment.addTarget(self, action: #selector(self.segment_change), for: .valueChanged)
          segment.sizeToFit()
          
          let corordinate_x=(frame_self.width-segment.frame.width)/2
          
          segment.frame=CGRect.init(x: corordinate_x, y:view_table.frame.origin.y+view_table.frame.height+interval , width: segment.frame.width, height: segment.frame.height)
          view.addSubview(segment)
     }
     func iseven(mview:ViewCourseWeekCell)->Bool{
          if(mview.tag%2==0){
               return true
          }
          return false
     }
     func isodd(mview:ViewCourseWeekCell)->Bool{
          if(mview.tag%2==1){
               return true
          }
          return false
     }
     func isselect(mview:ViewCourseWeekCell) -> Bool {
          if(mview.selected==1){
               return true
          }
          return false
     }
     func segment_change(sender: UISegmentedControl) {
          switch sender.selectedSegmentIndex {
          case 0:
               for i in view_cell{i.unchoose()}
               view_cell.filter(isodd).map(){
                    (i) -> ViewCourseWeekCell in
                    i.choose()
                    return i
               }
               break
          case 1:
               for i in view_cell{i.unchoose()}
               view_cell.filter(iseven).map(){
                    (i) -> ViewCourseWeekCell in
                    i.choose()
                    return i
               }
               break
          case 2:
               for i in view_cell{i.choose()}
          case 3:
               for i in view_cell{i.unchoose()}
          default:
               break
          }
     }
     func ViewWeekClick(sender:UITapGestureRecognizer) {
 
          
          var singleview=sender.view as! ViewCourseWeekCell
          singleview.clicked()
          let select_odd_num:Int=view_cell.filter(isodd).filter(isselect).count
          let select_even_num:Int=view_cell.filter(iseven).filter(isselect).count
          if((select_odd_num + select_even_num) == view_cell.count){
               segment.selectedSegmentIndex=2
          }
          else if(select_odd_num==0&&select_even_num==12){
               segment.selectedSegmentIndex=1
          }
          else if(select_odd_num==13&&select_even_num==0){
               segment.selectedSegmentIndex=0
          }
          else{
               segment.selectedSegmentIndex=3
          }
     }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }

     override func viewWillAppear(_ animated: Bool) {
          view.superview?.layer.cornerRadius=0
          //view.superview?.frame=view.frame
          popoverPresentationController?.sourceRect=view.frame
          print(view.superview?.frame)
     }
     
}
class ViewCourseWeekCell:UIView{
     var label:UILabel=UILabel()
     var week:Int!
     var selected:Int=0
     func clicked() {
          if(selected==0){
               choose()
          }else{
               unchoose()
          }
     }
     func choose() {
          selected=1
          backgroundColor=UIColor.init(red: 110/255, green: 157/255, blue: 4/255, alpha: 1)
          label.textColor=UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
          

     }
     func unchoose() {
          selected=0
          backgroundColor=UIColor(red:242/255, green: 242/255, blue: 242/255, alpha: 1)
          label.textColor=UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
          
          
     }

}
public protocol ViewCourseEditWeekDelegate:class{
     func reloadschedule(week:[Int])
}
