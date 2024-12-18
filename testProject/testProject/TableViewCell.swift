//
//  TableViewCell.swift
//  testProject
//
//  Created by TJ on 2024/12/18.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var phoneCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
