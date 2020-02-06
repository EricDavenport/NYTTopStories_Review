//
//  NewsFeedViewController.swift
//  NYTTopStories
//
//  Created by Eric Davenport on 2/6/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
  
  private var newsFeedView = NewsFeedView()
  
  override func loadView() {
    view = newsFeedView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // setting up collection view data source and delegate
    newsFeedView.collectionView.dataSource = self
    newsFeedView.collectionView.delegate = self
    
    // register the cell for collection view
    newsFeedView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "articleCell")
    
    view.backgroundColor = .systemBackground  // white when dark mode is off - black when dark mode on
  }
  
  
}


extension NewsFeedViewController : UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 50
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath)
    cell.backgroundColor = .white
    return cell
  }
  
 
}

extension NewsFeedViewController : UICollectionViewDelegateFlowLayout {
  // return item size
  // itemHeight ~ 30% of nheight devide
  // itemWidth ~ 100% of width of device
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let maxSize : CGSize = UIScreen.main.bounds.size
    let itemWidth: CGFloat = maxSize.width
    let itemHeight: CGFloat = maxSize.height * 0.30  // 30%
    return CGSize(width: itemWidth, height: itemHeight)
  }
}
