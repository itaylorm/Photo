//
//  IMButtonTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
@testable import Photo

class ButtonTests: XCTestCase {
  
  func testValidButtonCreated() {
    let backgroundColor = UIColor.red
    let title = "Special"
    let button = Button(backgroundColor: backgroundColor, title: title)
    
    XCTAssertEqual(button.title(for: .normal), title)
    XCTAssertEqual(button.backgroundColor, backgroundColor,
                   "Button backgroundColor is \(String(describing: button.backgroundColor)) expected: \(backgroundColor)")
    let expectedCornerRadius: CGFloat = 10.0
    XCTAssertEqual(button.layer.cornerRadius, expectedCornerRadius,
                   "Button corner radius is \(button.layer.cornerRadius) expected: \(expectedCornerRadius)")
    let titleColor = UIColor.white
    XCTAssertEqual(button.titleColor(for: .normal), titleColor,
                   "Button title color was \(String(describing: button.titleColor(for: .normal))) expected: \(titleColor)")
    let expectedFont = UIFont.preferredFont(forTextStyle: .headline)
    XCTAssertEqual(button.titleLabel?.font, expectedFont,
                   "Button title font was \(String(describing: button.titleLabel?.font)) expected: \(expectedFont)")
    XCTAssertFalse(button.translatesAutoresizingMaskIntoConstraints)
  }
  
}
