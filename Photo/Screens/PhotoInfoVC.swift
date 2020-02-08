//
//  PhotoInfoVC.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/7/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

class PhotoInfoVC: DataLoadingVC {
  
  let photoImageView = PhotoImageView(frame: .zero)
  var creationDateView = ValueView(frame: .zero)
  var creationTimeView = ValueView(frame: .zero)
  
  var viewModel: PhotoViewModel!
  
  let padding: CGFloat = 10
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configurePhotoView()
    configureCreationDateView()
    configureCreationTimeView()
    getPhotoInformation()
  }
  
  @objc func dismissVC() {
      dismiss(animated: true)
  }
  
  private func getPhotoInformation() {
  
    PhotoManager.shared.getPhotoInformation(viewModel: viewModel) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let viewModel):
        self.viewModel = viewModel
        print("Done")
      case .failure(let error):
        print(error.rawValue)
      }
    }
  }
  
  private func configureViewController() {
      view.backgroundColor = .systemBackground
      
      let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
      navigationItem.rightBarButtonItem = doneButton
  }
  
  private func configurePhotoView() {
    view.addSubviews(photoImageView)
    photoImageView.image = viewModel.thumbNail
    NSLayoutConstraint.activate([
      photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
      photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      photoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding)
    ])
  }
  
  private func configureCreationDateView() {
    view.addSubviews(creationDateView)
    creationDateView.title = "Date"
    creationDateView.value = viewModel.creationDate?.convertToDateFormat() ?? "Unknown"

    NSLayoutConstraint.activate([
      creationDateView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: padding),
      creationDateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      creationDateView.heightAnchor.constraint(equalToConstant: 30)
    ])
  }

  private func configureCreationTimeView() {
    view.addSubviews(creationTimeView)
    creationTimeView.title = "Time:"
    creationTimeView.value = viewModel.creationDate?.convertToTimeFormat() ?? "Unknown"

    NSLayoutConstraint.activate([
      creationTimeView.topAnchor.constraint(equalTo: creationDateView.bottomAnchor, constant: padding),
      creationTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      creationTimeView.heightAnchor.constraint(equalToConstant: 30)
    ])
  }
  
}
