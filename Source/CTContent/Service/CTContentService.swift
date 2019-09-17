//
//  CTBilling.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation
import RxSwift
import Alamofire

public class CTContentService: NSObject {
    public func fetchContent(withIdentifier identifier: String) -> Observable<CTContentModel?> {
        return CTContent.shared.restManager.get(endpoint: "\(identifier)").map { (responseModel: CTContentResponseModel) in
            return CTMarkdownParser().parseContent(withContentString: responseModel.content)
        }
    }

    public func fetchUnparsedContent(withIdentifier identifier: String) -> Observable<String> {
        return CTContent.shared.restManager.getUnparsed(endpoint: "\(identifier)/raw")
    }
}
