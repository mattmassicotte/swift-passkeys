# swift-passkeys
An experiment building passkey-based auth with Swift and AWS

## The Parts

[AWS Cognito](https://aws.amazon.com/cognito/) is the user database. Cognito can do all kinds of things, including built-in support for Sign in with Apple. But, as of right now, it does not support WebAuthn. So, custom hooks and a [WebAuthn package][webauthn-package] are required and made this project much more complex.

[AWS API Gateway](https://aws.amazon.com/api-gateway) is used as an HTTP server.

Routes:

- `GET /.well-known/apple-app-site-association`
- `GET /makeCredential?username=xyz`
- `POST /makeCredential?username=xyz`

[AWS Lambda](https://aws.amazon.com/lambda/) is used to run the Swift code for the HTTP server responses and Cognito hooks.

[AWS CloudFormation][cloudformation] is used to set up and configure the AWS resources.

## Manual Configuration

I had a goal of making this all zero-cost. Unforutnately, I ran into a snag. Apple's AuthenticationServices framework requires a domain that serves `/.well-known/apple-app-site-association`. And a top-level path requires using a custom domain with API Gateway. This is possible do with CloudFormation, but requires a Route 53 hosted zone, which costs 0.50$ per month. To get around this, I left the custom domain for API Gateway manual.

## Code of Conduct

Everyone interacting in the rake-remote-file project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mattmassicotte/rake-remote-file/blob/master/CODE_OF_CONDUCT.md).

[cloudformation]: https://aws.amazon.com/cloudformation
[webauthn-package]: https://github.com/swift-server/webauthn-swift