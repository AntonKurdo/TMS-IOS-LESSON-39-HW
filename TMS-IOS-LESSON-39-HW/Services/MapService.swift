import MapKit

class MapService: NSObject {
    var parentView: ViewController!
    let mapView : MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .light
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        return map
    }()
    
    
    init(view: ViewController) {
        super.init()
        parentView = view
        for a in RealmManager.shared.annotations {
            let point = MKPointAnnotation()
            point.title = a.title
            point.subtitle = a.subtitle
            point.coordinate = CLLocationCoordinate2D(latitude: a.latitude, longitude: a.longitude)
            mapView.addAnnotation(point)
        }
        mapView.delegate = self
        setupMapView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapRecognized))

        mapView.addGestureRecognizer(tapGesture)
        
    }
    
    private func setupMapView() {
        parentView.view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: parentView.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: parentView.view.bottomAnchor),
            mapView.rightAnchor.constraint(equalTo: parentView.view.rightAnchor),
            mapView.leftAnchor.constraint(equalTo: parentView.view.leftAnchor),
        ])
    }
    @objc
    func tapRecognized(sender: UITapGestureRecognizer) {
        print("sender", sender)
        
        let locationInMap = sender.location(in: mapView)
        
        let coordinate = mapView.convert(locationInMap, toCoordinateFrom: mapView)
        
        let alert = UIAlertController(title: "text location", message: "enter locationText", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { _ in
            let annotation = MKPointAnnotation()
            annotation.title = alert.textFields?.first?.text ?? "Here"
            annotation.subtitle = "One day I'll go here..."
            annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            self.mapView.addAnnotation(annotation)
            RealmManager.shared.add(newAnnotation: annotation, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        parentView.present(alert, animated: true)
    }
    
    func setRegion(to coordinate: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}


extension MapService: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        mapView.removeAnnotation(annotation)
        RealmManager.shared.annotations.forEach { a in
            if(a.latitude == annotation.coordinate.latitude && a.longitude == annotation.coordinate.longitude) {
                RealmManager.shared.remove(annotation: a, completion: nil)
            }
        }
    }
}
