//
//  GetVolumeInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetVolumeValues: RequestValues {
    let group: Group

    init(group: Group) {
        self.group = group
    }
}

class GetVolumeInteractor: ObservableInteractor {

    typealias T = GetVolumeValues

    private let renderingControlRepository: RenderingControlRepository

    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }

    func buildInteractorObservable(values: GetVolumeValues?) -> Observable<Int> {

        guard let group = values?.group else {
            return Observable.error(SonosError.invalidImplementation)
        }

        return createTimer(SonosSettings.shared.renewGroupVolumeTimer)
            .flatMap(mapToVolume(for: group))
            .distinctUntilChanged({ $0 == $1 })
    }
}

private extension GetVolumeInteractor {
    func mapToVolume(for group: Group) -> ((Int) -> Observable<Int>) {
        return { _ in
            return self.renderingControlRepository
                .getVolume(for: group)
                .asObservable()
        }
    }
}

class GetRoomVolumeValues: RequestValues {
    let room: Room

    init(room: Room) {
        self.room = room
    }
}

class GetRoomVolumeInteractor: ObservableInteractor {

    typealias T = GetRoomVolumeValues

    private let renderingControlRepository: RenderingControlRepository

    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }

    func buildInteractorObservable(values: GetRoomVolumeValues?) -> Observable<Int> {

        guard let room = values?.room else {
            return Observable.error(SonosError.invalidImplementation)
        }

        return createTimer(SonosSettings.shared.renewGroupVolumeTimer)
            .flatMap(mapToVolume(for: room))
            .distinctUntilChanged({ $0 == $1 })
    }
}

private extension GetRoomVolumeInteractor {
    func mapToVolume(for room: Room) -> ((Int) -> Observable<Int>) {
        return { _ in
            return self.renderingControlRepository
                .getVolume(for: room)
                .asObservable()
        }
    }
}
