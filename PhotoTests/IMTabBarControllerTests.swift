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
        XCTAssert(tabBarController.tabBar.tintColor == Colors.tint)
        
        let expectedTabCount = 4
        XCTAssertEqual(tabBarController.children.count, expectedTabCount,
                       "TabBarController does all expected children with \(tabBarController.children.count) expected: \(expectedTabCount)")
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
        let navController = controller as? UINavigationController
        
        let expectedCount = 1
        XCTAssertEqual(navController?.viewControllers.count, expectedCount,
                       "\(title)NC has \(String(describing: navController?.viewControllers.count)) expected: \(expectedCount)")
        
        let childController = navController?.viewControllers[0]
        XCTAssertTrue(childController is T, "\(title)NC has a child controller that is not of the expected type: \(title)VC")
        let viewController = childController as? T
        XCTAssertEqual(viewController?.title, title)
        XCTAssertNotNil(viewController?.tabBarItem, "PhotosVC is not associated with the TabBarController")
        XCTAssertEqual(viewController?.tabBarItem.tag, tabPosition,
                       "\(title)VC is in position: \(String(describing: viewController?.tabBarItem.tag)) instead of expected: \(tabPosition)")
        XCTAssertEqual(viewController?.tabBarItem.image, image)
    }
    
}
