//
//  ViewController.swift
//  Flick
//
//  Created by James Rochabrun on 3/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit


class FeedVC: UICollectionViewController {
    
    //MARK: Porperties
    fileprivate var movies = [Movie]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.reloadData()
                self?.refreshControl.endRefreshing()
                self?.customIndicator.stopAnimating()
            }
        }
    }
    
    fileprivate var searchActive : Bool = false
    var endpoint: String = ""
    fileprivate var isGrid = false
    fileprivate var searchResults: [Movie] = []
    fileprivate let headerID = "headerID"
    
    //MARK: UI elements
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.selectedSegmentIndex = 0
        sc.tintColor = UIColor.hexStringToUIColor(Constants.Color.appMainColor)
        sc.insertSegment(withTitle: "List", at: 0, animated: true)
        sc.insertSegment(withTitle: "Grid", at: 1, animated: true)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .white
        sc.addTarget(self, action: #selector(changeLayout), for: .valueChanged)
        return sc
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return rf
    }()
    
    private let customIndicator: CustomActivityIndicator = {
        let indicator = CustomActivityIndicator()
        return indicator
    }()
    
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
    
    private func setUpViews() {
        
        view.addSubview(segmentedControl)
        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        
        collectionView?.addSubview(customIndicator)
        customIndicator.heightAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
        customIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //MARK: App lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = searchBar
        collectionView?.backgroundColor = .white
        collectionView?.register(MovieCell.self)
        collectionView?.contentInset = UIEdgeInsets(top: 37, left: 0, bottom: 0, right: 0)
        collectionView?.insertSubview(refreshControl, at: 0)
        segmentedControl.selectedSegmentIndex = 0
        setUpViews()
        getMoviesData()
    }
    
    //MARK: Class handlers
    @objc private func refresh(_ refreshControl: UIRefreshControl) {
        getMoviesData()
    }
    
    @objc fileprivate func changeLayout() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            collectionView?.collectionViewLayout.invalidateLayout()
            isGrid = false
            UIView.animate(withDuration: 0.2) { () -> Void in
                DispatchQueue.main.async {
                    self.collectionView?.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: true)
                }
            }
        } else {            
            collectionView?.collectionViewLayout.invalidateLayout()
            isGrid = true
            UIView.animate(withDuration: 0.2) { () -> Void in
                DispatchQueue.main.async {
                    self.collectionView?.setCollectionViewLayout(GridLayout(), animated: true)
                }
            }
        }
    }
    
    private func getMoviesData() {
        
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
                DispatchQueue.main.async {
                    self?.showAlertWith(title: "Error", message: error.localizedDescription)
                    self?.customIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: collectionviewdelegate
extension FeedVC {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.endEditing(true)
        var movie: Movie?
        if searchActive {
            movie = self.searchResults[indexPath.row]
        } else {
            movie = self.movies[indexPath.row]
        }
        let movieDetailVC = MovieDetailVC()
        movieDetailVC.movie = movie
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

//MARK: Datasource
extension FeedVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchActive  {
            return self.searchResults.count
        } else {
            return movies.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MovieCell
        let movie = searchActive ? searchResults[indexPath.row] : movies[indexPath.row]
        var movieViewModel = MovieViewModel(model: movie)
        movieViewModel.isGrid = self.isGrid
        cell.displayMovieInCell(using: movieViewModel)
        return cell
    }
}

//MARK: uisearchbardelegate
extension FeedVC: UISearchBarDelegate {
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
        searchBar.endEditing(true)
        reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true;
        self.filterContentFor(textToSearch: searchText)
        
        if searchText != "" {
            searchActive = true
        } else {
            searchActive = false
        }
        reloadData()
    }
    
    func filterContentFor(textToSearch: String) {
        self.searchResults = self.movies.filter({ (movie) -> Bool in
            let nameToFind = movie.title.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            //let typeToFind = place.type.range(of: textToSearch,  options: NSString.CompareOptions.caseInsensitive)
            //let locationToFind = place.location.range(of: textToSearch, options: NSString.CompareOptions.caseInsensitive)
            
            return (nameToFind != nil) //|| (typeToFind != nil) || (locationToFind != nil)
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}

//MARK: Layout
extension FeedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize(width: 0, height: 0)
        if isGrid {
            size.width = ((self.collectionView?.frame.size.width)! / 3.0) - 0.5
            size.height = size.width
        } else {
            size = getHeightFromMoviein(indexPath)
        }
        return size
    }
    
    private func getHeightFromMoviein(_ indexPath: IndexPath) -> CGSize {
        
        var size = CGSize(width: 0, height: 0)
        var movie: Movie?
        if searchActive {
            movie = self.searchResults[indexPath.row]
        } else {
            movie = self.movies[indexPath.row]
        }
        
        if let item = movie {
            let estimatedHeightForOverview = estimatedHeightFor(text: item.overview)
            size.height = estimatedHeightForOverview + 100
            size.width = view.frame.width
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





