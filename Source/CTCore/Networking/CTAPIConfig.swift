//
//  CTAPIConfig.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

public class CTApiConfig {
    var url: String
    var clientId: String
    var clientSecret: String
    var grantType: CTOauth2Grant
    var fullUrl: String {
        get {
            return url
        }
    }

    public init (withBaseUrl baseUrl: String, clientId: String, clientSecret: String, grantType: CTOauth2Grant) {
        self.url = baseUrl
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.grantType = grantType
    }
}

public class CTJwtApiConfig: CTApiConfig {
    init (withBaseUrl baseUrl: String) {
        super.init(withBaseUrl: baseUrl, clientId: "", clientSecret: "", grantType: .jwt)
    }
}

public class CTVendorApiConfig: CTApiConfig {
    var version: String = ""
    var vendor: String = ""

    override var fullUrl: String {
        get {
            return "\(url)/\(version)"
        }
    }

    init (withBaseUrl baseUrl: String, clientId: String, clientSecret: String, grantType: CTOauth2Grant, version: String, vendor: String) {
        super.init(withBaseUrl: baseUrl, clientId: clientId, clientSecret: clientSecret, grantType: grantType)
        self.version = version
        self.vendor = vendor
    }
}
