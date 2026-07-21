import SwiftUI

/// A read-only transcript of a past session.
struct ConversationDetailView: View {
    let conversation: Conversation

    var body: some View {
        MessageList(messages: conversation.messages)
            .navigationTitle(conversation.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if let mood = conversation.mood {
                    ToolbarItem(placement: .topBarTrailing) {
                        MoodLabel(mood: mood)
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        ConversationDetailView(conversation: Conversation(
            title: "Long but steady",
            messages: [
                .user("Today was long but I got through it."),
                .assistant("You pushed through a demanding day and still made it to the other side.")
            ],
            mood: .neutral
        ))
    }
}
