import Testing
@testable import companions

@Suite("Mood parsing")
struct MoodTests {

    @Test("Exact model replies map to a mood", arguments: Mood.allCases)
    func exactReply(mood: Mood) {
        #expect(Mood(matching: mood.rawValue) == mood)
    }

    @Test("Whitespace and casing are tolerated")
    func messyReply() {
        #expect(Mood(matching: "  happy\n") == .happy)
        #expect(Mood(matching: "ANXIOUS") == .anxious)
    }

    @Test("Replies outside the known set are rejected")
    func unknownReply() {
        #expect(Mood(matching: "Excited") == nil)
        #expect(Mood(matching: "The mood is Happy") == nil)
        #expect(Mood(matching: "") == nil)
    }
}

@Suite("Conversation list")
struct ConversationTests {

    @Test("Appends a conversation the list hasn't seen")
    func appendsNew() {
        var conversations: [Conversation] = []
        conversations.upsert(Conversation(title: "First", messages: []))
        #expect(conversations.count == 1)
    }

    @Test("Updates in place, without disturbing later sessions")
    func updatesMatchingID() {
        let first = Conversation(title: "First", messages: [])
        let second = Conversation(title: "Second", messages: [])
        var conversations = [first, second]

        var edited = first
        edited.messages = [.user("hello")]
        conversations.upsert(edited)

        #expect(conversations.count == 2)
        #expect(conversations[0].messages.count == 1)
        #expect(conversations[1].title == "Second")
    }
}
