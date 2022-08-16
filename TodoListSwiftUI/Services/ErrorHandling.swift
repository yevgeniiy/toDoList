//
//  ErrorHandling.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.08.2022.
//

import Foundation

class ErrorHandling: ObservableObject {
    
    static var shared = ErrorHandling()
    
    @Published var currentAlert: Error?
    @Published var hasError: Bool = false
    
    var localizedError: String { return currentAlert?.localizedDescription ?? "Unknown Error." }

    func handle(error: Error) {
        print(error)
        hasError = true
        currentAlert = error
    }
    
    func dismissButton() {
        hasError = false
        currentAlert = nil
    }
}
