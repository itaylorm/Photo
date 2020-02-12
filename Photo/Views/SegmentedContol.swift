//
//  SegmentedContol.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/12/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

class SegmentedControl: UISegmentedControl {

  override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  init(titles: [String]) {
      super.init(frame: .zero)

      var index = 0
      for title in titles {
          insertSegment(withTitle: title, at: index, animated: true)
          index += 1
      }

      if !titles.isEmpty { selectedSegmentIndex = 0}

      configure()
  }

  /// Setup custom settings
  private func configure() {
      translatesAutoresizingMaskIntoConstraints = false

      setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
      setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.label], for: .normal)
      backgroundColor = .systemGroupedBackground
      selectedSegmentTintColor = .systemGreen
  }
}
