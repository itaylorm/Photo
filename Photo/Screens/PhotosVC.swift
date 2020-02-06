//
//  PhotosVC.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

class PhotosVC: UIViewController {

    var collectionView: UICollectionView!
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    func configureViewController() {
        title = "Photos"
        view.backgroundColor = Colors.background
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
}
