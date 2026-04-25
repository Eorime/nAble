import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm: ProfileViewModel
    @State private var showDeleteAlert = false
    @State private var deletePassword = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Profile")
                    .foregroundColor(Color("AppBlack"))
                    .font(.custom("FiraGO-SemiBold", size: 24))
                    .padding(.horizontal)

                if vm.isLoggedIn {
                    FavoritePlaces(places: vm.favoritePlaces)

                    if !vm.addedLocations.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("My Locations")
                                .font(.custom("FiraGO-SemiBold", size: 18))
                                .foregroundColor(Color("AppBlack"))
                                .padding(.horizontal)

                            LazyVStack(spacing: 10) {
                                ForEach(vm.addedLocations) { location in
                                    UserLocationCard(location: location)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }

                    VStack(spacing: 12) {
                        Button {
                            vm.logOut()
                        } label: {
                            Text("Log Out")
                                .font(.custom("FiraGO-Medium", size: 16))
                                .foregroundColor(Color("AppWhite"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color("AppGreen"))
                                .cornerRadius(8)
                        }

                        Button {
                            showDeleteAlert = true
                        } label: {
                            Text("Delete Account")
                                .font(.custom("FiraGO-Medium", size: 16))
                                .foregroundColor(Color("AppRed"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color("AppRed").opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)

                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 64))
                            .foregroundColor(Color("AppGreen").opacity(0.4))
                        Text("Join n'Able to enable (｡•̀ᴗ-) \nsaving places and adding new locations")
                            .font(.custom("FiraGO-Regular", size: 15))
                            .foregroundColor(Color("AppGray"))
                            .multilineTextAlignment(.center)

                        Button {
                            vm.coordinator?.showAuth()
                        } label: {
                            Text("Log In")
                                .font(.custom("FiraGO-Medium", size: 16))
                                .foregroundColor(Color("AppWhite"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color("AppGreen"))
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.top, 80)
                }
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBG"))
        .onAppear {
            vm.loadData()
        }
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            SecureField("Enter password", text: $deletePassword)
            Button("Delete", role: .destructive) {
                vm.deleteAccount(password: deletePassword)
                deletePassword = ""
            }
            Button("Cancel", role: .cancel) {
                deletePassword = ""
            }
        } message: {
            Text("This action is permanent and cannot be undone. Please enter your password to confirm.")
        }
    }
}
