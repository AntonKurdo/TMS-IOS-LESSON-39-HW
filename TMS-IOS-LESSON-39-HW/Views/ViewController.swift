import UIKit
import MapKit

class ViewController: UIViewController {
    var mapService: MapService!
    var locationService: LocationPermissionService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
       
    }
    
    
    private  func setupMap() {
        mapService = MapService(view: self)
        
        locationService = LocationPermissionService(view: self, mapService: mapService)
    }
}

