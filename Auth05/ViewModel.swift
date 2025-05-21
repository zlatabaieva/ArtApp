//
//  ViewModel.swift
//  Auth05
//
//  Created by Apple on 21.03.2025.
//

import SwiftUI

// Модели ответов API
enum Signup {
    struct Response: Decodable {
        let jwt: String
    }
}

enum Signin {
    struct Response: Decodable {
        let jwt: String
    }
}

enum Logout {
    struct Response: Decodable {
        let success: Bool
        let message: String?
    }
}

// Конечные точки API
enum MainEndpoint: Endpoint {
    case signup
    case signin(email: String, password: String)
    case profiles(number: Int, token: String)
    case logout(token: String)
    
    var rawValue: String {
        switch self {
        case .signup: return "sign_up"
        case .signin: return "sign_in"
        case .profiles: return "profiles"
        case .logout: return "logout"
        }
    }
    
    var compositePath: String {
        switch self {
        case .logout: return "/api/v1/\(self.rawValue)"
        case .profiles(let number, _): return "/api/v1/\(self.rawValue)/\(number)"
        default: return "/api/v1/\(self.rawValue)"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .logout(let token):
            return [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
        case .profiles(_, let token):
            return [
                "Content-Type": "application/json"
            ]
        case .signin, .signup:
            return ["Content-Type": "application/www-form-urlencoded"]
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .signin(let email, let password):
            return ["email": email, "password": password]
        default:
            return nil
        }
    }
}

// Рабочий для сетевых запросов
final class MainWorker {
    let worker = BaseURLWorker(baseUrl: "http://localhost:3000")
    
    func load(request: Request, completion: @escaping (Result<Data?, Error>) -> Void) {
        worker.executeRequest(with: request) { response in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let result):
                completion(.success(result.data))
            }
        }
    }
}

// Основная ViewModel
final class ViewModel: ObservableObject {
    enum Const {
        static let tokenKey = "token"
    }
    
    @Published var gotToken: Bool = KeychainService().getString(forKey: Const.tokenKey)?.isEmpty == false
    @AppStorage("IsLoggedIn") var isLoggedIn: Bool = false
    
    private var worker = MainWorker()
    private var keychain = KeychainService()
    
    func signUp(login: String, email: String, password: String) {
        let endpoint = MainEndpoint.signup
        let request = Request(endpoint: endpoint, method: .post)
        
        worker.load(request: request) { [weak self] (result: Result<Data?, Error>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                if let data = data,
                   let response = try? JSONDecoder().decode(Signup.Response.self, from: data) {
                    let token = response.jwt
                    self?.keychain.setString(token, forKey: Const.tokenKey)
                    self?.isLoggedIn = true
                    DispatchQueue.main.async {
                        self?.gotToken = true
                    }
                } else {
                    print("Failed to get token")
                }
            }
        }
    }
    
    func signIn(login: String, password: String) {
        let endpoint = MainEndpoint.signin(email: login, password: password)
        let request = Request(endpoint: endpoint, method: .post)
        
        worker.load(request: request) { [weak self] (result: Result<Data?, Error>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                if let data = data,
                   let response = try? JSONDecoder().decode(Signin.Response.self, from: data) {
                    let token = response.jwt
                    self?.keychain.setString(token, forKey: Const.tokenKey)
                    self?.isLoggedIn = true
                    DispatchQueue.main.async {
                        self?.gotToken = true
                    }
                } else {
                    print("Failed to get token")
                }
            }
        }
    }
    
    func logout() {
        guard let token = keychain.getString(forKey: Const.tokenKey) else {
            print("No token found")
            return
        }
        
        let endpoint = MainEndpoint.logout(token: token)
        let request = Request(endpoint: endpoint, method: .post)
        worker.load(request: request) { [weak self] (result: Result<Data?, Error>) in
            switch result {
            case .failure(let error):
                print("Logout error: \(error)")
            case .success(let data):
                if let data = data,
                   let response = try? JSONDecoder().decode(Logout.Response.self, from: data),
                   response.success {
                    
                    self?.keychain.clearKeychain()
                    self?.isLoggedIn = false
                    
                    DispatchQueue.main.async {
                        self?.gotToken = false
                        print("User logged out successfully")
                    }
                } else {
                    print("Failed to parse logout response")
                }
            }
        }
    }
    
    func getUsers() {
        let token = keychain.getString(forKey: Const.tokenKey) ?? ""
        let request = Request(endpoint: MainEndpoint.profiles(number: 8, token: token))
        
        worker.load(request: request) { (result: Result<Data?, Error>) in
            switch result {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let data):
                guard let data = data else {
                    print("No data received")
                    return
                }
                print(String(data: data, encoding: .utf8) ?? "Invalid data")
            }
        }
    }
    
    
}
