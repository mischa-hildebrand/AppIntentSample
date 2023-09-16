//
//  ContentView.swift
//  AppIntentSample
//
//  Created by Mischa on 31.07.23.
//

import AppIntents
import Intents
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            CoffeeShortcuts.updateAppShortcutParameters()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
