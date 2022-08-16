//
//  DataErrors.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.08.2022.
//

import Foundation

enum DataErrors: Error {
    case taskFieldIsEmpry
}

extension DataErrors: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .taskFieldIsEmpry:
            return "Task field is empty."
        }
    }
}
