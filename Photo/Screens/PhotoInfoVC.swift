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
  var creationDateView: ValueView!
  var creationTimeView: ValueView!
  
  var viewModel: PhotoViewModel!
  
  let padding: CGFloat = 10
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configurePhotoView()
    configureCreationDateView()
    configureCreationTimeView()
  }
  
  @objc func dismissVC() {
      dismiss(animated: true)
  }
  
  func configureViewController() {
      view.backgroundColor = .systemBackground
      
      let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
      navigationItem.rightBarButtonItem = doneButton
  }
  
  func configurePhotoView() {
    view.addSubviews(photoImageView)
    photoImageView.image = viewModel.image

    NSLayoutConstraint.activate([
      photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
      photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      photoImageView.heightAnchor.constraint(equalToConstant: 400)
    ])

  }
  
  func configureCreationDateView() {
    let title = "Date:"
    let value = viewModel.creationDate?.convertToDateFormat() ?? "Unknown"
    creationDateView = ValueView(title: title, value: value, fontSize: 20)
    view.addSubviews(creationDateView)

    NSLayoutConstraint.activate([
      creationDateView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: padding),
      creationDateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      creationDateView.heightAnchor.constraint(equalToConstant: 20)
    ])
  }

  func configureCreationTimeView() {
    let title = "Time:"
    let value = viewModel.creationDate?.convertToTimeFormat() ?? "Unknown"
    creationTimeView = ValueView(title: title, value: value, fontSize: 20)
    view.addSubviews(creationTimeView)

    NSLayoutConstraint.activate([
      creationTimeView.topAnchor.constraint(equalTo: creationDateView.bottomAnchor, constant: padding),
      creationTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      creationTimeView.heightAnchor.constraint(equalToConstant: 20)
    ])
  }
  
}
