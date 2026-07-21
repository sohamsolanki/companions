import Foundation

/// A completed or in-progress journaling session.
struct Conversation: Identifiable {
    let id: UUID
    var title: String
    var messages: [Message]
    var mood: Mood?

    init(id: UUID = UUID(), title: String, messages: [Message], mood: Mood? = nil) {
        self.id = id
        self.title = title
        self.messages = messages
        self.mood = mood
    }

    static let untitled = "Untitled Session"
}

extension Array where Element == Conversation {
    /// Replaces the conversation with a matching id, or appends it if it's new.
    ///
    /// Sessions write back to this array on every assistant reply, so the update has to
    /// be keyed by id — indexing by position would clobber whichever session ended last.
    mutating func upsert(_ conversation: Conversation) {
        if let index = firstIndex(where: { $0.id == conversation.id }) {
            self[index] = conversation
        } else {
            append(conversation)
        }
    }
}
