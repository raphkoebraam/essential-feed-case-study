//
//  Created by Raphael Silva on 17/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potenteial memory leak.", file: file, line: line)
        }
    }
}
