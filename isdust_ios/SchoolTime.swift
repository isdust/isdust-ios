//
//  SchoolTime.swift
//  isdust_ios
//
//  Created by wzq on 8/25/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class SchoolTime{
    static var date_firstweek="20160905"
    static let D_DAY:Double = 86400
    static let D_WEEK:Double = 604800

    static func getTodayZhoushu()->Int{
        var DateFormatter_input:Foundation.DateFormatter!
        DateFormatter_input=Foundation.DateFormatter()
        DateFormatter_input.dateFormat = "yyyyMMdd"
        var date_firstweek=DateFormatter_input.date(from: self.date_firstweek)!
        var date_today=Date()
        let components=Calendar.current.dateComponents([.day], from: date_firstweek, to: date_today)
        let week=components.day!/7
        if(week<=0){
            return 1
        }
        if(week>23){
            return 23
        }
        return week+1
    }
    static func getTodayWeek()->Int{
        var result = [0,7,1,2,3,4,5,6]
        var date_today=Date()
        let components=Calendar.current.dateComponents([.weekday], from: date_today)
        let weekday=components.weekday!
  
        return result[weekday]
    }
    static func getdayarray(week:Int)->[String]{
        var result:[String]=[String]()
        var DateFormatter_input:Foundation.DateFormatter!
        var DateFormatter_output_month:Foundation.DateFormatter!
        var DateFormatter_output_day:Foundation.DateFormatter!
        var date1:Date!
        var date2:Date!
        DateFormatter_input=Foundation.DateFormatter()
        DateFormatter_output_month=Foundation.DateFormatter()
        DateFormatter_output_day=Foundation.DateFormatter()
        DateFormatter_input.dateFormat = "yyyyMMdd"
        DateFormatter_output_month.dateFormat = "M"
        DateFormatter_output_day.dateFormat = "d"
        
        
        date1=DateFormatter_input.date(from: date_firstweek)
        date2=DateFormatter_input.date(from: date_firstweek)
        date1.addTimeInterval(D_DAY*7*(Double(week)-1))
        date2.addTimeInterval(D_DAY*7*(Double(week)-1))
        result.append(DateFormatter_output_month.string(from: date1)+"月")
        date2.addTimeInterval(-D_DAY)
        for i in 1..<8{

            var day1=Int(DateFormatter_output_day.string(from: date1))!-1
            var day2=Int(DateFormatter_output_day.string(from: date2))!-1
            date2.addTimeInterval(D_DAY)
            date1.addTimeInterval(D_DAY)
            
            if(day1-day2<0){
                result.append(DateFormatter_output_month.string(from: date2)+"月")
                continue
            }
            result.append(DateFormatter_output_day.string(from: date2))
        
        }
        return result
        
        
        
    
    }
    static func num2week(num:Int) -> String {
        switch num {
        case 1:
            return "周一"
        case 2:
            return "周二"
        case 3:
            return "周三"
        case 4:
            return "周四"
        case 5:
            return "周五"
        case 6:
            return "周六"
        case 7:
            return "周日"
            
        default:
            return "error"
        }
    }
    static func num2jieci(num:Int)->String{
        switch num {
        case 1:
            return "1-2"
            break
        case 2:
            return "3-4"
            break
        case 3:
            return "5-6"
            break
        case 4:
            return "7-8"
            break
        case 5:
            return "9-10"
            break
        case 6:
            return "10-12"
            break

        default:
            return "error"
        }
    
    
    }
    static func date2week(date:String)->String{
        var DateFormatter_input:Foundation.DateFormatter!
        DateFormatter_input=Foundation.DateFormatter()
        var date1:Date!
        var result:[String]=["周日","周一","周二","周三","周四","周五","周六"]

        DateFormatter_input.dateFormat = "yyyy/MM/dd HH:mm:ss"
        date1=DateFormatter_input.date(from: date)
        let components = Calendar.current.dateComponents([.weekday], from: date1)
        let week=components.weekday
        
        return result[Int(week!)-1]

    }
    static func date2day(date:String)->String?{//返回今天，昨天
        var DateFormatter_input:Foundation.DateFormatter!
        DateFormatter_input=Foundation.DateFormatter()
        
        var date1:Date!
        var date2:Date!=Date()
        DateFormatter_input.dateFormat = "yyyy/MM/dd HH:mm:ss"
        date1=DateFormatter_input.date(from: date)!
//        let components = Calendar.current.dateComponents([.day,.hour], from: date1, to: date2)
        var component1=Calendar.current.dateComponents([.day,.month,.year], from: date1)
        var component2=Calendar.current.dateComponents([.day,.month,.year], from: date2)
        
        let component_delta = Calendar.current.dateComponents([.day,.hour], from: date1, to: date2)
        
        let day1=component1.day!
        let day2=component2.day!
        //var a=components.hour
        if(component1.day==component2.day&&component1.month==component2.month&&component1.year==component2.year){
            return "今天"
        }else if(component1.month==component2.month&&component1.year==component2.year&&((day2-day1==1))){
            return "昨天"
        }
        
        
        return nil
        
    }
    static func date2day_card(date:String)->String{
        var result:String?
        if let result=date2day(date: date){
            return result
        }
        return date2week(date: date)
    
    }
    static func date2month(date:String)->String{
        var DateFormatter_input:Foundation.DateFormatter!
        DateFormatter_input=Foundation.DateFormatter()
        
        var date1:Date!
        DateFormatter_input.dateFormat = "yyyy/MM/dd HH:mm:ss"
        date1=DateFormatter_input.date(from: date)!
        let components = Calendar.current.dateComponents([.month], from: date1)
        return String(components.month!)
        
    }
    static func date2time(date:String)->String{
        var DateFormatter_input:Foundation.DateFormatter!
        var DateFormatter_output_time:Foundation.DateFormatter!

        DateFormatter_input=Foundation.DateFormatter()
        DateFormatter_output_time=Foundation.DateFormatter()
        
        var date1:Date!
        DateFormatter_input.dateFormat = "yyyy/MM/dd HH:mm:ss"
        DateFormatter_output_time.dateFormat="HH:mm"
        
        date1=DateFormatter_input.date(from: date)!
        
        return DateFormatter_output_time.string(from: date1)
    
    }
    static func date2daymonth(date:String)->String{
        var DateFormatter_input:Foundation.DateFormatter!
        var DateFormatter_output_time:Foundation.DateFormatter!
        
        DateFormatter_input=Foundation.DateFormatter()
        DateFormatter_output_time=Foundation.DateFormatter()
        var date1:Date!
        DateFormatter_input.dateFormat = "yyyy/MM/dd HH:mm:ss"
        DateFormatter_output_time.dateFormat="MM-dd"
        
        date1=DateFormatter_input.date(from: date)!
        
        return DateFormatter_output_time.string(from: date1)
    }
    static func date2time_card(date:String)->String{
    
//        var result:String?
        if let result=date2day(date: date){
            return date2time(date: date)
        }
        return date2daymonth(date: date)
    }

}
