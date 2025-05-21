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
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
//                    Button(action: { showAuth = false }) {
//                        Image(systemName: "xmark")
//                            .font(.title2)
//                            .foregroundColor(.black)
//                    }
                    .padding(.trailing)
                }
                
                Image("a")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                    
            }
            Text("Почта")
                .font(.headline)
                .foregroundColor(.black)
                .padding(4)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("user_6@email.com", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
                    .foregroundColor(.black)
            Text("Пароль")
                .foregroundColor(.black)
                .font(.headline)
                .padding(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                SecureField("testtest", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
                
//                Button(action: {
//                    if viewModel.gotToken {
//                        
//                        NavigationView {
//                            ProfileView(viewModel: profileViewModel)
//                        }
//                    }
//                    showAuth = false
//                }) {
//            Button(action: {
//                showAuth = false })
                            Button(action: {
                                if viewModel.gotToken {
            
                                    NavigationView {
                                        ProfileView(viewModel: profileViewModel)
                                    }
                                }
                                showAuth = false
                            })   {
                        Text("Войти")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(12)
                }
//                .disabled(login.isEmpty || password.isEmpty)
                .padding(.top, 20)
                }
                .padding()
                .frame(maxWidth: 500)
                .background(Color(red: 0.98, green: 0.95, blue: 0.92))
            }
          
        }
   

