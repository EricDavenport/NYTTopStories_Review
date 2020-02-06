//
//  TopStoriesTabController.swift
//  NYTTopStories
//
//  Created by Eric Davenport on 2/6/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

class TopStoriesTabController: UITabBarController {
  
  private lazy var newsFeedVC : NewsFeedViewController = {
    let viewController = NewsFeedViewController()
    viewController.tabBarItem = UITabBarItem(title: "News Feed", image: UIImage(systemName: "magnifyingglass.circle"), tag: 0)
    viewController.tabBarItem.selectedImage?.withTintColor(.red)
    viewController.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
    return viewController
  }()
  
  private lazy var savedArticlesVC : SavedArticleViewController = {
     let viewController = SavedArticleViewController()
     viewController.tabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "folder"), tag: 1)
    viewController.tabBarItem.selectedImage?.withTintColor(.green)
    viewController.tabBarItem.selectedImage = UIImage(systemName: "folder.fill")
     return viewController
   }()
  
  private lazy var settingVC : SettingsViewController = {
     let viewController = SettingsViewController()
     viewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
    viewController.tabBarItem.selectedImage?.withTintColor(.orange)
     return viewController
   }()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      viewControllers = [newsFeedVC, savedArticlesVC, settingVC]
      
    }
    



}
