//
//  IMTitleLabelTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
@testable import Photo

class IMTitleLabelTests: XCTestCase {

    func testIMTitleLabelCreate() {
        
        let alignment = NSTextAlignment.center
        let fontSize: CGFloat = 26
        let titleLabel = IMTitleLabel(textAlignment: alignment, fontSize: fontSize)
        XCTAssertNotNil(titleLabel, "IMTitleLabel instance could not be created")
        XCTAssertEqual(titleLabel.textAlignment, alignment, "IMTitleLabel did not keep the passed text alignment")
        
        let expectedTextColor = UIColor.label
        XCTAssertEqual(titleLabel.textColor, expectedTextColor, "IMTitleLabel textColor property has changed from expected \(expectedTextColor.description)")
        XCTAssertTrue(titleLabel.adjustsFontSizeToFitWidth, "IMTitleLabel adjustsFontSizeToFitWidth is not true")
        
        let expectedMinimumScaleFactor: CGFloat = 0.90
        let actualMiniumScaleFactor: CGFloat = titleLabel.minimumScaleFactor
        XCTAssertTrue(abs(actualMiniumScaleFactor - expectedMinimumScaleFactor) < 0.01, "IMTitleLabel minimumScaleFactor is not set to \(expectedMinimumScaleFactor)")
        
        let expectedLineBreakMode = NSLineBreakMode.byTruncatingTail
        XCTAssertEqual(titleLabel.lineBreakMode, expectedLineBreakMode)
        XCTAssertFalse(titleLabel.translatesAutoresizingMaskIntoConstraints)
    }

}
