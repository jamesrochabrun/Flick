//
//  ViewController.swift
//  Flick
//
//  Created by James Rochabrun on 3/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit


class FeedVC: UICollectionViewController, UISearchBarDelegate {
    
    fileprivate var movies = [Movie]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.reloadData()
                self?.refreshControl.endRefreshing()
                self?.customIndicator.stopAnimating()
            }
        }
    }
    
    var shouldShowSearchResults = false
    var endpoint: String = ""
    let gridLayout = GridLayout()
    var isGrid = false
    var searchResults: [Movie] = []
    fileprivate let headerID = "headerID"
    var searchController: UISearchController!
    
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
    
    let customIndicator: CustomActivityIndicator = {
        let indicator = CustomActivityIndicator()
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationController?.hidesBarsOnSwipe = true
        collectionView?.backgroundColor = .white
        collectionView?.register(MovieCell.self)
        //collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.insertSubview(refreshControl, at: 0)
        segmentedControl.selectedSegmentIndex = 0
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        setUpViews()
        getMoviesData()
    }
    
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text {
//            self.filterContentFor(textToSearch: searchText)
//            self.collectionView?.reloadData()
//        }
//    }
    
    func filterContentFor(textToSearch: String) {
        self.searchResults = self.movies.filter({ (movie) -> Bool in
            let nameToFind = movie.title.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            //let typeToFind = place.type.range(of: textToSearch,  options: NSString.CompareOptions.caseInsensitive)
            //let locationToFind = place.location.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            
            return (nameToFind != nil) //|| (typeToFind != nil) || (locationToFind != nil)
        })
    }
    
    private func setUpViews() {
        view.addSubview(segmentedControl)
        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44).isActive = true
        
        collectionView?.addSubview(customIndicator)
        customIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            return self.searchResults.count
        } else {
            return movies.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MovieCell
        var movie: Movie?
        if shouldShowSearchResults{
            movie = self.searchResults[indexPath.row]
        } else {
            movie = self.movies[indexPath.row]
        }
        
        let movieViewModel = MovieViewModel(model: movie!)
        cell.displayMovieInCell(using: movieViewModel)
        return cell
    }
        
    func getMoviesData() {
        
        MovieService.sharedInstance.getNowPlayingMovies(with: endpoint) { [weak self] (result) in
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
    
    func changeLayout() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            self.collectionView?.collectionViewLayout.invalidateLayout()
            isGrid = false
            UIView.animate(withDuration: 0.2) { () -> Void in
                DispatchQueue.main.async {
                    self.collectionView?.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: true)
                }
            }
        } else {
            self.collectionView?.collectionViewLayout.invalidateLayout()
            isGrid = true
            UIView.animate(withDuration: 0.2) { () -> Void in
                DispatchQueue.main.async {
                    self.collectionView?.setCollectionViewLayout(self.gridLayout, animated: true)
                }
            }
        }
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        getMoviesData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movie = movies[indexPath.item]
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! Header
       // header.addSubview(searchController.searchBar)
        header.backgroundColor = .red
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize(width: 0, height: 0)
        
        if isGrid {
            size.width = ((self.collectionView?.frame.size.width)! / 3.0) - 0.5
            size.height = size.width
            print("grid")

        } else {
            
            let movie = movies[indexPath.item]
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





class Header: BaseCollectionviewCell {
    
    
    
    
    
    
    
    
    
    
}






