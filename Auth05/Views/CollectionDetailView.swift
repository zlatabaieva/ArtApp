//
//  CollectionDetailView.swift
//  Auth05
//
//  Created by Apple on 24.03.2025.
//
//import SwiftUI
//// MARK: - Детальные экраны
//struct CollectionDetailView: View {
//    @ObservedObject var viewModel: DetailViewModel
//    let collectionId: Int
//    
//    var body: some View {
//            if viewModel.isLoading {
//                ProgressView()
//            } else if let error = viewModel.error {
//                Text("Ошибка: \(error)")
//                    .foregroundColor(.red)
//            } else if let collection = viewModel.collectionDetail {
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 20) {
//                        Text(collection.title)
//                            .font(.largeTitle)
//                            .bold()
//                        
//                        Text(collection.body)
//                            .font(.body)
//
//                        
//                    }
//                    .padding()
//                }
//            }
//    }
//}
