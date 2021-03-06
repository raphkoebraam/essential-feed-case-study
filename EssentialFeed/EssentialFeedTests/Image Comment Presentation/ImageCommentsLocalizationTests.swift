//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Raphael Silva on 06/03/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)

        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
