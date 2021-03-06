//
//  IMButton.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

class Button: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(backgroundColor: UIColor, title: String) {
    self.init(frame: .zero)
    set(backgroundColor: backgroundColor, title: title)
  }
  
  func set(backgroundColor: UIColor, title: String) {
    self.backgroundColor = backgroundColor
    self.setTitle(title, for: .normal)
  }
  
  private func configure() {
    layer.cornerRadius = 10
    setTitleColor(.white, for: .normal)
    titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
}
