//
//  LocalStorageHelpers.swift
//  AC3.2-LocalStorage
//
//  Created by Louis Tur on 1/16/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit


// MARK: - Protocols
protocol JSONConvertible {
  func toJson() -> [String : AnyHashable]
  init?(json: [String : AnyHashable])
}


// MARK: - HELPERS
public func stripMaskResizing(_ views: UIView...) { //"..." multiple parameters of same type
  stripMaskResizing(views)
}

public func stripMaskResizing(_ views: [UIView]) {
  let _ = views.map{ $0.translatesAutoresizingMaskIntoConstraints = false }
}

public extension Array where Element: NSLayoutConstraint {
  
  public func activate() {
    let _ = self.map{ $0.isActive = true }
  }
}

