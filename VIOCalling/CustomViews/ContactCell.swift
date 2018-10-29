//
//  ContactCell.swift
//  VIOCalling
//
//  Created by Arun Kumar on 26/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgContact: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
