//
//  ContentView.swift
//  misaka
//
//  Created by mini on 2024/01/15.
//

import SwiftUI

struct ContentView: View {
    @State var error = false
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
