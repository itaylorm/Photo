//
//  IMBodyLabelTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
@testable import Photo

class IMBodyLabelTests: XCTestCase {

    func testIMBodyLabelCreate() {
        
        let alignment = NSTextAlignment.left
        let bodyLabel = IMBodyLabel(textAlignment: alignment)
        XCTAssertNotNil(bodyLabel, "IMBodyLabel instance could not be created")
        XCTAssertEqual(bodyLabel.textAlignment, alignment, "IMBodyLabel did not keep the passed text alignment")
        
        let expectedTextColor = UIColor.secondaryLabel
        XCTAssertEqual(bodyLabel.textColor, expectedTextColor, "IMBodyLabel textColor property has changed from expected \(expectedTextColor.description)")
        XCTAssertTrue(bodyLabel.adjustsFontSizeToFitWidth, "IMBodyLabel adjustsFontSizeToFitWidth is not true")
        
        let expectedMinimumScaleFactor: CGFloat = 0.75
        let actualMiniumScaleFactor: CGFloat = bodyLabel.minimumScaleFactor
        XCTAssertTrue(abs(actualMiniumScaleFactor - expectedMinimumScaleFactor) < 0.01, "IMBodyLabel minimumScaleFactor is not set to \(expectedMinimumScaleFactor)")
        
        let expectedLineBreakMode = NSLineBreakMode.byWordWrapping
        XCTAssertEqual(bodyLabel.lineBreakMode, expectedLineBreakMode)
        XCTAssertFalse(bodyLabel.translatesAutoresizingMaskIntoConstraints)
    }

}
