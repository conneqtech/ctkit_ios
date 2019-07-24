public protocol CTKitBase {
    var restManager: CTRestManager { get set }
    var authManager: CTAuthManagerBase { get set }
    var isConfigured: Bool { get set }
}
