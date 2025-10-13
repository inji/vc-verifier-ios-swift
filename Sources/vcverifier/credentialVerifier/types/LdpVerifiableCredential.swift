import Foundation

struct LdpVerifiableCredential: VerifiableCredential {
    func isRevoked(credential: String) async throws-> Bool {
        try await LdpRevokeChecker().isRevoked(credential: credential)
    }
}

