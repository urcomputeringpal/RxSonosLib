//
//  GroupRenderingControlRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Jesse Newland on 6/3/24.
//  Copyright © 2024 Uberweb. All rights reserved.
//

import Foundation
import RxSwift


class GroupRenderingControlRepositoryImpl: GroupRenderingControlRepository {

    private let network = LocalNetwork<GroupRenderingControlTarget>()

    func getGroupVolume(for room: Room) -> Single<Int> {
        return network
            .request(.getGroupVolume, on: room)
            .map(mapDataToVolume)
    }

    func setGroupVolume(volume: Int, for room: Room) -> Completable {
        return network
            .request(.setGroupVolume(volume), on: room)
            .asCompletable()
    }

    func setRelativeGroupVolume(volume: Int, for room: Room) -> Completable {
        return network
            .request(.setRelativeGroupVolume(volume), on: room)
            .asCompletable()
    }

    func snapshotGroupVolume(for room: Room) -> Completable {
        return network
            .request(.snapshotGroupVolume, on: room)
            .asCompletable()
    }


    func getGroupMute(for room: Room) -> Single<Bool> {
        return network
            .request(.getGroupMute, on: room)
            .map(mapDataToMute)
    }

    func setGroupMute(enabled: Bool, for room: Room) -> Completable {
        return network
            .request(.setGroupMute(enabled), on: room)
            .asCompletable()
    }

}

private extension GroupRenderingControlRepositoryImpl {
    func mapDataToVolume(data: [String: String]) -> Int {
        guard let volumeString = data["CurrentVolume"],
              let volume = Int(volumeString) else {
            return 0
        }
        return volume
    }


    func mapDataToMute(data: [String: String]) throws -> Bool {
        guard let muteString = data["CurrentMute"],
              let mute = Int(muteString) else {
                throw SonosError.noData
        }
        return (mute == 1)

    }
}
