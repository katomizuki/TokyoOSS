import Foundation
import RxSwift
import Firebase
import RxCocoa
struct Post {
    let id:String
    let title:String
    let content:String
    var likeCount = 0
    init(dic:[String:Any]) {
        self.id = dic["id"] as? String ?? ""
        self.title = dic["title"] as? String ?? ""
        self.content = dic["content"] as? String ?? ""
    }
}
protocol FetchPostProtocol {
    func getFsData() -> Single<[Post]>
}
struct FetchPost:FetchPostProtocol {
    func getFsData() -> Single<[Post]> {
            return Single<[Post]>.create { (observer) -> Disposable in
                ref_post.getDocuments(){ (querySnapshot, err) in
                    if let error = err {
                        observer(.failure(error))
                        return
                    }
                    if let snapShot = querySnapshot {
                        let documents = snapShot.documents.map { Post(dic: $0.data()) }
                        observer(.success(documents))
                        return
                    }
                }
                return Disposables.create()
            }
        }
}
