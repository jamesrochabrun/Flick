//
//  Reusable.swift
//  Flick
//
//  Created by James Rochabrun on 3/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

//protocols

protocol Reusable {}

extension Reusable where Self: UITableViewCell  {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension Reusable where Self: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//elements conforming the protocol
extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}

extension UITableView {
    
    func register<T: UITableViewCell>(_ :T.Type) where T: Reusable {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not deque cell with identifier")
        }
        return cell
    }
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ :T.Type) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not deque cell with identifier")
        }
        return cell
    }
}


