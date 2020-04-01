//
//  SearchCriteria.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/26/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import Foundation
import UIKit

var displayedYears = [Int]()
var selectedYear = -1
var selectedMonth = -1
var selectedDay = -1
var currentYear = Date.year()
var startMonthIndex = 0

let mainSegment = FloatingSegment(titles: ["All", "Search"])
let yearSegment = FloatingSegment(frame: .zero)
let monthSegment = FloatingSegment(titles: ["Back"])
let daySegment = FloatingSegment(frame: .zero)

protocol SearchCriterialDelegate: class {
  func didTapSearch()
  func didCancelSearch()
}

class SearchCriteria: UIView {
  
  weak var delegate: SearchCriterialDelegate!
  
  var startDate: Date? {
    if selectedYear != -1 {
      let calendar = Calendar.current
      let month = selectedMonth == -1 ? 1 : selectedMonth
      let day = selectedDay == -1 ? 1 : selectedDay
      let components = DateComponents(calendar: calendar, year: selectedYear, month: month, day: day)
      return components.date
    } else {
      return nil
    }
  }
  
  var endDate: Date? {
    if selectedYear != -1 {
      let calendar = Calendar.current
      let current = Date()
      selectedYear = selectedYear == 0 ? Date().year() : selectedYear
      let month = selectedMonth == -1 ? 12 : selectedMonth
      var components = DateComponents(calendar: calendar, year: selectedYear, month: month)
      let selectedYearMonth = components.date ?? current
      let endOfMonthDay = selectedDay == -1 ? selectedYearMonth.endOfMonth() : selectedDay
      components.day = endOfMonthDay
      return components.date
    } else {
      return nil
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(delegate: SearchCriterialDelegate) {
    self.init(frame: .zero)
    self.delegate = delegate
  }
  
  @objc func mainChange( _ mainSegment: FloatingSegment) {
  
    switch mainSegment.selectedSegmentIndex {
    case 0:
      print("Search All")
    case 1:
      if yearSegment.numberOfSegments <= 0 {
        displayYears(Date().year(), 5)
      }
      mainSegment.isHidden = true
      yearSegment.isHidden = false
    default:
      mainSegment.isHidden = false
      yearSegment.isHidden = true
    }
  }
  
  func displayYears(_ end: Int, _ increment: Int) {
    let start = end - increment
    let range = start < end ? [Int](start...end).reversed() : [Int](end...start).reversed()
    yearSegment.removeAllSegments()
    yearSegment.insertSegment(withTitle: "Back", at: 0, animated: true)
    var index = 1
    range.forEach { year in
      yearSegment.insertSegment(withTitle: String(year), at: index, animated: true)
      index += 1
    }
    yearSegment.insertSegment(withTitle: "...", at: 7, animated: true)
    
  }
  
  func displayMonths(_ increment: Int) {
    let months = Date.months()
    var end = startMonthIndex + increment
    if end > 11 { end = 11 }
    let range = [Int](startMonthIndex...end)
    startMonthIndex = end
    monthSegment.removeAllSegments()
    monthSegment.insertSegment(withTitle: "Back", at: 0, animated: true)
    
    var index = 1
    range.forEach { month in
      monthSegment.insertSegment(withTitle: months[month], at: index, animated: true)
      index += 1
    }
    monthSegment.insertSegment(withTitle: "...", at: 8, animated: true)
  }
  
  @objc func yearChange( _ segment: FloatingSegment) {
    
    if segment.selectedSegmentIndex == 0 {
      if let yearString = segment.titleForSegment(at: 1),
        let year = Int(yearString), year != Date().year() {
        displayYears(year, -5)
      } else {
        segment.isHidden = true
        mainSegment.isHidden = false
        mainSegment.selectedSegmentIndex = 0
        delegate.didCancelSearch()
      }
    } else if segment.selectedSegmentIndex == 7 {
      if let yearString = segment.titleForSegment(at: 6),
        let year = Int(yearString) {
        displayYears(year, 5)
      } else {
        displayYears(currentYear, 5)
      }
    } else {
      
      if let yearString = segment.titleForSegment(at: segment.selectedSegmentIndex),
        let year = Int(yearString) {
        selectedYear = year
      } else {
        selectedYear = currentYear
      }
      
      startMonthIndex = 0
      displayMonths(6)
      yearSegment.isHidden = true
      monthSegment.isHidden = false
      
      delegate.didTapSearch()
      
    }
  }
  
  @objc func monthChange( _ segment: FloatingSegment) {
    if segment.selectedSegmentIndex == 0 {
      if startMonthIndex == 11 {
        startMonthIndex = 0
        displayMonths(6)
      } else {
        segment.isHidden = true
        yearSegment.isHidden = false
        monthSegment.isHidden = true
      }

    } else if segment.selectedSegmentIndex == 8 {
      if startMonthIndex >= 8 {
        startMonthIndex = 0
      }
      displayMonths(6)
    } else {
      if let monthName = segment.titleForSegment(at: segment.selectedSegmentIndex), let position = Date.months().firstIndex(of: monthName) {
        selectedMonth = position + 1
        delegate.didTapSearch()
      }
      
    }
  }
  
  @objc func dayChange( _ segment: FloatingSegment) {
  }
  
  private func configure() {
    backgroundColor = UIColor.clear
    translatesAutoresizingMaskIntoConstraints = false
    
    configureMainSegment()
    configureYearSegment()
    configureMonthSegment()
    configureDaySegment()
  }
  
  private func configureMainSegment() {
    addSubview(mainSegment)
    mainSegment.addTarget(self, action: #selector(mainChange(_:)), for: .valueChanged)
    mainSegment.pinToEdges(of: self)
  }
  
  private func configureYearSegment() {
    addSubview(yearSegment)
    yearSegment.addTarget(self, action: #selector(yearChange(_:)), for: .valueChanged)
    yearSegment.pinToEdges(of: self)
    yearSegment.isHidden = true
  }
  
  private func configureMonthSegment() {
    addSubview(monthSegment)
    monthSegment.addTarget(self, action: #selector(monthChange(_:)), for: .valueChanged)
    monthSegment.pinToEdges(of: self)
    monthSegment.isHidden = true
  }
  
  private func configureDaySegment() {
    addSubview(daySegment)
    daySegment.addTarget(self, action: #selector(dayChange(_:)), for: .valueChanged)
    daySegment.pinToEdges(of: self)
    daySegment.isHidden = true
  }
}
