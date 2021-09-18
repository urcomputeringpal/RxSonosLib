//
//  BecomeCoordinatorOfStandaloneGroupInteractor.swift
//  RxSonosLib
//
//  Created by Deno von Selasinsky on 18.09.21.
//  Copyright © 2021 Uberweb. All rights reserved.
//

import Foundation

import RxSwift

struct SetBecomeCoordinatorOfStandaloneGroupValues: RequestValues {
    let group: Group
    let idx: Int
}

class SetBecomeCoordinatorOfStandaloneGroupInteractor: CompletableInteractor {

    typealias T = SetBecomeCoordinatorOfStandaloneGroupValues
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(values: SetBecomeCoordinatorOfStandaloneGroupValues?) -> Completable {
        
        guard let group = values?.group,
              let idx = values?.idx else {
            return Completable.error(SonosError.invalidImplementation)
        }
        
        return transportRepository.setBecomeCoordinatorOfStandaloneGroup(for: group, idx: idx)
        
    }
}
