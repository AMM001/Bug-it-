//
//  ImageUploadService.swift
//  BugIT
//
//  Created by admin on 16/09/2024.
//

import FirebaseStorage

protocol ImageUploadServiceProtocol {
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
}

class ImageUploadService:ImageUploadServiceProtocol {
    
    let storage = Storage.storage()
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = storage.reference().child("bug_images/\(UUID().uuidString).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageConversionError", code: 0, userInfo: nil)))
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
}
