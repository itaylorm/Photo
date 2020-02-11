//
//  CIImageMock.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/11/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import Photos

enum ImageKeys: String {
  case exif = "{Exif}"
  case tiff = "{TIFF}"
  case iptc = "{IPTC}"
}

class CIImageMock: CIImage {
  
  private var _properties: [String: Any] = [:]
  override var properties: [String: Any] { return _properties }
  
  static let dictionary: [String: Any?] = ["ColorModel": "RGB", "ProfileName": "sRGB IEC61966-2.1"]
  
  static let iphoneExifDictionary: [String: Any?] = ["LensModel": "iPhone XS Max back camera 4.25mm f/1.8",
                                        "FocalLength": "4.25",
                                        "FocalLenIn35mmFilm": 26,
                                        "ShutterSpeedValue": "5.321928",
                                        "ISOSpeedRatings": [400]]
  
  static let slrExifDictionary: [String: Any?] = ["LensModel": "EF24-105mm f/4L IS USM",
                                        "BodySerialNumber":"082024007376",
                                        "LensSerialNumber": "000011ed1e",
                                        "FocalLength": "4.25",
                                        "FocalLenIn35mmFilm": 28,
                                        "ShutterSpeedValue": "10.287712",
                                        "ISOSpeedRatings": [100]]
  
  static let iphoneTiffDictionary: [String: Any?] = ["Make": "Apple",
                                          "Model": "iPhone XS Max",
                                          "XResolution": 240,
                                          "YResolution": 240,
                                          "Software": "Adobe Photoshop Lightroom Classic 9.1 (Macintosh)"]
  
  static let slrTiffDictionary: [String: Any?] = ["Make": "Canon",
                                          "Model": "Canon EOS 5D Mark III",
                                          "XResolution": 240,
                                          "YResolution": 240,
                                          "Software": "Adobe Photoshop Lightroom Classic 9.1 (Macintosh)"]
  
  
  static let iptcDictionary: [String: Any?] = ["Keywords": ["Beach", "Florida", "Fort Meyers", "Location", "Nature", "United States"]]

  override init?(contentsOf url: URL) {
    super.init()
    for entry in CIImageMock.dictionary {
      _properties[entry.key] = entry.value
    }
    
    _properties["{ExifAux}"] = ""
    _properties["DPIWidth"] = ""
    _properties["DPIHeight"] = ""
    _properties["PixelWidth"] = ""
    _properties["PixelHeight"] = ""
    _properties["Depth"] = ""
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(dictionary: [String: Any?]) {
    for entry in dictionary {
      _properties[entry.key] = entry.value
    }
  }
}
