public protocol CTKitBase {
    var restManager: CTRestManager! { get set }
    var authManager: CTAuthManager! { get set }

    func hasActiveSession() -> Bool

    func getActiveSessionEndDate() -> Date
    func getActiveSessionToken() -> String

    func terminateActiveSession()
}
