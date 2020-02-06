//
//  PhotosVC.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit
import Photos

class PhotosVC: DataLoadingVC {

    enum Section {
        case main
    }
    
    private var page = 1
    private var isLoadingMorePhotos = false
    private var hasMorePhotos = true
    
    var collectionView: UICollectionView!
    var photos = [PhotoViewModel]()
    var dataSource: UICollectionViewDiffableDataSource<Section, PhotoViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getPhotos()
        configureDataSource()
    }
    
    func getPhotos() {
        
        showLoadingView()
        isLoadingMorePhotos = true
        
        PhotoManager.shared.getPhotos(page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let photos):
                self.updateData(on: photos)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "OK")
            }
        }
        self.isLoadingMorePhotos = false
    }
    
    func configureViewController() {
        title = "Photos"
        view.backgroundColor = Colors.background
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createColumnFlowLayout(in: view, columns: 5))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID)
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, PhotoViewModel>(
            collectionView: collectionView, cellProvider: { (collectionView, indexPath, photoViewModel) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as? PhotoCell
            
            if let cell = cell {
                cell.set(photoViewModel: photoViewModel)
            }

            return cell
            
        })
    }
    
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
    
    func updateData(on images: [PhotoViewModel]) {
        if images.count < PhotoManager.shared.itemCountPerPage { self.hasMorePhotos = false }
        
        self.photos.append(contentsOf: images)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.photos)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }

    }
}

extension PhotosVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > (contentHeight - height) {
            guard !isLoadingMorePhotos, hasMorePhotos else { return }
            page += 1
            getPhotos()
        }
    }
}
