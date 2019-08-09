//
//  CTBilling.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation
import RxSwift

public class CTContentService: NSObject {
    
    public func fetchContent(withIdentifier identifier: String) -> Observable<CTContentModel> {
        return Observable.of(getAllMovingContent())
    }


    func getAllMovingContent() -> CTContentModel {
        let pages: [CTContentPageModel] = [
            CTContentPageModel(title: "Feature 1", body: "Cool feature bro", imageUrl: "https://example.com/image.png"),
            CTContentPageModel(title: "Feature 1", body: "Cool feature bro", imageUrl: "https://example.com/image.png"),
            CTContentPageModel(title: "Feature 1", body: "Cool feature bro", imageUrl: "https://example.com/image.png"),
        ]

        let content = CTContentModel(title: nil, body: nil, type: .allMoving, imageUrl: nil, pages: pages)

        return  content
    }
}
