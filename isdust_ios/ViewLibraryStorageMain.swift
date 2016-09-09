//
//  File.swift
//  isdust_ios
//
//  Created by wzq on 8/17/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ViewLibraryStorageMain: UIViewController,QRCodeReaderViewControllerDelegate {
    var mlibrary=Library()
    
    var serialQueue:DispatchQueue!
    var thread_result:[Book]!
    var thread_ISBN:String!
    func thread_search_name(){

        do{
            thread_result=try mlibrary.findBookByName(Name: textfield_bookname.text!)
            performSelector(onMainThread: Selector("search"), with: nil, waitUntilDone: false)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
            
            
        }
        
    }
    func thread_search_isbn(){
        do{
            thread_result=try mlibrary.findBookByISBN(ISBN: thread_ISBN)
            performSelector(onMainThread: Selector("search"), with: nil, waitUntilDone: false)
        }
        catch IsdustError.Network{
            self.performSelector(onMainThread: Selector(("ErrorNetwork")), with: nil, waitUntilDone: false, modes: nil)
        }catch{
            
            
        }

        
    }
    override func performSelector(onMainThread aSelector: Selector, with arg: Any?, waitUntilDone wait: Bool) {
        DispatchQueue.main.async {
            switch(aSelector){
            case Selector("search"):
                SVProgressHUD.dismiss()
                if(self.thread_result.count==0){
                    let alert = UIAlertView()
                    alert.title = "图书馆-查询"
                    alert.message = "没有找到该书"
                    alert.addButton(withTitle: "确定")
                    alert.delegate=self
                    alert.show()
                    return
                }
                self.performSegue(withIdentifier: "LibrarySearchResult", sender: nil)
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
        }
    }
    
    @IBOutlet weak var textfield_bookname: UITextField!

    
    
    @IBAction func ImageSearchClicked(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        serialQueue.async(execute: thread_search_name)
        //print(temp)
        
        
    }
    @IBAction func ImageScanClicked(_ sender: AnyObject) {
        if QRCodeReader.supportsMetadataObjectTypes() {
            let reader = createReader()
            reader.modalPresentationStyle = .formSheet
            reader.delegate               = self
            
            reader.completionBlock = { (result: QRCodeReaderResult?) in
                if let result = result {
                    print("Completion with result: \(result.value) of type \(result.metadataType)")
                }
            }
            
            present(reader, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        
    }

    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
//        self.dismiss(animated: true) { [weak self] in
////            let alert = UIAlertController(
////                title: "QRCodeReader",
////                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
////                preferredStyle: .alert
////            )
////            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
////            
////            self?.present(alert, animated: true, completion: nil)
//
//            
//        }
        self.dismiss(animated: true, completion: nil)
        self.thread_ISBN=result.value
        SVProgressHUD.show()
        self.serialQueue.async(execute: self.thread_search_isbn)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func createReader() -> QRCodeReaderViewController {
        let builder = QRCodeViewControllerBuilder { builder in
            builder.reader          = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
            builder.showTorchButton = true
            builder.showCancelButton = true
        }
        
        return QRCodeReaderViewController(builder: builder)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="LibrarySearchResult"){
            let SchoolCardChangePassController=segue.destination as! TableViewControllerLibrarySearchResult
            SchoolCardChangePassController.result=self.thread_result
            //print(1)
        }
    }
    override func viewDidLoad() {
        navigationController?.navigationBar.tintColor=UIColor.white
        serialQueue = DispatchQueue(label: "queuename", attributes: [])
        
    }
}
