import SwiftUI
import PhotosUI

struct PhotoCaptureView: View {
    var onComplete: (UIImage?) -> Void
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showCamera = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Add a photo (optional)")
                .font(.custom("FiraGO-SemiBold", size: 14))
                .foregroundColor(Color("AppGreen"))

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            HStack(spacing: 12) {
                Button {
                    showCamera = true
                } label: {
                    Label("Camera", systemImage: "camera")
                        .font(.custom("FiraGO-Regular", size: 13))
                        .foregroundColor(Color("AppGreen"))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color("AppGreen").opacity(0.1))
                        .cornerRadius(8)
                }

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Library", systemImage: "photo")
                        .font(.custom("FiraGO-Regular", size: 13))
                        .foregroundColor(Color("AppGreen"))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color("AppGreen").opacity(0.1))
                        .cornerRadius(8)
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            selectedImage = image
                        }
                    }
                }
            }

            HStack(spacing: 12) {
                Button {
                    onComplete(nil)
                } label: {
                    Text("Skip")
                        .font(.custom("FiraGO-Regular", size: 13))
                        .foregroundColor(.gray)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }

                Button {
                    onComplete(selectedImage)
                } label: {
                    Text("Continue")
                        .font(.custom("FiraGO-SemiBold", size: 13))
                        .foregroundColor(Color("AppBG"))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color("AppGreen"))
                        .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color("AppBG"))
        .cornerRadius(10)
        .frame(maxWidth: 340)
        .sheet(isPresented: $showCamera) {
            CameraPickerView(image: $selectedImage)
        }
    }
}
