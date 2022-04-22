//
//  CustomUISlider.swift
//  Zesty
//
//  Created by ispha on 11/10/19.
//  Copyright © 2019 ispha. All rights reserved.
//

import Foundation
import UIKit
class CustomUISlider: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 2
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        //set your bounds here
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
}
