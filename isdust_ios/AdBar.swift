//
//  AdBar.swift
//  isdust_ios
//
//  Created by wzq on 9/3/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class AdBar:UIView,UIScrollViewDelegate{
    var mScrollView:UIScrollView!
    var num_image:Int!
    var mUIImageView:[UIImageView]!
    var image_end:UIImageView!
    var mUIPageControl:UIPageControl!
    var page_current:Int=0
    var urls:[String]!
    var titles:[String]!
    var delegate:AdBarDelegate!
    init(frame: CGRect,num:Int) {
        super.init(frame: frame)
        mScrollView=UIScrollView()
        mScrollView.frame=CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        mScrollView.bounces=false
        mScrollView.isPagingEnabled=true
        mScrollView.showsVerticalScrollIndicator=false
        mScrollView.showsHorizontalScrollIndicator=false
        mScrollView.isScrollEnabled=true
        mScrollView.isUserInteractionEnabled=true
        mScrollView.alwaysBounceHorizontal=true
        mScrollView.backgroundColor=UIColor.white
        mScrollView.contentSize=CGSize.init(width: frame.size.width*CGFloat(num+1), height: frame.size.height)
        mScrollView.delegate=self
        mUIImageView=[UIImageView]()
        urls=[String]()
        titles=[String]()
        for i in 0..<num{
            mUIImageView.append(UIImageView.init(frame: frame))
            urls.append("")
            titles.append("")
            mUIImageView[i].frame=CGRect.init(x: frame.size.width*CGFloat(i), y: 0, width:frame.size.width , height: frame.size.height)
            mUIImageView[i].tag=i
            mUIImageView[i].contentMode = .scaleAspectFill
            mUIImageView[i].image=#imageLiteral(resourceName: "test1")
            mUIImageView[i].isUserInteractionEnabled=true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imageclick))

            mUIImageView[i].addGestureRecognizer(gesture)
            mScrollView.addSubview(mUIImageView[i])
        }
        
        image_end=UIImageView.init(image: mUIImageView[0].image)
        image_end.frame = CGRect.init(x: frame.size.width*CGFloat(num), y: 0, width:frame.size.width , height: frame.size.height)
        image_end.contentMode = .scaleAspectFill
        mScrollView.addSubview(image_end)
        //mScrollView.addSubview(mUIImageView[0])
        mUIPageControl=UIPageControl()
        mUIPageControl.numberOfPages=num
        mUIPageControl.sizeToFit()
        mUIPageControl.isUserInteractionEnabled=false
        mUIPageControl.frame.origin=CGPoint.init(x: (frame.size.width-mUIPageControl.frame.size.width)/2, y: frame.size.height-mUIPageControl.frame.size.height)
        
        self.addSubview(mScrollView)
        self.addSubview(mUIPageControl)
        num_image=num
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(AdBar.nextpage), userInfo: nil, repeats: true)

    }
    
//    func loadimage(imagea:[UIImage])  {
//        for i in 0..<imagea.count{
//        mUIImageView[i].image=imagea[i]
//        }
//    }
    func load(index:Int,imagea:UIImage,title:String,url:String) {
        mUIImageView[index].image=imagea
        titles[index]=title
        urls[index]=url
        if(index==0){
            image_end.image=imagea
            //mUIImageView[num_image].image=imagea
        }
    }
    func imageclick(_ sender:UITapGestureRecognizer) {
        //print(])
        delegate.AdImageClick(urla: urls[(sender.view?.tag)!],titlea: titles[(sender.view?.tag)!])
    }
    func nextpage()  {
        page_current=page_current+1
        if(page_current==num_image){
            UIView.animate(withDuration: 0.4, animations:
                {
                    self.mScrollView.bounds.origin.x=self.mScrollView.bounds.width*CGFloat(self.page_current)
                    self.mUIPageControl.currentPage=self.page_current
                    
                    
                }, completion:
                {
                    (finished: Bool) -> Void in
                    if(finished==true){
                        self.mScrollView.bounds.origin.x=0
                        self.page_current=0
                        self.mScrollView.bounds.origin.x=self.mScrollView.bounds.width*CGFloat(self.page_current)
                        self.mUIPageControl.currentPage=self.page_current
                    }
            })

            return
            
            
        }else{
            UIView.animate(withDuration: 0.4, animations:
                {
                self.mScrollView.bounds.origin.x=self.mScrollView.bounds.width*CGFloat(self.page_current)
                self.mUIPageControl.currentPage=self.page_current
                
                
                }, completion:
                {
                    (finished: Bool) -> Void in
                if(finished==true){
                    }
                })
        
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //print(1)
        page_current=Int(mScrollView.bounds.origin.x/mScrollView.bounds.width)
        if(page_current==num_image){
            self.mScrollView.bounds.origin.x=0
        
        }
        page_current=Int(mScrollView.bounds.origin.x/mScrollView.bounds.width)
        mUIPageControl.currentPage=page_current
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
public protocol AdBarDelegate{
    func AdImageClick(urla:String,titlea:String)
}
