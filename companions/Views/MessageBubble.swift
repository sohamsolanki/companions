import SwiftUI

/// One chat bubble, aligned and coloured by author.
struct MessageBubble: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isUser { Spacer(minLength: 0) }

            Text(message.text)
                .padding(12)
                .background(message.isUser ? Color.accentColor : Color(.systemGray5))
                .foregroundStyle(message.isUser ? Color.white : Color.primary)
                .clipShape(ChatBubbleShape(isFromCurrentUser: message.isUser))
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))

            if !message.isUser { Spacer(minLength: 0) }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

/// A scrolling transcript of messages.
struct MessageList: View {
    let messages: [Message]

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .animation(.bubble, value: messages.count)
            }
            .onChange(of: messages.count) {
                guard let last = messages.last else { return }
                withAnimation(.bubble) { proxy.scrollTo(last.id, anchor: .bottom) }
            }
        }
    }
}

/// A rounded rectangle with the corner nearest its author squared off, like iMessage.
struct ChatBubbleShape: Shape {
    let isFromCurrentUser: Bool

    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 20
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: radius, height: radius))

        let tail = CGRect(
            x: isFromCurrentUser ? rect.maxX - radius : rect.minX,
            y: rect.maxY - radius,
            width: radius,
            height: radius
        )
        path.addRect(tail)
        return path
    }
}

extension Animation {
    /// Shared timing so bubbles appear consistently across every screen.
    static let bubble = Animation.spring(response: 0.3, dampingFraction: 0.7)
}

#Preview {
    MessageList(messages: [
        .user("Today was long but I got through it."),
        .assistant("You pushed through a demanding day and still made it to the other side.")
    ])
}
