import Foundation
import RxSwift
import Firebase
import RxCocoa
import FirebaseFirestoreSwift
import FirebaseAuth
struct Blogs:Codable {
    let blocks:[Post]
    var mainImage:String?
    var title:String
    var version:String
    var time:Double
    var isPublic:Bool?
    var uid:String
    var lat:Double?
    var lng:Double?
    var docId:String?
}
//[["data":["text":"アイウエオ","level":1],"id":"mizuki","type":"paragraph"],["data":["text":"アイウエオ","level":1],"id":"mizuki","type":"paragraph"]]
struct Post:Codable {
    let id:String
    let type:String
    let data:Content
}
struct Content:Codable {
    let text:String?
    let level:Int?
    var caption:String?
    var file:File?
}
struct File:Codable {
    var url:String?
    var stretched:Bool?
    var withBackground:Bool?
    var withBorder:Bool?
}
protocol FetchPostProtocol {
    func getFsData() -> Single<[Data]>
    func sendFsData(title:String,content:String,urlString:String,lat:Double,lng:Double,completion: @escaping (Result<String, Error>) -> Void)
    func getBlogsData() -> Single<[Blogs]>
    func getMyBlogs() -> Single<[Blogs]>
    func updateFsData(blogs:Blogs,completion:@escaping (Error?)->Void)
}
struct Editor:Codable {
    let blocks:[Post]
    var title:String
    var version:String
    var time:Int
}
struct FetchPost:FetchPostProtocol {
    func sendFsData(title:String,content:String,urlString:String,lat:Double,lng:Double,completion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let id = ref_post.document().documentID
        let messages = self.changeContent(content: content)
        let anyies = self.changeDic(arr: messages)
        let now = Date().timeIntervalSince1970 * 10000000
        let dic:[String:Any] = ["blocks":anyies,"title":"\(title)","mainImage":urlString,"version":"2.22.2","time":now,"isPublic":true,"uid":uid,"lat":lat,"lng":lng,"docId":id]
        ref_post.document(id).setData(dic)
    }
    func updateFsData(blogs:Blogs,completion:@escaping (Error?)->Void) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = blogs.docId else { return }
        let bool = blogs.isPublic ?? true
        let flag = !bool
        ref_post.document(id).updateData(["isPublic" : flag], completion: completion)
    }
    
    func getFsData() -> Single<[Data]> {
            return Single<[Data]>.create { (observer) -> Disposable in
                ref_post.getDocuments(){ (querySnapshot, err) in
                    if let error = err {
                        observer(.failure(error))
                        return
                    }
                    if let snapShot = querySnapshot {
                        var datas = [Data]()
                        var blogs = [Editor]()
                        snapShot.documents.forEach { doc in
                            let data = doc.data()
                            if let blog = try? Firestore.Decoder().decode(Editor.self, from: data) {
                                blogs.append(blog)
                            }
                            if let encoder = try? JSONEncoder().encode(blogs) {
                                datas.append(encoder)
                            }
                        }
                        observer(.success(datas))
                        return
                    }
                }
                return Disposables.create()
            }
        }
    
    func getDocumentsId()->Single<[String]>{
        return Single<[String]>.create { (observer) -> Disposable in
            ref_post.getDocuments() { snapShot, error in
                guard let snapShot = snapShot else {
                    return
                }
                if let error = error {
                    observer(.failure(error))
                    return
                }
                let snap = snapShot.documents
                let array = snap.map({ $0.documentID })
                observer(.success(array))
                return
            }
            return Disposables.create()
        }
    }
    func changeContent(content:String)->[String] {
        let chars = Array(content)
        var message = [String]()
        var startIndex = 0
        var endIndex = 0
        for i in 0..<chars.count {
            let char = String(chars[i])
            if char == "\n" {
                endIndex = i
                message.append(content.substring(str: content, start: startIndex, end: endIndex))
                startIndex = i + 1
            }
        }
        if chars[chars.count - 1] != "\n" {
            message.append(content.substring(str: content, start: startIndex, end: content.count))
        }
        return message
    }
    
    func changeDic(arr:[String])->[Any]{
        var answer = [Any]()
        arr.forEach({
            let ele = ["data": ["text":"\($0)","level":1],"id":"mizuki","type":"paragraph"] as [String : Any]
            answer.append(ele)
        })
        return answer
    }
    func getBlogsData() -> Single<[Blogs]> {
            return Single<[Blogs]>.create { (observer) -> Disposable in
                ref_post.getDocuments(){ (querySnapshot, err) in
                    if let error = err {
                        observer(.failure(error))
                        return
                    }
                    if let snapShot = querySnapshot {
                        var blogs = [Blogs]()
                        snapShot.documents.forEach { doc in
                            let data = doc.data()
                            if let blog = try? Firestore.Decoder().decode(Blogs.self, from: data) {
                                blogs.append(blog)
                            }
                        }
                        observer(.success(blogs))
                        return
                    }
                }
                return Disposables.create()
            }
        }
    
    func getMyBlogs() -> Single<[Blogs]> {
        guard let uid = Auth.auth().currentUser?.uid else { fatalError() }
//        print(uid)
            return Single<[Blogs]>.create { (observer) -> Disposable in
                ref_post.getDocuments(){ (querySnapshot, err) in
                    if let error = err {
                        observer(.failure(error))
                        return
                    }
                    if let snapShot = querySnapshot {
                        var blogs = [Blogs]()
                        snapShot.documents.forEach { doc in
                            let data = doc.data()
                            if let blog = try? Firestore.Decoder().decode(Blogs.self, from: data) {
                                print(blog)
                                if uid == blog.uid {
                                blogs.append(blog)
                                }
                            } else { print("ダメだった")}
                        }
                        observer(.success(blogs))
                        return
                    }
                }
                return Disposables.create()
            }
        }
  
}

//getMyBlogs

extension String {
    func substring(str: String,start:Int,end:Int)->String {
        // 最初のインデックスをとる
        let zero = str.startIndex
        // 初期値から数字をとる
        let s = str.index(zero, offsetBy: start)
        let e = str.index(zero, offsetBy: end)
        return String(str[s..<e])
    }
}
