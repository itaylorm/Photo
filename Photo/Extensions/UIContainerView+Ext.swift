//
//  UIContainerView+Ext.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/10/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

extension UIStackView {
  
  func addArrangedSubviews(_ views: UIView ...) {
    for view in views { addArrangedSubview(view) }
  }
}
