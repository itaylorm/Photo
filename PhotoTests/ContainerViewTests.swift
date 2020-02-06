//
//  IMContainerViewTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
@testable import Photo

class ContainerViewTests: XCTestCase {

    func testValidContainerViewCreate() {
        let container = ContainerView()
        let backgroundColor = Colors.background
        
        XCTAssertEqual(container.backgroundColor, backgroundColor,
                       "ContainerView background color \(String(describing: container.backgroundColor)) expected: \(backgroundColor)")
        
        let expectedCornerRadius: CGFloat = 16.0
        XCTAssertEqual(container.layer.cornerRadius, expectedCornerRadius,
                       "Container corner radius is \(container.layer.cornerRadius) expected: \(expectedCornerRadius)")
        
        let expectedBorderWidth: CGFloat = 2
        XCTAssertEqual(container.layer.borderWidth, expectedBorderWidth,
                       "Container border width is \(container.layer.borderWidth) expected: \(expectedBorderWidth)")
        
        let expectedBorderColor = UIColor.white.cgColor
        XCTAssertEqual(container.layer.borderColor, expectedBorderColor,
                       "Container border color is \(String(describing: container.layer.borderColor)) expected: \(expectedBorderColor)")
        XCTAssertFalse(container.translatesAutoresizingMaskIntoConstraints)
    }

}
