//
//  Constants.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

enum Colors {
  static let background = UIColor.systemBackground
  static let tint = UIColor.systemBlue
}

enum Images {
  static let tabImagePhotos = UIImage(named: "photos")
  static let tabImageAlbums = UIImage(named: "albums")
  static let tabImageLocations = UIImage(named: "locations")
  static let tabImageMemories = UIImage(named: "memories")
}

enum TabBarNames {
  static let photos = "Photos"
  static let albums = "Albums"
  static let locations = "Locations"
  static let memories = "Memories"
}

enum TabBarIndexes {
  static let photos = 0
  static let albums = 1
  static let locations = 2
  static let memories = 3
}

enum ScreenSize {
  static let width        = UIScreen.main.bounds.size.width
  static let height       = UIScreen.main.bounds.size.height
  static let maxLength    = max(ScreenSize.width, ScreenSize.height)
  static let minLength    = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
  static let idiom                    = UIDevice.current.userInterfaceIdiom
  static let nativeScale              = UIScreen.main.nativeScale
  static let scale                    = UIScreen.main.scale
  
  static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
  static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
  static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
  static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
  static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
  static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
  static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
  static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0
  
  static func isiPhoneXAspectRatio() -> Bool {
    return isiPhoneX || isiPhoneXsMaxAndXr
  }
  
  enum ScreenSizes {
    static let iPhone11ProMaxandXsMaxPortrait = CGSize(width: 414, height: 896)
    static let iPhone11ProMaxandXsMaxLandscape = CGSize(width: 896, height: 414)
    static let iPhone11andXrPortrait = CGSize(width: 414, height: 896)
    static let iPhone11andXrLandscape = CGSize(width: 896, height: 414)
    static let iPhone11ProandXsandXPortrait = CGSize(width: 375, height: 812)
    static let iPhone11ProandXsandXLandscape = CGSize(width: 812, height: 375)
    static let iPhone8PlusPortrait = CGSize(width: 414, height: 736)
    static let iPhone8PlusLandscape = CGSize(width: 736, height: 414)
    static let iPhone8Portrait = CGSize(width: 375, height: 667)
    static let iPhone8Landscape = CGSize(width: 667, height: 375)
    static let iPhoneSEPortrait = CGSize(width: 320, height: 568)
    static let iPhoneSELandscape = CGSize(width: 568, height: 320)
  }

  enum ScreenScale {
    static let iPhone11ProMaxandXsMax: CGFloat = 3
      static let iPhone11andXr: CGFloat = 2
      static let iPhone11ProandXsandX: CGFloat = 3
      static let iPhone8Plus: CGFloat = 3
      static let iPhone8: CGFloat = 2
      static let iPhoneSE: CGFloat = 2
  }
}
