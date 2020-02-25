//
//  GetUserResponse.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/24/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

struct UserTopLevelDictionary: Codable {
    let user: UserInformation
}

struct UserInformation: Codable {
    let lastName: String
    let firstname: String
    let linkedinUrl: String
    let imageUrl: String
}
