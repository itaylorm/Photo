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
  let informationView = UIStackView()
  let doneButton = Button(backgroundColor: UIColor.systemGreen, title: "Done")
  let segmented = SegmentedControl(titles: ["Display Info", "Hide Info"])
  
  var spaceView = ValueView(frame: .zero)
  var creationDateView = ValueView(title: "Date:")
  var creationTimeView = ValueView(title: "Time:")
  var makeView = ValueView(title: "Make:")
  var modelView = ValueView(title: "Model:")
  var lensView = ValueView(title: "Lens:")
  
  var viewModels: [PhotoViewModel]!
  var currentViewModel: PhotoViewModel!
  var currentIndex: Int = -1
  
  let padding: CGFloat = 10
  
  var showPhotoInformation = true
  
  var photoViewTopConstraint: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    configureViewController()
    configurePhotoView()
    configureInformationView()
    getPhoto()
    //getPhotoExtendedInformation()
  }
  
  deinit {
     NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
  }
  
  @objc func rotated() {
    getPhoto()
  }
  
  @objc func dismissVC() {
    dismiss(animated: true)
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
  
  private func getPhoto() {
    var image: UIImage?
    let heightModifier: CGFloat = showPhotoInformation ? 170 : 60
    let imageBounds = CGRect(x: 0, y: 0, width: view.bounds.width - padding, height: view.bounds.height - heightModifier)
    image = PhotoManager.shared.getPhoto(photoViewModel: currentViewModel, available: imageBounds, photoType: .forInfo)
    currentViewModel.imagePortrait = image
    photoImageView.contentMode = .top
    
    if let image = image {
      photoImageView.image = image
      let height = image.size.height
      let width = image.size.width
      photoImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
      creationDateView.value = currentViewModel.creationDate?.convertToDateFormat() ?? "Unknown"
      creationTimeView.value = currentViewModel.creationDate?.convertToTimeFormat() ?? "Unknown"
    }
  }
  
  private func displayPhotoInformation() {
    makeView.value = currentViewModel.make ?? ""
    modelView.value = currentViewModel.model ?? ""
    lensView.value = currentViewModel.lens ?? ""
    informationView.isHidden = !showPhotoInformation
  }
  
  private func getPhotoExtendedInformation() {
    informationView.isHidden = true
    PhotoManager.shared.getPhotoInformation(viewModel: currentViewModel) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let viewModel):
        self.currentViewModel = viewModel
        self.displayPhotoInformation()
      case .failure(let error):
        print(error.rawValue)
      }
    }
  }
  
  private func configureViewController() {
    view.backgroundColor = .systemBackground
    view.addSubviews(doneButton, segmented)
    configureDoneButton()
    configureSegmented()
  }
  
  @objc func changeInformationDisplay(_ sender: SegmentedControl) {
    showPhotoInformation = sender.selectedSegmentIndex == 0 ? true : false
    informationView.isHidden = !showPhotoInformation
    getPhoto()
  }
  
  @objc func changeSwitch(_ sender: UISwitch) {
    title = sender.isOn == true ? "" : "Photo info hidden"
  }
  
  private func configureDoneButton() {
    doneButton.addTarget(self, action: #selector(dismissVC), for: .touchDown)
    
    NSLayoutConstraint.activate([
      doneButton.widthAnchor.constraint(equalToConstant: 75),
      doneButton.heightAnchor.constraint(equalToConstant: 30),
      doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
      doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
    ])
  }
  
  private func configureSegmented() {
    segmented.addTarget(self, action: #selector(changeInformationDisplay(_:)), for: .valueChanged)
    view.addSubview(segmented)
    NSLayoutConstraint.activate([
      segmented.widthAnchor.constraint(equalToConstant: 175),
      segmented.heightAnchor.constraint(equalToConstant: 30),
      segmented.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
      segmented.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding)
    ])
  }
  
  private func configurePhotoView() {
    view.addSubviews(photoImageView)
    photoImageView.isUserInteractionEnabled = true
    let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
    leftSwipe.direction = .left
    view.addGestureRecognizer(leftSwipe)
    
    let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
    rightSwipe.direction = .right
    view.addGestureRecognizer(rightSwipe)
    
    NSLayoutConstraint.activate([
      photoImageView.topAnchor.constraint(equalTo: segmented.bottomAnchor, constant: padding),
      photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
    ])
  }
  
  private func configureInformationView() {
    view.addSubview(informationView)
    informationView.axis = .vertical
    informationView.distribution = .equalSpacing
    informationView.translatesAutoresizingMaskIntoConstraints = false
    
    informationView.addArrangedSubviews(spaceView, creationDateView, creationTimeView, makeView, modelView, lensView)
    
    NSLayoutConstraint.activate([
      informationView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: padding),
      informationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      informationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
    ])
    
  }
  
}
