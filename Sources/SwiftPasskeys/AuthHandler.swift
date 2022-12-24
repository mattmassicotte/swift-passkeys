import AWSLambdaRuntime
import AWSLambdaEvents

struct CognitoEvent: Codable {

}

struct CognitoResponse: Codable {

}

@main
struct AuthHandler: LambdaHandler {
	init(context: AWSLambdaRuntimeCore.LambdaInitializationContext) async throws {
	}

	func handle(_ event: CognitoEvent, context: LambdaContext) async throws -> CognitoResponse {
		context.logger.debug("hello?")

		return CognitoResponse()
	}
}
