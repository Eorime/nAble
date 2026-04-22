import SwiftUI
import MapKit
import CoreLocation

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var selectedLocation: UserLocationModel?
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        ZStack {
            mapLayer
            locationControls
            addButton
        }
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
        .onChange(of: viewModel.userLocation) { _, newLocation in
            guard let location = newLocation else { return }
            withAnimation {
                cameraPosition = .region(MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))
            }
        }
        .animation(.easeInOut, value: viewModel.isAddingLocation)
        .animation(.easeInOut, value: viewModel.currentStep)
    }
    
    private var mapLayer: some View {
        MapReader { proxy in
            Map(position: $cameraPosition) {
                ForEach(viewModel.locations) { location in
                    Annotation("", coordinate: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.green)
                            .font(.title)
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
    
    private var locationControls: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    guard let location = viewModel.userLocation else { return }
                    withAnimation {
                        cameraPosition = .region(MKCoordinateRegion(
                            center: location,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
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
                        Button {
                            viewModel.startAddingLocation()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                                .frame(width: 56, height: 56)
                                .background(Color("AppGreen"))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .zIndex(999)
    }
}
