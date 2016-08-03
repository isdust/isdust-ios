//
//  TableViewSchoolCard.swift
//  isdust_ios
//
//  Created by wzq on 8/3/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import Foundation

class TableViewSchoolCard: UITableViewCell {
    @IBOutlet weak var label_type: UILabel!
    
    @IBOutlet weak var label_detail: UILabel!

    @IBOutlet weak var label_balance: UILabel!
    @IBOutlet weak var label_deposit: UILabel!
    @IBOutlet weak var label_time: UILabel!
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)!
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
