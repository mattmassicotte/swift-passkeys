import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation
import WebAuthn
import SotoCognitoIdentityProvider

struct AppSiteAssociation: Codable {
	struct WebCredentials: Codable {
		let apps: [String]
	}

	let webCredentials: WebCredentials

	enum CodingKeys: String, CodingKey {
		case webCredentials = "webcredentials"
	}
}

let conifg = WebAuthnConfig(relyingPartyDisplayName: "SwiftPasskeys",
							relyingPartyID: "1",
//							relyingPartyOrigin: "passkeys.massicotte.org",
							timeout: 30.0)

let manager = WebAuthnManager(config: conifg)
let awsClient = AWSClient(httpClientProvider: .createNew)
let userPoolId = ProcessInfo.processInfo.environment["USER_POOL_CLIENT_ID"] ?? ""

struct AuthUser: User {
	var userID: String
	var name: String
	var displayName: String
}

@main
struct HTTPHandler: LambdaHandler {
	init(context: AWSLambdaRuntimeCore.LambdaInitializationContext) async throws {
	}

	func handle(_ event: APIGatewayV2Request, context: LambdaContext) async throws -> APIGatewayV2Response {
		let method = event.context.http.method
		let path = event.context.http.path

		// worst possible kind of url routing

		switch (method, path) {
		case (.GET, "/Test/.well-known/apple-app-site-association"):
			let content = AppSiteAssociation(webCredentials: .init(apps: ["5GXRS83U4Z.com.mycompany.PasskeyClient"]))
			let data = try JSONEncoder().encode(content)

			var response = APIGatewayV2Response(statusCode: .ok, body: String(data: data, encoding: .utf8))

			response.headers = ["content-type": "application/json"]

			return response
		case (.GET, "/Test/makeCredential"):
			guard let username = event.queryStringParameters?["username"] else {
				return .init(statusCode: .badRequest)
			}
			
			let params = event.queryStringParameters ?? [:]

			context.logger.info("params: \(params)")

			let user = AuthUser(userID: UUID().uuidString, name: username, displayName: username)

			let (options, _) = try manager.beginRegistration(user: user)

			context.logger.info("challenge: \(options.challenge)")

			let data = try JSONEncoder().encode(options)

			try await signUp(username: username, credOptions: options, logger: context.logger)

			var response = APIGatewayV2Response(statusCode: .created,
												body: String(data: data, encoding: .utf8))
			response.headers = ["content-type": "application/json"]

			return response
		case (.POST, "/Test/makeCredential"):
			return .init(statusCode: .ok)
		default:
			return APIGatewayV2Response(statusCode: .notFound)
		}
	}

	private func signUp(username: String, credOptions: PublicKeyCredentialCreationOptions, logger: Logger) async throws {
		let attributes: [CognitoIdentityProvider.AttributeType] = [
			.init(name: "custom:publicKeyCred", value: credOptions.challenge),
		]

		let cognito = CognitoIdentityProvider(client: awsClient)

		let signUpRequest = CognitoIdentityProvider.SignUpRequest(
			clientId: userPoolId,
			password: "webauthn",
			userAttributes: attributes,
			username: username
		)

		let _ = try await cognito.signUp(signUpRequest)
	}
}
