//
//  BugSubmissionView.swift
//  BugIT
//
//  Created by admin on 12/09/2024.

import SwiftUI

struct BugSubmissionView<ViewModel: BugSubmissionViewModelProtocol & ObservableObject>: View {
    
    @ObservedObject var viewModel: ViewModel
    @State private var isImagePickerPresented = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Image Picker
                if let image = viewModel.selectedImage {
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
                
                // Bug Description
                TextField("Enter bug description", text: $viewModel.bugDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Submit Button
                Button(action: {
                    viewModel.submitBug()
                }) {
                    Text("Submit Bug")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .disabled(viewModel.isUploading)

                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)").foregroundColor(.red)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Bug Submission")
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $viewModel.selectedImage)
            }
        }
    }
}


#Preview {
    BugSubmissionView(viewModel: BugSubmissionViewModel())
}
