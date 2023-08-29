import UIKit

final class ActionSheetService {

    static let shared = ActionSheetService()
    
    private init() {}

    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first?.rootViewController
    }

    func showActionSheet<T: RawRepresentable>(title: String, options: [T], completion: @escaping (T) -> Void) {
        guard let rootViewController = getRootViewController() else {
            return
        }
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for option in options {
            let action = UIAlertAction(title: option.rawValue as? String, style: .default) { _ in
                completion(option)
            }
            actionSheet.addAction(action)
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        rootViewController.present(actionSheet, animated: true, completion: nil)
    }
}
