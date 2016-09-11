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
        try! db.executeStatements("CREATE TABLE schedule (_id INTEGER PRIMARY KEY AUTOINCREMENT, zhoushu SMALLINT, xingqi SMALLINT, jieci SMALLINT, kecheng VARCHAR)")
    }

    func droptable() {
        db.executeStatements("DROP TABLE IF EXISTS schedule")
        try! db.executeStatements("CREATE TABLE schedule (_id INTEGER PRIMARY KEY AUTOINCREMENT, zhoushu SMALLINT, xingqi SMALLINT, jieci SMALLINT, kecheng VARCHAR)")        
    }
    func importclass(course:[Kebiao]) {
        for i in course{            
            try!db.executeUpdate("INSERT INTO schedule VALUES (NULL, ?, ?,?,?)", values: [i.zhoushu!,(i.xingqi!),(i.jieci!),(i.raw!)])
        }
        
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
        try!db.executeUpdate("DELETE FROM schedule WHERE xingqi=? and jieci=? and kecheng=?", values: [xingqi,jieci,kecheng])
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
            temp.raw=query.string(forColumn: "kecheng")
            let temp_array=temp.raw?.components(separatedBy: "<br>")
            temp.kecheng=temp_array?[0]
            temp.teacher=temp_array?[2]
            temp.location=temp_array?[3]
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
            temp.raw=query.string(forColumn: "kecheng")
            let temp_array=temp.raw?.components(separatedBy: "<br>")
            temp.kecheng=temp_array?[0]
            temp.teacher=temp_array?[2]
            temp.location=temp_array?[3]
            result.append(temp)
        }
        return result
        
    }
    func getcourse(xingqi:Int,jieci:Int,kecheng:String) -> [Kebiao] {
        var result = [Kebiao] ()
        
        var query=try!db.executeQuery("SELECT * FROM schedule WHERE xingqi=? and jieci=? and kecheng=?", values: [xingqi,jieci,kecheng])
        while query.next() {
            var temp=Kebiao()
            //print(query.int(forColumnIndex: query.columnIndex(forName: "zhoushu")))
            
            temp.zhoushu=String(query.long(forColumn: "zhoushu"))
            temp.xingqi=String(query.long(forColumn: "xingqi"))
            temp.jieci=String(query.long(forColumn: "jieci"))
            temp.raw=query.string(forColumn: "kecheng")
            let temp_array=temp.raw?.components(separatedBy: "<br>")
            temp.kecheng=temp_array?[0]
            temp.teacher=temp_array?[2]
            temp.location=temp_array?[3]
            result.append(temp)
        }
        return result
    }

    
    
}
