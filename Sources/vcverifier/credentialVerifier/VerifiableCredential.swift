import Foundation

protocol VerifiableCredential {
    func isRevoked(credential: String) async throws-> Bool
}
