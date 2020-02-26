//
//  ErrorStruct.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/26/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation
struct ErrorStruct: Codable, Error {
    let status: Int
    let error: String
    var localizedDescription: String {
        return error
    }
}
