import SwiftUI
import MapKit
import CoreLocation

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var selectedLocation: UserLocationModel?
    
    var body: some View {
        ZStack {
            mapLayer
            addLocationOverlay
            locationControls
            addButton
            if let location = selectedLocation {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedLocation = nil
                    }
                   
            LocationDetailModal(location: location)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: selectedLocation == nil)
        .navigationBarHidden(true)
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
        .onAppear {
            viewModel.requestLocation()
            Task {
                await viewModel.loadLocations()
            }
        }
        .onChange(of: viewModel.isLoading) { isLoading in
            if isLoading {
                LoaderManager.shared.show()
            } else {
                LoaderManager.shared.hide()
            }
        }
        .animation(.easeInOut, value: viewModel.isAddingLocation)
        .animation(.easeInOut, value: viewModel.currentStep)
    }
    
    private var mapLayer: some View {
        MapReader { proxy in
            Map(position: $viewModel.cameraPosition) {
                ForEach(viewModel.locations) { location in
                    Annotation("", coordinate: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )) {
                        Button {
                            selectedLocation = location
                        } label: {
                            Image(location.locationId)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
                        }
                    }
                    .tag(location)
                }
                UserAnnotation()
            }
            .mapStyle(.standard)
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            .onTapGesture { screenCoordinate in
                if viewModel.currentStep == .markLocation {
                    if let coordinate = proxy.convert(screenCoordinate, from: .local) {
                        viewModel.handleMapTap(at: coordinate)
                    }
                }
            }
        }
    }
    
    private var addLocationOverlay: some View {
        Group {
            if viewModel.isAddingLocation {
                ZStack {
                    if viewModel.currentStep != .markLocation {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                    }
                    modalContent
                }
                .animation(.easeInOut(duration: 0.2), value: viewModel.currentStep)
            }
        }
    }
    
    private var modalContent: some View {
        VStack {
            Spacer()
            switch viewModel.currentStep {
            case .selectType:
                TypeSelectionModal(viewModel: viewModel)
            case .markLocation:
                MarkLocationInstructionView()
                    .allowsHitTesting(false)
            case .addPhoto:
                PhotoCaptureView { image in
                    viewModel.confirmPhoto(image)
                }
            }
            Spacer()
        }
        .allowsHitTesting(viewModel.currentStep != .markLocation)
    }
    
    private var locationControls: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    guard let location = viewModel.userLocation else { return }
                    withAnimation {
                        viewModel.cameraPosition = .region(MKCoordinateRegion(
                            center: location,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        ))
                    }
                } label: {
                    Image(systemName: "location.fill")
                        .foregroundColor(Color("AppGreen"))
                        .font(.system(size: 20))
                        .frame(width: 21, height: 21)
                        .padding(16)
                        .background(Color("AppBG"))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding(.leading, 20)
                .padding(.bottom, 20)
                
                Spacer()
            }
        }
    }
    
    private var addButton: some View {
        Group {
            if viewModel.isLoggedIn {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddLocationButton(vm: viewModel)
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                    }
                }
            }
        }
        .zIndex(999)
    }
}
