import SwiftUI

struct ProfileHeader: View {
    let fullName: String
    let username: String
    let email: String
    let avatarUrl: String
    let onUpdateFullName: (String) -> Void
    let onUpdateUsername: (String) -> Void
    let onUpdateAvatar: (UIImage) -> Void

    @State private var isEditingFullName = false
    @State private var isEditingUsername = false
    @State private var fullNameInput = ""
    @State private var usernameInput = ""
    @State private var showImagePicker = false

    var body: some View {
        HStack(spacing: 12) {
            Button {
                showImagePicker = true
            } label: {
                if !avatarUrl.isEmpty, let url = URL(string: avatarUrl) {
                    CachedAsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color("AppGreen").opacity(0.2))
                    }
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .id(avatarUrl)
                } else {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(Color("AppGreen").opacity(0.6))
                }
            }
            .sheet(isPresented: $showImagePicker) {
                PhotoCaptureView { image in
                    if let image = image {
                        onUpdateAvatar(image)
                    }
                    showImagePicker = false
                }
                .presentationBackground(Color("AppBG"))
                .presentationDetents([.medium])
            }

            VStack(alignment: .leading, spacing: 4) {
                if isEditingFullName {
                    HStack {
                        TextField("Full Name", text: $fullNameInput)
                            .font(.custom("FiraGO-SemiBold", size: 18))
                            .foregroundColor(Color("AppBlack"))
                            .submitLabel(.done)
                            .onSubmit {
                                onUpdateFullName(fullNameInput)
                                isEditingFullName = false
                            }
                        Button {
                            onUpdateFullName(fullNameInput)
                            isEditingFullName = false
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color("AppGreen"))
                        }
                    }
                } else {
                    HStack {
                        Text(fullName.isEmpty ? "Full Name" : fullName)
                            .font(.custom("FiraGO-SemiBold", size: 18))
                            .foregroundColor(fullName.isEmpty ? Color("AppGray") : Color("AppBlack"))
                        Button {
                            fullNameInput = fullName
                            isEditingFullName = true
                        } label: {
                            Image(systemName: "pencil")
                                .font(.caption)
                                .foregroundColor(Color("AppGray"))
                        }
                    }
                }

                if isEditingUsername {
                    HStack {
                        TextField("Username", text: $usernameInput)
                            .font(.custom("FiraGO-Regular", size: 14))
                            .foregroundColor(Color("AppBlack"))
                            .submitLabel(.done)
                            .onSubmit {
                                onUpdateUsername(usernameInput)
                                isEditingUsername = false
                            }
                        Button {
                            onUpdateUsername(usernameInput)
                            isEditingUsername = false
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color("AppGreen"))
                        }
                    }
                } else {
                    HStack {
                        Text(username.isEmpty ? "Username" : username)
                            .font(.custom("FiraGO-Regular", size: 14))
                            .foregroundColor(username.isEmpty ? .secondary : Color("AppBlack"))
                        Button {
                            usernameInput = username
                            isEditingUsername = true
                        } label: {
                            Image(systemName: "pencil")
                                .font(.caption)
                                .foregroundColor(Color("AppGray"))
                        }
                    }
                }

                Text(email)
                    .font(.custom("FiraGO-Regular", size: 13))
                    .foregroundColor(Color("AppGray"))
            }
        }
        .padding(.horizontal)
    }
}
