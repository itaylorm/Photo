//
//  ValueView.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/7/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

class ValueView: UIImageView {

  private var titleLabel: SecondaryTitleLabel!
  private var valueLabel: BodyLabel!

  private let padding: CGFloat = 10
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(title: String, value: String, fontSize: CGFloat) {
    self.init(frame: .zero)
    
    titleLabel = SecondaryTitleLabel(textAlignment: .left, fontSize: 20)
    titleLabel.text = title
    
    valueLabel = BodyLabel(textAlignment: .left)
    valueLabel.text = value
    addSubviews(titleLabel, valueLabel)
    
  }
  
  private func configure() {
    configureView()
  }
  
  private func configureView() {
    backgroundColor = Colors.background
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureTitlelabel() {
    titleLabel.sizeToFit()
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      titleLabel.heightAnchor.constraint(equalToConstant: 20)
    ])
  }

  func configureValuelabel() {
    valueLabel.sizeToFit()
    
    NSLayoutConstraint.activate([
      valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
      valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: padding),
      valueLabel.heightAnchor.constraint(equalToConstant: 20)
    ])
  }
  
}
