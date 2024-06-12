//
//  NoInternetView.swift
//  CustomeDataAPICalling
//
//  Created by Arpit iOS Dev. on 07/06/24.
//

import Foundation
import UIKit

class NoInternetView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
     func commonInit() {
        let bundle = Bundle(for: type(of: self))
                let nib = UINib(nibName: "NoInternetView", bundle: bundle)
                guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
                view.frame = self.bounds
                view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                addSubview(view)
    }
}
