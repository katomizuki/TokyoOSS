import Foundation

struct Post {
    let id:String
    let title:String
    let content:String
    var likeCount = 0
}
struct SectionOfPost {
    var posts:[Post]
}
