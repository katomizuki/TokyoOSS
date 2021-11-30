import Foundation
import RxSwift
import Firebase
import RxCocoa
import FirebaseFirestoreSwift
struct Blogs:Codable {
    let blocks:[Post]
}
//[["data":["text":"アイウエオ","level":1],"id":"mizuki","type":"paragraph"],["data":["text":"アイウエオ","level":1],"id":"mizuki","type":"paragraph"]]
struct Post:Codable {
    let id:String
    let type:String
    let data:Content
}
struct Content:Codable {
    let text:String
    let level:Int?
}
protocol FetchPostProtocol {
    func getFsData() -> Single<[Post]>
    func sendFsData(title:String,content:String,completion:@escaping (Result<String,Error>)->Void)
}
struct FetchPost:FetchPostProtocol {
    func sendFsData(title:String,content:String,completion: @escaping (Result<String, Error>) -> Void) {
        let id = ref_ios.document().documentID
        let messages = self.changeContent(content: content)
        let anyies = self.changeDic(arr: messages)
        print(anyies,"⚡️")
        let dic:[String:Any] = ["blocks":anyies,"title":"\(title)","mainImage":"mainImageURL","version":"2.22.2","time":"時間だよ","public":true,"uid":"uidだよ"]
        ref_post.document(id).setData(dic)
    }
    
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
                            let blogs = try? Firestore.Decoder().decode(Blogs.self, from: data)
                            guard let encoder = try? JSONEncoder().encode(blogs) else { return }
                            print(String(bytes: encoder, encoding: .utf8)!)
                        }
                        return
                    }
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
}


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
