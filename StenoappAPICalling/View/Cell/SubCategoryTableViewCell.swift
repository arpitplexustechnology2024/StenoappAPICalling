//
//  SubCategoryTableViewCell.swift
//  StenoappAPICalling
//
//  Created by Arpit iOS Dev. on 12/06/24.
//

import UIKit

class SubCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var myView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myView.layer.borderWidth = 1
        myView.layer.borderColor = UIColor.customeRed.cgColor
        myView.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
