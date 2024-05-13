//
//  ContentDirectoryRepository.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol ContentDirectoryRepository {
    
    func getQueue(for room: Room) -> Single<[MusicProviderTrack]>
    func getFavorites(for room: Room) -> Single<[FavProviderItem]>
    
}
