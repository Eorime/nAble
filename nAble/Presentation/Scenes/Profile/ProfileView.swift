import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm: ProfileViewModel
    @State private var showDeleteAlert = false
    @State private var deletePassword = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Profile")
                    .foregroundColor(Color("AppBlack"))
                    .font(.custom("FiraGO-Medium", size: 21))
                    .padding(.horizontal)

                if vm.isLoggedIn {
                    ProfileHeader(
                        fullName: vm.fullName,
                        username: vm.username,
                        email: vm.email,
                        onUpdateFullName: { vm.updateFullName($0) },
                        onUpdateUsername: { vm.updateUsername($0) }
                    )
                    FavoritePlaces(places: vm.favoritePlaces, onDelete: { place in
                        vm.deleteFavoritePlace(place)
                    })

                    if !vm.addedLocations.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("My Locations")
                                .font(.custom("FiraGO-Medium", size: 14))
                                .foregroundColor(Color("AppBlack"))
                                .padding(.horizontal)

                            ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(vm.addedLocations) { location in
                                    UserLocationCard(location: location, onDelete: {
                                           vm.deleteLocation(location)
                                       })
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .frame(height: 300)
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
