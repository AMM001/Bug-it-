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

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Image Picker
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

                // Bug Description TextField
                TextField("Enter bug description", text: $bugDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Submit Button
                Button(action: {
                    // Handle submit logic here
                }) {
                    Text("Submit Bug")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
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
}

#Preview {
    BugSubmissionView()
}
