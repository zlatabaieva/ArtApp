//
//  ProfileViewModel.swift
//  Auth05
//
//  Created by Apple on 23.03.2025.
//

//import SwiftUI
//final class ProfileViewModel: ObservableObject {
//    private var worker = MainWorker()
//    private var keychain = KeychainService()
//    enum Const {
//        static let tokenKey = "token"
//    }
//    func getUsers() {
//        let token = keychain.getString(forKey: Const.tokenKey) ?? ""
//        let request = Request(endpoint: MainEndpoint.profiles(number: 8, token: token))
//        worker.load(request: request) { result in
//            switch result {
//            case .failure(_):
//                print("gotError = true ")
//            case .success(let data):
//                guard let data else {
//                    print("gotError = true ")
//                    return
//                }
//                
//                print(String(JSONDecoder().decode(ProfileView.self, data)))
//            }
//        }
//    }
//}
import SwiftUI
import Foundation

final class ProfileViewModel: ObservableObject {
    @Published var gotProfiles: Bool = false
    @Published var gotError: Bool = false
    @Published var profile: Profile? = nil

    private var worker = MainWorker()
    private var keychain = KeychainService()

    enum Const {
        static let tokenKey = "token"
    }

    func getUsers() {
        let token = keychain.getString(forKey: Const.tokenKey) ?? ""
        let request = Request(endpoint: MainEndpoint.profiles(number: 8, token: token))

        worker.load(request: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(_):
                    self?.gotError = true
                    self?.gotProfiles = false
                case .success(let data):
                    guard let data = data else {
                        self?.gotError = true
                        self?.gotProfiles = false
                        return
                    }

                    do {
                        let decodedProfile = try JSONDecoder().decode(Profile.self, from: data)
                        self?.profile = decodedProfile
                        self?.gotProfiles = true
                        self?.gotError = false
                    } catch {
                        print("Failed to decode JSON: \(error)")
                        self?.gotError = true
                        self?.gotProfiles = false
                    }
                }
            }
        }
    }
}
