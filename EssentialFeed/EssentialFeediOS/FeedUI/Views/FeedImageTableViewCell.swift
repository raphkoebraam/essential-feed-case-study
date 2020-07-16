//
//  Created by Raphael Silva on 25/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import UIKit

public final class FeedImageTableViewCell: UITableViewCell {
    @IBOutlet private(set) public var locationContainer: UIView!
    @IBOutlet private(set) public var locationLabel: UILabel!
    @IBOutlet private(set) public var descriptionLabel: UILabel!
    @IBOutlet private(set) public var feedImageContainer: UIView!
    @IBOutlet private(set) public var feedImageRetryButton: UIButton!
    @IBOutlet private(set) public var feedImageView: UIImageView!
    
    var onRetry: (() -> Void)?
    
    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
}
