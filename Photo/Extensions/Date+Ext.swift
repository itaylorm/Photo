//
//  Date+Ext.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import Foundation

/// Ideas for these functions taken from the following
/// https://stackoverflow.com/questions/39018335/swift-3-comparing-date-objects
/// https://www.youtube.com/watch?v=GPtVfSC35T8
extension Date {
  
  static func create(year: Int, month: Int, day: Int) -> Date? {
    guard (1...12).contains(month) else { return nil }
    guard isValidDayForMonth(day: day, month: month, year: year) else { return nil }
    
    let calendar = Calendar.current
    let dateComponents = DateComponents(calendar: calendar, year: year, month: month, day: day)
    return calendar.date(from: dateComponents)
  }

  static func createWithTime(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date? {
    let calendar = Calendar.current
    let dateComponents = DateComponents(calendar: calendar, year: year, month: month, day: day, hour: hour, minute: minute, second: second)
    return calendar.date(from: dateComponents)
  }
  
  static func isValidDayForMonth(day: Int, month: Int, year: Int) -> Bool {
    if [4, 6, 9, 11].contains(month) && day < 31 { return true }
    if [1, 3, 5, 7, 8, 10, 12].contains(month) && day < 32 { return true}
    if month == 2 && (day < 29) || (isLeapYear(year) && day == 29) { return true }
    return false
  }
  
  static func isLeapYear(_ year: Int) -> Bool {
      return ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
  }
  
  static func convertPhotoDateToDate(_ dateString: String ) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    return dateFormatter.date(from: dateString)
  }
  
  func convertToString() -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.timeZone = .current
      return dateFormatter.string(from: self)
  }
  
  func convertToDateFormat() -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM dd yyyy"
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.timeZone = .current
      return dateFormatter.string(from: self)
  }
  
  func convertToTimeFormat() -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "H:mm:ss a zzz"
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.timeZone = .current
      return dateFormatter.string(from: self)
  }
  
  func convertToMonthYearFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM yyyy"
    return dateFormatter.string(from: self)
  }
  
  func dayOfWeek() -> Int {
    let calendar = Calendar.current
    return calendar.component(.weekday, from: self)
  }
  
  func day() -> Int {
    let calendar = Calendar.current
    return calendar.component(.day, from: self)
  }
  
  func month() -> Int {
    let calendar = Calendar.current
    return calendar.component(.month, from: self)
  }
  
  func year() -> Int {
    let calendar = Calendar.current
    return calendar.component(.year, from: self)
  }
  
  func hour() -> Int {
    let calendar = Calendar.current
    return calendar.component(.hour, from: self)
  }
  
  func minute() -> Int {
    let calendar = Calendar.current
    return calendar.component(.minute, from: self)
  }
  
  func second() -> Int {
    let calendar = Calendar.current
    return calendar.component(.second, from: self)
  }
  
  func nanosecond() -> Int {
    let calendar = Calendar.current
    return calendar.component(.nanosecond, from: self)
  }
  
  func startOfDay() -> Date? {
    let calendar = Calendar.current
    return calendar.dateInterval(of: .day, for: self)?.start
  }
  
  func endOfDay() -> Date? {
    let calendar = Calendar.current
    return calendar.dateInterval(of: .day, for: self)?.end
  }
  
  func startOfMonth() -> Date? {
    let calendar = Calendar.current
    return calendar.dateInterval(of: .month, for: self)?.start
  }
  
  func endOfMonth() -> Date? {
    let calendar = Calendar.current
    return calendar.dateInterval(of: .month, for: self)?.end
  }
  
  func addMinutes(_ minutes: Int) -> Date? {
    let calendar = Calendar.current
    return calendar.date(bySetting: .minute, value: minutes, of: self)
  }
  
  func addHours(_ hours: Int) -> Date? {
    let calendar = Calendar.current
    return calendar.date(bySetting: .hour, value: hours, of: self)
  }
  
  func addDays(_ days: Int) -> Date? {
    let calendar = Calendar.current
    return calendar.date(bySetting: .day, value: days, of: self)
  }
  
  func addMonths(_ months: Int) -> Date? {
    let calendar = Calendar.current
    return calendar.date(bySetting: .month, value: months, of: self)
  }
  
  func addYears(_ years: Int) -> Date? {
    let calendar = Calendar.current
    return calendar.date(bySetting: .year, value: years, of: self)
  }
  
  func isEqualTo(_ date: Date, _ ignoreTime: Bool = false) -> Bool {
    if ignoreTime {
      let order = Calendar.current.compare(self, to: date, toGranularity: .day)
      return order == ComparisonResult.orderedSame
    }
    return self == date
  }

  func isGreaterThan(_ date: Date, _ ignoreTime: Bool = false) -> Bool {
    if ignoreTime {
      let order = Calendar.current.compare(self, to: date, toGranularity: .day)
      return order == ComparisonResult.orderedDescending
    }
     return self > date
  }

  func isSmallerThan(_ date: Date, _ ignoreTime: Bool = false) -> Bool {
    if ignoreTime {
      let order = Calendar.current.compare(self, to: date, toGranularity: .day)
      return order == ComparisonResult.orderedAscending
    }
     return self < date
  }
  
  func isBetween(_ date1: Date, and date2: Date) -> Bool {
    return (min(date1, date2) ... max(date1, date2)).contains(self)
  }
}
