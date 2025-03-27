//
//  ProfileService.swift
//  Auth05
//
//  Created by Apple on 21.03.2025.
//

//import Foundation
//
//class ProfileService {
//    static func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
//        guard let url = URL(string: "http://localhost:3000/api/v1/profiles") else {
//            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
//                return
//            }
//
//            do {
//                let decodedProfile = try JSONDecoder().decode(Profile.self, from: data)
//                completion(.success(decodedProfile))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//
//        task.resume()
//    }
//}
