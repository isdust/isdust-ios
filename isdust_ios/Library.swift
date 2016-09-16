//
//  Library.swift
//  isdust_ios
//
//  Created by wzq on 7/28/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class Library{
    struct PersonalInfo {
        var name:String
        var id:String
        var state:String
        init(){
            name=""
            id=""
            state=""
        
        }
    }
    var mPersonalInfo=PersonalInfo()
    
    var mhttp:Http
    init(){
        mhttp=Http()
    }
    func md5(data:String) -> String {
        
        let cs = (data as NSString).utf8String
        let buffer = UnsafeMutablePointer<Int8>.init(mutating: cs)
        let b = String.init(cString: openssl_md5(buffer))
        return b.lowercased();
    }
    func login(user:String,password:String) throws -> String {
        var msubmit="rdid="+user+"&rdPasswd="+md5(data: password)+"&returnUrl=&password="
        var text_web = try mhttp.post("http://interlib.sdust.edu.cn/opac/reader/doLogin",msubmit)
        print(text_web.contains("用户名或密码错误!"))
        if((text_web.contains("用户名或密码错误!")) == true){
            return "账号或密码错误";
        
        }
        var expression="<font class=\"space_font\">([\\S\\s]*?)</font>"
        var regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.caseInsensitive)
        var res = regex.matches(in: text_web, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, (text_web.characters.count)))
        var temp_array=[String]()
        for i in res{
            temp_array.append((text_web as NSString).substring(with: i.rangeAt(1)))
        
        }
        mPersonalInfo.name=temp_array[1]
        mPersonalInfo.id=temp_array[0]
        mPersonalInfo.state=temp_array[2]
        return "登录成功"
        
        
    }
    func get_borrwingdetail() throws -> [[String]] {
        var result:[[String]] = [[String]] ()
        var text_web=try mhttp.get("http://interlib.sdust.edu.cn/opac/loan/renewList")
        var expression="<td width=\"40\"><input type=\"checkbox\" name=\"barcodeList\" value=\"([0-9]*?)\" />[\\s\\S]*?target=\"_blank\">([\\S\\s]*?)</a></td>[\\S\\s]*?<td width=\"100\">([0-9]{4}-[0-9]{2}-[0-9]{2})[\\S\\s]*?<td width=\"100\">([0-9]{4}-[0-9]{2}-[0-9]{2})"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.caseInsensitive)
        var res = regex.matches(in: text_web, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text_web.characters.count))
        
        for i in res{
            var temp=[String](repeating:"",count:4)
            for j in 0..<4{
                temp[j]=(text_web as NSString).substring(with: i.rangeAt( j+1))
                
            }
            result.append(temp)
        
        }
        
        return result
    }
    func getLocalMap(text:String) -> String {
        let source="{\"QBCK\":\"青岛科图版书库\",\"JNJC\":\"济南教材参考库\",\"QXKYL\":\"青岛现刊阅览室\",\"QZKK\":\"青岛自科书库\",\"QWYK\":\"青岛外文书样本库\",\"QWWK\":\"青岛外文书库\",\"TDZKK\":\"泰东自科现刊\",\"QZYK\":\"青岛中文书样本库\",\"TDYB\":\"泰东样本库\",\"KJGK\":\"泰西过刊\",\"JNGK\":\"中文期刊\",\"JNWWK\":\"济南外文刊\",\"TDZT\":\"泰东中图库\",\"TDSKK\":\"泰东社科现刊\",\"JNGP\":\"济南随书光盘库\",\"QSKK\":\"青岛社科书库\",\"JNQK\":\"济南期刊库\",\"JNSK\":\"济南社科借阅区\",\"QJCK\":\"青岛教材样本库\",\"TDKT\":\"泰东科图库\",\"KJZKK\":\"泰西自科现刊\",\"QMJK\":\"青岛密集库\",\"QDZY\":\"青岛电子阅览室\",\"TDGK\":\"泰东过刊库\",\"TDXS\":\"泰东学生阅览室\",\"JNGJ\":\"济南工具书\",\"TDKY\":\"泰东考研库\",\"QGKK\":\"青岛过期期刊库\",\"Q007\":\"青岛未分配流通库\",\"JNXS\":\"济南学生借书处\",\"JNBC\":\"济南保存库\",\"TDWW\":\"泰东外文库\",\"TDZH\":\"泰东综合库\",\"KJTC\":\"特藏图书\",\"JNZK\":\"济南自科借阅区\",\"JNFY\":\"济南复印\",\"TDTC\":\"泰东特藏库\",\"KJZT\":\"泰西中图库\",\"TDZLS\":\"泰文法资料室\",\"JNWW\":\"济南外文借书处\",\"WFFG\":\"文法分馆\",\"QGJK\":\"青岛工具书库\",\"JNLS\":\"济南临时库\",\"QTCK\":\"青岛特藏书库\",\"KJSKK\":\"泰西社科现刊\",\"JNJS\":\"济南教师借书处\",\"JNDZ\":\"济南电子阅览室\",\"TDJS\":\"泰东教师阅览室\"}"
        let data = source.data(using: String.Encoding.utf8) //data  是json格式字符串
        let json = try? JSONSerialization.jsonObject(with: data!) as! NSDictionary
        
        return (json![text] as? String)!
        
    }
    func getOriginLib(text:String) -> String {
        let source="{\"02000\":\"泰安东校区\",\"04000\":\"泰山科技学院\",\"01000\":\"青岛校区\",\"01000 \":null,\"03000\":\"济南校区\",\"999\":\"山东科技大学图书馆\",\"05000\":\"文法分馆\"}"
        let data = source.data(using: String.Encoding.utf8) //data  是json格式字符串
        let json = try? JSONSerialization.jsonObject(with: data!) as! NSDictionary
        return (json![text] as? String)!
        
    }
    func getState(text:String) -> String {
        let source="{\"0\":{\"stateType\":0,\"stateName\":\"流通还回上架中\"},\"1\":{\"stateType\":1,\"stateName\":\"编目\"},\"2\":{\"stateType\":2,\"stateName\":\"在馆\"},\"3\":{\"stateType\":3,\"stateName\":\"借出\"},\"4\":{\"stateType\":4,\"stateName\":\"丢失\"},\"5\":{\"stateType\":5,\"stateName\":\"剔除\"},\"6\":{\"stateType\":6,\"stateName\":\"交换\"},\"7\":{\"stateType\":7,\"stateName\":\"赠送\"},\"8\":{\"stateType\":8,\"stateName\":\"装订\"},\"9\":{\"stateType\":9,\"stateName\":\"锁定\"},\"10\":{\"stateType\":10,\"stateName\":\"预借\"},\"12\":{\"stateType\":12,\"stateName\":\"清点\"},\"13\":{\"stateType\":13,\"stateName\":\"闭架\"},\"14\":{\"stateType\":14,\"stateName\":\"修补\"},\"15\":{\"stateType\":15,\"stateName\":\"查找中\"}}"
        let data = source.data(using: String.Encoding.utf8) //data  是json格式字符串
        let json = try? JSONSerialization.jsonObject(with: data!) as AnyObject
        
        
        //let number = json?["Language"]??["Field"]??[0]?["Number"] as? String
        
        return ((json?[text] as! NSDictionary) ["stateName"] as? String)!
        
    }
    func getReturnDate(source:String,barcode:String) -> String {
        let data = source.data(using: String.Encoding.utf8) //data  是json格式字符串
        let json = try? JSONSerialization.jsonObject(with: data!) as! NSDictionary
        var temp=((json?[barcode] as! NSDictionary) ["returnDate"]) as! NSNumber
        let temp1=temp.decimalValue/1000
        return "\(temp1)"
    }
    func renew_all() throws -> String {
        var text_web=try mhttp.post("http://interlib.sdust.edu.cn/opac/loan/doRenew","furl=%2Fopac%2Floan%2FrenewList&renewAll=all" )
        var content=try getMiddleText(text_web, "<div style=\"margin:20px auto; width:50%; height:auto!important; min-height:200px; border:2px dashed #ccc;\">", "<input")
        
        content=content.replacingOccurrences(of: "\t", with: "")
        content=content.replacingOccurrences(of: "\n", with: "")
        content=content.replacingOccurrences(of: "\r", with: "")
        var temp_array=content.components(separatedBy: "<br/>")
        var len=(temp_array.count)-1
        var result=""
        for i in 1..<len{
            result+=(temp_array[i])
        }
        return result
    }
    func TimeStamp2Date(timeStamp:String) -> String {

        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp)!
        let date = NSDate(timeIntervalSince1970: timeInterval)
        
        //格式话输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy/MM/dd"
        return dformatter.string(from: date as Date)
    }
    func AnalyzeStorage(text:String) throws -> [[String]] {
        var result:[[String]] = [[String]] ()
        let temp:String = try getMiddleText(text,"[{\"","}]")
        var raw_bookinfo = "[{\"" + temp + "}]"
        var raw_borrowinfo = try getMiddleText(text,"{\"loanWorkMap\":",",\"holdingList");
        
        let data = raw_bookinfo.data(using: String.Encoding.utf8) //data  是json格式字符串
        let json = try? JSONSerialization.jsonObject(with: data!)
        
        for i in 0 ..< (json! as AnyObject).count{
            var temp=[String ](repeating:"",count: 6 )
            let temp_json =  ((json as! NSArray)[i] as! NSDictionary)
            
            temp[0]=temp_json["callno"]as! String
            temp[1]=temp_json["barcode"] as! String
            temp[2]=getState(text:String( temp_json["state"] as! Int))
            if(temp[2]=="借出"){
            temp[3]=TimeStamp2Date(timeStamp: getReturnDate(source: raw_borrowinfo,barcode: temp[1] ));
            }else{
            temp[3]=""
            }
            temp[4]=getOriginLib(text: temp_json["orglib"] as! String)
            temp[5]=getLocalMap(text: temp_json["orglocal"] as! String)
            
            result.append(temp)
            
            
        
        }
        return result
    }
    func xml_getSuoshuhao(raw:String,bookrecno:String) -> String {
        var xmldoc=SWXMLHash.parse(raw)
        var b=xmldoc["records"].children[0].children[0].element?.text
    
        for i in 0 ..< xmldoc["records"].children.count{
            if(xmldoc["records"].children[i].children[0].element?.text==bookrecno){
                return (xmldoc["records"].children[i].children[1].element?.text)!
            }
        
        }
        return ""
    }
    func AnalyzeSearch(text:String) throws -> [Book] {
        var result:[Book]=[Book]()
        var expression_all="<td class=\"bookmetaTD\" style=\"background-color([\\s\\S]*?)<div id=\"bookSimpleDetailDiv_"
        var expression_name="<a href=\"book/[\\s\\S]*?\\?globalSearchWay=[\\s\\S]*?\" id=\"title_[\\s\\S]*?\" target=\"_blank\">([\\S\\s]*?)</a>"
        let regex_all = try! NSRegularExpression(pattern: expression_all, options: NSRegularExpression.Options.caseInsensitive)
        let regex_name = try! NSRegularExpression(pattern: expression_name, options: NSRegularExpression.Options.caseInsensitive)
        var res_all = regex_all.matches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text.characters.count))
        
        
        var url_suoshuhao="http://interlib.sdust.edu.cn/opac/book/callnos?bookrecnos="
        
        for i in res_all{
            
            var text_all=(text as NSString).substring(with: i.rangeAt( 1))
            var res_name = regex_name.matches(in: text_all, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text_all.characters.count))
            var book_name=(text_all as NSString).substring(with: res_name[0].rangeAt( 1))
            book_name=book_name.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "")
            var temp_book=Book()
            temp_book.name=book_name
            temp_book.writer=try getMiddleText(text_all, "?searchWay=author&q=", "\" target=\"_blank\"> ")
            temp_book.publisher=try getMiddleText(text_all,  "?searchWay=publisher&q=", "\" target=\"_blank\"> ")
            temp_book.publishedday=try getMiddleText(text_all, "出版日期: ","</div>").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t",with: "")
            temp_book.bookrecno=try getMiddleText(text_all,  "express_bookrecno=\"", "\" express_isbn=")
            temp_book.ISBN=try getMiddleText(text_all, "express_isbn=\"", "\" express_bookmeta_").replacingOccurrences(of: "-", with: "")
             url_suoshuhao+=temp_book.bookrecno+",";
            result.append(temp_book)
            
        
        }
        
        var raw_suoshuhao=try mhttp.get(url_suoshuhao)
        
        for i in 0 ..< result.count{
            var temp_book=result[i]
            result[i].Suoshuhao=xml_getSuoshuhao(raw: raw_suoshuhao,bookrecno: temp_book.bookrecno)
        
        }
        return  result
    }
    func findBookByISBN(ISBN:String) throws-> [Book] {
        var text_web=try mhttp.get("http://interlib.sdust.edu.cn/opac/search?rows=100&hasholding=1&searchWay0=marc&q0=&logical0=AND&q=" + ISBN + "&searchWay=isbn&scWay=dim&searchSource=reader")
        var result=try AnalyzeSearch(text: text_web)
        return result
    }
    func findBookByName(Name:String) throws -> [Book] {
        var text_web=try mhttp.get("http://interlib.sdust.edu.cn/opac/search?rows=100&hasholding=1&searchWay0=marc&q0=&logical0=AND&q="+mhttp.urlencode(Name)+"&searchWay=title&searchSource=reader")
        var result=try AnalyzeSearch(text: text_web)
        return result
    }
    func getStorage(bookrecno:String) throws -> [[String]] {
        var text_web=try mhttp.get("http://interlib.sdust.edu.cn/opac/api/holding/"+bookrecno)
        var result=try AnalyzeStorage(text: text_web)
        return result
    }
}
