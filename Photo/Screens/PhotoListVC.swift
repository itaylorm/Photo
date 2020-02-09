//
//  PhotosVC.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit
import Photos
import CoreLocation

class PhotoListVC: DataLoadingVC {
  
  enum Section {
    case main
  }
  
  private var page = 1
  private var isLoadingMorePhotos = false
  private var hasMorePhotos = true
  
  var collectionView: UICollectionView!
  var photoViewModels = [PhotoViewModel]()
  var dataSource: UICollectionViewDiffableDataSource<Section, PhotoViewModel>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
    configureCollectionView()
    getPhotos()
    configureDataSource()
  }
  
  @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
    print("Swipe")
  }
  
  func getPhotos() {
    
    showLoadingView()
    isLoadingMorePhotos = true
    
    PhotoManager.shared.getPhotos(page: page) { [weak self] result in
      guard let self = self else { return }
      
      self.dismissLoadingView()
      
      switch result {
      case .success(let photoViewModels):
        self.updateData(on: photoViewModels)
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
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createColumnFlowLayout(in: view))
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
  
  func updateData(on images: [PhotoViewModel]) {
    //if images.count < PhotoManager.shared.itemCountPerPage { self.hasMorePhotos = false }
    
    self.photoViewModels.append(contentsOf: images)
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoViewModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(self.photoViewModels)
    
    DispatchQueue.main.async {
      self.dataSource.apply(snapshot, animatingDifferences: true)
    }
  }
}

extension PhotoListVC: UICollectionViewDelegate {
  
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
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let viewModel = photoViewModels[indexPath.row]
    
    let destinationVC = PhotoInfoVC()
    destinationVC.viewModels = photoViewModels
    destinationVC.currentIndex = indexPath.row
    destinationVC.currentViewModel = viewModel
    let navigationController = UINavigationController(rootViewController: destinationVC)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true)
    
  }
}
