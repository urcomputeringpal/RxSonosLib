//
//  GetTrackImageInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

open class GetTrackImageValues: RequestValues {
    let track: Track
    
    public init(track: Track) {
        self.track = track
    }
}

open class GetTrackImageInteractor: BaseInteractor<GetTrackImageValues, Data?>  {
    
    let transportRepository: TransportRepository
    
    public init(transportRepository: TransportRepository) {
        self.transportRepository = transportRepository
    }
    
    override func buildInteractorObservable(requestValues: GetTrackImageValues?) -> Observable<Data?> {
        
        guard let track = requestValues?.track else {
            return Observable.error(NSError.sonosLibInvalidImplementationError())
        }
        
        return self.transportRepository
            .getImage(for: track)
    }
}