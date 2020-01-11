//
//  NetworkClient.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 10/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation

class NetworkClient {
    
    struct Auth {
        static var sessionId = ""
        static var userId = ""
        static var user: User?
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case logout
        case webAuth
        case fetchUserData
        case addStudentLocation
        case updateLocation(id: String)
        case fetchStudentsLocation(limit: Int?, skip: Int?)
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            case .logout: return Endpoints.base + "/session"
            case .webAuth: return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
            case .fetchUserData: return Endpoints.base + "/users/" + Auth.userId
            case .addStudentLocation: return Endpoints.base + "/StudentLocation"
            case .updateLocation(let id): return Endpoints.base + "/StudentLocation/" + id
            case .fetchStudentsLocation(let limit, let skip):
                var url = Endpoints.base + "/StudentLocation"
                var joinQuery = "?"
                if let limit = limit {
                    url += joinQuery + "limit=\(limit)"
                    joinQuery = "&"
                }
                
                if let skip = skip {
                    url += joinQuery + "skip=\(skip)"
                    joinQuery = "&"
                }
                
                return url + joinQuery + "order=-updatedAt"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func updateLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, id: String, completion: @escaping(Bool, Error?) -> Void) {
        let body = AddUserLocationRequest(uniqueKey: Auth.userId, firstName: Auth.user!.firstName, lastName: Auth.user!.lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        taskForPOSTRequest(url: Endpoints.updateLocation(id: id).url, responseType: UpdateLocationResponse.self, body: body, udacityApi: false, method: "PUT") { response, error in
            if let _ = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func addNewLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping(Bool, Error?) -> Void) {
        let body = AddUserLocationRequest(uniqueKey: Auth.userId, firstName: Auth.user!.firstName, lastName: Auth.user!.lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
        taskForPOSTRequest(url: Endpoints.addStudentLocation.url, responseType: AddLocationResponse.self, body: body, udacityApi: false) { response, error in
            if let _ = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func fetchStudentsLocation(limit: Int? = nil, skip: Int? = nil, completion: @escaping(Bool, Error?) -> Void) {
        let _ = taskForGETRequest(url: Endpoints.fetchStudentsLocation(limit: limit, skip: skip).url, responseType: StudentInformation.self, udacityApi: false) { (response, error) in
           if let response = response {
            StudentLocationManager.shared.setStudents(students: response.results)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func fetchUserData(completion: @escaping(Bool, Error?) -> Void) {
        let _ = taskForGETRequest(url: Endpoints.fetchUserData.url, responseType: User.self) { (response, error) in
            if let response = response {
                Auth.user = response
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            Auth.userId = ""
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: LoginCredentials(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.userId = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, udacityApi: Bool = true, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            if udacityApi {
                let range = 5..<data.count
                data = data.subdata(in: range)
            }
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, udacityApi: Bool = true, method: String = "POST", completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard var data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            if udacityApi {
                let range = 5..<data.count
                data = data.subdata(in: range)
            }

            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}
