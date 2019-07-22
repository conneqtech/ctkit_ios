//
//  CTOAuth2GrantTypes.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 24/09/2018.
//

public enum CTOauth2Grant: String {
    case clientCredentials = "client_credentials"
    case resourceOwner = "password"
    case jwt = "jwt"
}
