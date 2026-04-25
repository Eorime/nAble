import SwiftUI

struct ProfileHeader: View {
    let fullName: String
    let username: String
    let email: String
    let onUpdateFullName: (String) -> Void
    let onUpdateUsername: (String) -> Void

    @State private var isEditingFullName = false
    @State private var isEditingUsername = false
    @State private var fullNameInput = ""
    @State private var usernameInput = ""

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(Color("AppGreen").opacity(0.6))

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
                        Text(username.isEmpty ? "Username" : "\(username)")
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
