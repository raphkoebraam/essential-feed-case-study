//
//  CellController.swift
//  EssentialFeediOS
//
//  Created by Raphael Silva on 07/03/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import UIKit

public struct CellController {
    let id: AnyHashable
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    let dataSourcePrefetching: UITableViewDataSourcePrefetching?

    public init(id: AnyHashable, dataSource: UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching) {
        self.id = id
        self.dataSource = dataSource
        self.delegate = dataSource
        self.dataSourcePrefetching = dataSource
    }

    public init(id: AnyHashable, dataSource: UITableViewDataSource) {
        self.id = id
        self.dataSource = dataSource
        self.delegate = nil
        self.dataSourcePrefetching = nil
    }
}

extension CellController: Equatable {
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
}
extension CellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
