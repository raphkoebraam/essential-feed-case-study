//
//  SharedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Raphael Silva on 07/03/2021.
//  Copyright © 2021 Raphael Silva. All rights reserved.
//

import XCTest
import EssentialFeed

class SharedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)

        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }

    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }
}
