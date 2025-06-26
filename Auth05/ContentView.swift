//
//  ContentView.swift
//  Auth05
//
//  Created by Apple on 21.03.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @State private var login: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var showOnboarding: Bool = true
    @State private var showAuth: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
               
                if viewModel.gotToken {
                    ProfileView(viewModel: profileViewModel)
                        .transition(.opacity)
                }
                
              
                if showAuth {
                    AuthView(
                        viewModel: viewModel,
                        showAuth: $showAuth,
                        login: $login,
                        email: $email,
                        password: $password
                    )
                    .zIndex(1)
                    .transition(.opacity)
                }
                
                
                if showOnboarding {
                    OnboardingView(showOnboarding: $showOnboarding)
                        .zIndex(2)
                        .transition(.opacity)
                }
            }
            .animation(.default, value: showOnboarding)
            .animation(.default, value: showAuth)
            .animation(.default, value: viewModel.gotToken)
            .onAppear {
                showOnboarding = true
                showAuth = true
            }
        }
        .navigationViewStyle(.stack)
    }
}


struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    @State private var totalPages = 4
    var body: some View {
        TabView(selection: $currentPage) {
            
            OnboardingPage(
                image: "on1",
                currentPage: $currentPage,
                totalPages: 4,
                showOnboarding: $showOnboarding
            )
            .tag(0)
            
          
            OnboardingPage(
                image: "on2",
                currentPage: $currentPage,
                totalPages: 4,
                showOnboarding: $showOnboarding
            )
            .tag(1)
            
        
            OnboardingPage(
                image: "on3",
                currentPage: $currentPage,
                totalPages: 4,
                showOnboarding: $showOnboarding
            )
            .tag(2)
            
            
            OnboardingPage(
                image: "on4",
                currentPage: $currentPage,
                totalPages: 4,
                showOnboarding: $showOnboarding,
                isLastPage: true
            )
            .tag(3)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        
        .ignoresSafeArea(.all)
        .statusBar(hidden: true)
    }
}

// Один экран онбординга

struct OnboardingPage: View {
    let image: String
    @Binding var currentPage: Int
    let totalPages: Int
    @Binding var showOnboarding: Bool
    var isLastPage: Bool = false
    
    var body: some View {
        ZStack {
           
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
           
            VStack {
                Spacer()
                
                    .frame(height: 150)
            }
            .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                Spacer()
                
                if isLastPage {
                    Button(action: {
                        showOnboarding = false
                    }) {
                        Text("Начать")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(12)
                    }
                    .padding(16)
                    .padding(.bottom, 40)
                } else {
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Далее")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(12)
                    }
                    .padding(16)
                    .padding(.bottom, 40)
                }
            }
        }
        .ignoresSafeArea(.all)
        .statusBar(hidden: true)
    }
}

struct AuthView: View {
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @Binding var showAuth: Bool
    @Binding var login: String
    @Binding var email: String
    @Binding var password: String
    @State private var showProfile = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    // Основной контент
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            // Кнопка закрытия (при необходимости)
                            // Button(action: { showAuth = false }) {
                            //     Image(systemName: "xmark")
                            //         .font(.title2)
                            //         .foregroundColor(.black)
                            // }
                            .padding(.trailing)
                        }
                        
                        Image("a")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                        
                        // Группа полей ввода
                        Group {
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            TextField("Введите email", text: $email)
                                .textFieldStyle(.roundedBorder)
                                .foregroundColor(.black)
                            
                            Text("Пароль")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            SecureField("Введите пароль", text: $password)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding(.horizontal, 4)
                        
                        // Кнопка входа
                        Button(action: loginAction) {
                            Text("Войти")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(12)
                        }
                        .padding(.top, 20)
                        
                        // Ссылка на регистрацию
                        HStack {
                            Text("Нет аккаунта?")
                                .foregroundColor(.black)
                            
                            Button(action: { /* переход на регистрацию */ }) {
                                Text("Зарегистрироваться")
                                    .foregroundColor(.black)
                                    .underline()
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                    .frame(maxWidth: 500)
                    .frame(minHeight: geometry.size.height) // Важно: минимальная высота = высоте экрана
                }
            }
            .background(Color(red: 0.988, green: 0.984, blue: 0.984))
            .edgesIgnoringSafeArea(.all) // Игнорируем безопасные области
        }
    }

    private func loginAction() {
        if viewModel.gotToken {
            // Переход в профиль
        }
        showAuth = false
    }
        }
   

