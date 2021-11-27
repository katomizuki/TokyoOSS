import Foundation
struct Validator {
    static func isEnableEmail(email: String) -> Bool {
        let args = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let validation = NSPredicate(format: "SELF MATCHES %@", args)
        return validation.evaluate(with: email)
    }
    static func isEnablePassWord(password: String)-> Bool {
        let args = "^(?=.*?[A-Za-z])(?=.*?[0-9])[A-Za-z0-9]{8,}$"
        let validation = NSPredicate(format: "SELF MATCHES %@", args)
        return validation.evaluate(with: password)
    }
}
