import SwiftUI

struct AccessibilityBadge: View {
    let icon: String
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
            Text(label)
                .font(.custom("FiraGO-Regular", size: 11))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .foregroundColor(Color("AppGreen"))
    }
}
