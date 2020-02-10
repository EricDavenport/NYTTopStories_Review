//
//  SavedArticleCell.swift
//  NYTTopStories
//
//  Created by Eric Davenport on 2/10/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

// step 1: custom delegate setup
protocol SavedArticleCellDelegate: AnyObject {
  func didSelectMoreButton(_ savedArticleCell: SavedArticleCell, article: Article)
}

class SavedArticleCell: UICollectionViewCell {
  
  // step 2: custom delegate setup
  weak var delegate: SavedArticleCellDelegate?
  // to keep track of the article selected
  private var currntArticle: Article!
  
  // more button
  // article title
  // news image
  public lazy var moreButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
    //   custom delegation
    button.addTarget(self, action: #selector(moreButtonPressed(_:)), for: .touchUpInside)
    return button
  }()
  
  public lazy var articleTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .title2)
    label.numberOfLines = 0
    label.text = "Article title"
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    moreButtonContraints()
    articleTitleConstraints()
  }
  
  @objc private func moreButtonPressed(_ sender: UIButton) {
    // step 3: custom delegate setup
    delegate?.didSelectMoreButton(self, article: currntArticle)
  }
  
  private func moreButtonContraints() {
    addSubview(moreButton)
    moreButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      moreButton.topAnchor.constraint(equalTo: topAnchor),
      moreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
      moreButton.heightAnchor.constraint(equalToConstant: 44),
      moreButton.widthAnchor.constraint(equalTo: moreButton.heightAnchor)
    ])
  }
  
  private func articleTitleConstraints() {
    addSubview(articleTitle)
    articleTitle.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      articleTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
      articleTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
      articleTitle.topAnchor.constraint(equalTo: moreButton.bottomAnchor),
      articleTitle.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  public func configureCell(for savedArticle: Article) {
    currntArticle = savedArticle    // associating the cell with its article
    articleTitle.text = savedArticle.title
    
  }
}
