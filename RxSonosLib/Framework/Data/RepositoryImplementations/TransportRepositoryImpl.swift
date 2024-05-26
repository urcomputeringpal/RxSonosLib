//
//  TransportRepositoryImpl.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class TransportRepositoryImpl: TransportRepository {

    private let network = LocalNetwork<TransportTarget>()

    func getNowPlaying(for room: Room) -> Single<Track?> {

        let positionInfoNetwork = network.request(.positionInfo, on: room)
        let mediaInfoNetwork = network.request(.mediaInfo, on: room)

        return Single.zip(positionInfoNetwork, mediaInfoNetwork, resultSelector: mapDataToNowPlaying(for: room))
    }

    func getNowPlayingProgress(for room: Room) -> Single<GroupProgress> {
        return network.request(.positionInfo, on: room)
            .map(mapPositionInfoDataToProgress)
    }

    func getTransportState(for room: Room) -> Single<TransportState> {
        return network.request(.transportInfo, on: room)
            .map(mapTransportDataToState)
    }

    func getImage(for track: Track) -> Maybe<Data> {
        let downloadNetwork = DownloadNetwork()
        guard let imageUri = (track as? TrackImage)?.imageUri else {
            return Maybe.empty()
        }

        if let cachedImage = CacheManager.shared.get(for: .trackImage, item: track.uri) {
            return Maybe.just(cachedImage)
        }

        return downloadNetwork
            .request(download: imageUri)
            .do(onSuccess: { (data) in
                CacheManager.shared.set(data, for: .trackImage, item: track.uri)
            })
            .asMaybe()
    }

    func setNextTrack(for room: Room) -> Completable {
        return network.request(.next, on: room)
            .asCompletable()
    }

    func setPreviousTrack(for room: Room) -> Completable {
        return network.request(.previous, on: room)
            .asCompletable()
    }

    func setPlay(group: Group) -> Completable {
        return network.request(.play, on: group.master)
            .asCompletable()
    }


    func addTrackToQueuePlayNext(uri: String, group: Group) -> Completable {
        return network.request(.addTrackToQueuePlayNext(uri: uri), on: group.master)
            .asCompletable()
    }

    func addTrackToQueueEnd(uri: String, group: Group) -> Completable {
        return network.request(.addTrackToQueueEnd(uri: uri), on: group.master)
            .asCompletable()
    }

    func removeTrackFromQueue(track: Int, group: Group) -> Completable {
        return network.request(.removeTrackFromQueue(number: track), on: group.master)
            .asCompletable()
    }

    func setPlayUri(uri: String, group: Group) -> Completable {
        // TODO optional metadata?
        return network.request(.setAVTransportURI(uri: uri, metadata: ""), on: group.master)
            .asCompletable()
    }

    func setPause(group: Group) -> Completable {
        return network.request(.pause, on: group.master)
            .asCompletable()
    }

    func setStop(group: Group) -> Completable {
        return network.request(.stop, on: group.master)
            .asCompletable()
    }

    func seekTrack(time: String, for room: Room) -> Completable {
        return network.request(.seekTime(time: time), on: room)
            .asCompletable()
    }

    func changeTrack(number: Int, for room: Room) -> Completable {
        return network.request(.changeTrack(number: number), on: room)
            .asCompletable()
    }


    func setAVTransportURI(for group: Group, masterURI: String, metadata: String) -> Completable {
        return network.request(.setAVTransportURI(uri: masterURI, metadata: metadata), on: group.master)
            .asCompletable()
    }

    func setBecomeCoordinatorOfStandaloneGroup(for group: Group, idx: Int) -> Completable {
        let slave = group.slaves[idx]
        return network.request(.setBecomeCoordinatorOfStandaloneGroup, on: slave)
            .asCompletable()
    }
}

private extension TransportRepositoryImpl {
    func mapDataToNowPlaying(for room: Room) -> (([String: String], [String: String]) throws -> Track?) {
        return { positionInfoResult, mediaInfoResult in
            guard let track = try NowPlayingTrackFactory(room: room.ip,
                                                         positionInfo: positionInfoResult,
                                                         mediaInfo: mediaInfoResult,
                                                         progress: self.mapPositionInfoDataToProgress(data: positionInfoResult))
                    .create() else {
                    return nil
            }

            return track
        }
    }

    func mapTransportDataToState(data: [String: String]) -> TransportState {
        return TransportState.map(string: data["CurrentTransportState"])
    }

    func mapPositionInfoDataToProgress(data: [String: String]) -> GroupProgress {
        return GroupProgress.map(positionInfo: data)
    }
}
