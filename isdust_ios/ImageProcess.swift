//
//  ImageProcess.swift
//  isdust_ios
//
//  Created by wzq on 7/24/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class ImageProcess{
    //var context:CGContext?
    var data:UnsafeMutablePointer<UInt8>=nil
    var rect:CGRect=CGRect()
    init(){
    }

    func loadimage(mimage: UIImage) {
        var inImage=mimage.CGImage
        
        var bitmapByteCount = 0
        var bitmapBytesPerRow = 0
        
        //Get image width, height
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        bitmapBytesPerRow = Int(pixelsWide) * 4
        bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(bitmapByteCount)
        data=UnsafeMutablePointer<UInt8>(malloc(bitmapByteCount))
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        
        //Clear the context
        CGContextClearRect(context, rect)
        
        // Draw the image to the bitmap context. Once we draw, the memory
        // allocated for the context for rendering will then contain the
        // raw image data in the specified color space.
        CGContextDrawImage(context, rect, inImage)
        
        // Now we can get a pointer to the image data associated with the bitmap
        // context.
        let mdata = CGBitmapContextGetData(context)
        let dataType = UnsafePointer<UInt8>(mdata)
        
        for(var i=0;i<pixelsHigh;i++){
            for(var j=0;j<pixelsWide;j++){
            let offset = 4*((Int(pixelsWide) * Int(i)) + Int(j))
                data[offset]=dataType[offset]
                data[offset+1]=dataType[offset+1]
                data[offset+2]=dataType[offset+2]
                data[offset+3]=dataType[offset+3]
            
            }
        }
        free(mdata)

        
        
        
    }
    func getPixelColorAtLocation(point:CGPoint) -> UIColor {
        let offset = 4*((Int(rect.width) * Int(point.y)) + Int(point.x))
        let alpha = data[offset]
        let red = data[offset+1]
        let green = data[offset+2]
        let blue = data[offset+3]
        let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)
        return color;
    }
    func binarize() {
        for(var i=0;i<Int(rect.height);i+=1){
            for(var j=0;j<Int(rect.width);j += 1){
                let offset = 4*((Int(rect.width) * Int(i)) + Int(j))
                let blue = data[offset+3]
                if(blue>50){
                    data[offset+0]=0xFF
                    data[offset+1]=0xFF
                    data[offset+2]=0xFF
                    data[offset+3]=0xFF
                }else{
                    data[offset+0]=0xFF
                    data[offset+1]=0x0
                    data[offset+2]=0x0
                    data[offset+3]=0x0
                }
                
                    }
                    
                }
    }
    func split(split_detail:[CGRect]) -> [ImageProcess] {
        var result:[ImageProcess]=[ImageProcess]()
        for(var i=0;i<split_detail.count;i++){
            
            var tmp_rect = CGRect(x:0, y:0, width:Int(split_detail[i].width), height:Int(split_detail[i].height))
            var bitmapBytesPerRow = Int(split_detail[i].width) * 4
            var bitmapByteCount = bitmapBytesPerRow * Int(split_detail[i].height)
            var temp_data=UnsafeMutablePointer<UInt8>(malloc(bitmapByteCount))
            for(var j=0;j<Int(split_detail[i].height);j++){
                for(var k=0;k<Int(split_detail[i].width);k++){
                    
                    let offset_temp = 4*((Int(split_detail[i].width) * Int(j)) + Int(k))
                    var offset1=Int(rect.width) * Int(j+Int(split_detail[i].origin.y))
                    offset1+=Int(k+Int(split_detail[i].origin.x))
                    offset1*=4
                    //var offset = 4*((Int(rect!.width) * Int(j+split_detail[i].maxX)) + Int(k+split_detail[i].maxY))
                    
                    temp_data[offset_temp]=data[offset1]
                    temp_data[offset_temp+1]=data[offset1+1]
                    temp_data[offset_temp+2]=data[offset1+2]
                    temp_data[offset_temp+3]=data[offset1+3]
                }
            
            }
            var temp=ImageProcess()
            temp.rect=tmp_rect
            temp.data=temp_data
            result.append(temp)
            
        
        }
        
        return result
    }
    func printbit() -> Void {
        for(var i=0;i<Int(rect.height);i++){
            for(var j=0;j<Int(rect.width);j++){
            let offset = 4*((Int(rect.width) * Int(i)) + Int(j))
                if(data[offset+3]>200){
                    print("1",terminator: "")
                }else{
                print("0",terminator: "")
            }
           
        
        }
             print("\n",terminator: "")
    }
    }
}