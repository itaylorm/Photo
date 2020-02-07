//
//  DateTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/7/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
@testable import Photo

class DateTests: XCTestCase {

  func testDateCreateSuccess() {
    let now = Date()
    let assembled = Date.create(year: now.year(), month: now.month(), day: now.day())
    XCTAssertNotNil(assembled)
    XCTAssertTrue(now.isEqualTo(assembled!, true))
  }

  func testDateCreateInvalidDay() {
    let assembled = Date.create(year: 2020, month: 10, day: 32)
    XCTAssertNil(assembled)
  }
  
  func testDateCreateInvalidMonth() {
    let date = Date.create(year: 2020, month: 13, day: 01)
    XCTAssertNil(date)
  }
  
  func testDateCreateNegativeYear() {
    let date = Date.create(year: -1, month: 12, day: 01)
    XCTAssertNotNil(date)
  }
  
  func testDateInvalidLeapDay() {
    let date = Date.create(year: 2019, month: 02, day: 29)
    XCTAssertNil(date)
  }
  
}
