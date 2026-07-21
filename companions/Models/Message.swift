import Foundation

/// A single turn in a journaling session.
struct Message: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isUser: Bool

    static func user(_ text: String) -> Message {
        Message(text: text, isUser: true)
    }

    static func assistant(_ text: String) -> Message {
        Message(text: text, isUser: false)
    }
}
