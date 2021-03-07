//
//  ImageCommentCellController.swift
//  EssentialFeediOS
//
//  Created by Raphael Silva on 07/03/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import UIKit
import EssentialFeed

public final class ImageCommentCellController: CellController {

    private let model: ImageCommentViewModel

    public init(model: ImageCommentViewModel) {
        self.model = model
    }

    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ImageCommentTableViewCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.usernameLabel.text = model.username
        cell.dateLabel.text = model.date
        return cell
    }

    public func preload() {}

    public func cancelLoad() {}
}
