//
//  DetailViewModel.swift
//  Auth05
//
//  Created by Apple on 24.03.2025.
//

//import SwiftUI
//
//// MARK: - Детальный ViewModel
//final class DetailViewModel: ObservableObject {
//    @Published var postDetail: PostName?
//    @Published var collectionDetail: CollectionName?
//    @Published var isLoading = false
//    @Published var error: String?
//    
//    private var worker = MainWorker()
//    private var keychain = KeychainService()
//
//    enum Const {
//        static let tokenKey = "token"
//    }
//    
//    func fetchPostDetail(postId: Int) {
//        isLoading = true
//        error = nil
//        
//        let token = keychain.getString(forKey: Const.tokenKey) ?? ""
//        let request = Request(endpoint: MainEndpoint.postDetail(id: 113, token: token))
//        
//        worker.load(request: request) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                switch result {
//                case .success(let data):
//                    guard let data = data else {
//                        self?.error = "No data received"
//                        return
//                    }
//                    do {
//                        self?.postDetail = try JSONDecoder().decode(PostName.self, from: data)
//                    } catch {
//                        self?.error = "Failed to decode post: \(error.localizedDescription)"
//                    }
//                case .failure(let error):
//                    self?.error = error.localizedDescription
//                }
//            }
//        }
//    }
//    
//    func fetchCollectionDetail(collectionId: Int) {
//        isLoading = true
//        error = nil
//        
//        let token = keychain.getString(forKey: Const.tokenKey) ?? ""
//        let request = Request(endpoint: MainEndpoint.collectionDetail(id: 3, token: token))
//        
//        worker.load(request: request) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                switch result {
//                case .success(let data):
//                    guard let data = data else {
//                        self?.error = "No data received"
//                        return
//                    }
//                    do {
//                        self?.collectionDetail = try JSONDecoder().decode(CollectionName.self, from: data)
//                    } catch {
//                        self?.error = "Failed to decode collection: \(error.localizedDescription)"
//                    }
//                case .failure(let error):
//                    self?.error = error.localizedDescription
//                }
//            }
//        }
//    }
//}
