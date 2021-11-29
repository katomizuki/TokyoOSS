import Foundation
import RxSwift
import Firebase
import RxCocoa

struct Blogs:Codable {
    let blocks:[Post]
//    init(dic:[String:Any]) {
//        if let data = dic["blocks"] as? [Any] {
//            data.forEach {
//
//            }
//        }
//    }
}

struct Post:Codable {
    let id:String
    let type:String
    let text:String
//    let data:[Content]
}
struct Content:Codable {
    let level:Int
    let text:String
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
                        snapShot.documents.forEach { doc in
                            let data = doc.data()
                        }
                        return
                    }
                }
                return Disposables.create()
            }
        }
}
