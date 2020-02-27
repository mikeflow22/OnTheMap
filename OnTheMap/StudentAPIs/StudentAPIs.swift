//
//  StudentAPIs.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/22/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

class StudentAPIs {
    
    
    
    //MARK: - Endpoints
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let limitQuery = "?limit="
        static let uniqueKeyQuery = "?uniqueKey="
        static let sessionParam = "https://onthemap-api.udacity.com/v1/session"
        static let getUsersparam = "https://onthemap-api.udacity.com/v1/users/"
        static let orderParam = "?order=-updatedAt"
        
        case getAllStudents
        case limitStudentSearch(Int)
        case searchWithUniqueKey(String)
        case updateStudentLocation(String)
        case session
        case getUsers(String)
        case order
        
        var stringValue: String {
            switch self {
            case .getAllStudents: return Endpoints.base
            case .limitStudentSearch(let number): return Endpoints.base + Endpoints.limitQuery + "\(number)"
            case .searchWithUniqueKey(let userId):  return  Endpoints.base + Endpoints.uniqueKeyQuery + "\(userId)"
            case .updateStudentLocation(let objectId): return Endpoints.base + "/\(objectId)"
            case .session: return Endpoints.sessionParam
            case .getUsers(let userId): return Endpoints.getUsersparam + "\(userId)"
            case .order: return Endpoints.base + Endpoints.orderParam
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    
}
