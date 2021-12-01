import UIKit
import Foundation
import FirebaseAuth
extension UIViewController {
    func updateAuthencationTextField(tf:UITextField,button:UIButton) {
        let view = UIView()
        view.setDimensions(height: 40, width: 40)
        tf.rightView = view
        tf.rightViewMode = .always
        view.addSubview(button)
        button.setDimensions(height: 40, width: 40)
    }
    func showAlert(message:String) {
        let alertVC = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true, completion: nil)
    }
    func getErrorMessages(error:NSError)->String {
        var message = ""
        guard let errCode = AuthErrorCode(rawValue: error.code) else { return "" }
                switch errCode {
                case .invalidEmail: message =  "有効なメールアドレスを入力してください"
                case .emailAlreadyInUse: message = "既に登録されているメールアドレスです"
                case .weakPassword: message = "パスワードは６文字以上で入力してください"
                case .userNotFound: message = "アカウントが見つかりませんでした"
                case .wrongPassword: message = "パスワードを確認してください"
                case .userDisabled: message = "アカウントが無効になっています"
                default: message = "エラー: \(error.localizedDescription)"
                }
        return message
    }
}
