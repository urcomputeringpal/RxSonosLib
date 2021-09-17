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
}

class SetAVTransportURIInteractor: CompletableInteractor {

    typealias T = SetAVTransportURIValues
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(values: SetAVTransportURIValues?) -> Completable {
        
        guard let group = values?.group,
              let masterUrl = values?.masterUrl else {
            return Completable.error(SonosError.invalidImplementation)
        }
        
        return transportRepository.setAVTransportURI(for: group, masterURI: masterUrl)
        
    }
}
