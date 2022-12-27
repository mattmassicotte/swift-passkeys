import AWSLambdaRuntime
import AWSLambdaEvents

@main
struct HTTPHandler: LambdaHandler {
	init(context: AWSLambdaRuntimeCore.LambdaInitializationContext) async throws {
	}

	func handle(_ event: APIGatewayV2Request, context: LambdaContext) async throws -> APIGatewayV2Response {
		context.logger.debug("hello?")

		return APIGatewayV2Response(statusCode: .ok)
	}
}
