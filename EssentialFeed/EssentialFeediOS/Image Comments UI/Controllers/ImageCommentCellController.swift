//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Raphael Silva on 07/03/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import UIKit
import EssentialFeed

public final class ImageCommentCellController: NSObject, UITableViewDataSource {

    private let model: ImageCommentViewModel

    public init(model: ImageCommentViewModel) {
        self.model = model
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageCommentTableViewCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.usernameLabel.text = model.username
        cell.dateLabel.text = model.date
        return cell
    }
}
