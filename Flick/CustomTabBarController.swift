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
        
        let layout = UICollectionViewFlowLayout()
        let feedVC = FeedVC(collectionViewLayout: layout)
        let nowPlayingNavController  = UINavigationController(rootViewController: feedVC)
        nowPlayingNavController.tabBarItem.title = "Now Playing"
        //recentMesaggeNavController.tabBarItem.image = #imageLiteral(resourceName: "zoomIn")
        
//        let layout = UICollectionViewFlowLayout()
        let topRatedVC = TopRatedFeedVC(collectionViewLayout: layout)
        let topRatedNavController  = UINavigationController(rootViewController: topRatedVC)
        topRatedNavController.tabBarItem.title = "Top Rated"
        
        viewControllers = [nowPlayingNavController,topRatedNavController]
    }
    
    
    private func dummyNavControllerWith(title: String, imageName: String) -> UINavigationController {
        
        let vc = UIViewController()
        let navC = UINavigationController(rootViewController: vc)
        navC.tabBarItem.title = title
        navC.tabBarItem.image = UIImage(named: imageName)
        return navC
    }
}




