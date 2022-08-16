//
//  Priorities.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 19.04.2022.
//

import Foundation
import SwiftUI

enum Priority: String, CaseIterable {
    
    case high, normal, low
    
    var name:String {
        switch self {
        case .high:
            return "High"
        case .normal:
            return "Normal"
        case .low:
            return "Low"
        }
    }
    
    var color: Color {
        switch self {
        case .high:
            return .red
        case .normal:
            return .blue
        case .low:
            return .green
        }
    }
}


