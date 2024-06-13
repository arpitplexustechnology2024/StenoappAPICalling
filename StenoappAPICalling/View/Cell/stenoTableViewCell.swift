//
//  stenoTableViewCell.swift
//  StenoAPICalling
//
//  Created by Arpit iOS Dev. on 10/06/24.
//

import UIKit

class stenoTableViewCell: UITableViewCell {
    
    // All View Outlet
    
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var extPathView: UIView!
    @IBOutlet weak var extPath1View: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        idView.layer.borderWidth = 1
        nameView.layer.borderWidth = 1
        extPathView.layer.borderWidth = 1
        extPath1View.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
