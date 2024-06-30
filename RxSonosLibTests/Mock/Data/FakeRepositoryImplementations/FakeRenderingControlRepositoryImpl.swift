//
//  FakeRenderingControlRepositoryImpl.swift
//  RxSonosLibTests
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
@testable import RxSonosLib

class FakeRenderingControlRepositoryImpl: RenderingControlRepository {
    func change(volume: Int, for group: RxSonosLib.Group) -> RxSwift.Completable {
        return Completable.empty()
    }
    
    
    func getVolume(for room: Room) -> Single<Int> {
        return Single.just(30)
    }
    
    func getVolume(for group: Group) -> Single<Int> {
        return Single.just(70)
    }
    
    func set(volume: Int, for room: Room) -> Completable {
        return Completable.empty()
    }
    
    var lastVolume: Int?
    func set(volume: Int, for group: Group) -> Completable {
        self.lastVolume = volume
        return Completable.empty()
    }
    
    var numberSetMuteCalls = 0
    func setMute(room: Room, enabled: Bool) -> Completable {
        numberSetMuteCalls += 1
        return Completable.empty()
    }
    
    var numberGetMuteCalls = 0
    func getMute(room: Room) -> Single<Bool> {
        numberGetMuteCalls += 1
        return Single.just(true)
    }
}
