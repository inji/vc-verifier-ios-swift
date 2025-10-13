import Foundation

struct CredentialVerifierFactory {
    func get(format: CredentialFormat) -> VerifiableCredential {
        switch format {
        case .ldpVc:
            return LdpVerifiableCredential()
        }
    }
}
