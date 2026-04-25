import SwiftUI

struct ProfileView: View {
    @StateObject var vm: ProfileViewModel
    
    var body: some View {
            Text("Profile")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("AppBG"))
        
    }
}
