import SwiftUI

struct TypeSelectionModal: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var selectedCategory: Category? = nil
    let accessibilityTypes = LocationType.all.filter { ["friendly", "friendlyParking", "friendlyWC"].contains($0.id) }
    let problemTypes = LocationType.all.filter { !["friendly", "friendlyParking", "friendlyWC"].contains($0.id) }
    
    enum Category {
        case accessibility, problem
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if selectedCategory == nil {
                categorySelection
            } else {
                typeSelection
            }
        }
        .padding(16)
        .background(Color("AppBG"))
        .cornerRadius(10)
        .frame(maxWidth: 340)
    }
    
    private var categorySelection: some View {
        VStack(spacing: 12) {
            Text("What are you marking?")
                .font(.custom("FiraGO-SemiBold", size: 14))
                .foregroundColor(Color("AppGreen"))
            
            HStack(spacing: 14) {
                categoryButton(title: "Accessibility", color: Color("AppGreen")) {
                    selectedCategory = .accessibility
                }
                categoryButton(title: "Problem", color: Color.orange) {
                    selectedCategory = .problem
                }
            }
        }
    }
    
    private var typeSelection: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    selectedCategory = nil
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(headerColor)
                }
                Spacer()
                Text(selectedCategory == .accessibility ? "Accessibility" : "Problem")
                    .font(.custom("FiraGO-SemiBold", size: 14))
                    .foregroundColor(headerColor)
                Spacer()
            }
            
            let types = selectedCategory == .accessibility ? accessibilityTypes : problemTypes
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(types, id: \.0) { type in
                    Button {
                        viewModel.selectType(type.0)
                    } label: {
                        VStack(spacing: 6) {
                            Image(type.id)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text(type.name)
                                .font(.custom("FiraGO-Regular", size: 10))
                                .foregroundColor(colorForType(type.0))
                                .multilineTextAlignment(.center)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(colorForType(type.0).opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
    
    private func categoryButton(title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.custom("FiraGO-SemiBold", size: 13))
                .foregroundColor(color)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(color.opacity(0.1))
                .cornerRadius(8)
        }
    }
    
    private var headerColor: Color {
        selectedCategory == .problem ? Color.orange : Color("AppGreen")
    }
    
    private func colorForType(_ typeId: String) -> Color {
        switch typeId {
        case "roughRoad", "roughElevation", "stairs":
            return Color("AppRed")
        case "mildElevation", "mildRoad", "railedStairs":
            return Color.orange
        default:
            return Color("AppGreen")
        }
    }
}
