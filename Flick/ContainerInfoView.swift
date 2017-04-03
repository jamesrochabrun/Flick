//
//  ContainerInfoView.swift
//  Flick
//
//  Created by James Rochabrun on 4/2/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit


class ContainerInfoView: BaseView {
    
    var movie: MovieViewModel? {
        didSet {
            if let title = movie?.title , let overview = movie?.overview, let releaseDate = movie?.releaseDate {
                titleLabel.text = title
                overviewLabel.text = overview
                dateLabel.text = releaseDate
            }
            if let coverPath = movie?.coverPath {
                coverView.loadImageUsingCacheWithURLString(coverPath, placeHolder: #imageLiteral(resourceName: "placeholder"), completion: { (bool) in
                })
            }
        }
    }
    
    let coverView: UIImageView = {
        let cv = UIImageView()
        cv.contentMode = .scaleAspectFill
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.blur(with: .light)
        cv.clipsToBounds = true
        cv.opaque(with: 0.1)
        return cv
    }()
    
    let titleLabel: UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.numberOfLines = 0
        tl.textColor = .white
        tl.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        return tl
    }()
    
    let dateLabel: UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.textColor = .white
        tl.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        return tl
    }()
    
    let overviewLabel: UILabel = {
        let tl = UILabel()
        tl.translatesAutoresizingMaskIntoConstraints = false
        tl.numberOfLines = 0
        tl.textColor = .white
        tl.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        return tl
    }()
    
    override func setUpViews() {
        
        addSubview(coverView)
        coverView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        coverView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        coverView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        coverView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.UI.generalPadding).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.UI.generalPadding).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.UI.generalPadding).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.UI.generalPadding).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(overviewLabel)
        overviewLabel.sizeToFit()
        overviewLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        overviewLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.UI.generalPadding).isActive = true
        overviewLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        
    }
}










