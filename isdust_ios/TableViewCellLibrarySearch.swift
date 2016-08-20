//
//  TableViewCellLibrarySearch.swift
//  isdust_ios
//
//  Created by wzq on 8/20/16.
//  Copyright © 2016 isdust. All rights reserved.
//

import UIKit

class TableViewCellLibrarySearch: UITableViewCell {

    @IBOutlet weak var texifield_name: UILabel!
    
    @IBOutlet weak var textfield_writer: UILabel!
    
    @IBOutlet weak var textfield_bookrecno: UILabel!
    
    @IBOutlet weak var textfield_suoshuhao: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
