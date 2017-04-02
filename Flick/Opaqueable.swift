//
//  Opaqueable.swift
//  TumblrFeed
//
//  Created by James Rochabrun on 3/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol Opaqueable {}

extension Opaqueable where Self: UIView {
    
    func opaque(with alpha: CGFloat) {
        let overlay = UIView()
        overlay.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        overlay.alpha = alpha
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.frame = self.bounds
        self.addSubview(overlay)
    }
}

extension UIView: Opaqueable, Blurrable {}


