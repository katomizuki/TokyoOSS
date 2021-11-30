import FirebaseStorage
import Foundation

struct StorageService {
    static func upload(image:UIImage,completion:@escaping(Result<String,Error>)->Void) {
        guard let data = image.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        Storage.storage().reference().child(filename).putData(data, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            Storage.storage().reference().child(filename).downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let url = url else {
                    return
                }
                let urlString = "\(url)"
                completion(.success(urlString))
            }
        }
    }
}
