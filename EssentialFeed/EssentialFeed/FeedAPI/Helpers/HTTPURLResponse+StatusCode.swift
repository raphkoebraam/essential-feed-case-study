//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Raphael Silva on 09/07/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int {
        return 200
    }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
