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
