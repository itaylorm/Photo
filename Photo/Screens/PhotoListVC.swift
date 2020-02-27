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
  private var isSearching = false
  
  var collectionView: UICollectionView!
  var photos: [PhotoViewModel] = []
  var filteredPhotos: [PhotoViewModel] = []
  var dataSource: UICollectionViewDiffableDataSource<Section, PhotoViewModel>!
  
  var searchCriteria: SearchCriteria!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureCollectionView()
    getPhotos()
    configureDataSource()
    configureSearchCriteria()
  }
  
  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  private func getPhotos() {
    
    showLoadingView()
    isLoadingMorePhotos = true
    
    PhotoManager.shared.getPhotos(page: page) { [weak self] result in
      guard let self = self else { return }
      
      self.dismissLoadingView()
      
      switch result {
      case .success(let photoViewModels):
        self.photos.append(contentsOf: photoViewModels)
        self.updateData(on: self.photos)
      case .failure(let error):
        self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "OK")
      }
    }
    self.isLoadingMorePhotos = false
  }
  
  private func getPhotosFiltered() {
    guard let startDate = searchCriteria.startDate, let endDate = searchCriteria.endDate else {
      filteredPhotos.removeAll()
      updateData(on: photos)
      return
    }
    
    filteredPhotos = photos.filter { ($0.creationDate?.isBetween(startDate, and: endDate) ?? false)}
    updateData(on: filteredPhotos)
  }
  
  private func configureViewController() {
    view.backgroundColor = Colors.background
  }
  
  private func configureCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createColumnFlowLayout(in: view))
    view.addSubview(collectionView)
    collectionView.backgroundColor = .systemBackground
    collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID)
    collectionView.delegate = self
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])

  }
  
  private func configureSearchCriteria() {
    searchCriteria = SearchCriteria(delegate: self)
    view.addSubview(searchCriteria)
    
    NSLayoutConstraint.activate([
      searchCriteria.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      searchCriteria.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      searchCriteria.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
    ])
  }
  
  private func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, PhotoViewModel>(
      collectionView: collectionView, cellProvider: { (collectionView, indexPath, photoViewModel) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as? PhotoCell
        
        if let cell = cell {
          if photoViewModel.thumbNail == nil {
            photoViewModel.thumbNail = PhotoManager.shared.getPhoto(photoViewModel: photoViewModel, available: cell.bounds, photoType: .forList)
          }
          cell.set(photoViewModel: photoViewModel)
        }
        return cell
    })
  }
  
  private func updateData(on images: [PhotoViewModel]) {
    //if images.count < PhotoManager.shared.itemCountPerPage { self.hasMorePhotos = false }
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoViewModel>()
    snapshot.appendSections([.main])
    snapshot.appendItems(images)
    
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
    let destinationVC = PhotoInfoVC()
    destinationVC.viewModels = isSearching ? filteredPhotos : photos
    destinationVC.currentIndex = indexPath.row
    destinationVC.currentViewModel = isSearching ? filteredPhotos[indexPath.row] : photos[indexPath.row]
    destinationVC.modalPresentationStyle = .fullScreen
    present(destinationVC, animated: true)
  }
}

extension PhotoListVC: SearchCriterialDelegate {
  
  func didTapSearch() {
    isSearching = true
    getPhotosFiltered()
  }
  
  func didCancelSearch() {
    isSearching = false
    updateData(on: photos)
  }
  
}
