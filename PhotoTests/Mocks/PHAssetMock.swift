//
//  PHAssetMock.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/10/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import Photos

class PHAssetMock: PHAsset {
  private var _width: Int
  override var pixelWidth: Int { return _width }
  
  private var _height: Int
  override var pixelHeight: Int { return _height }
  
  private var _creationDate: Date?
  override var creationDate: Date? { return _creationDate }
  
  private var _isFavorite: Bool
  override var isFavorite: Bool { return _isFavorite }
  
  init(pixelWidth: Int, pixelHeight: Int, creationDate: Date?, isFavorite: Bool) {
    self._width = pixelWidth
    self._height = pixelHeight
    self._creationDate = creationDate
    self._isFavorite = isFavorite
  }
}
