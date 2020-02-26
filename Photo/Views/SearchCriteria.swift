//
//  SearchCriteria.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/26/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

class SearchCriteria: UIView {
  
  var startDate: Date?
  var endDate: Date?
  var selectedYear = 0
  var selectedMonth = 0
  var selectedDay = 0
  
  let mainSegment = FloatingSegment(titles: ["All", "Search"])
  let yearSegment = FloatingSegment(frame: .zero)
  let monthSegment = FloatingSegment(titles: ["Jan", "Feb", "March", "April", "May", "June", "July",
                                              "August", "September", "October", "November", "December"])
  let daySegment = FloatingSegment(frame: .zero)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func changeDisplay( _ segment: FloatingSegment) {
  
    switch segment.selectedSegmentIndex {
    case 0:
      segment.removeAllSegments()
      segment.insertSegment(withTitle: "All", at: 0, animated: true)
      segment.insertSegment(withTitle: "Search", at: 1, animated: true)
      segment.selectedSegmentIndex = 0
    case 1:
      segment.removeAllSegments()
      segment.insertSegment(withTitle: "Back", at: 0, animated: true)
      segment.insertSegment(withTitle: "Year", at: 1, animated: true)
      segment.insertSegment(withTitle: "Month", at: 2, animated: true)
      segment.insertSegment(withTitle: "Day", at: 3, animated: true)
      segment.selectedSegmentIndex = 1
    default:
      segment.removeAllSegments()
      segment.insertSegment(withTitle: "All", at: 0, animated: true)
      segment.insertSegment(withTitle: "Search", at: 1, animated: true)
      segment.selectedSegmentIndex = 0
    }
  }
  
  private func configure() {
    backgroundColor = UIColor.clear
    translatesAutoresizingMaskIntoConstraints = false
    configureMainSegment()
  }
  
  private func configureMainSegment() {
    addSubview(mainSegment)
    mainSegment.addTarget(self, action: #selector(changeDisplay(_:)), for: .valueChanged)
    mainSegment.pinToEdges(of: self)
  }
  
}
