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
  private var titleLabel = SecondaryTitleLabel()
  private var valueLabel = BodyLabel()
  
  var title: String {
    get { return titleLabel.text ?? "" }
    set { titleLabel.text = newValue }
  }
  
  var titleFontSize: CGFloat {
    get { return titleLabel.font.pointSize }
    set { titleLabel.font = UIFont.systemFont(ofSize: newValue, weight: .medium) }
  }
  
  var value: String {
    get { return valueLabel.text ?? "" }
    set { valueLabel.text = newValue }
  }
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    configureView()
    configureStackView(padding: 5)
    configureTitlelabel()
    configureValuelabel()
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
    
  }
  
  func configureTitlelabel() {
    stackView.addArrangedSubview(titleLabel)
    titleLabel.sizeToFit()
    NSLayoutConstraint.activate([
      titleLabel.widthAnchor.constraint(equalToConstant: 65)
    ])
  }

  func configureValuelabel() {
    stackView.addArrangedSubview(valueLabel)
    valueLabel.sizeToFit()
  }
  
}
