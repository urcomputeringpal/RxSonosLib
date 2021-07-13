//
//  RenderingControlRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class RenderingControlRepositoryImpl: RenderingControlRepository {
    
    private let network = LocalNetwork<RenderingControlTarget>()
    
    func getVolume(for room: Room) -> Single<Int> {
        return network
            .request(.getVolume, on: room)
            .map(mapDataToVolume)
    }
    
    func getVolume(for group: Group) -> Single<Int> {
        let roomObservables = ([group.master] + group.slaves).map(mapRoomToVolume)
        return Single.zip(roomObservables, zipRoomVolumes)
    }
    
    func set(volume: Int, for room: Room) -> Completable {
        return network
            .request(.setVolume(volume), on: room)
            .asCompletable()
    }
    
    func set(volume: Int, for group: Group) -> Completable {
        let roomObservables = ([group.master] + group.slaves).map({ network.request(.setVolume(volume), on: $0) })
        return Single.zip(roomObservables).asCompletable()
    }
    
    func change(volume: Int, for group: Group) -> Completable {
        let maxVolume = 100
        let rooms = [group.master] + group.slaves
        let roomObservables = rooms.map(mapRoomToVolume)
        return Single.zip(roomObservables).asObservable()
            .flatMap({ (volumes) -> Observable<[String: String]> in
                let vol = volumes.reduce(0, +) / volumes.count
                let delta = volume - vol
                if delta == 0 { return Observable<[String: String]>.empty() }
                let multi = delta > 0 ? (maxVolume - vol) / delta : vol / delta
                let volumeObs = Observable.from( volumes.map { $0 + (delta > 0 ? (maxVolume - $0) / multi : $0 / multi) })
                let roomObs = Observable.from(rooms)
                return Observable.zip(volumeObs, roomObs).flatMap { [weak self] (volume, room) -> Observable<[String: String]> in
                    guard let self = self else {return Observable<[String: String]>.empty()}
                    return self.network.request(.setVolume(volume), on: room).asObservable()
                }
            })
            .ignoreElements()
    }
    
    func setMute(room: Room, enabled: Bool) -> Completable {
        return network
            .request(.setMute(enabled), on: room)
            .asCompletable()
    }
    
    func getMute(room: Room) -> Single<Bool> {
        return network
            .request(.getMute, on: room)
            .map(mapDataToMute)
    }
    
}

private extension RenderingControlRepositoryImpl {
    func mapDataToVolume(data: [String: String]) -> Int {
        guard let volumeString = data["CurrentVolume"],
              let volume = Int(volumeString) else {
            return 0
        }
        return volume
    }
    
    func mapRoomToVolume(room: Room) -> Single<Int> {
        return getVolume(for: room)
    }
    
    func zipRoomVolumes(volumes: [Int]) -> Int {
        return volumes.reduce(0, +) / volumes.count
    }
    
    func mapDataToMute(data: [String: String]) throws -> Bool {
        guard let muteString = data["CurrentMute"],
              let mute = Int(muteString) else {
                throw SonosError.noData
        }
        return (mute == 1)
        
    }
}
