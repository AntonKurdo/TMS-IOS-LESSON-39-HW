import RealmSwift
import MapKit

class Annotation: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String?
    @Persisted var subtitle: String?
    @Persisted var latitude: CLLocationDegrees
    @Persisted var longitude: CLLocationDegrees
    
    convenience init(title: String?, subtitle: String?, coors: CLLocationCoordinate2D) {
        self.init()
        self.title = title
        self.subtitle = subtitle
        self.latitude = coors.latitude
        self.longitude = coors.longitude
    }
}
