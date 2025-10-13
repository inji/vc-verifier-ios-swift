public enum CredentialFormat: String {
    case ldpVc = "ldp_vc"

    static func from(_ value: String) -> CredentialFormat? {
        return CredentialFormat(rawValue: value)
    }
}
