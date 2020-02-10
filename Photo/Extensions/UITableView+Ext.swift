//
//  UITableView+Ext.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit

extension UITableView {
  
  func reloadDataOnMainThread() {
    DispatchQueue.main.async { self.reloadData() }
  }
  
  func removeExcessCells() {
    tableFooterView = UIView(frame: .zero)
  }
}
