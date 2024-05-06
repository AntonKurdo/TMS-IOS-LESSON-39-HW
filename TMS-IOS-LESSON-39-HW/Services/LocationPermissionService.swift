import Foundation
import UIKit
import CoreLocation

class LocationPermissionService: NSObject {
    
    var parentView: ViewController!
    
    var mapService: MapService?
    
    let locationManager = CLLocationManager()
    
    init(view: ViewController, mapService: MapService?) {
        super.init()
        
        self.parentView = view
        self.mapService = mapService
        locationManager.delegate = self
        requestLocationPermission()
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    private func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            presentSettingsActionSheet()
        default:
            break
        }
    }
    
    private func presentSettingsActionSheet() {
        let alert = UIAlertController(title: "Permission to Location", message: "This app needs access to location ...", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        parentView.present(alert, animated: true)
    }
}

extension LocationPermissionService: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        for location in locations {
            guard let ms = mapService else {return}
            ms.setRegion(to: location.coordinate)
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("ERROR: \(error.localizedDescription)")
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.requestLocation()
            self.locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}
