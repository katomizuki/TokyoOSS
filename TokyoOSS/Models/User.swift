import Foundation
import RxSwift

struct User {
    let id:String
    let name:String
    let email:String
    let password:String
    init(dic:[String:Any]) {
        self.id = dic["id"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.password = dic["password"] as? String ?? ""
    }
}
protocol FetchUserProtocol {
    func fetchUser(userId:String)->Single<User>
}
struct FetchUser:FetchUserProtocol {
    func fetchUser(userId:String) -> Single<User> {
            return Single<User>.create { (observer) -> Disposable in
                ref_post.document(userId).getDocument(){ (querySnapshot, err) in
                    if let error = err {
                        observer(.failure(error))
                        return
                    }
                    if let snapShot = querySnapshot {
                        guard let dic = snapShot.data() else { return }
                        let user = User(dic: dic)
                        observer(.success(user))
                        return
                    }
                }
                return Disposables.create()
            }
        }
}
