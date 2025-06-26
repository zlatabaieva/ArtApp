//
//  ProfileSettingsView.swift
//  Auth05
//
//  Created by Apple on 26.03.2025.
//
import SwiftUI

struct ProfileSettingsView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var avatarImage: UIImage?
    @State private var showImagePicker = false
    @State private var showLogoutAlert = false
    @State private var showSaveSuccess = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var showProfileView = false
    
    @State private var editedName: String = ""
    @State private var editedBio: String = ""
    @State private var editedContact: String = ""
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Form {
                    avatarSection
                    personalInfoSection
                    actionsSection
                    
                }
                
                
                NavigationLink(
                    destination: ProfileView(viewModel: viewModel),
                    isActive: $showProfileView,
                    label: { EmptyView() }
                ).hidden()
                    .background(Color(red: 0.98, green: 0.95, blue: 0.92))
                CustomTabBar(showProfileView: $showProfileView)
                
            }
        }
        .navigationViewStyle(.stack)
        .background(Color(red: 0.98, green: 0.95, blue: 0.92))
        .navigationBarHidden(true) // Скрывает навигационную панель
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $avatarImage)
        }
        .alert("Изменения сохранены", isPresented: $showSaveSuccess) {
            Button("OK", role: .cancel) { }
        }
        .alert("Ошибка", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .alert("Выход", isPresented: $showLogoutAlert) {
            Button("Выйти", role: .destructive, action: logout)
            Button("Отмена", role: .cancel) { }
        } message: {
            Text("Вы уверены, что хотите выйти?")
        }
        .onAppear(perform: loadInitialData)
        .onChange(of: viewModel.profile) { _ in
            updateLocalFields()
        }
    }
    
    private var avatarSection: some View {
        Section {
            HStack {
                Spacer()
                Button(action: { showImagePicker = true }) {
                    if let avatarImage = avatarImage {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 20)
            .listRowBackground(Color.clear)
        }
        .listRowInsets(EdgeInsets())
    }
    
    private var personalInfoSection: some View {
        Section(header: Text("Личная информация")) {
            TextField("Имя", text: $editedName)
            TextField("Контакт", text: $editedContact)
                .keyboardType(.emailAddress)
        }
    }
    
    private var actionsSection: some View {
        Section {
            Button(action: saveChangesLocally) {
                
                Text("Сохранить изменения")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(12)
                
                
            }
            
            Button(action: resetToOriginal) {
                
                Text("Сбросить")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                    )
                
            }
            
            Button(action: { showLogoutAlert = true }) {
                Text("Выйти")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
            Button(action: { showLogoutAlert = true }) {
                Text("Удалить")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red, lineWidth: 1)
                    )
            }
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
    }


    private func loadInitialData() {
        if viewModel.profile == nil {
            viewModel.getUsers()
        }
        loadSavedAvatar()
        updateLocalFields()
    }
    
    private func updateLocalFields() {
        guard let profile = viewModel.profile else { return }
        editedName = profile.name
        editedBio = profile.bio
        editedContact = profile.contact
        
        if avatarImage == nil {
            loadAvatar(from: profile.avatar.url)
        }
    }
    
    private func loadAvatar(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    avatarImage = image
                }
            }
        }.resume()
    }
    private func resetToOriginal() {
        guard let originalProfile = viewModel.profile else {
            errorMessage = "Не удалось загрузить оригинальные данные"
            showErrorAlert = true
            return
        }
        
        editedName = originalProfile.name
        editedBio = originalProfile.bio
        editedContact = originalProfile.contact
        
 
        avatarImage = nil
        loadAvatar(from: originalProfile.avatar.url)
        
        
        let fileURL = getAvatarFilePath()
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
    private func saveChangesLocally() {
        guard let currentProfile = viewModel.profile else {
            errorMessage = "Профиль не загружен"
            showErrorAlert = true
            return
        }
        
        guard !editedName.isEmpty else {
            errorMessage = "Имя не может быть пустым"
            showErrorAlert = true
            return
        }
        
        do {
            let updatedProfile = Profile(
                name: editedName,
                bio: editedBio,
                avatar: currentProfile.avatar,
                contact: editedContact,
                authorTags: currentProfile.authorTags,
                posts: currentProfile.posts,
                collections: currentProfile.collections
            )
            
            viewModel.profile = updatedProfile
            saveAvatarLocally()
            showSaveSuccess = true
            
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
        } catch {
            errorMessage = "Ошибка при сохранении: \(error.localizedDescription)"
            showErrorAlert = true
        }
    }
    
    private func saveAvatarLocally() {
        guard let avatarImage = avatarImage,
              let data = avatarImage.jpegData(compressionQuality: 0.8) else { return }
        
        do {
            try data.write(to: getAvatarFilePath())
        } catch {
            print("Ошибка сохранения аватара: \(error)")
        }
    }
    
    private func loadSavedAvatar() {
        let fileURL = getAvatarFilePath()
        if FileManager.default.fileExists(atPath: fileURL.path),
           let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            avatarImage = image
        }
    }
    
    private func getAvatarFilePath() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("userAvatar.jpg")
    }
    
    private func logout() {
        print("Пользователь вышел")
    }
}


struct CustomTabBar: View {
    @Binding var showProfileView: Bool
    @State private var showAddMenu = false
    @State private var selectedTab: Tab = .settings
    
    enum Tab {
        case profile
        case settings
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Кнопка профиля
            Button {
                showProfileView = true
                selectedTab = .profile
            } label: {
                TabButton(
                    icon: "person.fill",
                    label: "Профиль",
                    isActive: selectedTab == .profile
                )
            }
            
            // Центральная кнопка "Добавить"
            ZStack {
                TabButton(
                    icon: showAddMenu ? "xmark.circle.fill" : "plus.circle.fill",
                    label: "Добавить",
                    isActive: false,
                    action: {
                        withAnimation(.spring()) {
                            showAddMenu.toggle()
                        }
                    }
                )
                
                if showAddMenu {
                    AddMenu(showAddMenu: $showAddMenu)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Кнопка настроек
            Button {
                selectedTab = .settings
            } label: {
                TabButton(
                    icon: "gearshape.fill",
                    label: "Настройки",
                    isActive: selectedTab == .settings
                )
            }
        }
        .frame(height: 70)
        .background(Color.white)
        .overlay(Divider(), alignment: .top)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct AddMenu: View {
    @Binding var showAddMenu: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: {
                showAddMenu = false
             
            }) {
                HStack {
                    Image(systemName: "doc.fill")
                        .foregroundColor(.blue)
                    Text("Добавить")
                        .foregroundColor(.primary)
                }
            }
            
            Divider()
            
            Button(action: {
                showAddMenu = false
            
            }) {
                HStack {
                    Image(systemName: "folder.fill")
                        .foregroundColor(.blue)
                    Text("Добавить")
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

struct TabButton: View {
    let icon: String
    let label: String
    let isActive: Bool
    var action: () -> Void = {}
    
    var body: some View {
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
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
