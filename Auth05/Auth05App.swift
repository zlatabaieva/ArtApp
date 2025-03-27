//
//  Auth05App.swift
//  Auth05
//
//  Created by Apple on 21.03.2025.
//

import SwiftUI

@main
struct Auth05App: App {
    @StateObject private var viewModel = ViewModel()
        @StateObject private var profileViewModel = ProfileViewModel()
    var body: some Scene {
        WindowGroup {
                ContentView(viewModel: ViewModel()).ignoresSafeArea(.all).padding(.horizontal, 0)
                    .edgesIgnoringSafeArea(.horizontal)
                //                .background(Color(red: 0.98, green: 0.95, blue: 0.92))
                    .environmentObject(ProfileViewModel())
            }
            
    }
}
