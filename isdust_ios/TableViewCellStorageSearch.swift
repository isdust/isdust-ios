//
//  TableViewCellStorageSearch.swift
//  isdust_ios
//
//  Created by wzq on 8/20/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class TableViewCellStorageSearch: UITableViewCell {
    
    @IBOutlet weak var textfield_suoshuhao: UILabel!
    
    @IBOutlet weak var textfield_bookrecno: UILabel!
    @IBOutlet weak var textfield_StorageLocation: UILabel!
    
    @IBOutlet weak var textfield_StorageCondition: UILabel!

    @IBOutlet weak var textfield_DueTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
