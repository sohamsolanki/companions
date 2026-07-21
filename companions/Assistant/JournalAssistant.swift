import Foundation
import FoundationModels

/// Wraps the on-device language model so views never talk to `FoundationModels` directly.
///
/// Every call opens a fresh `LanguageModelSession`. Journaling replies, title generation and
/// mood classification are independent asks — sharing a session would leak the summary prompt
/// into the mood classification and skew it.
struct JournalAssistant {
    enum Failure: LocalizedError {
        case modelUnavailable

        var errorDescription: String? {
            switch self {
            case .modelUnavailable:
                "The journaling assistant isn't available on this device."
            }
        }
    }

    /// Whether the system model can serve requests right now.
    var isAvailable: Bool {
        SystemLanguageModel.default.isAvailable
    }

    /// Responds to a journal entry in the companion's voice.
    func reply(to entry: String) async throws -> String {
        try await respond(to: Prompts.journalEntry(entry))
    }

    /// A three-word title for a finished exchange, or a fallback when the model declines.
    func title(for messages: [Message]) async -> String {
        let title = try? await respond(to: Prompts.title(for: transcript(of: messages)))
        return title?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
            ?? Conversation.untitled
    }

    /// The dominant mood of an exchange, or `nil` if the model is unavailable or replies
    /// with something outside the known set.
    func mood(for messages: [Message]) async -> Mood? {
        guard let reply = try? await respond(to: Prompts.mood(for: transcript(of: messages))) else {
            return nil
        }
        return Mood(matching: reply)
    }

    private func respond(to prompt: String) async throws -> String {
        guard isAvailable else { throw Failure.modelUnavailable }
        let session = LanguageModelSession()
        return try await session.respond(to: Prompt(prompt)).content
    }

    private func transcript(of messages: [Message]) -> String {
        messages.map(\.text).joined(separator: "\n")
    }
}

private extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}
