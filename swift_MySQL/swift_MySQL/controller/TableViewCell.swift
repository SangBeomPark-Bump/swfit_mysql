//
//  TableViewCell.swift
//  swift_MySQL
//
//  Created by changbin an on 12/18/24.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblPhoneNum: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
