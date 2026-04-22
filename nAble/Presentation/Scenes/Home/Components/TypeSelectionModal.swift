import SwiftUI

struct TypeSelectionModal: View {
    @ObservedObject var viewModel: HomeViewModel
    
    let types = [
        ("toilet", "Accessible Restroom"),
        ("car", "Accessible Parking"),
        ("chair", "Accessible Seating")
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            Text("What type of accessibility?")
                .font(.custom("FiraGO-SemiBold", size: 14))
                .foregroundColor(Color("AppGreen"))
            
            HStack(spacing: 14) {
                ForEach(types, id: \.0) { type in
                    Button {
                        viewModel.selectType(type.1)
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: type.0)
                                .font(.system(size: 18))
                                .foregroundColor(Color("AppGreen"))
                            Text(type.1)
                                .font(.custom("FiraGO-Regular", size: 10))
                                .foregroundColor(Color("AppGreen"))
                                .multilineTextAlignment(.center)
                        }
                        .padding(10)
                    }
                }
            }
        }
        .padding(10)
        .padding(.top, 10)
        .background(Color("AppBG"))
        .cornerRadius(10)
        .frame(maxWidth: 340)
    }
}
