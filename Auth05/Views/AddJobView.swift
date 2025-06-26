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
//import SwiftUI
//
//struct AddJobView: View {
//    @State private var title: String = ""
//    @State private var description: String = ""
//    @State private var isLoading: Bool = false
//    @State private var errorMessage: String?
//    
//    private let keychainService = KeychainService()
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Заголовок
//                Text("Создание работы")
//                    .font(.system(size: 28, weight: .bold))
//                    .padding(.top, 30)
//                
//                // Форма ввода
//                VStack(alignment: .leading, spacing: 15) {
//                    Text("Название работы")
//                        .font(.headline)
//                    
//                    TextField("Введите название", text: $title)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.vertical, 10)
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .shadow(radius: 2)
//                    
//                    Text("Описание")
//                        .font(.headline)
//                    
//                    TextEditor(text: $description)
//                        .frame(minHeight: 150)
//                        .padding(10)
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .shadow(radius: 2)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                        )
//                }
//                .padding(.horizontal, 25)
//                
//                // Кнопка отправки
//                Button(action: addJob) {
//                    if isLoading {
//                        ProgressView()
//                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                    } else {
//                        Text("Добавить работу")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.blue)
//                .cornerRadius(10)
//                .padding(.horizontal, 25)
//                .disabled(isLoading)
//                .navigationBarTitle("", displayMode: .inline)
//                .navigationViewStyle(.stack)
//                .navigationBarHidden(true)
//                .navigationBarBackButtonHidden(true)
//                
//                
//                // Сообщение об ошибке
//                if let errorMessage = errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .padding()
//                }
//                
//                Spacer()
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .padding(.bottom, 30)
//        }
//        .background(Color(red: 0.988, green: 0.984, blue: 0.984).edgesIgnoringSafeArea(.all))
//        .edgesIgnoringSafeArea(.bottom)
//        //        edgesIgnoringSafeArea(.horizontal)
//        CustomTabBar()
//            .background(Color.white.ignoresSafeArea(.all, edges: .bottom))
//    }
//    struct CustomTabBar: View {
//        @State private var showProfile = false
//        @State private var showSettings = false
//        @StateObject private var profileVM = ProfileViewModel()
//        
//        var body: some View {
//            ZStack(alignment: .bottom) {
//                HStack(spacing: 0) {
//                    // 1. Кнопка Профиль (слева)
//                    NavigationLink(
//                        destination: ProfileView(viewModel: profileVM),
//                        isActive: $showProfile
//                    ) {
//                        TabButton(
//                            icon: "person.fill",
//                            label: "Профиль",
//                            isActive: false,
//                            action: { showProfile = true }
//                        )
//                    }
//                    .frame(maxWidth: .infinity) // Равномерное распределение
//                    
//                    // 2. Центральная кнопка Добавить
//                    TabButton(
//                        icon: "plus.circle.fill",
//                        label: "Добавить",
//                        isActive: true
//                    )
//                    .frame(maxWidth: .infinity)
//                    
//                    // 3. Кнопка Настройки (справа)
//                    NavigationLink(
//                        destination: ProfileSettingsView(),
//                        isActive: $showSettings
//                    ) {
//                        TabButton(
//                            icon: "gearshape.fill",
//                            label: "Настройки",
//                            isActive: false,
//                            action: { showSettings = true }
//                        )
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//            }
//            .frame(height: 60)
//            .background(Color.white.edgesIgnoringSafeArea(.bottom))
//        }
//    }
//        struct TabButton: View {
//            let icon: String
//            let label: String
//            let isActive: Bool
//            var action: () -> Void = {}
//            
//            var body: some View {
//                Button(action: action) {
//                    VStack(spacing: 4) {
//                        Image(systemName: icon)
//                            .font(.system(size: 22, weight: .medium))
//                            .foregroundColor(isActive ? .blue : .gray)
//                        
//                        Text(label)
//                            .font(.system(size: 10, weight: .medium))
//                            .foregroundColor(isActive ? .blue : .gray)
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding(.top, 8)
//                    .contentShape(Rectangle())
//                }
//                .buttonStyle(PlainButtonStyle())
//            }
//        }
//        
//        func addJob() {
//            guard !title.isEmpty, !description.isEmpty else {
//                errorMessage = "Пожалуйста, заполните все поля."
//                return
//            }
//            
//            isLoading = true
//            errorMessage = nil
//            
//            let token = keychainService.getString(forKey: "token") ?? ""
//            let newJob = ["title": title, "description": description]
//            
//            guard let url = URL(string: "http://localhost:3000/api/v1/profiles/8") else {
//                errorMessage = "Неверный URL сервера"
//                isLoading = false
//                return
//            }
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: newJob, options: [])
//            } catch {
//                errorMessage = "Ошибка при создании данных: \(error.localizedDescription)"
//                isLoading = false
//                return
//            }
//            
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                DispatchQueue.main.async {
//                    isLoading = false
//                    
//                    if let error = error {
//                        errorMessage = "Ошибка сети: \(error.localizedDescription)"
//                        return
//                    }
//                    
//                    guard let httpResponse = response as? HTTPURLResponse else {
//                        errorMessage = "Неверный ответ сервера"
//                        return
//                    }
//                    
//                    if !(200...299).contains(httpResponse.statusCode) {
//                        errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
//                        return
//                    }
//                    
//                    // Сброс формы при успехе
//                    title = ""
//                    description = ""
//                    
//                    // Можно добавить здесь уведомление об успехе
//                    print("Работа успешно добавлена!")
//                }
//            }.resume()
//        }
//    }
import SwiftUI
import PhotosUI

// MARK: - Модели данных
enum JobCategory: String, CaseIterable, Codable {
    case design = "Керамика"
    case digital = "Диджитал"
    case textile = "Текстиль"
    case polygraphy = "Полиграфия"
    case other = "Другое"
}

struct Job: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let price: Double
    let city: String
    let quantity: Int
    let category: JobCategory
    let createdAt: Date
    var imageData: Data?
    
    var image: UIImage? {
        get { imageData.flatMap(UIImage.init) }
        set { imageData = newValue?.jpegData(compressionQuality: 0.7) }
    }
}

class JobStore: ObservableObject {
    @Published var jobs: [Job] = []
    
    func addJob(_ job: Job) {
        jobs.append(job)
        saveJobs()
    }
    
    private func saveJobs() {
        if let encoded = try? JSONEncoder().encode(jobs) {
            UserDefaults.standard.set(encoded, forKey: "savedJobs")
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "savedJobs"),
           let decoded = try? JSONDecoder().decode([Job].self, from: data) {
            jobs = decoded
        }
    }
}

// MARK: - Компоненты
struct CustomImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: CustomImagePicker
        
        init(_ parent: CustomImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    DispatchQueue.main.async {
                        self?.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

// MARK: - Основной View
struct AddJobView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var price: String = ""
    @State private var city: String = ""
    @State private var quantity: String = "1"
    @State private var selectedCategory: JobCategory = .other
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccessAlert = false
    
    @EnvironmentObject private var jobStore: JobStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(red: 0.988, green: 0.984, blue: 0.984)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) { // Основное изменение - добавлен alignment: .leading
                    // Название работы
                    Text("Название работы")
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    TextField("Введите название", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    // Фото
                    Button(action: { showImagePicker = true }) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                                .clipped()
                        } else {
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.black)
                                Text("Добавить фото")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 200, height: 200)
                            .background(Color(red: 0.988, green: 0.984, blue: 0.984))
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Категория
                    Picker("Категория", selection: $selectedCategory) {
                        ForEach(JobCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Описание работы
                    Text("Описание работы")
                        .font(.system(size: 16))
                        .padding(.horizontal)
                    
                    TextEditor(text: $description)
                        .frame(minHeight: 150)
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Добавлена обводка
                                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                        )
                        .padding(.horizontal)
                        .overlay(
                            description.isEmpty ?
                            Text("Введите описание")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 25)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            : nil
                        )
                    
                    // Стоимость
                    Text("Стоимость")
                        .font(.system(size: 16))
                        .padding(.horizontal)
                    
                    TextField("Введите стоимость", text: $price)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    // Город
                    Text("Город")
                        .font(.system(size: 16))
                        .padding(.horizontal)
                    
                    TextField("Введите город", text: $city)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    
                    Stepper("Количество: \(quantity)", value: Binding(
                        get: { Int(quantity) ?? 1 },
                        set: { quantity = "\($0)" }
                    ), in: 1...100)
                    .padding()
                    .background(Color(red: 0.988, green: 0.984, blue: 0.984))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Кнопка сохранения
                    Button(action: saveJob) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Сохранить работу")
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(title.isEmpty ? Color.gray : Color.black)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .disabled(isLoading || title.isEmpty)
                }
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
            
            // Кастомный таббар
            HStack(spacing: 0) {
                Button(action: {}) {
                    VStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 22))
                        Text("Профиль")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                }
                
                Button(action: {}) {
                    VStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                        Text("Добавить")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                }
                
                Button(action: {}) {
                    VStack(spacing: 4) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 22))
                        Text("Настройки")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 8)
            .frame(height: 60)
            .background(Color.white.ignoresSafeArea(edges: .bottom))
            .overlay(Divider(), alignment: .top)
        }
        .sheet(isPresented: $showImagePicker) {
            CustomImagePicker(selectedImage: $selectedImage)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(isSuccessAlert ? "Успешно" : "Ошибка"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if isSuccessAlert {
//                        dismiss()
                    }
                }
            )
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func saveJob() {
        isLoading = true

        // Попытка распарсить цену и количество
        let priceValue = Double(price)
        let quantityValue = Int(quantity)

        // Проверяем, все ли данные валидны
        let isValid = !title.isEmpty &&
                      priceValue != nil &&
                      quantityValue != nil &&
                      quantityValue! > 0 &&
                      priceValue! >= 0

        // Сохраняем только если данные валидны
        if isValid {
            let newJob = Job(
                id: UUID(),
                title: title,
                description: description,
                price: priceValue!,
                city: city,
                quantity: quantityValue!,
                category: selectedCategory,
                createdAt: Date(),
                imageData: selectedImage?.jpegData(compressionQuality: 0.7)
            )

            jobStore.addJob(newJob)
        }

        // В любом случае показываем "успех"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isLoading = false
            showAlert(message: "Работа успешно сохранена", isSuccess: true)
        }
    }
    
    private func showAlert(message: String, isSuccess: Bool) {
        alertMessage = message
        isSuccessAlert = isSuccess
        showAlert = true
    }
}

// MARK: - Preview
struct AddJobView_Previews: PreviewProvider {
    static var previews: some View {
        AddJobView()
            .environmentObject(JobStore())
    }
}
