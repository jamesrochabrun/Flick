//
//  GridLayout.swift
//  Flick
//
//  Created by James Rochabrun on 4/1/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    let innerSpace: CGFloat = 0.5
    let numberOfItemsInRow: CGFloat = 3
    
    override init() {
        super.init()
        minimumLineSpacing = innerSpace
        minimumInteritemSpacing = innerSpace
        scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func itemWidth() -> CGFloat {
        return ((self.collectionView?.frame.size.width)! / self.numberOfItemsInRow) - self.innerSpace
    }
    
    override var itemSize: CGSize {
        set {
        }
        get {
            return CGSize(width: itemWidth(), height: itemWidth())
        }
    }
}
