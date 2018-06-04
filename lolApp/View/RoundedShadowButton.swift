

import UIKit

class RoundedShadowButton: UIButton {

    var orginalSize : CGRect?
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        orginalSize = self.frame
        self.layer.cornerRadius = 5.0
        self.layer.shadowRadius = 10.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
    }
}
