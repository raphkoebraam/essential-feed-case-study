//
//  Created by Raphael Silva on 28/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import XCTest
import EssentialFeed

class FeedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)

        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
