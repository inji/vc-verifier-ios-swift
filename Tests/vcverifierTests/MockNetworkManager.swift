import Foundation
@testable import vcverifier

/// A test double for NetworkManagerClient, used for injecting mock responses during unit tests.
final class MockNetworkManager: NetworkManaging {
    
    // MARK: - Configurable Properties
    
    /// The response that will be returned when `sendHTTPRequest` is called.
    var mockResponse: [String: Any]?
    
    /// The error that will be thrown if you want to simulate a network failure.
    var mockError: Error?
    
    /// A flag to track whether the request was invoked (useful for assertions).
    private(set) var isRequestCalled = false
    
    /// Captured parameters for validation in tests.
    private(set) var lastURL: String?
    private(set) var lastMethod: HttpMethod?
    private(set) var lastHeaders: [String: String]?
    private(set) var lastBodyParams: [String: String]?
    
    // MARK: - Implementation
    
    func sendHTTPRequest(
        url: String,
        method: HttpMethod,
        bodyParams: [String: String]? = nil,
        headers: [String: String]? = nil
    ) async throws -> [String: Any] {
        isRequestCalled = true
        lastURL = url
        lastMethod = method
        lastHeaders = headers
        lastBodyParams = bodyParams
        
        if let mockError {
            throw mockError
        }
        
        guard let response = mockResponse else {
            throw NetworkManagerClientException.failed("Mock response not set")
        }
        
        return response
    }
}
