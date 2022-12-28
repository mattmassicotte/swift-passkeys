import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation
import WebAuthn

struct AppSiteAssociation: Codable {
	struct WebCredentials: Codable {
		let apps: [String]
	}

	let webCredentials: WebCredentials

	enum CodingKeys: String, CodingKey {
		case webCredentials = "webcredentials"
	}
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
			return .init(statusCode: .ok)
		case (.POST, "/Test/makeCredential"):
			return .init(statusCode: .ok)
		default:
			return APIGatewayV2Response(statusCode: .notFound)
		}
	}
}
