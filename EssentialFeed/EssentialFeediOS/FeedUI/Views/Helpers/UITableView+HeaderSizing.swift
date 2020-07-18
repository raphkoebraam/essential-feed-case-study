//
//  Created by Raphael Silva on 18/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import UIKit

extension UITableView {
    func sizeTableHeaderToFit() {
        guard let header = tableHeaderView else { return }
        
        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let shouldUpdateFrame = header.frame.height != size.height
        
        if shouldUpdateFrame {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
