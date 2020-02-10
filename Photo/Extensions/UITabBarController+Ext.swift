//
//  UITabBarController+Ext.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

extension UITabBarController {
  
  func createNC(viewController: UIViewController, title: String, image: UIImage?, tabPosition: Int) -> UINavigationController {
    guard !title.isEmpty, let image = image, tabPosition > -1 else {
      print("Unable to create view controller")
      return UINavigationController()
    }
    viewController.title = title
    viewController.tabBarItem = UITabBarItem(title: title, image: image, tag: tabPosition)
    return UINavigationController(rootViewController: viewController)
  }
  
}
