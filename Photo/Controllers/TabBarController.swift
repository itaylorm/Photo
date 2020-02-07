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
    
    func createPhotosNC() -> UINavigationController {
        return createNC(viewController: PhotoListVC(), title: TabBarNames.photos, image: Images.tabImagePhotos, tabPosition: TabBarIndexes.photos)
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
