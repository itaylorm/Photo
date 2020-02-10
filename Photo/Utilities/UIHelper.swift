//
//  UIHelper.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/6/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

enum UIHelper {
  
  static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
    
    let width = view.bounds.width
    let padding: CGFloat = 12
    let minimumItemSpacing: CGFloat = 10
    let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
    let itemWidth =  availableWidth / 3
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
    
    return flowLayout
  }
  
  static func createColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
    
    var columns: CGFloat
    
    if DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8Zoomed {
      columns = 3
    } else if DeviceTypes.isiPhone8PlusStandard || DeviceTypes.isiPhoneX || DeviceTypes.isiPhoneXsMaxAndXr {
      columns = 4
    } else if DeviceTypes.isiPad {
      columns = 6
    } else {
      columns = 4
    }
    
    let width = view.bounds.width
    let padding: CGFloat = 12
    let minimumItemSpacing: CGFloat = 10
    let spaces = columns - 1
    let availableSize = width - (padding * spaces) - (minimumItemSpacing * spaces)
    let itemSize =  (availableSize / columns)
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
    
    return flowLayout
  }
  
}
