import Foundation

final class LocalStorage {

    static let shared = LocalStorage()
    
    private init() {}

    var ratingSource: String? {
        get {
            return UserDefaults.standard.value(forKey: "ratingSource") as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "ratingSource")
        }
    }

    var ratingValue: String? {
        get {
            return UserDefaults.standard.value(forKey: "ratingValue") as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "ratingValue")
        }
    }

    func setInitialValueFromFirstRating(rating: Rating) {
        ratingSource = rating.source.rawValue
        ratingValue = rating.value
    }
}
