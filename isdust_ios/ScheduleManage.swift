//
//  ScheduleManage.swift
//  isdust_ios
//
//  Created by wzq on 8/23/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
import FMDB

class ScheduleManage{
    var db:FMDatabase!
    init  () {
        let path=try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("schedule.db").path
        db = FMDatabase(path: path)
        
        
        if !(db.open()) {
            print("Unable to open database")
            return
        }
        try! db.executeStatements("CREATE TABLE schedule (_id INTEGER PRIMARY KEY AUTOINCREMENT, zhoushu SMALLINT, xingqi SMALLINT, jieci SMALLINT, class VARCHAR,location VARCHAR,teacher VARCHAR)")
    }

    func droptable() {
        db.executeStatements("DROP TABLE IF EXISTS schedule")
        try! db.executeStatements("CREATE TABLE schedule (_id INTEGER PRIMARY KEY AUTOINCREMENT, zhoushu SMALLINT, xingqi SMALLINT, jieci SMALLINT, class VARCHAR,location VARCHAR,teacher VARCHAR)")
    }
    func importclass(course:[Kebiao]) {
        for i in course{            
            try!db.executeUpdate("INSERT INTO schedule VALUES (NULL,?,?,?,?,?,?)", values: [i.zhoushu!,(i.xingqi!),(i.jieci!),(i.kecheng!),(i.location!),(i.teacher!)])
        }
        
    }
    func importclass(course:Kebiao) {
            try!db.executeUpdate("INSERT INTO schedule VALUES (NULL,?,?,?,?,?,?)", values: [course.zhoushu!,(course.xingqi!),(course.jieci!),(course.kecheng!),(course.location!),(course.teacher!)])
        
        
    }
    func getcount() -> Int {
        
        var result=try!db.executeQuery("select count(*) from schedule", values: nil)
        result.next()
        return result.long(forColumnIndex: 0)
    }
    func deleteclass(zhoushu:Int,xingqi:Int,jieci:Int) {
        try!db.executeUpdate("DELETE FROM schedule WHERE zhoushu=? and xingqi=? and jieci=?", values: [zhoushu,xingqi,jieci])
    }
    func deleteclass(xingqi:Int,jieci:Int,kecheng:String) {
        try!db.executeUpdate("DELETE FROM schedule WHERE xingqi=? and jieci=? and class=?", values: [xingqi,jieci,kecheng])
    }
    func deleteclass(xingqi:Int,jieci:Int,kecheng:String,zhoushu:String) {
        try!db.executeUpdate("DELETE FROM schedule WHERE xingqi=? and jieci=? and class=? and zhoushu=?", values: [xingqi,jieci,kecheng,zhoushu])
    }
    func deleteclass(couser:Kebiao) {
        try!db.executeUpdate("DELETE FROM schedule WHERE zhoushu=? and xingqi=? and jieci=?", values: [couser.zhoushu!,couser.xingqi!,couser.jieci!])
    }
    func getTodaySchedule()->[Kebiao]{
        let zhoushu=SchoolTime.getTodayZhoushu()
        var week=SchoolTime.getTodayWeek()
        var result = [Kebiao] ()
        let query=try!db.executeQuery("SELECT * FROM schedule WHERE `zhoushu`=? AND xingqi=? ORDER BY jieci", values: [zhoushu,week])
        while query.next() {
            var temp=Kebiao()
            
            temp.zhoushu=String(query.long(forColumn: "zhoushu"))
            temp.xingqi=String(query.long(forColumn: "xingqi"))
            temp.jieci=String(query.long(forColumn: "jieci"))
            
            temp.kecheng=(query.string(forColumn: "class"))
            temp.teacher=(query.string(forColumn: "teacher"))
            temp.location=(query.string(forColumn: "location"))
            result.append(temp)
        }
        return result
    }
    func getcourse(week:Int) -> [Kebiao] {
        var result = [Kebiao] ()
        
        var query=try!db.executeQuery("SELECT * FROM schedule WHERE `zhoushu`=?", values: [week])
        while query.next() {
            var temp=Kebiao()

            temp.zhoushu=String(query.long(forColumn: "zhoushu"))
            temp.xingqi=String(query.long(forColumn: "xingqi"))
            temp.jieci=String(query.long(forColumn: "jieci"))

            temp.kecheng=(query.string(forColumn: "class"))
            temp.teacher=(query.string(forColumn: "teacher"))
            temp.location=(query.string(forColumn: "location"))
            result.append(temp)
        }
        return result
        
    }
    func getcourse(xingqi:Int,jieci:Int,kecheng:String) -> [Kebiao] {
        var result = [Kebiao] ()
        
        var query=try!db.executeQuery("SELECT * FROM schedule WHERE xingqi=? and jieci=? and class=?", values: [xingqi,jieci,kecheng])
        while query.next() {
            var temp=Kebiao()
            //print(query.int(forColumnIndex: query.columnIndex(forName: "zhoushu")))
            
            temp.zhoushu=String(query.long(forColumn: "zhoushu"))
            temp.xingqi=String(query.long(forColumn: "xingqi"))
            temp.jieci=String(query.long(forColumn: "jieci"))
            
            temp.kecheng=(query.string(forColumn: "class"))
            temp.teacher=(query.string(forColumn: "teacher"))
            temp.location=(query.string(forColumn: "location"))
            result.append(temp)
        }
        return result
    }
    func importclass(data:[Dictionary<String,Any>]){
        for i in data{
            if(i.count==3)            {
                continue;

            }
            let mteacher:String=i["teacher"] as! String
            let mclass:String=i["class"] as! String
            let mlocation:String=i["location"] as! String
            let mjieci:Int=i["jieci"] as! Int
            let mxingqi:Int=i["xingqi"] as! Int
            let mzhoushu:[Int]=i["zhoushu"] as! [Int]
            for j in mzhoushu{
                var temp=Kebiao()
                temp.location=mlocation
                temp.teacher=mteacher
                temp.kecheng=mclass
                temp.jieci=String(mjieci)
                temp.xingqi=String(mxingqi)
                temp.zhoushu=String(j)
                importclass(course: temp)
            }
        }
    }
    func deleteclass(data:[Dictionary<String,Any>]) {
        for i in data{
            let mteacher:String=i["teacher"] as! String
            let mclass:String=i["class"] as! String
            let mlocation:String=i["location"] as! String
            let mjieci:Int=i["jieci"] as! Int
            let mxingqi:Int=i["xingqi"] as! Int
            let mzhoushu:[Int]=i["zhoushu"] as! [Int]
            for j in mzhoushu{
                var temp=Kebiao()
                temp.location=mlocation
                temp.teacher=mteacher
                temp.kecheng=mclass
                temp.jieci=String(mjieci)
                temp.xingqi=String(mxingqi)
                temp.zhoushu=String(j)
                try!db.executeUpdate("DELETE FROM schedule WHERE xingqi=? and jieci=? and class=? and zhoushu=?", values: [Int(temp.xingqi!),Int(temp.jieci!),temp.kecheng,Int(temp.zhoushu!)])

            }
        }
    }

    
    
}
