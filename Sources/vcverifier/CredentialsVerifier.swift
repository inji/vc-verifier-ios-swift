import Foundation

public struct CredentialsVerifier {

    public init() {}

    public func verify(credential: String, format: CredentialFormat) async -> VerificationResult {
        do {
            let verifier = CredentialVerifierFactory().get(format: format)
            let isRevoked = try await verifier.isRevoked(credential: credential)
            
            if isRevoked {
                return VerificationResult(
                    verificationStatus: false,
                    verificationMessage: ERROR_VC_REVOKED,
                    verificationErrorCode: ERROR_CODE_VC_REVOKED,
                    statusListVC: nil
                )
            }
            
            return VerificationResult(
                verificationStatus: true,
                verificationMessage: "",
                verificationErrorCode: "",
                statusListVC: nil
            )
        } catch {
            return VerificationResult(
                verificationStatus: false,
                verificationMessage: "Exception during Verification: \(error.localizedDescription)",
                verificationErrorCode: ERROR_CODE_VERIFICATION_FAILED,
                statusListVC: nil
            )
        }
    }

}
