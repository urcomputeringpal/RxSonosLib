//
//  ContentDirectoryRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class ContentDirectoryRepositoryImpl: ContentDirectoryRepository {
    
    private let network = LocalNetwork<ContentDirectoryTarget>()
    
    func getQueue(for room: Room) -> Single<[MusicProviderTrack]> {
        return network
            .request(.browse, on: room)
            .map(mapDataToQueue(room: room))
    }
    
    func getFavorites(for room: Room) -> Single<[FavProviderItem]> {
        return network
            .request(.favorites, on: room)
            .map(mapDataToFavList(room: room))
    }
    
}

private extension ContentDirectoryRepositoryImpl {
    func mapDataToQueue(room: Room) -> (([String: String]) throws -> [MusicProviderTrack]) {
        return { data in
            return try data["Result"]?
                .mapMetaItems()?
                .enumerated()
                .compactMap(self.mapQueueItemToTrack(room: room)) ?? []
        }
    }
    
    func mapQueueItemToTrack(room: Room) -> ((Int, [String: String]) throws -> MusicProviderTrack?) {
        return { index, data in
            print(data)
            return try QueueTrackFactory(room: room.ip, queueItem: index + 1, data: data).create()
        }
    }
    
    func mapDataToFavList(room: Room) -> (([String: String]) throws -> [FavProviderItem]) {
        return { data in
            return try data["Result"]?
                .mapMetaItems()?
                .enumerated()
                .compactMap(self.mapItemToFav(room: room)) ?? []
        }
    }
    
    func mapItemToFav(room: Room) -> ((Int, [String: String]) throws -> FavProviderItem?) {
        return { index, data in
            print(data)
            return try FavFactory(room: room.ip, queueItem: index + 1, data: data).create()
        }
    }
}
