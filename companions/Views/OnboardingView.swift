import SwiftUI

/// First-run screen that collects the user's name.
struct OnboardingView: View {
    @Binding var userName: String
    @Binding var hasOnboarded: Bool

    private var trimmedName: String {
        userName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome!")
                .font(.largeTitle)
                .bold()
            Text("We're so glad you're here. Enter your name so we can get to know you better.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            TextField("Enter your name", text: $userName)
                .textFieldStyle(.roundedBorder)
                .textContentType(.givenName)
                .submitLabel(.done)
                .onSubmit(continueIfNamed)

            Button("Continue", action: continueIfNamed)
                .buttonStyle(.borderedProminent)
                .disabled(trimmedName.isEmpty)
        }
        .padding()
    }

    private func continueIfNamed() {
        guard !trimmedName.isEmpty else { return }
        userName = trimmedName
        hasOnboarded = true
    }
}

#Preview {
    OnboardingView(userName: .constant(""), hasOnboarded: .constant(false))
}
