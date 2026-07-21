import SwiftUI

/// An active journaling session: a transcript plus a composer.
///
/// The session owns its own messages and writes back into `conversations` keyed by
/// ``sessionID``, so opening a second session never overwrites the first.
struct SessionView: View {
    @Binding var conversations: [Conversation]

    private let assistant = JournalAssistant()

    @State private var sessionID = UUID()
    @State private var messages: [Message] = []
    @State private var draft = ""
    @State private var isGenerating = false

    private var canSend: Bool {
        !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isGenerating
    }

    var body: some View {
        VStack(spacing: 0) {
            MessageList(messages: messages)
            composer
        }
        .navigationTitle("New Session")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: startFreshSession)
    }

    private var composer: some View {
        HStack(alignment: .bottom, spacing: 12) {
            TextField("What's on your mind?", text: $draft, axis: .vertical)
                .lineLimit(1...5)
                .padding(12)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )

            Button(action: send) {
                if isGenerating {
                    ProgressView()
                } else {
                    Image(systemName: "paperplane.fill")
                }
            }
            .disabled(!canSend)
            .accessibilityLabel("Send entry")
        }
        .padding()
    }

    /// Each visit to this screen starts a new conversation rather than resuming the last.
    private func startFreshSession() {
        guard !messages.isEmpty else { return }
        sessionID = UUID()
        messages = []
        draft = ""
    }

    private func send() {
        let entry = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !entry.isEmpty else { return }

        append(.user(entry))
        draft = ""
        isGenerating = true

        Task {
            do {
                append(.assistant(try await assistant.reply(to: entry)))
            } catch {
                append(.assistant("Sorry — \(error.localizedDescription)"))
            }
            await saveProgress()
            isGenerating = false
        }
    }

    private func append(_ message: Message) {
        withAnimation(.bubble) { messages.append(message) }
    }

    /// Persists the session into the list, labelling it after the first exchange.
    private func saveProgress() async {
        guard let existing = conversations.first(where: { $0.id == sessionID }) else {
            // First exchange: ask the model for a title and a mood before filing it away.
            let title = await assistant.title(for: messages)
            let mood = await assistant.mood(for: messages)
            conversations.upsert(
                Conversation(id: sessionID, title: title, messages: messages, mood: mood)
            )
            return
        }

        var updated = existing
        updated.messages = messages
        conversations.upsert(updated)
    }
}

#Preview {
    NavigationStack {
        SessionView(conversations: .constant([]))
    }
}
