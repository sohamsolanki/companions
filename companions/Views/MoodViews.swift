import SwiftUI

/// A count of sessions per mood, shown above the conversation list.
struct MoodBar: View {
    let conversations: [Conversation]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Mood.allCases) { mood in
                let count = conversations.filter { $0.mood == mood }.count
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(mood.color.opacity(count > 0 ? 0.8 : 0.2))
                        .frame(width: 32, height: 16)
                    Text(mood.rawValue)
                        .font(.caption2)
                    Text("\(count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(count) \(mood.rawValue) sessions")
            }
        }
    }
}

/// The mood tag on a conversation row.
struct MoodLabel: View {
    let mood: Mood

    var body: some View {
        Text(mood.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(mood.color.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))
            .foregroundStyle(mood.color.opacity(0.9))
    }
}

#Preview {
    VStack(spacing: 24) {
        MoodBar(conversations: [
            Conversation(title: "Good day", messages: [], mood: .happy),
            Conversation(title: "Rough morning", messages: [], mood: .anxious)
        ])
        MoodLabel(mood: .happy)
    }
}
