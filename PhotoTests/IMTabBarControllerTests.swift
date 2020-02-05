//
//  IMTabBarControllerTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
@testable import Photo

class IMTabBarControllerTests: XCTestCase {
    
    func testValidTabBarControllerCreated() {
        let tabBarController = IMTabBarController()
        XCTAssert(tabBarController.tabBar.tintColor == Colors.tintColor)
        
        let expectedTabCount = 4
        XCTAssertEqual(tabBarController.children.count, expectedTabCount, "TabBarController does not have the correct number of children with \(tabBarController.children.count) instead of \(expectedTabCount)")
    }

    func testTabBarControllerCreatedWithInvalidTintColor() {
        let tabBarController = IMTabBarController()
        XCTAssert(tabBarController.tabBar.tintColor != UIColor.systemRed, "TabBarController does not have the correct tint color")
    }
    
    func testPhotosNCCreated() {
        validateTab(vcType: PhotosVC(), title: TabBarNames.photos, image: Images.tabImagePhotos!, tabPosition: TabBarIndexes.photos)
    }
    
    func testAlbumsNCCreated() {
        validateTab(vcType: AlbumsVC(), title: TabBarNames.albums, image: Images.tabImageAlbums!, tabPosition: TabBarIndexes.albums)
    }
    
    func testLocationsNCCreated() {
        validateTab(vcType: LocationsVC(), title: TabBarNames.locations, image: Images.tabImageLocations!, tabPosition: TabBarIndexes.locations)
    }
    
    func testMemoriesNCCreated() {
        validateTab(vcType: MemoriesVC(), title: TabBarNames.memories, image: Images.tabImageMemories!, tabPosition: TabBarIndexes.memories)
    }
    
    private func validateTab<T: UIViewController>(vcType: T, title: String, image: UIImage, tabPosition: Int) {
        let tabBarController = IMTabBarController()
        let viewControllers = tabBarController.viewControllers
        XCTAssertNotNil(viewControllers, "The tab view controllers cannot be nil")
        
        XCTAssertTrue(viewControllers!.count > tabPosition, "The tab controller cannot have a tab position larger than the count")
        
        let controller = tabBarController.viewControllers![tabPosition]
        XCTAssertTrue(controller is UINavigationController)
        let nc = controller as! UINavigationController
        
        let expectedCount = 1
        XCTAssertEqual(nc.viewControllers.count, expectedCount, "\(title)NC has \(nc.viewControllers.count) view controllers instead of the expected: \(expectedCount)")
        
        let childController = nc.viewControllers[0]
        XCTAssertTrue(childController is T, "\(title)NC has a child controller that is not of the expected type: \(title)VC")
        let vc = childController as! T
        XCTAssertEqual(vc.title, title)
        XCTAssertNotNil(vc.tabBarItem, "PhotosVC is not associated with the TabBarController")
        XCTAssertEqual(vc.tabBarItem.tag, tabPosition, "\(title)VC is in position: \(vc.tabBarItem.tag) instead of expected: \(tabPosition)")
        XCTAssertEqual(vc.tabBarItem.image, image)
    }
    
}
