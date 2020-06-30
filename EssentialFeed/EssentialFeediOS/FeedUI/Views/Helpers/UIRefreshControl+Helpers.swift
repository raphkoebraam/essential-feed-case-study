//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Raphael Silva on 30/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
