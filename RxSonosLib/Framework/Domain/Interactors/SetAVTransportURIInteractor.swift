//
//  SetAVTransportURIInteractor.swift
//  RxSonosLib
//
//  Created by Deno von Selasinsky on 17.09.21.
//  Copyright © 2021 Uberweb. All rights reserved.
//

import Foundation

import RxSwift

struct SetAVTransportURIValues: RequestValues {
    let group: Group
    let masterUrl: String
    let metadata: String
}

class SetAVTransportURIInteractor: CompletableInteractor {

    typealias T = SetAVTransportURIValues

    private let transportRepository: TransportRepository

    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }

    func buildInteractorObservable(values: SetAVTransportURIValues?) -> Completable {

        guard let group = values?.group,
              let masterUrl = values?.masterUrl,
              let metadata = values?.metadata
              else {
            return Completable.error(SonosError.invalidImplementation)
        }

        return transportRepository.setAVTransportURI(for: group, masterURI: masterUrl, metadata: metadata)

    }
}

struct SetRoomAVTransportURIValues: RequestValues {
    let room: Room
    let uri: String
    let metadata: String
}

class SetRoomAVTransportURIInteractor: CompletableInteractor {

    typealias T = SetRoomAVTransportURIValues

    private let transportRepository: TransportRepository

    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }

    func buildInteractorObservable(values: SetRoomAVTransportURIValues?) -> Completable {

        guard let room = values?.room,
              let uri = values?.uri,
              let metadata = values?.metadata
              else {
            return Completable.error(SonosError.invalidImplementation)
        }

        return transportRepository.setAVTransportURI(room: room, masterURI: uri, metadata: metadata)

    }
}
