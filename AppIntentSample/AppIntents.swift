import AppIntents
import SwiftUI

let coffeeOptionsProvider = CoffeeOptionsProvider()

struct CoffeeIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Make a coffee"
    
    @Parameter(title: "Coffee", optionsProvider: CoffeeOptionsProvider())
    var coffee: Coffee
    
    @MainActor
    func perform() async throws -> some ProvidesDialog {
        .result(dialog: .init("Here's your \(coffee.name)"))
//        .result(value: "Here's your \(coffee)")
    }
}

struct Coffee: AppEntity {
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Coffee"

    let id: UUID
    
    let name: String
    
    var displayRepresentation: DisplayRepresentation {
        .init(stringLiteral: "\(name)")
    }
    
    static var defaultQuery = CoffeeQuery()

}

struct CoffeeQuery: EntityQuery {
    
    func entities(for identifiers: [Coffee.ID]) async throws -> [Coffee] {
        let options = try await coffeeOptionsProvider.results()
        return options.filter { coffee in
            identifiers.contains(coffee.id)
        }
    }
    
    func suggestedEntities() async throws -> [Coffee] {
        try await coffeeOptionsProvider.results()
    }
    
}

struct CoffeeOptionsProvider: DynamicOptionsProvider {
    
    static let options: [Coffee] = [
        .init(id: .init(), name: "Flat White"),
        .init(id: .init(), name: "Cappuccino"),
        .init(id: .init(), name: "Espresso")
    ]
    
    func results() async throws -> [Coffee] {
        CoffeeOptionsProvider.options
    }
    
//    func defaultResult() async -> Coffee? {
//        Self.options.first
//    }
}


// ⚡️ Current problem: When using the shortcut with Siri,
// Siri keeps aksing "What's the coffee?" without any options to choose from.

struct CoffeeShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: CoffeeIntent(), phrases: [
            "\(.applicationName) Make me a coffee, please!"
        ])
    }
}
