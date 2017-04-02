//
//  ViewController.swift
//  Flick
//
//  Created by James Rochabrun on 3/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit

class FeedVC: UICollectionViewController {
    
    fileprivate let listDataSource = ListDataSource()
    //fileprivate let gridDataSource = GridDataSource()
    
    let gridLayout = GridLayout()
    var isGrid = false
    
    lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.selectedSegmentIndex = 0
        sc.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        sc.insertSegment(withTitle: "List", at: 0, animated: true)
        sc.insertSegment(withTitle: "Grid", at: 1, animated: true)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .white
        sc.addTarget(self, action: #selector(changeLayout), for: .valueChanged)
        return sc
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return rf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        collectionView?.register(HorizontalMovieCell.self)
        collectionView?.dataSource = listDataSource
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.insertSubview(refreshControl, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: NSNotification.Name.successDataNotification, object: nil)
        setUpViews()
    }
    
    private func setUpViews() {
        view.addSubview(segmentedControl)

        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
    }
    
    func reloadTable() {
        collectionView?.reloadData()
       // customIndicator.stopAnimating()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func changeLayout() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            self.collectionView?.collectionViewLayout.invalidateLayout()
            isGrid = false
            
            UIView.animate(withDuration: 0.2) { () -> Void in
                DispatchQueue.main.async {
                  //  self.collectionView?.delegate = self
                    self.collectionView?.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: true)
                  //  self.collectionView?.reloadData()
                }
            }
        } else {
            self.collectionView?.collectionViewLayout.invalidateLayout()
            isGrid = true
            UIView.animate(withDuration: 0.2) { () -> Void in
                DispatchQueue.main.async {
                    //self.collectionView?.delegate = nil
                    self.collectionView?.setCollectionViewLayout(self.gridLayout, animated: true)
                    //self.collectionView?.reloadData()

                }
            }
        }
    }

    
    func refresh(_ refreshControl: UIRefreshControl) {
       // getMoviesData()
        refreshControl
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movie = listDataSource.getMovies()[indexPath.item]
        let movieDetailVC = MovieDetailVC()
        movieDetailVC.movie = movie
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize(width: 0, height: 0)
        
        if isGrid {
            size.width = ((self.collectionView?.frame.size.width)! / 3.0) - 0.5
            size.height = size.width
            print("grid")

        } else {
            
            let movie = listDataSource.getMovies()[indexPath.item]
            let estimatedHeightForOverview = estimatedHeightFor(text: movie.overview)
            size.height = estimatedHeightForOverview + 100
            size.width = view.frame.width
            print("flow")
        }
        
        return size
    }
    
    private func estimatedHeightFor(text: String) -> CGFloat {
        
        //1 substract the subviews widths
        let approximateWidthOfBioTextView = view.frame.width  - Constants.UI.movieWidthHorizontalCell - (Constants.UI.horizontalCellPadding * 3)
        //2 here we put a big number for the height
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        //3 this attribute is the font that we set to the textview
        let attributes = [NSFontAttributeName:  UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)]
        //4 use this method
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return estimatedFrame.height
    }
}

class ListDataSource: NSObject, UICollectionViewDataSource {
    
    
    private var movies = [Movie]() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.successDataNotification, object: nil)
        }
    }
    
    override init() {
        super.init()
        getMoviesData()
    }
    
    func getMoviesData() {
        
        MovieService.sharedInstance.getNowPlayingMovies { [weak self] (result) in
            switch result {
            case .Success(let movies):
                var tempMovies = [Movie]()
                for movie in movies {
                    if let movie = movie {
                        tempMovies.append(movie)
                    }
                }
                self?.movies = tempMovies
            case .Error(let error):
                print(error)
            }
        }
    }
    
    func getMovies() -> [Movie] {
        return movies
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as HorizontalMovieCell
        let movie = movies[indexPath.item]
        let movieViewModel = MovieViewModel(model: movie)
        cell.displayMovieInCell(using: movieViewModel)
        return cell
    }
}

extension Notification.Name {
    static let successDataNotification = Notification.Name("dataSuccess")
    static let dismissViewNotification = Notification.Name("dismiss")
}


