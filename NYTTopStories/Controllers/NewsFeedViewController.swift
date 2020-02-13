//
//  NewsFeedViewController.swift
//  NYTTopStories
//
//  Created by Eric Davenport on 2/6/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import DataPersistence

class NewsFeedViewController: UIViewController {
  
  private let newsFeedView = NewsFeedView()
  
  // step 2: setting up data persistence and its delegate
  // since we need an instance passed to the ArticleDetailViewController we declare a dataPersistence here
  private var dataPersistence: DataPersistence<Article>!
  
  // data for our collection view
  private var newsArticles = [Article]() {
    didSet {
      DispatchQueue.main.async {
        self.newsFeedView.collectionView.reloadData()
        self.navigationItem.title = (self.newsArticles.first?.section.capitalized ?? " ") + " News"
      }
    }
  }
  
  private var sectionName = "Technology" {
    didSet {
      queryAPI(for: sectionName)
    }
  }
  
  init(_ dataPersistence: DataPersistence<Article>) {
    self.dataPersistence = dataPersistence
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = newsFeedView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground // white when dark mode is off, black when dark mode is on
    
    // setting up collection datasource and delegate
    newsFeedView.collectionView.dataSource = self
    newsFeedView.collectionView.delegate = self
    
    // register a collection view cell
    newsFeedView.collectionView.register(NewsCell.self, forCellWithReuseIdentifier: "articleCell")
    
    newsFeedView.searchBar.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    fetchStories()
  }
  
  private func fetchStories(for section: String = "Technology") {
    // retrieve section name from UserDefaults
    if let thisSectionName = UserDefaults.standard.object(forKey: UserKey.newsSection) as? String {
      if thisSectionName != self.sectionName {
        // we are looking at a new section
        // make a new query
        queryAPI(for: thisSectionName)
      } else {
        queryAPI(for: self.sectionName)
      }
    } else {
      // use the default section name
      queryAPI(for: self.sectionName)
    }
  }
    
    private func queryAPI(for section: String) {
    NYTTopStoriesAPIClient.fetchTopStories(for: section) { [weak self] (result) in
      switch result {
      case .failure(let appError):
        print("error fetching stories: \(appError)")
      case .success(let articles):
        self?.newsArticles = articles
      }
    }
  }
}


extension NewsFeedViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return newsArticles.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as? NewsCell else {
      fatalError("could not downcast to NewsCell")
    }
    let article = newsArticles[indexPath.row]
    cell.configureCell(with: article)
    cell.backgroundColor = .systemBackground
    return cell
  }
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
  // return item size
  // itemHeight ~ 30% of height of device
  // itemWidth = 100% of width of device
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let maxSize: CGSize = UIScreen.main.bounds.size
    let itemWidth: CGFloat = maxSize.width
    let itemHeight: CGFloat = maxSize.height * 0.20 // 30%
    return CGSize(width: itemWidth, height: itemHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let article = newsArticles[indexPath.row]
    // using initializers as dependency injection mechanisms
    let articleDVC = ArticleDetailViewController(dataPersistence, article: article)
    
    // step 3: setting up data persistence and its delegate
    navigationController?.pushViewController(articleDVC, animated: true)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if newsFeedView.searchBar.isFirstResponder {
      newsFeedView.searchBar.resignFirstResponder()
    }
  }
  
}

extension NewsFeedViewController : UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard !searchText.isEmpty else {
      // if text is empty reload sall the articles
      fetchStories()
      return
    }
    // filter articles based on searchText
    newsArticles = newsArticles.filter {
      $0.title.lowercased().contains(searchText.lowercased()) }
    print(searchText)
    resignFirstResponder()
  }
}
