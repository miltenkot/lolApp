//
//  RoundImageView.swift
//  uberApp
//
//  Created by Bartek Lanczyk on 06.03.2018.
//  Copyright © 2018 miltenkot. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {

    override func awakeFromNib() {
        setupView()
    }
    func setupView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.0
    }
 

}
