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
        case updateStudentLocation(String)
        
        var stringValue: String {
            switch self {
            case .getAllStudents: return Endpoints.base
            case .limitStudentSearch(let number): return Endpoints.base + Endpoints.limitQuery + "\(number)"
            case .searchWithUniqueKey(let userId):  return  Endpoints.base + Endpoints.uniqueKeyQuery + "\(userId)"
            case .updateStudentLocation(let objectId): return Endpoints.base + "/\(objectId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    static func assignStudentToBody(_ student: Student) -> Student {
        return Student(firstName: student.firstName, lastName: student.lastName, latitude: student.latitude, longitude: student.longitude, mapString: student.mapString, mediaURL: student.mediaURL, createdAt: student.createdAt, objectId: student.objectId, uniqueKey: student.uniqueKey, updatedAt: student.updatedAt)
    }
    
    class func funcForAllGetMethods<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
        print("This is the response (GET) url: \(url) for: \(responseType.self).")
        
        //create urlSession
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response: \(response.statusCode)")
            }
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let responseObject =  try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch  {
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func funcForAllPostMethods<ResponseType: Decodable, RequestType: Encodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        print("this is the url: \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy  = .convertToSnakeCase
        
        do {
            request.httpBody = try encoder.encode(body)
        } catch  {
            print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print("Response: \(response.statusCode)")
            }
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void){
        
    }
    
    class func updateStudentLocation(student: Student, completion: @escaping (Bool, Error?) -> Void){
        
        let body = assignStudentToBody(student)
        print("This is the url for: \(#function) -> \(Endpoints.updateStudentLocation(body.objectId).url)")
        var request = URLRequest(url: Endpoints.updateStudentLocation(body.objectId).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        do {
            request.httpBody = try encoder.encode(body)
        } catch  {
            print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
            DispatchQueue.main.async {
                completion(false, error)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response in: \(#function) \(response.statusCode)")
            }
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            guard let data = data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                completion(false, error)
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let responseObject = try decoder.decode(PutStudentResponse.self, from: data)
                print("student was updated at:  \(responseObject.updatedAt)")
                DispatchQueue.main.async {
                    completion(true,nil)
                }
            } catch  {
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }
        task.resume()
    }
    
    class func postStudentLocation(student: Student, completion: @escaping (Bool, Error?) -> Void){
        let body =  assignStudentToBody(student)
        
        var request = URLRequest(url: Endpoints.getAllStudents.url)
        print("this is the url for function: \(#function) -> url:  \(Endpoints.getAllStudents.url)")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        do {
            request.httpBody = try encoder.encode(body)
        } catch  {
            print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
            DispatchQueue.main.async {
                completion(false, error)
            }
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response in postStudentLocation(): \(response.statusCode)")
            }
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            guard let data =  data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()
            //            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let object = try decoder.decode(StudentPostResponse.self, from: data)
                let datay = try decoder.decode(String.self, from: data)
                print("Object's creation date: \(object.createdAt)")
                DispatchQueue.main.async {
                    print("datay: \(datay)")
                    completion(true, nil)
                }
            } catch  {
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func getStudentsWithALimit(studentLimit limit: Int, completion: @escaping ([Student]?, Error?) -> Void){
        funcForAllGetMethods(url: Endpoints.limitStudentSearch(limit).url, responseType: TopLevelDictionary.self) { (response, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if let response = response {
                var studentsWithFullNames = [Student]()
                
                for student in response.results {
                    if student.firstName != "" && student.lastName != "" {
                        print("Student's name: \(student.fullName)")
                        studentsWithFullNames.append(student)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(studentsWithFullNames, nil)
                }
            } else {
                DispatchQueue.main.async {
                    print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                    completion(nil, error)
                }
            }
        }
    }
    
    class func getAllStudents(completion: @escaping ([Student]?, Error?) -> Void){
        funcForAllGetMethods(url: Endpoints.getAllStudents.url, responseType: TopLevelDictionary.self) { (response, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if let response = response {
                var studentsWithFullNames = [Student]()
                
                for student in response.results {
                    if student.firstName != "" && student.lastName != "" {
                        print("Student's name: \(student.fullName)")
                        studentsWithFullNames.append(student)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(studentsWithFullNames, nil)
                }
            } else {
                DispatchQueue.main.async {
                    print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                    completion(nil, error)
                }
            }
        }
    }
    
}
