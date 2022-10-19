//
//  ActivityTableViewCell.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 10/18/22.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationTitleLabel: UILabel!
    
    @IBOutlet weak var notificationDateLabel: UILabel!
    
    @IBOutlet weak var notificationBodyLabel: UILabel!
    
    @IBOutlet weak var disclosureIndicatorImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
