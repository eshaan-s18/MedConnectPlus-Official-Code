//
//  ConditionTableViewCell.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/14/22.
//

import UIKit

// MARK: - Condition TableView Cell
class ConditionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
        
    @IBOutlet weak var pinImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
