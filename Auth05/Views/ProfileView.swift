//
//  ProfileView.swift
//  Auth05
//
//  Created by Apple on 21.03.2025.
//
//import SwiftUI
//
//struct ProfileView: View {
//    let viewModel: ProfileViewModel
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                // Аватар
//                AsyncImage(url: URL(string: viewModel.avatar.url)) { image in
//                    image
//                        .resizable()
//                        .scaledToFill()
//                } placeholder: {
//                    ProgressView()
//                }
//                .frame(width: 100, height: 100)
//                .clipShape(Circle())
//
//                // Имя
//                Text(viewModel.name)
//                    .font(.title)
//                    .bold()
//
//                // Биография
//                Text(viewModel.bio)
//                    .font(.body)
//                    .multilineTextAlignment(.center)
//
//                // Контактная информация
//                Text(viewModel.contact)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//
//                // Список постов
//                ForEach(viewModel, id: \.id) { post in
//                    PostCard(post: post)
//                }
//            }
//            .padding()
//        }
//    }
//}
//
//struct PostCard: View {
//    let post: Post
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text(post.title)
//                .font(.headline)
//                .bold()
//
//            AsyncImage(url: URL(string: post.postImage.url)) { image in
//                image
//                    .resizable()
//                    .scaledToFit()
//            } placeholder: {
//                ProgressView()
//            }
//            .frame(maxWidth: .infinity)
//            .cornerRadius(10)
//
//            HStack {
//                ForEach(post.categoryList, id: \.self) { category in
//                    Text(category)
//                        .font(.caption)
//                        .padding(5)
//                        .background(Color.blue.opacity(0.2))
//                        .cornerRadius(5)
//                }
//            }
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(10)
//        .shadow(radius: 5)
//    }
//}
//
//
//
//
import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedTab: ProfileTab = .posts
    @State private var selectedPost: Post? = nil
    @State private var selectedCollection: Collection? = nil
    @State private var isDescriptionExpanded = false
    @State private var showAllTags = false
    
    enum ProfileTab {
        case posts
        case collections
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 8) {
                    if viewModel.gotProfiles, let profile = viewModel.profile {
                        profileHeader(profile: profile)
                        tabPicker
                        contentView(profile: profile)
                            .padding(.bottom, 70) // Отступ для нижней панели
                    } else if viewModel.gotError {
                        Text("Ошибка при загрузке данных")
                            .foregroundColor(.red)
                    } else {
                        ProgressView()
                    }
                }
                .background(Color(red: 0.98, green: 0.95, blue: 0.92))
                .frame(maxWidth: .infinity)
            }
            .edgesIgnoringSafeArea(.horizontal)

            CustomTabBar()
                .background(Color.white.ignoresSafeArea(.all, edges: .bottom))
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(item: $selectedPost) { post in
            PostDetailView(post: post)
        }
        .sheet(item: $selectedCollection) { collection in
            CollectionDetailView(collection: collection)
        }
        .onAppear {
            viewModel.getUsers()
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationViewStyle(.stack)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true) 
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
                        isActive: true
                    )
                    
                    
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
    // MARK: - Subviews
    
    private func profileHeader(profile: Profile) -> some View {

        
        return VStack(spacing: 0) {
  
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: profile.avatar.url)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(.top, 60)

                Text(profile.name)
                    .font(.title)
                    .bold()
                
                HStack(spacing: 20) {
                    VStack {
                        Text("ОЦЕНКИ")
                            .font(.caption)
                        Text("128")
                            .font(.headline)
                    }
                    
                    VStack {
                        Text("РАБОТ")
                            .font(.caption)
                        Text("9")
                            .font(.headline)
                    }
                    
                    VStack {
                        Text("КОЛЛЕКЦИЙ")
                            .font(.caption)
                        Text("2")
                            .font(.headline)
                    }
                    
                }
                .padding(.bottom, 4)
            }
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.839, green: 0.918, blue: 1.0))
            .cornerRadius(12)
            .ignoresSafeArea()
            
       
            VStack(alignment: .leading, spacing: 12) {
             
                Button(action: {
                    withAnimation {
                        isDescriptionExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text("Описание")
                            .font(.headline)
                        Image(systemName: isDescriptionExpanded ? "chevron.up" : "chevron.down")
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if isDescriptionExpanded {
                    VStack(alignment: .leading, spacing: 12) {
                        
                       
                        TagView(
                                    tags: profile.authorTags,
                                    showAll: $showAllTags,
                                    maxVisibleTags: maxVisibleTags
                                )
                        Text(profile.bio)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
    private let maxVisibleTags = 6
    struct TagView: View {
        let tags: [String]
        @Binding var showAll: Bool
        let maxVisibleTags: Int
        
      
        private let tagColors = [
            Color(red: 1.0, green: 0.58, blue: 0.83),
            Color(red: 0.18, green: 0.86, blue: 0.39),
            Color(red: 0.97, green: 0.85, blue: 0.01),
            Color(red: 0.42, green: 0.71, blue: 1.0)
        ]
        
       
        private func randomTagColor() -> Color {
            tagColors.randomElement() ?? tagColors[0]
        }
        
        var visibleTags: [String] {
            showAll ? tags : Array(tags.prefix(maxVisibleTags))
        }
        
        var remainingTagsCount: Int {
            max(tags.count - maxVisibleTags, 0)
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
               
                FlowLayout(spacing: 8) {
                    ForEach(visibleTags, id: \.self) { tag in
                        Text(tag)
                            .font(.headline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(randomTagColor())
                            .cornerRadius(10)
                            .foregroundColor(.black) // Белый текст для лучшей читаемости
                    }
                }
                
              
                if remainingTagsCount > 0 && !showAll {
                    Button(action: {
                        withAnimation {
                            showAll = true
                        }
                    }) {
                        Text("+\(remainingTagsCount)")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }



    struct FlowLayout: Layout {
        var spacing: CGFloat
        
        func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
            let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
            
            var totalWidth: CGFloat = 0
            var totalHeight: CGFloat = 0
            var lineWidth: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for size in sizes {
                if lineWidth + size.width + spacing > proposal.width ?? 0, lineWidth > 0 {
                    totalHeight += lineHeight + spacing
                    totalWidth = max(totalWidth, lineWidth)
                    lineWidth = 0
                    lineHeight = 0
                }
                
                lineWidth += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            
            totalHeight += lineHeight
            totalWidth = max(totalWidth, lineWidth - spacing)
            
            return CGSize(width: totalWidth, height: totalHeight)
        }
        
        func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
            var point = bounds.origin
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if point.x + size.width > bounds.maxX, point.x > bounds.minX {
                    point.x = bounds.minX
                    point.y += lineHeight + spacing
                    lineHeight = 0
                }
                
                subview.place(at: point, proposal: .unspecified)
                point.x += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
        }
    }

    struct InfoRow: View {
        let title: String
        let value: String
        
        var body: some View {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(value)
                    .font(.subheadline)
            }
        }
    }
                
    
    private var tabPicker: some View {
        Picker("Выберите вкладку", selection: $selectedTab) {
            Text("Посты").tag(ProfileTab.posts)
            Text("Коллекции").tag(ProfileTab.collections)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
        .padding(.top,12)
    }
    
    private func contentView(profile: Profile) -> some View {
        Group {
            switch selectedTab {
            case .posts:
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 8),
                                GridItem(.flexible(), spacing: 8)
                            ],
                            spacing: 8
                        ) {
                            ForEach(profile.posts, id: \.id) { post in
                                Button(action: {
                                    selectedPost = post
                                }) {
                                    PostCard(post: post)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 262)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
            case .collections:
                ScrollView {
                    VStack(spacing: 32) {
                        ForEach(profile.collections, id: \.id) { collection in
                            Button(action: {
                                selectedCollection = collection
                            }) {
                                CollectionCard(collection: collection)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                }
                
            }
        }
    }
}

// MARK: - Card Views

struct PostCard: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Изображение с фиксированной шириной
            AsyncImage(url: URL(string: post.postImage.url)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 140)
                        .clipped()
                } else {
                    Color.gray
                        .frame(maxWidth: .infinity)
                        .frame(height: 140)
                }
            }
            .cornerRadius(10)
            
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(post.categoryList, id: \.self) { category in
                        Text(category)
                            .font(.system(size: 12))
                    }
                }
            }
            Text(post.title)
                .font(.system(size: 14))
                .lineLimit(2)
                .frame(height: 40, alignment: .top)
            .frame(height: 30)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}
struct CollectionCard: View {
    let collection: Collection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 8) {
                Image("1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 80)
                    .clipped()
                    .cornerRadius(6)
                
                Image("2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 80)
                    .clipped()
                    .cornerRadius(6)
                
                Image("3")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 80)
                    .clipped()
                    .cornerRadius(6)
            }
            .frame(maxWidth: .infinity)
            
            // Заголовок
            Text(collection.title)
                .font(.headline)
                .bold()
                .padding(.top, 4)
            
            // Описание
            
            
            // Теги
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(collection.tagList, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 12))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .cornerRadius(12)
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
// MARK: - Detail Views

struct PostDetailView: View {
    let post: Post
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text(post.title)
                    .font(.largeTitle)
                    .bold()
                
                AsyncImage(url: URL(string: post.postImage.url)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Категории")
                        .font(.headline)
                    
                    HStack {
                        ForEach(post.categoryList, id: \.self) { category in
                            Text(category)
                                .padding(8)
                                .background(Color(red: 1.0, green: 0.58, blue: 0.83))
                                .cornerRadius(8)
                        }
                    }
                }
                
                    Text("Описание")
                        .font(.headline)
                    Text("Не польского польского роттердаме начала отличие и европа именно была.")
                        .font(.body)
                HStack(alignment: .top, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Стоимость")
                            .font(.headline)
                        Text("Город")
                            .font(.headline)
                        Text("Количество")
                            .font(.headline)
                    }
                    
                  
                    VStack(alignment: .leading, spacing: 10) {
                        Text("4200")
                            .font(.body)
                        Text("Москва")
                            .font(.body)
                        Text("9")
                            .font(.body)
                    }
                }
                
                
                
                Spacer()
            }
            .padding()
        }
    }
}

struct CollectionDetailView: View {
    let collection: Collection
    let images = ["1", "2", "3"]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(collection.title)
                        .font(.largeTitle)
                        .bold()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(images, id: \.self) { imageName in
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 250, height: 180) 
                                    .clipped()
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.horizontal, -16)
                    
                    Text(collection.body)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                
                // Теги
                VStack(alignment: .leading, spacing: 8) {
                    Text("Теги:")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(collection.tagList, id: \.self) { tag in
                                Text(tag)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(red: 0.18, green: 0.86, blue: 0.39))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(16)
        }
    }
}//struct AddWorkView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject var viewModel: ProfileViewModel
//    @State private var title: String = ""
//    @State private var description: String = ""
//    @State private var category: String = ""
//    @State private var selectedImage: UIImage?
//    @State private var showImagePicker = false
//    @State private var showError = false
//    @State private var errorMessage = ""
//    
//    let categories = ["Живопись", "Графика", "Скульптура", "Фотография", "Дизайн"]
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Основная информация")) {
//                    TextField("Название работы", text: $title)
//                    TextField("Описание", text: $description)
//                    
//                    Picker("Категория", selection: $category) {
//                        ForEach(categories, id: \.self) {
//                            Text($0)
//                        }
//                    }
//                }
//                
//                Section(header: Text("Изображение")) {
//                    Button(action: {
//                        showImagePicker = true
//                    }) {
//                        if let selectedImage = selectedImage {
//                            Image(uiImage: selectedImage)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(height: 200)
//                        } else {
//                            HStack {
//                                Image(systemName: "photo")
//                                Text("Выбрать изображение")
//                            }
//                        }
//                    }
//                }
//                
//                Section {
//                    Button("Сохранить работу") {
//                        saveWork()
//                    }
//                    .disabled(title.isEmpty || description.isEmpty || category.isEmpty || selectedImage == nil)
//                }
//            }
//            .navigationTitle("Новая работа")
//            .navigationBarItems(
//                leading: Button("Отмена") {
//                    presentationMode.wrappedValue.dismiss()
//                }
//            )
//            .sheet(isPresented: $showImagePicker) {
//                ImagePicker(image: $selectedImage)
//            }
//            .alert("Ошибка", isPresented: $showError) {
//                Button("OK", role: .cancel) { }
//            } message: {
//                Text(errorMessage)
//            }
//        }
//    }
//    
//    private func saveWork() {
//        guard let image = selectedImage,
//              let imageData = image.jpegData(compressionQuality: 0.8) else {
//            errorMessage = "Не удалось обработать изображение"
//            showError = true
//            return
//        }
//        
//        let newPost = Post(
//            id: 2,
//            title: title,
//            categoryList: [category],
//            postImage:[postImage], profile: <#ProfileClass#>
//        )
//        
//        viewModel.addPost(newPost)
//        presentationMode.wrappedValue.dismiss()
//    }
//}
