# Companions
<img src="https://static.wikia.nocookie.net/ipod/images/4/46/Swift_icon.png/revision/latest?cb=20220607183653" alt="Swift" width=30px/> <img src="https://upload.wikimedia.org/wikipedia/en/b/ba/Xcode_26_icon.png" alt="Xcode" width='29px'/> <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Apple_Intelligence.svg/3840px-Apple_Intelligence.svg.png" alt="Apple Intelligence" width='29px'/>


A private journaling companion for iOS. You write an entry, and an on-device model reflects
it back to you, asks a gentle follow-up question, and leaves you with some encouragement.
Each session is given a three-word title and tagged with a mood, so the list of past entries
doubles as a rough picture of how things have been going.

Everything runs through Apple's **Foundation Models** framework, on device. No entry ever
leaves the phone, and there is no account, server, or API key.

Built with Swift. Made with love for MannMukti UIUC in Champaign, IL ❤️

## Requirements

- iOS 26 or later, on a device with Apple Intelligence enabled
- Xcode 26 or later

The Foundation Models framework isn't available in the Simulator or on unsupported hardware.
The app still launches there — it shows a banner explaining the assistant is unavailable.

## Running it

```sh
git clone https://github.com/sohamsolanki/companions.git
cd companions
open companions.xcodeproj
```

## Layout

```
companions/
├── Models/           Message, Conversation, Mood
├── Assistant/        JournalAssistant — the only code that touches FoundationModels
│                     Prompts — all prompt text, kept out of the call sites
└── Views/            ContentView (session list), SessionView (chat), OnboardingView,
                      ConversationDetailView, MessageBubble, MoodViews
```

## License

MIT — see [LICENSE](LICENSE).
