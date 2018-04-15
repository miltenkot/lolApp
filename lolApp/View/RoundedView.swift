//
//  RoundedView.swift
//  lolApp
//
//  Created by Bartek Lanczyk on 15.04.2018.
//  Copyright © 2018 miltenkot. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    
    override func awakeFromNib() {
        setupView()
    }
    func setupView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    
}
