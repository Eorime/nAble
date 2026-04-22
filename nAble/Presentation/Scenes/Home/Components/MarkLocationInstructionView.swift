import SwiftUI

struct MarkLocationInstructionView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 21))
                .foregroundColor(Color("AppGreen"))
            
            Text("Mark the location!")
                .font(.custom("Firago-Regular", size: 11))
                .foregroundColor(Color("AppGreen"))
        }
        .padding(15)
        .background(Color("AppBG"))
        .cornerRadius(8)
    }
}
