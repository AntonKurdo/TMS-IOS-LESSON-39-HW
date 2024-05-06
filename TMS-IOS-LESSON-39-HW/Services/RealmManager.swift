import RealmSwift
import Foundation
import MapKit

class RealmManager {
    static let shared = RealmManager()
    
    var realm: Realm?
    
    var annotations: [Annotation] = []
    
    private init() {
        realm = try! Realm()
        fetchAll()
    }
    
    func fetchAll() {
        guard let realm else {return}
        let result = realm.objects(Annotation.self)
        annotations = result.toArray(type: Annotation.self)
    }
    
    func add(newAnnotation: MKAnnotation, completion: (() -> ())?) {
        guard let realm else {return}
        let car = Annotation(title: newAnnotation.title ?? "", subtitle: newAnnotation.subtitle ?? "", coors: newAnnotation.coordinate)
        car.id = UUID().uuidString
        try! realm.write {
            realm.add(car)
        }
        fetchAll()
    }
    
    func remove(annotation: Annotation, completion: (() -> ())?) {
        guard let realm else {return}
        try! realm.write {
            realm.delete(annotation)
        }
        fetchAll()
        completion?()
    }
}

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as?  T }
    }
}
