//
//  SetNextTrackInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 18/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct SetNextTrackValues: RequestValues {
    let group: Group
}

class SetNextTrackInteractor: CompletableInteractor {

    typealias T = SetNextTrackValues

    private let transportRepository: TransportRepository

    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }

    func buildInteractorObservable(values: SetNextTrackValues?) -> Completable {
        guard let group = values?.group else {
            return Completable.error(SonosError.invalidImplementation)
        }

        return transportRepository
            .setNextTrack(for: group.master)
    }
}

struct SetPlayUriValues: RequestValues {
    let group: Group
    let uri:String
}

class SetPlayUriInteractor: CompletableInteractor {

    typealias T = SetPlayUriValues

    private let transportRepository: TransportRepository

    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }

    func buildInteractorObservable(values: SetPlayUriValues?) -> Completable {
        guard let group = values?.group, let uri = values?.uri else {
            return Completable.error(SonosError.invalidImplementation)
        }

        return transportRepository
            .setPlayUri(uri: uri, group: group)
    }
}
struct AddTrackToQueueValues: RequestValues {
    let group: Group
    let uri:String
    let metadata:String
}

class AddTrackToQueuePlayNextInteractor: CompletableInteractor {

    typealias T = AddTrackToQueueValues

    private let transportRepository: TransportRepository

    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }

    func buildInteractorObservable(values: AddTrackToQueueValues?) -> Completable {
        guard let group = values?.group, let uri = values?.uri, let metadata = values?.metadata else {
            return Completable.error(SonosError.invalidImplementation)
        }

        return transportRepository
            .addTrackToQueuePlayNext(uri: uri, metadata: metadata, group: group)
    }
}

class AddTrackToQueueEndInteractor: CompletableInteractor {

    typealias T = AddTrackToQueueValues

    private let transportRepository: TransportRepository

    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }

    func buildInteractorObservable(values: AddTrackToQueueValues?) -> Completable {
        guard let group = values?.group, let uri = values?.uri, let metadata = values?.metadata else {
            return Completable.error(SonosError.invalidImplementation)
        }

        return transportRepository
            .addTrackToQueueEnd(uri: uri, metadata: metadata, group: group)
    }
}

struct RemoveTrackFromQueueValues: RequestValues {
    let group: Group
    let track: Int
}

class RemoveTrackFromQueueInteractor: CompletableInteractor {

    typealias T = RemoveTrackFromQueueValues

    private let transportRepository: TransportRepository

    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }

    func buildInteractorObservable(values: RemoveTrackFromQueueValues?) -> Completable {
        guard let group = values?.group, let track = values?.track else {
            return Completable.error(SonosError.invalidImplementation)
        }

        return transportRepository
            .removeTrackFromQueue(track: track, group: group)
    }
}

struct RemoveAllTracksFromQueueValues: RequestValues {
    let group: Group
}

class RemoveAllTracksFromQueueInteractor: CompletableInteractor {

    typealias T = RemoveAllTracksFromQueueValues

    private let transportRepository: TransportRepository

    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }

    func buildInteractorObservable(values: RemoveAllTracksFromQueueValues?) -> Completable {
        guard let group = values?.group else {
            return Completable.error(SonosError.invalidImplementation)
        }

        return transportRepository
            .removeAllTracksFromQueue(group: group)
    }
}
