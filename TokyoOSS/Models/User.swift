import Foundation
import RxSwift

struct User {
    let id:String
    let name:String
    let email:String
    let password:String
    let icon:String
    init(dic:[String:Any]) {
        self.id = dic["id"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.email = dic["email"] as? String ?? ""
        self.password = dic["password"] as? String ?? ""
        self.icon = dic["icon"] as? String ?? ""
    }
}
protocol FetchUserProtocol {
    func fetchUser(userId:String)->Single<User>
    func updateIcon(uid:String,iconUrl:String,completion:@escaping(Error?)->Void)
}
struct FetchUser:FetchUserProtocol {
    func fetchUser(userId:String) -> Single<User> {
            return Single<User>.create { (observer) -> Disposable in
                ref_user.document(userId).getDocument(){ (querySnapshot, err) in
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
    static func sendUser(uid:String,name:String,email:String,compeltion:@escaping(Error?)->Void) {
//        let id = ref_user.document().documentID
        let dic:[String:Any] = ["uid":uid,"name":name,"email":email,"icon":"","admin":false]
        ref_user.document(uid).setData(dic,completion: compeltion)
    }
    func updateIcon(uid:String,iconUrl:String,completion:@escaping(Error?)->Void) {
        ref_user.document(uid).updateData(["icon":iconUrl],completion: completion)
    }
}
