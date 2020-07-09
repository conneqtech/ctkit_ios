//
//  CTMarkdownParser.swift
//  ctkit
//
//  Created by Gert-Jan Vercauteren on 28/08/2019.
//

import Foundation

public class CTMarkdownParser {

    let titleMarker = "# "
    let imageMarker = "![alt text]("
    let actionMarker = "===ACTION==="

    let swipeItemsStartMarker = "===SWIPE_ITEMS_START==="
    let swipeItemsEndMarker = "===SWIPE_ITEMS_END==="
    let swipeItemMarker = "===SWIPE_ITEM==="

    public func parseContent(withContentString contentString: String) -> CTContentModel? {
        let contentArray = prepareContentArray(withContentString: contentString)
        let contentType = determineContentType(withContentArray: contentArray)

        var title: String?
        var body: String?
        var imageUrl: String?
        if contentType != .allMoving {
            title = extractTitle(withContentArray: contentArray)
            body = extractBody(withContentArray: contentArray)
            imageUrl = extractImageUrl(withContentArray: contentArray)
        }

        var pages: [CTContentPageModel] = []

        if contentType != .allStatic {
            pages = extractPages(withContentArray: contentArray)
        }

        let actions = extractActions(withContentArray: contentArray)

        return CTContentModel(title: title, body: body, type: contentType, imageUrl: imageUrl, pages: pages, actions: actions)
    }
}

// MARK: - Content extraction
extension CTMarkdownParser {
    func extractTitle(withContentArray contentArray: [String]) -> String? {
        var title: String?

        for line in contentArray {
            if line.starts(with: swipeItemsStartMarker) {
                break
            }

            if line.starts(with: titleMarker) {
                title = String(line.dropFirst(2))
                break
            }
        }

        return title
    }

    func extractBody(withContentArray contentArray: [String]) -> String? {
        var body: [String] = []

        for line in contentArray {
            if line.starts(with: titleMarker) {
                continue
            }

            if line.starts(with: swipeItemsStartMarker) {
                break
            }

            if line.starts(with: imageMarker) {
                break
            }

            if line.starts(with: actionMarker) {
                break
            }

            if !line.isEmpty {
                body.append(line)
            }
        }

        let joined = body.joined(separator: "\n")

        return joined != "" ? joined : nil
    }

    func extractImageUrl(withContentArray contentArray: [String]) -> String? {
        var imageUrl: String?

        for line in contentArray {
            if line.starts(with: swipeItemsStartMarker) {
                break
            }

            if line.starts(with: imageMarker) {
                imageUrl = line
                break
            }
        }

        let urlMatch = findUrlInString(imageUrl)
        return urlMatch == "" ? nil : urlMatch
    }
}

// MARK: - Page extraction
extension CTMarkdownParser {
    func extractPages(withContentArray contentArray: [String]) -> [CTContentPageModel] {
        var pages: [CTContentPageModel] = []

        var pageIndexes: [Int] = []
        for (index, line) in contentArray.enumerated() {
            if line.starts(with: swipeItemMarker) {
                pageIndexes.append(index+1)
            }
        }

        let lastPageEndIndex = contentArray.firstIndex(of: swipeItemsEndMarker)

        for (index, item) in pageIndexes.enumerated() {
            var pageSlice: ArraySlice<String>?
            if index != pageIndexes.count - 1 {
                let endIndex = pageIndexes[index+1] - 1
                pageSlice = contentArray[item..<endIndex]
            } else {
                if let lastPageEndIndex = lastPageEndIndex {
                    pageSlice = contentArray[item..<lastPageEndIndex]
                }
            }

            if let slice = pageSlice {
                let pageArray = Array(slice)
                let title = extractTitle(withContentArray: pageArray)
                let body = extractBody(withContentArray: pageArray)
                let imageUrl = extractImageUrl(withContentArray: pageArray)

                let contentPage = CTContentPageModel(title: title, body: body, imageUrl: imageUrl)
                pages.append(contentPage)
            }
        }
        return pages
    }
}

// MARK: - Button extraction
extension CTMarkdownParser {
    func extractActions(withContentArray contentArray: [String]) -> [CTContentButtonModel] {
        var actions: [CTContentButtonModel] = []

        if let actionMarkerIndex = contentArray.firstIndex(of: actionMarker) {
            let markdownActions = contentArray[actionMarkerIndex...]

            for action in markdownActions {
                if action.starts(with: "[") && action.last == ")" {
                    var text = action[action.firstIndex(of: "[")!...action.firstIndex(of: "]")!]
                    text = text.dropFirst()
                    text = text.dropLast()

                    var link = action[action.firstIndex(of: "(")!...action.firstIndex(of: ")")!]
                    link = link.dropFirst()
                    link = link.dropLast()

                   actions.append(CTContentButtonModel(text: String(text), link: String(link)))
                }
            }
        }

        return actions
    }
}

// MARK: - Utils
extension CTMarkdownParser {
    /**
     Split the string into entries in an array for further processing.
     This is the first step in parsing the contentString we receive from the contentAPI.
     */
    func prepareContentArray(withContentString contentString: String) -> [String] {
        var content: [String] = []
        let lines = contentString.components(separatedBy: CharacterSet.newlines)
        lines.forEach {
            if $0.count != 0 {
                content.append(String($0))
            }
        }

        return content
    }

    func findUrlInString(_ imageLine: String?) -> String {
        guard let input = imageLine else {
            return ""
        }

        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

        var url: String = ""
        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            url = String(input[range])
        }

        return url
    }

    func determineContentType(withContentArray contentArray: [String]) -> CTContentType {
        if !contentArray.contains(swipeItemsStartMarker) {
            return .allStatic
        }

        var determinedType: CTContentType?
        var alreadyFoundSwipeItem = false

        contentArray.forEach { line in
            //If we find a title tag before a swipe item at least the title is static
            if determinedType == nil && line.starts(with: titleMarker) {
                determinedType = .titleStatic
            }

            if line.starts(with: swipeItemsStartMarker) {
                alreadyFoundSwipeItem = true

                // If we haven't found a title and we find SWIPE_ITEMS_START first, everything moves.
                if determinedType == nil {
                    determinedType = .allMoving
                }
            }

            // If we already found swipe item there is no use in finding some body text.
            if !alreadyFoundSwipeItem {
                // If we already find a title, check if we find a body before swipe_items_start body is static too.
                if determinedType == .titleStatic && !line.isEmpty && !line.starts(with: titleMarker) {
                    determinedType = .titleAndBodyStatic
                }
            }
        }

        guard let type = determinedType else {
            return .allStatic
        }

        return type
    }
}
