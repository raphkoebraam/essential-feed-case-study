//
//  UIView+Helpers.swift
//  EssentialFeediOS
//
//  Created by Raphael Silva on 07/03/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import UIKit

extension UIView {
    public func makeContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(self)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            topAnchor.constraint(equalTo: container.topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        return container
    }
}
