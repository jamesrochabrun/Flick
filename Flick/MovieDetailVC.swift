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
                self.posterImageView.loadImageUsingCacheWithURLString(movieViewModel.posterPathBig, placeHolder: #imageLiteral(resourceName: "placeholder"), completion: { (bool) in
                    if bool {
                        self.posterImageView.alpha = 0
                        UIView.animate(withDuration: 0.8, animations: { [weak self] in
                            self?.posterImageView.alpha = 1
                            self?.scrollView.contentOffset = CGPoint(x: 0, y: 145)
                        })
                        self.customIndicator.stopAnimating()
                    }
                })
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










