//
//  NetworkController.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/27/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import Foundation

class NetworkController {
    static let shared = NetworkController()
    var students = [Student]()
    var orderedStudents = [Student]()
    
    struct Auth {
        static var sessionId = ""
        static var accountKey = ""
        static var registered = false
        static var expiration = ""
    }
    
    struct ParseHeaderKeys {
        static let APIKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
    }
    
    struct ParseHeaderValues {
        static let APIKeyValues = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationIDValues = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    func assignStudentToBody(_ student: Student) -> Student {
        return Student(firstName: student.firstName, lastName: student.lastName, longitude: student.longitude, latitude: student.latitude, mapString: student.mapString, mediaURL: student.mediaURL, uniqueKey: student.createdAt ?? "", objectId: student.objectId, createdAt: student.uniqueKey, updatedAt: student.updatedAt)
    }
    
    func funcForAllGetMethods<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void){
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
            
            do {
                let responseObject =  try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch  {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func funcForAllPostMethods<ResponseType: Decodable, RequestType: Encodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        print("this is the url: \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //per mentors adding the first addValue method
               request.addValue("application/json", forHTTPHeaderField: "Accept")
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
            
            let newData = data.subdata(in: 5..<data.count)
            print("This is the data thats printed: \(String(data: newData, encoding: .utf8)!)")
            
            if let response = response as? HTTPURLResponse {
                print("Response: \(response.statusCode)")
                //if response is greater than 400 then we have an error
                if response.statusCode > 400 {
                    print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                    do {
                        //decode the data we got back into our errorStruct model so we can present the  error on the viewController
                        let message = try JSONDecoder().decode(ErrorStruct.self, from: newData)
                        print("Status of Error: \(message.status)\n Error message: \(message.error)")
                        let myError = ErrorStruct(status: message.status, error: message.error)
                        completion(nil, myError)
                        return
                    } catch  {
                        print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                    }
                }
            }
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
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
                return
            }
        }
        task.resume()
    }
    
    func funcToPostStudentLocation<ResponseType: Decodable, RequestType: Encodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        print("this is the url: \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
       
        let encoder = JSONEncoder()
        
        do {
            request.httpBody = try encoder.encode(body)
        } catch  {
            print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            print("This is the data thats printed: \(String(data: data, encoding: .utf8)!)")
            
            if let response = response as? HTTPURLResponse {
                print("Response: \(response.statusCode)")
                //if response is greater than 400 then we have an error
                if response.statusCode > 400 {
                    print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                    do {
                        //decode the data we got back into our errorStruct model so we can present the  error on the viewController
                        let message = try JSONDecoder().decode(ErrorStruct.self, from: data)
                        print("Status of Error: \(message.status)\n Error message: \(message.error)")
                        let myError = ErrorStruct(status: message.status, error: message.error)
                        completion(nil, myError)
                        return
                    } catch  {
                        print("Error in: \(#function)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)")
                    }
                }
            }
            
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                //per Mentor's adding the newData property
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
                
            } catch {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
        }
        task.resume()
    }
    
    func orderStudentsInList(completion: @escaping (Bool, Error?) -> Void){
        funcForAllGetMethods(url: StudentAPIs.Endpoints.order.url, responseType: TopLevelDictionary.self) { (responseObject, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            if let responseObject = responseObject {
                DispatchQueue.main.async {
                    self.orderedStudents = responseObject.results
                    completion(true, nil)
                }
            } else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
        }
    }
    
    //function works with optionals
    func getUserData(student: Student, completion: @escaping(Bool, ErrorStruct?) -> Void){
        let url = StudentAPIs.Endpoints.getUsers(student.uniqueKey).url
        funcForAllGetMethods(url: url, responseType: GetUserResponse.self) { (responseObject, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                completion(false, error as? ErrorStruct)
                return
            }
            
            if let responseObject = responseObject {
                print("This is the responseobject firstName: \(String(describing: responseObject.user.firstName))")
                print("This is the responseobject lastName: \(String(describing: responseObject.user.lastName))")
                print("This is the responseobject imageURL: \(String(describing: responseObject.user.imageUrl))")
                print("This is the responseobject linkedinURL: \(String(describing: responseObject.user.linkedinUrl))")
            } else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                completion(false, error as? ErrorStruct)
            }
        }
    }
    
    //works - Use ErrorStruct to display the response we get back if its > 400
    func login(with email: String, password: String, completion: @escaping (Bool, Error? /*ErrorStruct?*/) -> ()){
        let url = StudentAPIs.Endpoints.session.url
        let loginRequestBody = LoginRequest(udacity: LoginData(username: email, password: password))
        
        funcForAllPostMethods(url: url, responseType: SessionResponse.self, body: loginRequestBody) { (responseObject, error ) in
            if let error = error  {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                completion(false, error /*as? ErrorStruct*/)
                return
            }
            
            if let responseObject = responseObject {
                Auth.sessionId = responseObject.session.id
                Auth.accountKey =  responseObject.account.key
                print("This is the accountKey: \(Auth.accountKey)")
                print("this is the sessionId we got back from loggin in: \(String(describing: Auth.sessionId))")
                
                Auth.expiration = responseObject.session.expiration
                print("this is the user's expiration date we got back from loggin in: \(String(describing: Auth.expiration))")
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                DispatchQueue.main.async {
                    completion(false, error /*as? ErrorStruct*/)
                }
                return
            }
        }
    }
    
    //works
    func logout(completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: StudentAPIs.Endpoints.session.url)
        print("This is the url in function: \(#function) -> url: \(StudentAPIs.Endpoints.session.url)")
        
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
            Auth.sessionId = ""
            DispatchQueue.main.async {
                print("The session ID sould now be empty: \(String(describing: Auth.sessionId))")
                completion(true, nil)
            }
        }
        task.resume()
    }
    
    //function  doesn't work
    func updateStudentLocation(student: Student, completion: @escaping (Bool, ErrorStruct?) -> Void){
        
        let postStudentRequest = PostStudentRequest(firstName: student.firstName, lastName: student.lastName, latitude: student.latitude, longitude: student.longitude, mapString: student.mapString, mediaURL: student.mediaURL, uniqueKey: student.uniqueKey)
        
        print("This is the url for: \(#function) -> \(StudentAPIs.Endpoints.updateStudentLocation(student.objectId ?? "").url)")
        var request = URLRequest(url: StudentAPIs.Endpoints.updateStudentLocation(student.objectId ?? "").url)
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
                completion(false, error as? ErrorStruct)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response in: \(#function) \(response.statusCode)")
            }
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion(false, error as? ErrorStruct)
                }
                return
            }
            
            guard let data = data else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                completion(false, error as? ErrorStruct)
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let newData = data.subdata(in: 5..<data.count)
            print("This is the data thats printed: \(String(data: newData, encoding: .utf8)!)")
            
            do {
                let responseObject = try decoder.decode(PutStudentResponse.self, from: newData)
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
    func postStudentLocation(student: Student, completion: @escaping (Bool, ErrorStruct?) -> Void){
        let postRequest = PostStudentRequest(firstName: student.firstName, lastName: student.lastName, latitude: student.latitude, longitude: student.longitude, mapString: student.mapString, mediaURL: student.mediaURL, uniqueKey: student.uniqueKey)
        
        print("this is the url for function: \(#function) -> url:  \(StudentAPIs.Endpoints.getAllStudents.url)")
        
        funcToPostStudentLocation(url: StudentAPIs.Endpoints.getAllStudents.url, responseType: StudentPostResponse.self, body: postRequest) { (responseObject, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion(false, error as? ErrorStruct)
                }
                return
            }
            
            if let returnedObject = responseObject {
                print("This is the object's id: \(returnedObject.objectId)")
                print("This is the createdAt date: \(returnedObject.createdAt)")
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                DispatchQueue.main.async {
                    completion(false, error as? ErrorStruct)
                }
            }
        }
    }
    
    //works
    func getAllStudents(completion: @escaping (ErrorStruct?) -> Void){
        funcForAllGetMethods(url: StudentAPIs.Endpoints.getAllStudents.url, responseType: TopLevelDictionary.self) { (response, error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                DispatchQueue.main.async {
                    completion(error as? ErrorStruct)
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
                    self.students = studentsWithFullNames
                    completion(nil)
                }
            } else {
                DispatchQueue.main.async {
                    print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                    completion(error as? ErrorStruct)
                }
            }
        }
    }
}
