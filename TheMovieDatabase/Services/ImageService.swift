import UIKit

final class ImageService {

    static let shared = ImageService()
    private var imageCache: [String: UIImage] = [:]

    private init() {}

    func getImageFromURL(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache[urlString] {
            completion(cachedImage)
            return
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data,
                  let image = UIImage(data: data) else  {
                print("Invalid Data or Image is Corrupted")
                completion(nil)
                return
            }
            self.imageCache[urlString] = image
            completion(image)
        }.resume()
    }
}
