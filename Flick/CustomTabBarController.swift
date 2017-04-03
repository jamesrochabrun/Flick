//
//  CustomTabBarController.swift
//  Flick
//
//  Created by James Rochabrun on 3/31/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    //set up our custom VC's
    override func viewDidLoad() {
        self.tabBar.barTintColor = UIColor.hexStringToUIColor(Constants.Color.appMainColor)
        self.tabBar.tintColor = .white
        
        let layout = GridLayout()
        let feedVC = FeedVC(collectionViewLayout: layout)
        feedVC.endpoint = "https://api.themoviedb.org/3/movie/now_playing?api_key="
        let nowPlayingNavController  = UINavigationController(rootViewController: feedVC)
        nowPlayingNavController.tabBarItem.title = "Now Playing"
        nowPlayingNavController.tabBarItem.image = #imageLiteral(resourceName: "rocket")
        
        let topRatedVC = FeedVC(collectionViewLayout: layout)
        topRatedVC.endpoint = "https://api.themoviedb.org/3/movie/top_rated?api_key="
        let topRatedNavController  = UINavigationController(rootViewController: topRatedVC)
        topRatedNavController.tabBarItem.title = "Top Rated"
        topRatedNavController.tabBarItem.image = #imageLiteral(resourceName: "favorite")
        
        viewControllers = [nowPlayingNavController,topRatedNavController]
    }
    
    
//    private func dummyNavControllerWith(title: String, imageName: String) -> UINavigationController {
//        
//        let vc = UIViewController()
//        let navC = UINavigationController(rootViewController: vc)
//        navC.tabBarItem.title = title
//        navC.tabBarItem.image = UIImage(named: imageName)
//        return navC
//    }
}




