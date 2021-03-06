//
//  HorizontalMovieCell.swift
//  Flick
//
//  Created by James Rochabrun on 3/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class MovieCell: BaseCollectionviewCell {
    
    var listLayouConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var gridLayoutConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()

    let movieImageview: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let movieTitleLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        l.textAlignment = .left
        l.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return l
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    override func setupViews() {
        
        //GRID LAYOUT
        addSubview(movieImageview)
        let gml = movieImageview.leftAnchor.constraint(equalTo: leftAnchor)
        let gmt = movieImageview.topAnchor.constraint(equalTo: topAnchor)
        let gmw = movieImageview.widthAnchor.constraint(equalTo: widthAnchor)
        let gmh = movieImageview.heightAnchor.constraint(equalTo: heightAnchor)
        gridLayoutConstraints.append(contentsOf: [gml, gmt, gmw, gmh])
       // NSLayoutConstraint.activate(gridLayoutConstraints)
        
        //LIST LAYOUT
        let lm = movieImageview.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.UI.horizontalCellPadding)
        let tm = movieImageview.topAnchor.constraint(equalTo: topAnchor, constant: Constants.UI.horizontalCellPadding)
        let hm = movieImageview.heightAnchor.constraint(equalToConstant: Constants.UI.movieHeightHorizontalCell)
        let wm = movieImageview.widthAnchor.constraint(equalToConstant: Constants.UI.movieWidthHorizontalCell)
        
        addSubview(movieTitleLabel)
        movieTitleLabel.alpha = 0
        let mt = movieTitleLabel.topAnchor.constraint(equalTo: movieImageview.topAnchor)
        let ml = movieTitleLabel.leftAnchor.constraint(equalTo: movieImageview.rightAnchor, constant: Constants.UI.horizontalCellPadding)
        let mr = movieTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.UI.horizontalCellPadding)
        let mh = movieTitleLabel.heightAnchor.constraint(equalToConstant: 25)
        
        addSubview(messageTextView)
        messageTextView.alpha = 0
        let mtt = messageTextView.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: Constants.UI.horizontalCellPadding)
        let mtl = messageTextView.leftAnchor.constraint(equalTo: movieTitleLabel.leftAnchor)
        let mtb = messageTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        let mtr = messageTextView.rightAnchor.constraint(equalTo: movieTitleLabel.rightAnchor)
        
        listLayouConstraints.append(contentsOf: [lm, tm, hm, wm, mt, ml, mr, mh, mtt, mtl, mtb, mtr])
       // NSLayoutConstraint.activate(listLayouConstraints)
    }
    
    func displayMovieInCell(using viewModel: MovieViewModel) {
        
        movieImageview.loadImageUsingCacheWithURLString(viewModel.posterPathSmall, placeHolder: #imageLiteral(resourceName: "placeholder")) { (bool) in
            self.movieImageview.alpha = 0
            UIView.animate(withDuration: 0.8, animations: {
                self.movieImageview.alpha = 1
            })
        }
        movieTitleLabel.text = viewModel.title
        messageTextView.text = viewModel.overview
        DispatchQueue.main.async { [weak self] in
            self?.changeLayout(viewModel.isGrid)
        }
    }
    
    private func prepareCellForGrid() {
        
        NSLayoutConstraint.deactivate(self.listLayouConstraints)
        NSLayoutConstraint.activate(self.gridLayoutConstraints)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.movieTitleLabel.alpha = 0
            self?.messageTextView.alpha = 0
            self?.layoutIfNeeded()
        })
    }
    
    private func prepareCellForList() {
        
        NSLayoutConstraint.deactivate(self.gridLayoutConstraints)
        NSLayoutConstraint.activate(self.listLayouConstraints)
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.movieTitleLabel.alpha = 1
            self?.messageTextView.alpha = 1
            self?.layoutIfNeeded()
        })
    }
    
    private func changeLayout(_ gridLayout: Bool) {
        
        if gridLayout {
            prepareCellForGrid()
        } else {
            prepareCellForList()
        }
    }
    
    override func willTransition(from oldLayout: UICollectionViewLayout, to newLayout: UICollectionViewLayout) {
        
        if newLayout is GridLayout {
            prepareCellForGrid()
        } else {
            prepareCellForList()
        }
    }
}





