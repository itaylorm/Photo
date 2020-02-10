//
//  PHFetchResult+Ext.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/6/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import Photos

extension PHFetchResult {
  
  @objc func isEmpty() -> Bool {
    // swiftlint:disable empty_count
    return self.count == 0
    // swiftlint:enable empty_count
  }
}
