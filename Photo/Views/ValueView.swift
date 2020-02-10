//
//  ValueView.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/7/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

class ValueView: UIView {
  
  private var stackView = UIStackView()
  private var titleLabel = SecondaryTitleLabel()
  private var valueLabel = BodyLabel()
  
  var title: String {
    get { return titleLabel.text ?? "" }
    set {
      titleLabel.text = newValue
      titleLabel.widthAnchor.constraint(equalToConstant: 65).isActive = true
    }
  }
  
  var titleFontSize: CGFloat {
    get { return titleLabel.font.pointSize }
    set { titleLabel.font = UIFont.systemFont(ofSize: newValue, weight: .medium) }
  }
  
  var value: String {
    get { return valueLabel.text ?? "" }
    set {
      valueLabel.text = newValue
      
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(title: String) {
    self.init(frame: .zero)
    self.title = title
  }
  
  override func sizeToFit() {
    titleLabel.sizeToFit()
    valueLabel.sizeToFit()
  }
  
  private func configure() {
    configureView()
    configureStackView(padding: 5)
  }
  
  private func configureView() {
    backgroundColor = Colors.background
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func configureStackView(padding: CGFloat) {
    addSubview(stackView)
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.spacing = 5.0
    stackView.addArrangedSubviews(titleLabel, valueLabel)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    
  }
  
}
