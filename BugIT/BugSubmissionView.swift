//
//  BugSubmissionView.swift
//  BugIT
//
//  Created by admin on 12/09/2024.

import SwiftUI
struct BugSubmissionView: View {
    
    @State private var selectedImage: UIImage?
    @State private var bugDescription: String = ""
    @State private var isImagePickerPresented = false
    @State private var isUploading = false
    @State private var uploadError: String?

    let googleSheetsService = GoogleSheetsService()
    let imageUploader = ImageUploader()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                } else {
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        Text("Select Image")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }

                TextField("Enter bug description", text: $bugDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: handleSubmit) {
                    Text("Submit Bug")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }

                if let error = uploadError {
                    Text("Error: \(error)").foregroundColor(.red)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Bug Submission")
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }

    // Handle bug submission
    func handleSubmit() {
        guard let image = selectedImage else { return }
        isUploading = true
        uploadError = nil

        imageUploader.uploadImage(image) { result in
            switch result {
            case .success(let imageURL):
                googleSheetsService.appendBugData(bugDescription: bugDescription, imageURL: imageURL) { result in
                    isUploading = false
                    switch result {
                    case .success:
                        print("Bug submitted successfully")
                    case .failure(let error):
                        uploadError = error.localizedDescription
                    }
                }
            case .failure(let error):
                isUploading = false
                uploadError = error.localizedDescription
            }
        }
    }
}


#Preview {
    BugSubmissionView()
}
