//
//  MovieDetailVC.swift
//  Flick
//
//  Created by James Rochabrun on 3/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailVC: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .clear
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let containerInfoView: ContainerInfoView = {
        let cv = ContainerInfoView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let mainContainer: BaseView = {
        let mv = BaseView()
        mv.backgroundColor = .clear
        return mv
    }()
    
    let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let customIndicator: CustomActivityIndicator = {
        let indicator = CustomActivityIndicator()
        return indicator
    }()
    
    var movie: Movie? {
        didSet {
            if let movie = movie {
                let movieViewModel = MovieViewModel(model: movie)
                containerInfoView.movie = movieViewModel
                self.posterImageView.loadImageUsingCacheWithURLString(movieViewModel.posterPathBig, placeHolder: #imageLiteral(resourceName: "placeholder"))
               // self.customIndicator.stopAnimating()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
    }

    func setUpViews() {
        
        view.addSubview(posterImageView)
        posterImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        posterImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        posterImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        posterImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(scrollView)
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        scrollView.addSubview(mainContainer)
        mainContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mainContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        mainContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        mainContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        scrollView.addSubview(containerInfoView)
        containerInfoView.topAnchor.constraint(equalTo: mainContainer.bottomAnchor).isActive = true
        containerInfoView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        containerInfoView.bottomAnchor.constraint(equalTo: containerInfoView.overviewLabel.bottomAnchor, constant: Constants.UI.generalPadding).isActive = true
        containerInfoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollView.bottomAnchor.constraint(equalTo: containerInfoView.bottomAnchor, constant: Constants.UI.generalPadding + 44).isActive = true
        
        posterImageView.addSubview(customIndicator)
        customIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

class ContainerInfoView: BaseView {
    
    var movie: MovieViewModel? {
        didSet {
            if let title = movie?.title , let overview = movie?.overview, let releaseDate = movie?.releaseDate {
                titleLabel.text = title
                overviewLabel.text = overview
                dateLabel.text = releaseDate
            }
            if let coverPath = movie?.coverPath {
                coverView.loadImageUsingCacheWithURLString(coverPath, placeHolder: nil)
            }
        }
    }
    
    let coverView: UIImageView = {
        let cv = UIImageView()
        cv.contentMode = .scaleAspectFill
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.blur(with: .light)
        cv.clipsToBounds = true
        cv.opaque(with: 0.3)
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




















