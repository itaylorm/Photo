//
//  IMTabBarController.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .secondarySystemBackground
        UITabBar.appearance().tintColor = Colors.tint
        self.viewControllers = [createPhotosNC(), createAlbumsNC(), createLocationsNC(), createMemoriesNC()]
    }
    
    func createPhotosNC() -> UIViewController {
      let viewController = PhotoListVC()
      viewController.title = title
      viewController.tabBarItem = UITabBarItem(title: TabBarNames.photos, image: Images.tabImagePhotos, tag: TabBarIndexes.photos)
      return viewController
    }
    
    func createAlbumsNC() -> UINavigationController {
        return createNC(viewController: AlbumsVC(), title: TabBarNames.albums, image: Images.tabImageAlbums, tabPosition: TabBarIndexes.albums)
    }
    
    func createLocationsNC() -> UINavigationController {
        return createNC(viewController: LocationsVC(), title: TabBarNames.locations, image: Images.tabImageLocations,
                        tabPosition: TabBarIndexes.locations)
    }
    
    func createMemoriesNC() -> UINavigationController {
        return createNC(viewController: MemoriesVC(), title: TabBarNames.memories, image: Images.tabImageMemories,
                        tabPosition: TabBarIndexes.memories)
    }
}
