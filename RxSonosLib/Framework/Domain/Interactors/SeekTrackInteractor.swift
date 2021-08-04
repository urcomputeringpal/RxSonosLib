//
//  SeekTrackInteractor.swift
//  RxSonosLib
//
//  Created by Roman Sokolov on 01/08/2021.
//  Copyright © 2021 GPL v3 http://www.gnu.org/licenses/gpl.html
//

import Foundation
import RxSwift

struct SeekTrackValues: RequestValues {
    let group: Group
    let time: String
}

class SeekTrackInteractor: CompletableInteractor {
    
    typealias T = SeekTrackValues
    
    private let transportRepository: TransportRepository
    
    init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    func buildInteractorObservable(values: SeekTrackValues?) -> Completable {
        guard let group = values?.group,
              let time = values?.time else {
            return Completable.error(SonosError.invalidImplementation)
        }
        
        return transportRepository
            .seekTrack(time: time, for: group.master)
    }
}
