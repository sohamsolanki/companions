import SwiftUI

/// Root view: onboarding on first launch, otherwise the session list.
struct ContentView: View {
    @AppStorage("userName") private var userName = ""
    @AppStorage("hasOnboarded") private var hasOnboarded = false

    @State private var conversations: [Conversation] = []

    private let assistant = JournalAssistant()

    var body: some View {
        if hasOnboarded {
            home
        } else {
            OnboardingView(userName: $userName, hasOnboarded: $hasOnboarded)
        }
    }

    private var home: some View {
        NavigationStack {
            List {
                Section {
                    MoodBar(conversations: conversations)
                        .frame(maxWidth: .infinity)
                        .listRowInsets(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8))
                } header: {
                    Text("Welcome, \(userName)!")
                }

                Section("Conversations") {
                    NavigationLink {
                        SessionView(conversations: $conversations)
                    } label: {
                        Label("New Session", systemImage: "square.and.pencil")
                    }

                    ForEach(conversations) { conversation in
                        NavigationLink {
                            ConversationDetailView(conversation: conversation)
                        } label: {
                            HStack {
                                Text(conversation.title)
                                if let mood = conversation.mood {
                                    Spacer()
                                    MoodLabel(mood: mood)
                                }
                            }
                        }
                    }
                    .onDelete { conversations.remove(atOffsets: $0) }

                    if conversations.isEmpty {
                        Text("No sessions yet. Start one above.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Journaling Assistant")
            .overlay(alignment: .bottom) { unavailableBanner }
        }
    }

    /// Surfaced once, at the root, instead of injected as a fake assistant message.
    @ViewBuilder
    private var unavailableBanner: some View {
        if !assistant.isAvailable {
            Text("The on-device journaling assistant isn't available right now.")
                .font(.footnote)
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
        }
    }
}

#Preview {
    ContentView()
}
