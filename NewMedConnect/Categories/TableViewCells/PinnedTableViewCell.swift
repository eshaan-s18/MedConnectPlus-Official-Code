//
//  PinnedTableViewCell.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 6/14/22.
//

import UIKit

class PinnedTableViewCell: UITableViewCell {

    @IBOutlet weak var pinnedTitle: UILabel!
    
    
    @IBOutlet weak var pinnedIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
