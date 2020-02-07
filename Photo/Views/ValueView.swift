//
//  ValueView.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/7/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

class ValueView: UIImageView {

  private var stackView = UIStackView()
  private var titleLabel: SecondaryTitleLabel!
  private var valueLabel: BodyLabel!
  
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
    configureStackView(padding: 5)
    
    configureTitlelabel()
    configureValuelabel()
    
  }
  
  private func configure() {
    configureView()
  }
  
  private func configureView() {
    backgroundColor = Colors.background
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func configureStackView(padding: CGFloat) {
    addSubview(stackView)
    stackView.axis = .horizontal
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        stackView.topAnchor.constraint(equalTo: topAnchor),
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])

    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(valueLabel)
  }
  
  func configureTitlelabel() {
    titleLabel.sizeToFit()
    NSLayoutConstraint.activate([
      titleLabel.widthAnchor.constraint(equalToConstant: 65)
    ])
  }

  func configureValuelabel() {
    valueLabel.sizeToFit()
  }
  
}
