import Foundation
import Gzip

// MARK: - Protocol for mocking

protocol NetworkManaging {
    func sendHTTPRequest(url: String, method: HttpMethod, bodyParams: [String: String]?,
                         headers: [String: String]?) async throws -> [String: Any]
}

// MARK: - Revocation Checker

final class LdpRevokeChecker {
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging = NetworkManagerClient.shared) {
        self.networkManager = networkManager
    }

    func isRevoked(credential: String) async throws -> Bool {
        do {
            guard let credentialData = credential.data(using: .utf8),
                  let vc = try JSONSerialization.jsonObject(with: credentialData) as? [String: Any]
            else {
                throw RevocationCheckException.invalidCredentialJSON
            }

            guard let credentialStatus = vc["credentialStatus"] as? [String: Any] else {
                return false
            }

            guard let statusListCredentialURL = credentialStatus["statusListCredential"] as? String else {
                throw RevocationCheckException.missingStatusListCredential
            }

            guard let statusListIndexString = credentialStatus["statusListIndex"] as? String,
                  let statusListIndex = Int(statusListIndexString)
            else {
                throw RevocationCheckException.invalidStatusListIndex
            }

            let statusListVCMap = try await networkManager.sendHTTPRequest(
                url: statusListCredentialURL,
                method: .get,
                bodyParams: nil,
                headers: nil
            )

            guard
                let credentialSubject = statusListVCMap["credentialSubject"] as? [String: Any],
                let encodedList = credentialSubject["encodedList"] as? String
            else {
                throw RevocationCheckException.invalidStatusListContent
            }

            let decodedBitSet = decodeEncodedList(encodedList)
            return isIndexRevoked(statusListIndex, bitSet: decodedBitSet)

        } catch {
            throw RevocationCheckException.failed("Failed to check revocation: \(error.localizedDescription)")
        }
    }

    private func isIndexRevoked(_ index: Int, bitSet: [UInt8]) -> Bool {
        let byteIndex = index / 8
        let bitIndex = index % 8

        guard byteIndex < bitSet.count else {
            return false
        }

        let targetByte = Int(bitSet[byteIndex])
        return ((targetByte >> (7 - bitIndex)) & 1) == 1
    }

    private func decodeEncodedList(_ encodedList: String) -> [UInt8] {
        let base64url = encodedList.hasPrefix("u") ? String(encodedList.dropFirst()) : encodedList
        guard let compressedData = try? decodeBase64URL(base64url) else {
            return []
        }
        return decompressGzip(data: compressedData)
    }

    private func decompressGzip(data: Data) -> [UInt8] {
        guard let decompressed = try? data.gunzipped() else {
            return []
        }
        return [UInt8](decompressed)
    }
}
