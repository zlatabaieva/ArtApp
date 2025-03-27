//
//  PostDetailView.swift
//  Auth05
//
//  Created by Apple on 24.03.2025.
//

//import SwiftUI
//struct PostDetailView: View {
//    @ObservedObject var viewModel: DetailViewModel
//    let postId: Int
//    
//    var body: some View {
//
//            if viewModel.isLoading {
//                ProgressView()
//            } else if let error = viewModel.error {
//                Text("Ошибка: \(error)")
//                    .foregroundColor(.red)
//            } else if let post = viewModel.postDetail {
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 20) {
//                        Text(post.title)
//                            .font(.largeTitle)
//                            .bold()
//                        
//                        AsyncImage(url: URL(string: post.postImage.url)) { image in
//                            image.resizable().scaledToFit()
//                        } placeholder: {
//                            ProgressView()
//                        }
//                        
//                        Text(post.body)
//                            .font(.body)
//                        
//                        // Дополнительные поля поста
//                        Text("Категории: \(post.categoryList.joined(separator: ", "))")
//                            .font(.subheadline)
//                        
//                        Text("Автор: \(post.profile)")
//                            .font(.subheadline)
//                    }
//                    .padding()
//                }
//            }
//        
//        .navigationTitle("Детали поста")
//    }
//}
//
