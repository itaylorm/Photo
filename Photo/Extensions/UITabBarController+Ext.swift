//
//  UITabBarController+Ext.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    func createNC(vc: UIViewController, title: String, image: UIImage?, tabPosition: Int) -> UINavigationController {
        guard title != "", let image = image, tabPosition > -1 else {
            return UINavigationController()
        }
        vc.title = title
        vc.tabBarItem = UITabBarItem(title: title, image: image, tag: tabPosition)
        return UINavigationController(rootViewController: vc)
    }
    
}
