//
//  BugITApp.swift
//  BugIT
//
//  Created by admin on 12/09/2024.
//

import SwiftUI
import Firebase

@main
struct BugITApp: App {
    
    init() {
        FirebaseApp.configure()  // This initializes Firebase
    }
    
    var body: some Scene {
        WindowGroup {
            let viewModel = BugSubmissionViewModel()
            BugSubmissionView(viewModel: viewModel)
        }
    }
}
