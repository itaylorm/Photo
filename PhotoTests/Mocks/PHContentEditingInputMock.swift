//
//  PHContentEditingInputMock.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/11/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import Photos

class PHContentEditingInputMock: PHContentEditingInput {
  
  private var _fullSizeImageURL = URL(fileURLWithPath: "MOCKPATH")
  override var fullSizeImageURL: URL? { return _fullSizeImageURL }
  
}
