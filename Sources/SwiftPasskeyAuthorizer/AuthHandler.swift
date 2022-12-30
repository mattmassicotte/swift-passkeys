import AWSLambdaRuntime
import AWSLambdaEvents

@main
struct AuthHandler: LambdaHandler {
	init(context: AWSLambdaRuntimeCore.LambdaInitializationContext) async throws {
	}

	func handle(_ event: CognitoEvent, context: LambdaContext) async throws -> CognitoEventResponse {
		context.logger.info("hello: \(event)")

		switch event {
		case .preSignUpSignUp(let params, let preSignup):
			let response = CognitoEventResponse.PreSignUp(autoConfirmUser: true,
														  autoVerifyPhone: false,
														  autoVerifyEmail: false)

			return CognitoEventResponse.preSignUpSignUp(params, preSignup, response)
		}
	}
}
