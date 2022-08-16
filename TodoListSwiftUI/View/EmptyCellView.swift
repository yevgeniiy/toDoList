//
//  EmptyCellView.swift
//  TodoListSwiftUI
//
//  Created by Yevgenii Kryzhanivskyi on 16.08.2022.
//

import SwiftUI

struct EmptyCellView: View {
    var body: some View {
        VStack {
            Image(systemName: "eyes")
                .resizable()
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            Text("You don't have any tasks yet.")
                .multilineTextAlignment(.center)
                .lineLimit(4)
                .padding(.horizontal, 20.0)
                .foregroundColor(.gray)
                .font(.subheadline)
        }
    }
}

struct EmptyCellView_Previews: PreviewProvider {
    static var previews: some View {
        List {
        EmptyCellView()
        }
    }
}
