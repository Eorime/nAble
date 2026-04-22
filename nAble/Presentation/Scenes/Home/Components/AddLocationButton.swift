import SwiftUI

struct AddLocationButton: View {
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        Button {
            if vm.isAddingLocation {
                vm.cancelAddingLocation()
            } else {
                vm.startAddingLocation()
            }
        } label: {
            Image("plusIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 21, height: 21)
                .foregroundColor(vm.isAddingLocation ? Color("AppBG") : Color("AppGreen"))
                .rotationEffect(.degrees(vm.isAddingLocation ? 45 : 0))
                .padding()
                .background(vm.isAddingLocation ? Color("AppGreen") : Color("AppBG"))
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}
