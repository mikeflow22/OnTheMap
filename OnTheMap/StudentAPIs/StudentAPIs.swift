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
        
        case getAllStudents
        case limitStudentSearch(Int)
        case searchWithUniqueKey(String)
        
        var stringValue: String {
            switch self {
            case .getAllStudents: return Endpoints.base
            case .limitStudentSearch(let number): return Endpoints.base + Endpoints.limitQuery + "\(number)"
            case .searchWithUniqueKey(let userId):  return  Endpoints.base + Endpoints.uniqueKeyQuery + "\(userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getAllStudents(completion: @escaping ([Student]?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: Endpoints.getAllStudents.url) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response for \(#function): \(response.statusCode)")
            }
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            
            guard let data = data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            var studentsWithFullNames = [Student]()
            
            do {
                let returnedStudents = try decoder.decode(TopLevelDictionary.self, from: data).results
                for student in returnedStudents {
                    if student.firstName != "" && student.lastName != "" {
//                        print("Student's name: \(student.fullName)")
                        studentsWithFullNames.append(student)
                    }
                }
                DispatchQueue.main.async {
                    completion(studentsWithFullNames, nil)
                }
            } catch  {
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
}
