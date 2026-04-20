import CoreLocation

protocol LocationServiceProtocol {
    func requestLocationPermission()
    func getCurrentLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void)
    func startMonitoringLocation(callback: @escaping (CLLocationCoordinate2D) -> Void)
    func stopMonitoringLocation()
}

class LocationService: NSObject, LocationServiceProtocol {
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?
    private var continuousCallback: ((CLLocationCoordinate2D) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        self.locationCompletion = completion
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            completion(.failure(LocationError.permissionDenied))
        @unknown default:
            completion(.failure(LocationError.unknown))
        }
    }
    
    func startMonitoringLocation(callback: @escaping (CLLocationCoordinate2D) -> Void) {
        self.continuousCallback = callback
        locationManager.startUpdatingLocation()
    }
    
    func stopMonitoringLocation() {
        locationManager.stopUpdatingLocation()
        continuousCallback = nil
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let coordinate = location.coordinate
        
        locationCompletion?(.success(coordinate))
        locationCompletion = nil
        
        continuousCallback?(coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                print("location unknown yet, waiting")
                return
            case .denied:
                locationCompletion?(.failure(LocationError.permissionDenied))
                locationCompletion = nil
            default:
                locationCompletion?(.failure(error))
                locationCompletion = nil
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        }  else if status == .denied || status == .restricted {
            locationCompletion?(.failure(LocationError.permissionDenied))
            locationCompletion = nil
        }
    }
}

enum LocationError: Error {
    case permissionDenied
    case locationUnavailable
    case unknown
}
