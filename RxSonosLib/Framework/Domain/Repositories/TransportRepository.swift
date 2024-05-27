//
//  TransportRepositoryImpl.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol TransportRepository {

    func getNowPlaying(for room: Room) -> Single<Track?>

    func getNowPlayingProgress(for room: Room) -> Single<GroupProgress>

    func getTransportState(for room: Room) -> Single<TransportState>

    func getImage(for track: Track) -> Maybe<Data>

    func setNextTrack(for room: Room) -> Completable

    func setPreviousTrack(for room: Room) -> Completable

    func setPlay(group: Group) -> Completable

    func setPlayUri(uri: String, group: Group) -> Completable

    func addTrackToQueuePlayNext(uri: String, metadata: String, group: Group) -> Completable

    func addTrackToQueueEnd(uri: String, metadata: String, group: Group) -> Completable

    func removeTrackFromQueue(track: Int, group: Group) -> Completable

    func removeAllTracksFromQueue(group: Group) -> Completable

    func setPause(group: Group) -> Completable

    func setStop(group: Group) -> Completable

    func seekTrack(time: String, for room: Room) -> Completable

    func changeTrack(number: Int, for room: Room) -> Completable

    func setAVTransportURI(for group: Group, masterURI: String, metadata: String) -> Completable

    func setBecomeCoordinatorOfStandaloneGroup(for group: Group, idx: Int) -> Completable

}
