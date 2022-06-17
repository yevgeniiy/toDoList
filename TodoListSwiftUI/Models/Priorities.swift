//
//  Priorities.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 19.04.2022.
//

import Foundation
import SwiftUI

let priorities = ["High", "Normal", "Low"]

func colorPriority(priority: String) -> Color {
    switch priority {
    case "High":
        return .red
    case "Normal":
        return .blue
    case "Low":
        return .green
    default:
        return .gray
    }
}

//enum Priorities: String, CaseIterable {
//    case high = "High"
//    case normal = "Normal"
//    case low = "Low"
//}
//
//extension Priorities {
//
//
//    func getPriorityColor() -> Color {
//        switch self {
//        case .high:
//            return .red
//        case .normal:
//            return .blue
//        case .low:
//            return .green
//        }
//    }
//
//}


