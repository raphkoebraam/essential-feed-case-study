//
//  Created by Raphael Silva on 30/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

public struct ResourceErrorViewModel {
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
    
    public let message: String?
}
