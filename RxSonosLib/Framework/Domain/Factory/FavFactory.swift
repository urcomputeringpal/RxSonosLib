//
//  FavFactory.swift
//  RxSonosLib
//
//  Created by Deno von Selasinsky on 25.09.21.
//

import Foundation

struct FavFactory {
    
    private let room: URL
    private let queueItem: Int
    private let data: [String: String]
    
    init(room: URL, queueItem: Int, data: [String: String]) {
        self.room = room
        self.queueItem = queueItem
        self.data = data
    }
    
    func create() throws -> FavProviderItem? {
        
        guard let uri = data["res"],
            let title = data["title"],
            let description = getDescription() else {
                return nil
        }
        
        return FavProviderItem(queueItem: queueItem, title: title, uri: uri, description: description)
    }
    
    private func getDescription() -> [TrackDescription: String]? {
        guard let title = data["title"] else { return nil }
        let description = [TrackDescription.title: title]
        
        return description
    }
    
}
