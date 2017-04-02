//
//  Blurrable.swift
//  TumblrFeed
//
//  Created by James Rochabrun on 3/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol Blurrable {}

extension Blurrable where Self: UIView {
    
    func blur(with style: UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.frame = self.bounds
        blurEffectView.clipsToBounds = true
        addSubview(blurEffectView)
    }
}


