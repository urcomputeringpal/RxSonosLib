//
//  Group.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

open class Group: Codable {

    /// The Master Room handles all requests that are fired to the Sonos Group
    public let master: Room

    /// Only some requests are also processed by slave rooms, as example volume controll requests
    public let slaves: [Room]

    /// Name of the group
    public lazy var name: String = {
        return (slaves.count > 0) ? "\(master.name) +\(slaves.count)" : master.name
    }()

    /// All Room names in this group
    public lazy var names: [String] = {
        return Array(Set(rooms.map({ $0.name })))
    }()

    /// All Rooms in this group
    var rooms: [Room] {
        return [master] + slaves
    }


    public init(master: Room, slaves: [Room]) {
        self.master = master
        self.slaves = slaves
    }

}

extension Group: Equatable {
    public static func == (lhs: Group, rhs: Group) -> Bool {

        return lhs.master == rhs.master && lhs.slaves.sorted(by: sortRooms) == rhs.slaves.sorted(by: sortRooms)
    }
}

extension Group : Identifiable {
    public var id: String {
        return self.master.deviceDescription.serialNumber
    }
}


private func sortRooms(room1: Room, room2: Room) -> Bool {
    return room1.uuid > room2.uuid
}

extension ObservableType where E == Group {
    public func getRooms() -> Observable<[Room]> {
        return
            self
            .map({ (group) -> [Room] in
                return group.rooms
            })
            .distinctUntilChanged()
    }

    public func getTrack() -> Observable<Track?> {
        return
            self
            .flatMap({ (group) -> Observable<Track?> in
                return SonosInteractor.getTrack(group)
            })
    }

    public func getImage() -> Observable<Data?> {
        return
            self
            .getTrack()
            .flatMap(ignoreNil)
            .flatMap({ (track) -> Observable<Data?> in
                return Observable
                    .just(track)
                    .getImage()
            })
            .distinctUntilChanged()
    }

    public func getProgress() -> Observable<GroupProgress> {
        return
            self
            .flatMap({ (group) -> Observable<GroupProgress> in
                return SonosInteractor.getProgress(group)
            })
            .distinctUntilChanged()
    }

    public func getQueue() -> Observable<[MusicProviderTrack]> {
        return
            self
            .flatMap({ (group) -> Observable<[MusicProviderTrack]> in
                return SonosInteractor.getQueue(group)
            })
    }

    public func getFavorites() -> Observable<[FavProviderItem]> {
        return
            self
            .flatMap({ (group) -> Observable<[FavProviderItem]> in
                return SonosInteractor.getFavorites(group)
            })
    }

    public func getTransportState() -> Observable<TransportState> {
        return
            self
            .flatMap({ (group) -> Observable<TransportState> in
                return SonosInteractor.getTransportState(group)
            })
    }

    public func set(transportState: TransportState) -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.setTransport(state: transportState, for: group)
            })
    }

    public func changeTrack(number: Int) -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.changeTrack(number: number, for: group)
            })
    }

    public func getVolume() -> Observable<Int> {
        return
            self
            .flatMap({ (group) -> Observable<Int> in
                return SonosInteractor.getVolume(group)
            })
    }

    public func set(volume: Int) -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.set(volume: volume, for: group)
            })
    }

    public func setNextTrack() -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.setNextTrack(group)
            })
    }

    public func setPreviousTrack() -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.setPreviousTrack(group)
            })
    }

    public func setPlayUri(_ uri: String) -> Completable {
           return
               self
               .take(1)
               .asSingle()
               .flatMapCompletable({ (group) -> Completable in
                   return SonosInteractor.setPlayUri(uri, group)
               })
       }

    public func addTrackToQueuePlayNext(uri:String, metadata:String) -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.addTrackToQueuePlayNext(uri: uri, metadata: metadata, group: group)
            })
    }

    public func addTrackToQueue(uri:String, metadata:String, number: Int) -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.addTrackToQueue(uri: uri, metadata: metadata, number: number, group: group)
            })
    }

    public func removeTrackFromQueue(track: Int) -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.removeTrackFromQueue(track: track, group: group)
            })
    }

    public func removeAllTracksFromQueue() -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.removeAllTracksFromQueue(group)
            })
    }

    public func getMute() -> Observable<[Bool]> {
        return
            self
            .take(1)
            .getRooms()
            .getMute()
    }

    public func set(mute enabled: Bool) -> Completable {
        return
            self
            .take(1)
            .getRooms()
            .set(mute: enabled)
    }

    public func setAVTransportURI(masterUrl: String, metadata: String, group: Group) -> Completable {
        return SonosInteractor.setAVTransportURI(masterUrl: masterUrl, metadata: metadata, for: group)
    }

    public func setBecomeCoordinatorOfStandaloneGroup(idx: Int, group: Group) -> Completable {
        return SonosInteractor.setBecomeCoordinatorOfStandaloneGroup(idx: idx, for: group)
    }

    public func getGroupVolume() -> Observable<Int> {
        return
            self
            .take(1)
            .flatMap({ (group) -> Observable<Int> in
                return SonosInteractor.getGroupVolume(for: group.master)
            })
            .asObservable()
    }

    public func setGroupVolume(volume: Int) -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.setGroupVolume(volume: volume, for: group.master)
            })
    }

    public func setRelativeGroupVolume(volume: Int) -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.setRelativeGroupVolume(volume: volume, for: group.master)
            })
    }

    public func setGroupMute(enabled: Bool) -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.setGroupMute(enabled: enabled, for: group.master)
            })
    }

    public func getGroupMute() -> Observable<Bool> {
        return
            self
            .take(1)
            .flatMap({ (group) -> Observable<Bool> in
                return SonosInteractor.getGroupMute(for: group.master)
            })
            .asObservable()
    }

    public func snapshotGroupVolume() -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (group) -> Completable in
                return SonosInteractor.snapshotGroupVolume(for: group.master)
            })
    }
}
