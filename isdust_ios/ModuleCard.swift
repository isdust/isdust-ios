//
//  ModuleCard.swift
//  isdust_ios
//
//  Created by wzq on 9/7/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation
class ModuleCard:UIView{
    let cell_width:CGFloat=60
    let cell_height:CGFloat=70
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }
    func drawcell()  {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
protocol ModuleCardClick {
    func ModuleMneuChoose()
}
