//
//  IMError.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/6/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import Foundation

enum IMError: String, Error {
  case unableToComplete = "Unable to complete your request for access to your photos. Please try again"
  case denied = "You do must allow allow the app permission to access your images"
  case notDetermined = "Unable to determine if app has access to your photos. Please try again"
  case restricted = "Access to photos is restricted"
  case dataNotFound = "Unable to find requested data"
  case pageIndexCannotBeZeroOrNegative = "Cannot ask for a zero or negative page index"
  case noMorePhotos = "There are no more photos in the library"
}
