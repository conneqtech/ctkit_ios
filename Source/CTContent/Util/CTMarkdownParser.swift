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
        let lines: [String] = contentString.components(separatedBy: CharacterSet.newlines)
        var result: CTContentModel = CTContentModel()
        result.pages = [CTContentBodyModel]()
        result.body = CTContentBodyModel()
        var current = result.body
        var captureAction = false
        for oneLine in lines {
            let line: String = oneLine.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            switch (true) {
            case line.starts(with: swipeItemMarker), line == "": break
                
            case captureAction:
                if let actionMarkerIndex = lines.firstIndex(of: actionMarker) {
                    let markdownActions = lines[actionMarkerIndex...]
                    
                    for action in markdownActions {
                        if action.starts(with: "[") && action.last == ")" {
                            var text = action[action.firstIndex(of: "[")!...action.firstIndex(of: "]")!]
                            text = text.dropFirst()
                            text = text.dropLast()
                            
                            var link = action[action.firstIndex(of: "(")!...action.firstIndex(of: ")")!]
                            link = link.dropFirst()
                            link = link.dropLast()
                            
                            result.button = CTContentButtonModel(text: String(text), link: String(link))
                        }
                    }
                }
                
                captureAction = false
                
            case line.starts(with: titleMarker):
                if current?.title == nil {
                    current?.title = String(line.dropFirst())
                }
                
            case line.starts(with: actionMarker):
                if result.button == nil {
                    captureAction = true
                }
                
            case line.starts(with: swipeItemsEndMarker):
                current = result.body
                
                
            case line.starts(with: swipeItemMarker):
                current = CTContentBodyModel()
                result.pages?.append(current ?? CTContentBodyModel())
                
            case line.starts(with: imageMarker):
                let foundImage: String = findUrlInString(line)
                if foundImage == nil || foundImage == "" {
                    current?.imageUrl = foundImage == "" ? nil : foundImage
                }
                
            default:
                if current?.body == nil {
                    current?.body = ""
                }
                else {
                    let body = current?.body
                    current?.body = "\(body)\n\(line)".trimmingCharacters(in: .whitespacesAndNewlines)
                    
                }
            }
            
        }
        
        if (result.body?.body == nil && result.body?.imageUrl == nil && result.body?.title == nil) {
            result.body = nil
        }
        return result
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
}


