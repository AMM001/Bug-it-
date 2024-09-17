//
//  BugSubmissionViewModel.swift
//  BugIT
//
//  Created by admin on 16/09/2024.
//

import Foundation
import SwiftUI

protocol BugSubmissionViewModelProtocol:AnyObject {
    
    var selectedImage: UIImage? { get set }
    var bugDescription: String { get set }
    var isUploading: Bool { get set }
    var errorMessage: String? { get set }
    
    func submitBug()
}

class BugSubmissionViewModel: ObservableObject , BugSubmissionViewModelProtocol {
    
    @Published var selectedImage: UIImage? = nil
    @Published var bugDescription: String = ""
    @Published var isUploading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let googleSheetsService:GoogleSheetsServiceProtocol
    private let imageUploadService:ImageUploadServiceProtocol
    
    init(googleSheetsService:GoogleSheetsServiceProtocol = GoogleSheetsService() ,
         imageUploadService:ImageUploadServiceProtocol = ImageUploadService() ){
        self.googleSheetsService = googleSheetsService
        self.imageUploadService = imageUploadService
    }
    
    // Handle bug submission
    func submitBug() {
        guard let image = selectedImage else {
            errorMessage = "Please select an image."
            return
        }
        
        isUploading = true
        errorMessage = nil
        
        // Step 1: Upload Image
        imageUploadService.uploadImage(image) { [weak self] result in
            switch result {
            case .success(let imageURL):
                // Step 2: Append data to Google Sheets
                self?.appendBugData(imageURL: imageURL)
            case .failure(let error):
                self?.isUploading = false
                self?.errorMessage = "Image upload failed: \(error.localizedDescription)"
            }
        }
    }
    
    private func appendBugData(imageURL: String) {
        googleSheetsService.appendBugData(bugDescription: bugDescription, imageURL: imageURL) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUploading = false
                switch result {
                case .success:
                    print("Bug submitted successfully")
                    self?.resetForm()
                case .failure(let error):
                    self?.errorMessage = "Submission failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func resetForm() {
        selectedImage = nil
        bugDescription = ""
    }
}
