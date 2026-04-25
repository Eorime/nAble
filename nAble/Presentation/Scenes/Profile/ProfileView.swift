import SwiftUI

struct ProfileView: View {
    @ObservedObject var vm: ProfileViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Profile")
                    .foregroundColor(Color("AppBlack"))
                    .font(.custom("FiraGO-SemiBold", size: 24))
                    .padding(.horizontal)
                
                FavoritePlaces(places: vm.favoritePlaces)
            }
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBG"))
        .onAppear {
            vm.loadData()
        }
    }
    
}
