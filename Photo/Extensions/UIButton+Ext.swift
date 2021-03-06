//
//  UIButton+Ext.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/14/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

extension UIButton {
  
  func applyFloatingButtonStyling() {
    layer.backgroundColor = Colors.tint.cgColor
    layer.opacity = 0.75
    layer.cornerRadius = self.frame.height / 2
    layer.shadowOpacity = 0.25
    layer.shadowRadius = 5
    layer.shadowOffset = CGSize(width: 0, height: 10)
  }
}
