//
//  ImageCell.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let reuseID = "PhotoCell"
    
    let imageView = PhotoImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(photoViewModel: PhotoViewModel) {
        imageView.image = photoViewModel.thumbNail
    }
    
    private func configure() {
        self.addSubview(imageView)
        imageView.pinToEdges(of: self)
    }
}
