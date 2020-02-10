//
//  PhotoInfoVC.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/7/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit
import SpriteKit

class PhotoInfoVC: DataLoadingVC {
  
  let photoImageView = PhotoImageView(frame: .zero)
  var creationDateView = ValueView(frame: .zero)
  var creationTimeView = ValueView(frame: .zero)
  
  var viewModels: [PhotoViewModel]!
  var currentViewModel: PhotoViewModel!
  var currentIndex: Int = -1
  
  let padding: CGFloat = 10
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
    configurePhotoView()
    configureCreationDateView()
    configureCreationTimeView()
    getPhoto()
    getPhotoExtendedInformation()
  }
  
  @objc func dismissVC() {
      dismiss(animated: true)
  }
  
  private func getPhoto() {
    PhotoManager.shared.getPhoto(viewModel: currentViewModel)
    self.photoImageView.image = self.currentViewModel.image
    self.photoImageView.layoutIfNeeded()

    var newSize: CGSize = CGSize(width: 0, height: 0)
    
    if let image = self.currentViewModel.image {
      let size = image.size

      var widthRatio: CGFloat = 0
      var heightRatio: CGFloat = 0
      
      if size.height > size.width {
        widthRatio = photoImageView.bounds.width / size.width
        heightRatio = size.height * widthRatio
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
      } else {
        widthRatio = 1.0
        heightRatio = photoImageView.bounds.width / size.width
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
      }

      let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

      UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
      image.draw(in: rect)
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      self.photoImageView.image = newImage
    }

    photoImageView.frame = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    creationDateView.value = currentViewModel.creationDate?.convertToDateFormat() ?? "Unknown"
    creationTimeView.value = currentViewModel.creationDate?.convertToTimeFormat() ?? "Unknown"
  }
  
  private func getPhotoExtendedInformation() {
    PhotoManager.shared.getPhotoInformation(viewModel: currentViewModel) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let viewModel):
        self.currentViewModel = viewModel
      case .failure(let error):
        print(error.rawValue)
      }
    }
  }
  
  @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
    if sender.direction == .right && currentIndex > 0 { currentIndex -= 1 }
    if sender.direction == .left && currentIndex < (viewModels.count - 1) { currentIndex += 1 }
    
    currentViewModel = viewModels[currentIndex]
    getPhotoExtendedInformation()
    
    UIView.transition(with: photoImageView, duration: 0.3,
                      options: [.transitionCrossDissolve], animations: {
      self.getPhoto()
    }, completion: nil)
  }
  
  private func configureViewController() {
    view.backgroundColor = .systemBackground
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    navigationItem.rightBarButtonItem = doneButton
  }
  
  private func configurePhotoView() {
    view.addSubviews(photoImageView)
    photoImageView.image = PhotoManager.shared.getPhoto(viewModel: currentViewModel)
    photoImageView.isUserInteractionEnabled = true
    let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
    leftSwipe.direction = .left
    view.addGestureRecognizer(leftSwipe)

    let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
    rightSwipe.direction = .right
    view.addGestureRecognizer(rightSwipe)
    
    NSLayoutConstraint.activate([
      photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
      photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
    ])
  }
  
  private func configureCreationDateView() {
    view.addSubviews(creationDateView)
    creationDateView.title = "Date"

    NSLayoutConstraint.activate([
      creationDateView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: padding),
      creationDateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      creationDateView.heightAnchor.constraint(equalToConstant: 30)
    ])
  }

  private func configureCreationTimeView() {
    view.addSubviews(creationTimeView)
    creationTimeView.title = "Time:"

    NSLayoutConstraint.activate([
      creationTimeView.topAnchor.constraint(equalTo: creationDateView.bottomAnchor, constant: padding),
      creationTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      creationTimeView.heightAnchor.constraint(equalToConstant: 30)
    ])
  }
  
}
