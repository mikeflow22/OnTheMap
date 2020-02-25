//
//  PostStudentRequest.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/25/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

//this goes into the body
struct PostStudentRequest: Codable {
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
}
