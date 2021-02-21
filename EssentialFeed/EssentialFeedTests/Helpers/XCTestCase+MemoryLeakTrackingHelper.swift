//
//  Created by Raphael Silva on 23/12/2019.
//  Copyright © 2019 Raphael Silva. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
