//
//  IMContainerViewTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
@testable import Photo

class IMContainerViewTests: XCTestCase {

    func testIMContainerViewCreate() {
        let container = IMContainerView()
        let backgroundColor = UIColor.systemBackground
        
        XCTAssertEqual(container.backgroundColor, backgroundColor,
                       "IMContainerView background color \(String(describing: container.backgroundColor)) expected: \(backgroundColor)")
        
        let expectedCornerRadius: CGFloat = 16.0
        XCTAssertEqual(container.layer.cornerRadius, expectedCornerRadius,
                       "IMContainer corner radius is \(container.layer.cornerRadius) expected: \(expectedCornerRadius)")
        
        let expectedBorderWidth: CGFloat = 2
        XCTAssertEqual(container.layer.borderWidth, expectedBorderWidth,
                       "IMContainer border width is \(container.layer.borderWidth) expected: \(expectedBorderWidth)")
        
        let expectedBorderColor = UIColor.white.cgColor
        XCTAssertEqual(container.layer.borderColor, expectedBorderColor,
                       "IMContainer border color is \(String(describing: container.layer.borderColor)) expected: \(expectedBorderColor)")
        XCTAssertFalse(container.translatesAutoresizingMaskIntoConstraints)
    }

}
