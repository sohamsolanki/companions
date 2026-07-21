import SwiftUI

/// The moods a session can be classified as.
///
/// The model is asked to reply with exactly one of these words, but its output is
/// free text — use ``init(matching:)`` to parse a reply rather than trusting it.
enum Mood: String, CaseIterable, Identifiable {
    case happy = "Happy"
    case sad = "Sad"
    case neutral = "Neutral"
    case angry = "Angry"
    case anxious = "Anxious"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .happy: .yellow
        case .sad: .blue
        case .neutral: .gray
        case .angry: .red
        case .anxious: .orange
        }
    }

    /// Parses a model reply, ignoring surrounding whitespace and casing.
    /// Returns `nil` if the reply isn't one of the five known moods.
    init?(matching reply: String) {
        let trimmed = reply.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let match = Mood.allCases.first(where: {
            $0.rawValue.caseInsensitiveCompare(trimmed) == .orderedSame
        }) else { return nil }
        self = match
    }
}
