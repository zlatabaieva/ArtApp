//
//  Model.swift
//  Auth05
//
//  Created by Apple on 21.03.2025.
//

import SwiftUI

struct UserData: Codable {
    var name: String
    var description: String
}

struct MyView: View {
    @State var user: UserData
    var body: some View {
        VStack {
            Text(user.name)
            Text(user.description)
        }
    }
}

#Preview {
    var userData = UserData(name: "Some", description: "Amazing")
    if
        let data = UserDefaults.standard.data(forKey: "userdata"),
        let userInfo = try? JSONDecoder().decode(UserData.self, from: data)
    {
        userData = userInfo
    } else {
        let data = (try? JSONEncoder().encode(userData)) ?? Data()
        UserDefaults.standard.setValue(data, forKey: "userdata")
    }
    return MyView(user: userData)
}
