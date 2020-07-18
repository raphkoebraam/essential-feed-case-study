//
//  Created by Raphael Silva on 18/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import XCTest
import EssentialFeediOS
@testable import EssentialApp

class SceneDelegateTests: XCTestCase {

    func test_sceneWillConnectToSession_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()
        
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is FeedTableViewController, "Expected a fed controller as top view controller, got \(String(describing: topController)) instead")
    }
}
