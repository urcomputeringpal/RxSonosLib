//
//  FakeTransportRepositoryImpl.swift
//  iOS Demo App
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
@testable import RxSonosLib
import RxSwift

class FakeTransportRepositoryImpl: TransportRepository {
    func setPlayUri(uri: String, group: RxSonosLib.Group) -> RxSwift.Completable {
        return Completable.empty()
    }
    
    func addTrackToQueuePlayNext(uri: String, metadata: String, group: RxSonosLib.Group) -> RxSwift.Completable {
        return Completable.empty()
    }
    
    func addTrackToQueue(uri: String, metadata: String, number: Int, group: RxSonosLib.Group) -> RxSwift.Completable {
        return Completable.empty()
    }
    
    func removeTrackFromQueue(track: Int, group: RxSonosLib.Group) -> RxSwift.Completable {
        return Completable.empty()
    }
    
    func removeAllTracksFromQueue(group: RxSonosLib.Group) -> RxSwift.Completable {
        return Completable.empty()
    }
    
    func seekTrack(time: String, for room: RxSonosLib.Room) -> RxSwift.Completable {
        return Completable.empty()
    }
    
    func changeTrack(number: Int, for room: RxSonosLib.Room) -> RxSwift.Completable {
        return Completable.empty()
    }
    
    func setAVTransportURI(for group: RxSonosLib.Group, masterURI: String, metadata: String) -> RxSwift.Completable {
        return Completable.empty()
    }
    
    func setAVTransportURI(room: RxSonosLib.Room, masterURI: String, metadata: String) -> RxSwift.Completable {
        return Completable.empty()
    }
    
    func setBecomeCoordinatorOfStandaloneGroup(for group: RxSonosLib.Group, idx: Int) -> RxSwift.Completable {
        return Completable.empty()
    }
    
    func setBecomeCoordinatorOfStandaloneRoomGroup(room: RxSonosLib.Room) -> RxSwift.Completable {
        return Completable.empty()
    }
    
    func setAVTransportURI(for room: Room, masterURI: String) -> Completable {
        return Completable.empty()
    }
    
    func getNowPlaying(for room: Room) -> Single<Track?> {
        return Single.just(MusicProviderTrack(sid: 9, flags: nil, sn: nil, queueItem: 7, duration: 265, uri: "x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1", imageUri: URL(string: "http://192.168.3.14:1400/getaa?s=1&u=x-sonos-spotify:spotify%3atrack%3a2MUy4hpwlwAaHV5mYHgMzd?sid=9&flags=8224&sn=1")!, description: [TrackDescription.title: "Before I Die", TrackDescription.artist: "Papa Roach", TrackDescription.album: "The Connection"], mediaInfo: [:], contentType: TrackContentType.lineInHomeTheater))
    }
    
    func getNowPlayingProgress(for room: Room) -> Single<GroupProgress> {
        return Single.just(GroupProgress(time: 30, duration: 60))
    }
    
    func getTransportState(for room: Room) -> Single<TransportState> {
        return Single.just(TransportState.paused)
    }
    
    func getImage(for track: Track) -> Maybe<Data> {
        let image = UIImage(named: "papa-roach-the-connection.jpg", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        let data = image.pngData()!
        return Maybe.just(data)
    }
    
    var nextTrackCounter = 0
    func setNextTrack(for room: Room) -> Completable {
        nextTrackCounter += 1
        return Completable.empty()
    }
    
    var previousTrackCounter = 0
    func setPreviousTrack(for room: Room) -> Completable {
        previousTrackCounter += 1
        return Completable.empty()
    }
    
    var activeState: TransportState?
    func setPlay(group: Group) -> Completable {
        activeState = TransportState.playing
        return Completable.empty()
    }
    
    func setPause(group: Group) -> Completable {
        activeState = TransportState.paused
        return Completable.empty()
    }
    
    func setStop(group: Group) -> Completable {
        activeState = TransportState.stopped
        return Completable.empty()
    }
    
}
