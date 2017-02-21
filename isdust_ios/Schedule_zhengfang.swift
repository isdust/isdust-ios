//
//  Schedule_zhengfang.swift
//  isdust_ios
//
//  Created by wzq on 9/30/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
extension String {
    var length: Int {
        return characters.count
    }
}
func += <K, V> ( left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
class Re{
    var regex:NSRegularExpression!
    init() {
        
    }
    func compile(_ expression:String)->Re{
        do {
            regex = try NSRegularExpression(pattern: expression)
        }catch let error {
        }
        return self
    }
    func findall(_ text:String)->[[String]]{
        var result:[[String]]=[[String]]()
        do {
            let nsString = text as NSString
            let res = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            var lastIdx = 0
            for i in 0..<res.count{
                var temp_result:[String]=[String]()
                for j in 0..<res[i].numberOfRanges{
                    temp_result.append(nsString.substring(with: res[i].rangeAt(j)))
                    
                }
                result.append(temp_result)
            }
            return result
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    func sub(_ template:String,_ data:String)->String{
        var result=regex.stringByReplacingMatches(in: data, options: [], range: NSRange(0..<data.utf16.count), withTemplate: template)
        return result
    }
    
}

func data_preprocess(data:String)->String{
    var result=data
    let re_replace_width = Re().compile(" width=\"[0-9]*?%\"")
    let re_replace_rowspan = Re().compile(" rowspan=\"[0-9]*?\"")
    let re_replace_class_noprint = Re().compile(" class=\"noprint\"")
    let re_replace_class_alt = Re().compile(" class=\"alt\"")
    let re_replace_font = Re().compile("<br><br><font color=\'red\'>([\\s\\S]*?)</font>")
    
    result = re_replace_width.sub("", result)
    result = re_replace_rowspan.sub("", result)
    result = re_replace_class_noprint.sub("", result)
    result = re_replace_class_alt.sub("", result)
    result = re_replace_font.sub("", result)
    
    
    return result
    
}
func extract_raw_schedule(data:String)->[[String]]{
    var mdata=data_preprocess(data:data)
    let re_jieci = Re().compile("<td>第[1,3,5,7,9]节</td>([\\s\\S]*?)</tr><tr>")
    let re_xingqi = Re().compile("<td align=\"Center\">([\\s\\S]*?)</td>")
    var jieci = re_jieci.findall(mdata)
    var xingqi:[[String]]=[[String]]()
    for i in jieci{
        var temp=re_xingqi.findall(i[1])
        var result_temp=[String]()
        for j in temp{
            result_temp.append (j[1])
            
        }
        xingqi.append(result_temp)
        
    }
    return xingqi
}
func filter_all(num:Int)->Bool{
    return true
}
func filter_even(num:Int)->Bool{
    return num%2==0
}
func filter_odd(num:Int)->Bool{
    return num%2==1
}

func process_zhouci(_ time:String)->[Int]{
    var result:[Int]!
    var myfilter:(Int)->Bool=filter_all
    if(time.contains("单")){
        myfilter=filter_odd
    }
    if(time.contains("双")){
        myfilter=filter_even
    }
    var re_zhouci=Re().compile("第([\\S\\s]*?)-([\\S\\s]*?)周")
    var temp_zhouci=re_zhouci.findall(time)
    result=Array(Int(temp_zhouci[0][1])!...Int(temp_zhouci[0][2])!)
    result=result.filter(myfilter)
    return result
}
func process_raw_cell(_ cell:String)->Dictionary<String,Any>{
    var result:Dictionary<String,Any>=Dictionary<String,Any>()
    var temp_split=cell.components(separatedBy: "<br>")
    result["class"]=temp_split[0]
    let re_zhouci = Re().compile("\\{[\\s\\S]*?\\}")
    let temp=re_zhouci.findall(temp_split[1])
    
    if(temp_split.count==4){
        result["teacher"] = temp_split[2]
        result["location"] = temp_split[3]
        //result["zhouci_raw"] = temp[0]
        result["zhoushu"] = process_zhouci(temp[0][0])
    }
    else if(temp_split.count==3){
        result["teacher"] = ""
        result["location"] = temp_split[2]
        //result["zhouci_raw"] = temp[0]
        result["zhoushu"] = process_zhouci(temp[0][0])
        
    }
    
    

    return result
}
func process_raw_schedule(_ raw:[[String]])->[Dictionary<String,Any>]{
    var result:[Dictionary<String,Any>]=[Dictionary<String,Any>]()
    var raw_copy:[[String]]=raw
    for i in 0..<raw_copy.count{
        for j in 0..<raw_copy[i].count{
            if(raw_copy[i][j]=="&nbsp;"){
                continue
            }
            if raw_copy[i][j].contains("<br><br>")==true{
                raw_copy[i][j]=raw_copy[i][j].replacingOccurrences(of: "<br><br><br>", with: "<br><br>")
                var temp_split=raw_copy[i][j].components(separatedBy: "<br><br>")
                for k in temp_split{
                    var result_child=process_raw_cell(k)
                    result_child["jieci"]=i+1
                    result_child["xingqi"] = j + 1
                    result.append(result_child)
                }
            }else{
                var result_child = process_raw_cell(raw_copy[i][j])
                result_child["jieci"] = i + 1
                result_child["xingqi"] = j + 1
                result.append(result_child)
            }
            
        }
    }
    return result
}


func extract_raw_change(data:String)->[[String]]{
    var mdata=data_preprocess(data:data)
    var re_table_all=Re().compile("<td>编号</td><td>课程名称</td><td>原上课时间地点教师</td><td>现上课时间地点教师</td><td>申请时间</td>[\\S\\s]*?</tr>([\\S\\s]*?)</table>")
    var temp_data_all=re_table_all.findall(mdata)[0]
    var re_table_row=Re().compile("<tr>[\\S\\s]*?<td>([\\S\\s]*?)</td><td>([\\S\\s]*?)</td><td>([\\S\\s]*?)</td><td>([\\S\\s]*?)</td><td>([\\S\\s]*?)</td>")
    var temp_data_row=re_table_row.findall(temp_data_all[1])
    return temp_data_row
    
}
func time_convert(time:String)->Int{
    let DateFormatter_input:Foundation.DateFormatter=Foundation.DateFormatter()
    DateFormatter_input.dateFormat = "yyyy-MM-dd-HH-mm"
    let date=DateFormatter_input.date(from: time)
    let result:Int=Int((date?.timeIntervalSince1970)!)
    return result
}
func process_raw_change_cell(name:String,data:String)->Dictionary<String,Any>{
    var result:Dictionary<String,Any>=Dictionary<String,Any>()
    var temp_split=data.components(separatedBy: "/")
    result["class"]=name
    result["teacher"]=temp_split[2]
    result["location"] = temp_split[1]
    result += resolve_change_time(data:temp_split[0])
    return result
}
func resolve_change_time(data:String)->Dictionary<String,Any>{
    var result:Dictionary<String,Any>=Dictionary<String,Any>()
    var re_time=Re().compile("周([\\S\\s]*?)第([\\S\\s]*?)节连续2节(\\{[\\s\\S]*?\\})")
    var temp_time=re_time.findall(data)
    result["xingqi"]=Int(temp_time[0][1])
    result["jieci"] = Int((Int(temp_time[0][2])!+1)/2)
    result["zhoushu"] = process_zhouci(temp_time[0][3])
    return result
}
func sortFunc(data1:Dictionary<String,Any>,data2:Dictionary<String,Any>)-> Bool{
    var num1=data1["date"] as! Int
    var num2=data2["date"] as! Int
    return num1<num2
}
func process_raw_change(data:[[String]])->[Dictionary<String,Any>]{
    var result:[Dictionary<String,Any>]=[Dictionary<String,Any>]()
    for i in data{
        var result_child:Dictionary<String,Any>=Dictionary<String,Any>()
        result_child["date"]=time_convert(time: i[5])
        if(i[3] != "&nbsp;"){result_child["old"]=process_raw_change_cell(name: i[2],data: i[3])}
        if(i[4] != "&nbsp;"){result_child["new"]=process_raw_change_cell(name: i[2],data: i[4])}
        result.append(result_child)
    }
    result = result.sorted(by: sortFunc)
    return result
}
func getschedule(data:String)->[Dictionary<String,Any>]{
    let temp=extract_raw_schedule(data: data)
    let result=process_raw_schedule(temp)
    return result
}
func getchange(data:String)->[Dictionary<String,Any>]{
    let temp=extract_raw_change(data:data)
    let result=process_raw_change(data:temp)
    return result
}
