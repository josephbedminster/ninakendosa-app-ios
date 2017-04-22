//
//  CommandeTableViewCell.swift
//  ninakendosa
//
//  Created by Tho Bequet on 21/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class CommandeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelCommande: UILabel!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var labelAdresse: UILabel!
    @IBOutlet weak var labelVille: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
