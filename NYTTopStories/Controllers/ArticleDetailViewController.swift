//
//  ArticleDetailViewController.swift
//  NYTTopStories
//
//  Created by Eric Davenport on 2/10/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import DataPersistence

class ArticleDetailViewController: UIViewController {
  
  // properties
  private var article: Article
  
  private var dataPersistence: DataPersistence<Article>
  
  private let detailView = ArticleDetailView()
  
  // initializer
  init(_ dataPersistence: DataPersistence<Article>, article: Article) {
    self.dataPersistence = dataPersistence
    self.article = article
    super.init(nibName: nil, bundle: nil)
  }
    
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = detailView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    updateUI()
    
    // adding a UIBarButtonItem to the right side to the navigation bar's title
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(saveArticleButtonPressed(_:)))
  }
  
  private func updateUI() {
    // TODO: refactor and setup in ArticleDetailView
    // e.g detailView.configureView(for article: article)

    navigationItem.title = article.title
    detailView.abstractHeadline.text = article.abstract
    detailView.newsImageView.getImage(with: article.getArticleImageURL(for: .superJumbo)) { [weak self] (result) in
      switch result {
      case .failure:
        DispatchQueue.main.async {
          self?.detailView.newsImageView.image = UIImage(systemName: "exclamationmark-octogon")
        }
      case .success(let image):
        DispatchQueue.main.async {
          self?.detailView.newsImageView.image = image
        }
      }
    }
  }
  
  @objc func saveArticleButtonPressed(_ sender: UIBarButtonItem) {
    navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bookmark.fill")
    do {
      // save to documents directory
      try dataPersistence.createItem(article)
    } catch {
      print("error saving article: \(error)")
    }
    
  }
  
}
