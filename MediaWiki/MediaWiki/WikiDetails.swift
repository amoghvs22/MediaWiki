//
//  WikiDetails.swift
//  MediaWiki
//
//  Created by Mac Mini on 29/09/18.
//

import UIKit

class WikiDetails: NSObject {
    var title  : String!
    var pageID : Int!
    var imgSource : String!
    
    class func initializeArray(_ res: NSDictionary) -> [WikiDetails]? {
        var resultsArray = [WikiDetails]()
        if let queryDict = res.value(forKey:"query") as? NSDictionary,
            let pagesArray = queryDict.value(forKey: "pages") as? NSArray {
            for dict in pagesArray {
                guard let obj = initializeDetails(dict as! NSDictionary) else { continue }
                resultsArray.append(obj)
            }
            return resultsArray
        }
        return nil
    }
    
    class func initializeDetails(_ updateDict:NSDictionary) -> WikiDetails? {
        
        let retVal  = WikiDetails()
        guard let pageID = updateDict.value(forKey:"pageid") as? Int,
            let title = updateDict.value(forKey:"title") as? String,
            let imgDict = updateDict.value(forKey:"thumbnail") as? NSDictionary,
            let imgSrc = imgDict.value(forKey: "source") as? String else { return nil }
        
        retVal.pageID = pageID
        retVal.title = title
        retVal.imgSource = imgSrc
        
        return retVal
    }
}
