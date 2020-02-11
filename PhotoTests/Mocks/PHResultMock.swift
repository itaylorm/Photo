//
//  PHResultMock.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/10/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import Photos

class PHFetchResultMock: PHFetchResult<PHAsset> {
  
  private var items: [PHAsset]
  
  override var count: Int { return items.count }
  
  override func object(at index: Int) -> PHAsset {
    return items[index]
  }

  init(items: [PHAsset]) {
    self.items = items
  }
}
