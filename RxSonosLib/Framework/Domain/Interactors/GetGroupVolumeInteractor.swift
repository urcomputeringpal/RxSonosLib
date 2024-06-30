//
//  GroupRenderingControlInteractors.swift
//  RxSonosLib
//
//  Created by Jesse Newland on 6/3/24.
//  Copyright © 2024 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

    // func getGroupVolume(for room: Room) -> Single<Int>

    // func setGroupVolume(volume: Int, for room: Room) -> Completable

    // func setRelativeGroupVolume(volume: Int, for room: Room) -> Completable

    // func snapshotGroupVolume(for room: Room) -> Completable

    // func getGroupMute(for room: Room) -> Single<Bool>

    // func setGroupMute(enabled: Bool, for room: Room) -> Completable

class GetGroupVolumeValues: RequestValues {
    let room: Room

    init(room: Room) {
        self.room = room
    }
}

class GetGroupVolumeInteractor: ObservableInteractor {

    typealias T = GetGroupVolumeValues

    private let groupRenderingControlRepository: GroupRenderingControlRepository

    init(groupRenderingControlRepository: GroupRenderingControlRepository) {
        self.groupRenderingControlRepository = groupRenderingControlRepository
    }

    func buildInteractorObservable(values: GetGroupVolumeValues?) -> Observable<Int> {

        guard let room = values?.room else {
            return Observable.error(SonosError.invalidImplementation)
        }

        return createTimer(SonosSettings.shared.renewGroupVolumeTimer)
            .flatMap(mapToVolume(for: room))
            .distinctUntilChanged({ $0 == $1 })
    }
}

private extension GetGroupVolumeInteractor {
    func mapToVolume(for room: Room) -> ((Int) -> Observable<Int>) {
        return { _ in
            return self.groupRenderingControlRepository
                .getGroupVolume(for: room)
                .asObservable()
        }
    }
}

class SetGroupVolumeValues: RequestValues {
    let volume: Int
    let room: Room

    init(volume: Int, room: Room) {
        self.volume = volume
        self.room = room
    }
}

class SetGroupVolumeInteractor: CompletableInteractor {

    typealias T = SetGroupVolumeValues

    private let groupRenderingControlRepository: GroupRenderingControlRepository

    init(groupRenderingControlRepository: GroupRenderingControlRepository) {
        self.groupRenderingControlRepository = groupRenderingControlRepository
    }

    func buildInteractorObservable(values: SetGroupVolumeValues?) -> Completable {

        guard let volume = values?.volume, let room = values?.room else {
            return Completable.error(SonosError.invalidImplementation)
        }

        return groupRenderingControlRepository
            .setGroupVolume(volume: volume, for: room)
    }
}

class SetRelativeGroupVolumeValues: RequestValues {
    let volume: Int
    let room: Room

    init(volume: Int, room: Room) {
        self.volume = volume
        self.room = room
    }
}

class SetRelativeGroupVolumeInteractor: CompletableInteractor {

    typealias T = SetRelativeGroupVolumeValues

    private let groupRenderingControlRepository: GroupRenderingControlRepository

    init(groupRenderingControlRepository: GroupRenderingControlRepository) {
        self.groupRenderingControlRepository = groupRenderingControlRepository
    }

    func buildInteractorObservable(values: SetRelativeGroupVolumeValues?) -> Completable {

        guard let volume = values?.volume, let room = values?.room else {
            return Completable.error(SonosError.invalidImplementation)
        }

        return groupRenderingControlRepository
            .setRelativeGroupVolume(volume: volume, for: room)
    }
}

class SnapshotGroupVolumeValues: RequestValues {
    let room: Room

    init(room: Room) {
        self.room = room
    }
}

class SnapshotGroupVolumeInteractor: CompletableInteractor {

    typealias T = SnapshotGroupVolumeValues

    private let groupRenderingControlRepository: GroupRenderingControlRepository

    init(groupRenderingControlRepository: GroupRenderingControlRepository) {
        self.groupRenderingControlRepository = groupRenderingControlRepository
    }

    func buildInteractorObservable(values: SnapshotGroupVolumeValues?) -> Completable {

        guard let room = values?.room else {
            return Completable.error(SonosError.invalidImplementation)
        }

        return groupRenderingControlRepository
            .snapshotGroupVolume(for: room)
    }
}

class GetGroupMuteValues: RequestValues {
    let room: Room

    init(room: Room) {
        self.room = room
    }
}

class GetGroupMuteInteractor: ObservableInteractor {

    typealias T = GetGroupMuteValues

    private let groupRenderingControlRepository: GroupRenderingControlRepository

    init(groupRenderingControlRepository: GroupRenderingControlRepository) {
        self.groupRenderingControlRepository = groupRenderingControlRepository
    }

    func buildInteractorObservable(values: GetGroupMuteValues?) -> Observable<Bool> {

        guard let room = values?.room else {
            return Observable.error(SonosError.invalidImplementation)
        }

        return createTimer(SonosSettings.shared.renewGroupVolumeTimer)
            .flatMap(mapToMute(for: room))
            .distinctUntilChanged({ $0 == $1 })
    }
}

private extension GetGroupMuteInteractor {

    func mapToMute(for room: Room) -> ((Int) -> Observable<Bool>) {
        return { _ in
            return self.groupRenderingControlRepository
                .getGroupMute(for: room)
                .asObservable()
        }
    }
}

class SetGroupMuteValues: RequestValues {
    let enabled: Bool
    let room: Room

    init(enabled: Bool, room: Room) {
        self.enabled = enabled
        self.room = room
    }
}

class SetGroupMuteInteractor: CompletableInteractor {

    typealias T = SetGroupMuteValues

    private let groupRenderingControlRepository: GroupRenderingControlRepository

    init(groupRenderingControlRepository: GroupRenderingControlRepository) {
        self.groupRenderingControlRepository = groupRenderingControlRepository
    }

    func buildInteractorObservable(values: SetGroupMuteValues?) -> Completable {

        guard let enabled = values?.enabled, let room = values?.room else {
            return Completable.error(SonosError.invalidImplementation)
        }

        return groupRenderingControlRepository
            .setGroupMute(enabled: enabled, for: room)
    }
}
