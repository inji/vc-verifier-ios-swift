import XCTest
@testable import vcverifier

final class LdpRevokeCheckerTests: XCTestCase {
    
    private var mockNetworkManager: MockNetworkManager!
    private var checker: LdpRevokeChecker!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        checker = LdpRevokeChecker(networkManager: mockNetworkManager)
    }

    // MARK: - Helpers

    private func loadMockFile(named name: String) throws -> String {
        guard let url = Bundle.module.url(forResource: name, withExtension: "json") else {
            XCTFail("Missing file: \(name)")
            throw NSError(domain: "Test", code: 1)
        }
        return try String(contentsOf: url)
    }


    // MARK: - Tests

    func testShouldReturnFalseWhenVCIsNotRevoked() async throws {
        let vcJson = try loadMockFile(named: "vcUnrevoked-https")
        let statusListJson = try loadMockFile(named: "status-list-vc")

        let data = statusListJson.data(using: .utf8)!
        let parsed = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        mockNetworkManager.mockResponse = parsed

        let isRevoked = try await checker.isRevoked(credential: vcJson)
        XCTAssertFalse(isRevoked)
    }

    func testShouldReturnTrueWhenVCIsRevoked() async throws {
        let vcJson = try loadMockFile(named: "vcRevoked-https")
        let statusListJson = try loadMockFile(named: "status-list-vc")

        let data = statusListJson.data(using: .utf8)!
        let parsed = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        mockNetworkManager.mockResponse = parsed

        let isRevoked = try await checker.isRevoked(credential: vcJson)
        XCTAssertTrue(isRevoked)
    }

    func testShouldReturnFalseWhenCredentialStatusIsMissing() async throws {
        let vcJson = try loadMockFile(named: "PS256SignedMosipVC")
        let isRevoked = try await checker.isRevoked(credential: vcJson)
        XCTAssertFalse(isRevoked)
    }

    func testShouldThrowExceptionForInvalidStatusListCredentialURL() async throws {
        var vcJson = try loadMockFile(named: "vcRevoked-https")
        vcJson = vcJson.replacingOccurrences(of: "https://example.com/status-list", with: "http://localhost:9999/invalid-url")
        
        mockNetworkManager.mockError = NSError(domain: "Network", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mock failure"])

        do {
            _ = try await checker.isRevoked(credential: vcJson)
            XCTFail("Expected RevocationCheckException to be thrown")
        } catch let error as RevocationCheckException {
            switch error {
            case .failed(let message):
                XCTAssertTrue(message.contains("Failed to check revocation"))
            default:
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
}
