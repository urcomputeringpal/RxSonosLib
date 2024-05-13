//
//  FavProviderItem.swift
//  RxSonosLib
//
//  Created by Deno von Selasinsky on 25.09.21.
//

import Foundation

open class FavProviderItem {
    
    /**
     * Number item in the queue
     */
    public let queueItem: Int
    

    public let title: String
    
    /**
     * track url
     */
    public let uri: String
    
    
    public let description: [TrackDescription: String]
    
    init(queueItem: Int, title: String, uri: String, description: [TrackDescription: String]) {
        self.queueItem = queueItem
        self.title = title
        self.uri = uri
        self.description = description
    }
    
}

extension FavProviderItem: Equatable {
    public static func == (lhs: FavProviderItem, rhs: FavProviderItem) -> Bool {
        return lhs.uri == rhs.uri
    }
}
