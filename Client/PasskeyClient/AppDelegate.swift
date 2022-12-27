import Cocoa
import AuthenticationServices
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet var window: NSWindow!


	func applicationDidFinishLaunching(_ aNotification: Notification) {
		window.contentViewController = NSHostingController(rootView: SigninView(window: window))
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}
}

final class AuthViewModel: NSObject, ObservableObject {
	let window: NSWindow
	private var authController: ASAuthorizationController?

	init(window: NSWindow) {
		self.window = window
	}

	func signUp() {
		let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: "passkeys.massicotte.org")

		let challenge = Data()
		let name = "Blob"
		let userID = UUID().uuidString.data(using: .utf8)!

		var request = provider.createCredentialRegistrationRequest(challenge: challenge, name: name, userID: userID)

		let controller = ASAuthorizationController(authorizationRequests: [request])

		controller.delegate = self
		controller.presentationContextProvider = self


		controller.performRequests()

		self.authController = controller
	}
}

extension AuthViewModel: ASAuthorizationControllerDelegate {
}

extension AuthViewModel: ASAuthorizationControllerPresentationContextProviding {
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return window
	}
}

struct SigninView: View {
	let viewModel: AuthViewModel

	init(window: NSWindow) {
		self.viewModel = AuthViewModel(window: window)
	}
	var body: some View {
		Button("Sign Up") {
			viewModel.signUp()
		}
		.frame(minWidth: 200.0, maxWidth: .infinity, minHeight: 200.0, maxHeight: .infinity)
	}
}
