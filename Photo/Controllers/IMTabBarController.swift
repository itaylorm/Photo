//
//  IMTabBarController.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

class IMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = Colors.tintColor
        self.viewControllers = [createPhotosNC(), createAlbumsNC(), createLocationsNC(), createMemoriesNC()]
    }
    
    func createPhotosNC() -> UINavigationController {
        return createNC(vc: PhotosVC(), title: TabBarNames.photos, image: Images.tabImagePhotos, tabPosition: TabBarIndexes.photos)
    }
    
    func createAlbumsNC() -> UINavigationController {
        return createNC(vc: AlbumsVC(), title: TabBarNames.albums, image: Images.tabImageAlbums, tabPosition: TabBarIndexes.albums)
    }
    
    func createLocationsNC() -> UINavigationController {
        return createNC(vc: LocationsVC(), title: TabBarNames.locations, image: Images.tabImageLocations, tabPosition: TabBarIndexes.locations)
    }
    
    func createMemoriesNC() -> UINavigationController {
        return createNC(vc: MemoriesVC(), title: TabBarNames.memories, image: Images.tabImageMemories, tabPosition: TabBarIndexes.memories)
    }
}
