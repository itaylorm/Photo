//
//  FloatingSegment.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/25/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

class FloatingSegment: SegmentedControl {
  
  override func draw(_ rect: CGRect) {
    layer.backgroundColor = Colors.background.cgColor
    layer.cornerRadius = self.frame.height / 2
    layer.shadowOpacity = 0.25
    layer.shadowRadius = 5
    layer.shadowOffset = CGSize(width: 0, height: 10)
  }
}
