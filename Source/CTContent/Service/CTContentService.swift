//
//  CTBilling.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 22/07/2019.
//

import Foundation
import RxSwift

public class CTContentService: NSObject {

    /**
     For now the following mock responses are sent back:

     845f19ee-23a0-47ce-80e6-31351787dc31: Title and body is static, images swipe
     3b42363f-f373-4c95-b657-5a3bf3285b2b: Title is static, body and images swipe
     4ca1e76d-77d3-40af-8c12-b5f55eb63b5d: Everything can swipe
     b97f98ef-63ff-473f-90f9-a77d0b019cfb: Nothing can swipe

     */
    public func fetchContent(withIdentifier identifier: String) -> Observable<CTContentModel> {
        if identifier == "845f19ee-23a0-47ce-80e6-31351787dc31" {
            return Observable.of(getStaticTitleAndBodySwipingImages())
        }
        
        if identifier == "3b42363f-f373-4c95-b657-5a3bf3285b2b" {
            return Observable.of(getStaticTitleSwipingBodyAndImages())
        }
        
        if identifier == "4ca1e76d-77d3-40af-8c12-b5f55eb63b5d" {
            return Observable.of(getAllMovingContent())
        }
        
        if identifier == "b97f98ef-63ff-473f-90f9-a77d0b019cfb" {
            return Observable.of(getAllStaticContent())
        }
        
        return Observable.of(getAllMovingContent())
    }

    func getAllStaticContent() -> CTContentModel {
        let content = CTContentModel(title: "Static title",
                                     body: "Static body nt efficitur nisl. Quisque faucibus dolor arcu, nec luctus velit pretium ut. Sed aliquet ex felis, sit amet molestie urna rhoncus vitae. Vestibulum u sollicitudin tellus lacus ut dolor. Donec id pretium neque, vitae tempus purus. Curabitur pulvinar mi quis elit eleifend volutpat. Aliquam et urna id turpis laoreet fermentum at sit amet erat. Mauris velit nibh, rutrum id metus consequat, tincidunt efficitur nisl. Quisque faucibus dolor arcu, nec luctus velit pretium ut. Sed aliquet",
                                     type: .allStatic,
                                     imageUrl: "https://images.unsplash.com/photo-1565286364541-5f0326e869ad?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1234&q=80",
                                     pages: [],
                                     actions: [])

        return  content
    }

    func getStaticTitleAndBodySwipingImages() -> CTContentModel {
        let pages: [CTContentPageModel] = [
            CTContentPageModel(title: nil,
                               body: nil,
                               imageUrl: "https://images.unsplash.com/photo-1556910109-a14b4226abff?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1234&q=80"),
            CTContentPageModel(title: nil,
                               body: nil,
                               imageUrl: "https://images.unsplash.com/photo-1565330223238-5eba33da3284?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1339&q=80"),
            CTContentPageModel(title: nil,
                               body: nil,
                               imageUrl: "https://images.unsplash.com/photo-1565286364541-5f0326e869ad?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1234&q=80")
        ]

        let content = CTContentModel(title: "Static title", body: "Static body, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus aliquam, neque vel condimentum cursus, justo lorem congue eros, eu sollicitudin tellus lacus ut dolor. Donec id pretium neque, vitae tempus purus. Curabitur pulvinar mi quis elit eleifend volutpat. Aliquam et urna id turpis laoreet fermentum at sit amet erat. Mauris velit nibh, rutrum id metus consequat, tincidunt efficitur nisl. Quisque faucibus dolor arcu, nec luctus velit pretium ut. Sed aliquet ex felis, sit amet molestie urna rhoncus vitae. Vestibulum mollis non nunc vel condimentum.", type: .titleAndBodyStatic, imageUrl: nil, pages: pages, actions: [])

        return  content
    }

    func getStaticTitleSwipingBodyAndImages() -> CTContentModel {
        let pages: [CTContentPageModel] = [
            CTContentPageModel(title: nil,
                               body: "Body 1, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus aliquam, neque vel condimentum cursus, justo lorem congue eros, eu sollicitudin tellus lacus ut dolor. Donec id pretium neque, vitae tempus purus. Curabitur pulvinar mi quis elit eleifend volutpat. Aliquam et urna id turpis laoreet fermentum at sit amet erat. Mauris velit nibh, rutrum id metus consequat, tincidunt efficitur nisl. Quisque faucibus dolor arcu, nec luctus velit pretium ut. Sed aliquet ex felis, sit amet molestie urna rhoncus vitae. Vestibulum u sollicitudin tellus lacus ut dolor. Donec id pretium neque, vitae tempus purus. Curabitur pulvinar mi quis elit eleifend volutpat. Aliquam et urna id turpis laoreet fermentum at sit amet erat. Mauris velit nibh, rutrum id metus consequat, tincidunt efficitur nisl. Quisque faucibus dolor arcu, nec luctus velit pretium ut. Sed aliquet ex felis, sit amet molestie urna rhoncus vitae. Vestibulum mo mollis non nunc vel condimentum.",
                               imageUrl: "https://images.unsplash.com/photo-1556910109-a14b4226abff?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1234&q=80"),
            CTContentPageModel(title: nil,
                               body: "Body 2, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus aliquam, neque vel condimentum cursus, justo lorem congue eros, eu sollicitudin tellus lacus ut dolor. Donec id pretium neque, vitae tempus purus. Curabitur pulvinar mi quis elit eleifend volutpat.",
                               imageUrl: "https://images.unsplash.com/photo-1565330223238-5eba33da3284?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1339&q=80"),
            CTContentPageModel(title: nil,
                               body: "Body 3, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus aliquam, neque vel condimentum cursus, justo lorem congue eros, eu sollicitudin tellus lacus ut dolor. Donec id pretium neque, vitae tempus purus. Curabitur pulvinar mi quis elit eleifend volutpat. Aliquam et urna id turpis laoreet fermentum at sit amet erat. Mauris velit nibh, rutrum id metus consequat, tincidunt efficitur nisl. Quisque faucibus dolor arcu, nec luctus velit pretium ut. Sed aliquet ex felis, sit amet molestie urna rhoncus vitae. Vestibulum mollis non nunc vel condimentum.",
                               imageUrl: "https://images.unsplash.com/photo-1565286364541-5f0326e869ad?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1234&q=80")
        ]

        let content = CTContentModel(title: "Static title", body: nil, type: .titleStatic, imageUrl: nil, pages: pages, actions: [])

        return  content
    }

    func getAllMovingContent() -> CTContentModel {
        let pages: [CTContentPageModel] = [
            CTContentPageModel(title: "Feature 1",
                               body: "Body 1, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus aliquam, neque vel condimentum cursus, justo lorem congue eros, eu sollicitudin tellus lacus ut dolor. Donec id pretium neque, vitae tempus purus. Curabitur pulvinar mi quis elit eleifend volutpat. Aliquam et urna id turpis laoreet fermentum at sit amet erat. Mauris velit nibh, rutrum id metus consequat, tincidunt efficitur nisl. Quisque faucibus dolor arcu, nec luctus velit pretium ut. Sed aliquet ex felis, sit amet molestie urna rhoncus vitae. Vestibulum u sollicitudin tellus lacus ut dolor. Donec id pretium neque, vitae tempus purus. Curabitur pulvinar mi quis elit eleifend volutpat. Aliquam et urna id turpis laoreet fermentum at sit amet erat. Mauris velit nibh, rutrum id metus consequat, tincidunt efficitur nisl. Quisque faucibus dolor arcu, nec luctus velit pretium ut. Sed aliquet ex felis, sit amet molestie urna rhoncus vitae. Vestibulum mo mollis non nunc vel condimentum.",
                               imageUrl: "https://images.unsplash.com/photo-1556910109-a14b4226abff?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1234&q=80"),
            CTContentPageModel(title: "Feature two that is so long it might actually take 2 lines to fully show in the app. Such a shame",
                               body: "Body 2, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus aliquam, neque vel condimentum cursus, justo lorem congue eros, eu sollicitudin tellus lacus ut dolor. Donec id pretium neque, vitae tempus purus. Curabitur pulvinar mi quis elit eleifend volutpat.",
                               imageUrl: "https://images.unsplash.com/photo-1565330223238-5eba33da3284?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1339&q=80"),
            CTContentPageModel(title: "Feature 3",
                               body: "Body 3, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus aliquam, neque vel condimentum cursus, justo lorem congue eros, eu sollicitudin tellus lacus ut dolor. Donec id pretium neque, vitae tempus purus. Curabitur pulvinar mi quis elit eleifend volutpat. Aliquam et urna id turpis laoreet fermentum at sit amet erat. Mauris velit nibh, rutrum id metus consequat, tincidunt efficitur nisl. Quisque faucibus dolor arcu, nec luctus velit pretium ut. Sed aliquet ex felis, sit amet molestie urna rhoncus vitae. Vestibulum mollis non nunc vel condimentum.",
                               imageUrl: "https://images.unsplash.com/photo-1565286364541-5f0326e869ad?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1234&q=80")
        ]

        let content = CTContentModel(title: nil, body: nil, type: .allMoving, imageUrl: nil, pages: pages, actions: [])

        return  content
    }
}
