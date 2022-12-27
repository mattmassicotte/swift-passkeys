import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation

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
		context.logger.info("hello: \(event.rawPath)")

		let content = AppSiteAssociation(webCredentials: .init(apps: ["5GXRS83U4Z.com.mycompany.PasskeyClient"]))
		let data = try JSONEncoder().encode(content)

		return APIGatewayV2Response(statusCode: .ok, body: String(data: data, encoding: .utf8))
	}
}
