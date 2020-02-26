//
//  StudentAPIs.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/22/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

class StudentAPIs {
    
    struct Auth {
        static var sessionId: String?
        static var accountKey: String?
        static var registered = false
        static var expiration: String?
    }
    
    struct ParseHeaderKeys {
        static let APIKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
    }
    
    struct ParseHeaderValues {
        static let APIKeyValues = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationIDValues = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    //MARK: - Endpoints
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let limitQuery = "?limit="
        static let uniqueKeyQuery = "?uniqueKey="
        static let sessionParam = "https://onthemap-api.udacity.com/v1/session"
        static let getUsersparam = "https://onthemap-api.udacity.com/v1/users/"
        
        case getAllStudents
        case limitStudentSearch(Int)
        case searchWithUniqueKey(String)
        case updateStudentLocation(String)
        case session
        case getUsers(String)
        
        var stringValue: String {
            switch self {
            case .getAllStudents: return Endpoints.base
            case .limitStudentSearch(let number): return Endpoints.base + Endpoints.limitQuery + "\(number)"
            case .searchWithUniqueKey(let userId):  return  Endpoints.base + Endpoints.uniqueKeyQuery + "\(userId)"
            case .updateStudentLocation(let objectId): return Endpoints.base + "/\(objectId)"
            case .session: return Endpoints.sessionParam
            case .getUsers(let userId): return Endpoints.getUsersparam + "\(userId)"
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
        
        //per mentors adding the first addValue method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //per mentors "when you make a  request to the server you will need to pass 2 parameters "x-parse-rest-api-key" and "x-parse-application-id" to the header.
        request.addValue(ParseHeaderKeys.APIKey, forHTTPHeaderField: ParseHeaderValues.APIKeyValues)
        request.addValue(ParseHeaderKeys.ApplicationID, forHTTPHeaderField: ParseHeaderValues.ApplicationIDValues)
        
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
            let newData = data.subdata(in: 5..<data.count)
            print(String(data: newData, encoding: .utf8)!)
            
            do {
                //per Mentor's adding the newData property
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                
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
    
    //function doesn't work
    class func getUserData(student: Student, completion: @escaping(Bool, Error?) -> Void){
        let url = Endpoints.getUsers(student.uniqueKey).url
        funcForAllGetMethods(url: url, responseType: GetUserResponse.self) { (responseObject, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                completion(false, error)
                return
            }
            
            if let responseObject = responseObject {
                print("This is the responseobject: \(responseObject.user.firstName)")
            } else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                completion(false, error)
            }
        }
    }
   
    class func login(with email: String, password: String, completion: @escaping (Bool, Error?) -> ()){
        let url = Endpoints.session.url
        let loginRequestBody = LoginRequest(udacity: LoginData(username: email, password: password))

        funcForAllPostMethods(url: url, responseType: SessionResponse.self, body: loginRequestBody) { (responseObject, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
               completion(false, error)
                return
            }
            
            if let responseObject = responseObject {
                Auth.sessionId = responseObject.session?.id
                print("this is the sessionId we got back from loggin in: \(String(describing: Auth.sessionId))")
                
                Auth.expiration = responseObject.session?.expeiration
                 print("this is the user's expiration date we got back from loggin in: \(String(describing: Auth.expiration))")
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.session.url)
        print("This is the url in function: \(#function) -> url: \(Endpoints.session.url)")
        
        request.httpMethod  = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LogoutSessionInformation(id: Auth.sessionId, expiration: "n/a")
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(body)
        } catch  {
            print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response deleting session: \(response.statusCode)")
            }
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                completion(false, error)
                return
            }
            
            //DELETE SESSION ID
            Auth.sessionId = nil
            DispatchQueue.main.async {
                print("The session ID sould now be empty: \(String(describing: Auth.sessionId))")
                completion(true, nil)
            }
        }
        task.resume()
    }
    
    //function  doesn't work
    class func updateStudentLocation(student: Student, completion: @escaping (Bool, Error?) -> Void){
        
        let postStudentRequest = PostStudentRequest(firstName: student.firstName, lastName: student.lastName, latitude: student.latitude, longitude: student.longitude, mapString: student.mapString, mediaURL: student.mediaURL, uniqueKey: student.uniqueKey)
        
        print("This is the url for: \(#function) -> \(Endpoints.updateStudentLocation(student.objectId).url)")
        var request = URLRequest(url: Endpoints.updateStudentLocation(student.objectId).url)
        request.httpMethod = "PUT"
        
        //per mentors adding the first addValue method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

//        //per mentors "when you make a  request to the server you will need to pass 2 parameters "x-parse-rest-api-key" and "x-parse-application-id" to the header.
        request.addValue(ParseHeaderKeys.APIKey, forHTTPHeaderField: ParseHeaderValues.APIKeyValues)
        request.addValue(ParseHeaderKeys.ApplicationID, forHTTPHeaderField: ParseHeaderValues.ApplicationIDValues)

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        do {
            request.httpBody = try encoder.encode(postStudentRequest)
        } catch  {
            print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
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
                print("student was updated at:  \(String(describing: responseObject.updatedAt))")
                DispatchQueue.main.async {
                    completion(true,nil)
                }
            } catch  {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }
        task.resume()
    }
    
    //function doesn't work
    class func postStudentLocation(student: Student, completion: @escaping (Bool, Error?) -> Void){
        let postRequest = PostStudentRequest(firstName: student.firstName, lastName: student.lastName, latitude: student.latitude, longitude: student.longitude, mapString: student.mapString, mediaURL: student.mediaURL, uniqueKey: student.uniqueKey)
        
        print("this is the url for function: \(#function) -> url:  \(Endpoints.getAllStudents.url)")
        
        funcForAllPostMethods(url: Endpoints.getAllStudents.url, responseType: StudentPostResponse.self, body: postRequest) { (responseObject, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            if let returnedObject = responseObject {
                print("This is the object's id: \(returnedObject.objectId)")
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
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
