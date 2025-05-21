//
//  AddJobView.swift
//  Auth05
//
//  Created by Apple on 14.05.2025.
//

//import SwiftUI
//import Foundation
//struct AddJobView: View {
//    var body: some View {
//        VStack {
//            Text("Создание работы")
//                
//        }
//        .background(Color(red: 0.98, green: 0.95, blue: 0.92))
//    }
//}
import SwiftUI

struct AddJobView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    private let keychainService = KeychainService()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Заголовок
                Text("Создание работы")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 30)
                
                // Форма ввода
                VStack(alignment: .leading, spacing: 15) {
                    Text("Название работы")
                        .font(.headline)
                    
                    TextField("Введите название", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    
                    Text("Описание")
                        .font(.headline)
                    
                    TextEditor(text: $description)
                        .frame(minHeight: 150)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 25)
                
                // Кнопка отправки
                Button(action: addJob) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Добавить работу")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal, 25)
                .disabled(isLoading)
                .navigationBarTitle("", displayMode: .inline)
                .navigationViewStyle(.stack)
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                
                
                // Сообщение об ошибке
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 30)
        }
        .background(Color(red: 0.98, green: 0.95, blue: 0.92).edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.bottom)
//        edgesIgnoringSafeArea(.horizontal)
        CustomTabBar()
            .background(Color.white.ignoresSafeArea(.all, edges: .bottom))
    }
    struct CustomTabBar: View {
        @State private var showAddMenu = false
        @State private var showSettings = false
        @StateObject private var profileVM = ProfileViewModel()
        var body: some View {
            ZStack(alignment: .bottom) {
             
                HStack(spacing: 0) {
                  
                    TabButton(
                        icon: "person.fill",
                        label: "Профиль",
                        isActive: false
                    )
                    
                    
                    ZStack {
                        TabButton(
                            icon: showAddMenu ? "xmark.circle.fill" : "plus.circle.fill",
                            label: "Добавить",
                            isActive: true,
                            action: {
                                withAnimation(.spring()) {
                                    showAddMenu.toggle()
                                }
                            }
                        )
                        
                       
                        if showAddMenu {
                            VStack(spacing: 12) {
                                Button(action: {
                                    showAddMenu = false
                                   
                                }) {
                                    HStack {
                                        NavigationLink(
                                            destination: AddJobView()
                                        ){
                                            Text("Добавить работу")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                                
                                Divider()
                                
                                Button(action: {
                                    showAddMenu = false
                                 
                                }) {
                                    HStack {
                                        
                                        Text("Добавить коллекцию")
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .shadow(radius: 5)
                            )
                            .frame(width: 220)
                            .offset(y: -100)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                  
                    NavigationLink(
                        destination: ProfileSettingsView(),
                        isActive: $showSettings
                    ) {
                        TabButton(
                            icon: "gearshape.fill",
                            label: "Настройки",
                            isActive: false,
                            action: { showSettings = true }
                        )
                    }
                }
                .frame(height: 70)
                .background(Color.white.edgesIgnoringSafeArea(.bottom))
                .overlay(Divider(), alignment: .top)
                .padding(.bottom, 30)
            }
        }
    }

    struct TabButton: View {
        let icon: String
        let label: String
        let isActive: Bool
        var action: () -> Void = {}
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(isActive ? .blue : .gray)
                    
                    Text(label)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(isActive ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    func addJob() {
        guard !title.isEmpty, !description.isEmpty else {
            errorMessage = "Пожалуйста, заполните все поля."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let token = keychainService.getString(forKey: "token") ?? ""
        let newJob = ["title": title, "description": description]
        
        guard let url = URL(string: "http://localhost:3000/api/v1/profiles/8") else {
            errorMessage = "Неверный URL сервера"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: newJob, options: [])
        } catch {
            errorMessage = "Ошибка при создании данных: \(error.localizedDescription)"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    errorMessage = "Ошибка сети: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    errorMessage = "Неверный ответ сервера"
                    return
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
                    return
                }
                
                // Сброс формы при успехе
                title = ""
                description = ""
                
                // Можно добавить здесь уведомление об успехе
                print("Работа успешно добавлена!")
            }
        }.resume()
    }
}

