//
//  StudentAPIs.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/22/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

class StudnetAPIs {
    
    //MARK: - Endpoints
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let limitQuery = "?limit="
        static let uniqueKeyQuery = "?uniqueKey="
        
        case limitStudentSearch(Int)
        case searchWithUniqueKey(String)
        
        var stringValue: String {
            switch self {
            case .limitStudentSearch(let number): return Endpoints.base + Endpoints.limitQuery + "\(number)"
            case .searchWithUniqueKey(let userId):  return  Endpoints.base + Endpoints.uniqueKeyQuery + "\(userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
        
        
        
        
    }
    
    
    
}
