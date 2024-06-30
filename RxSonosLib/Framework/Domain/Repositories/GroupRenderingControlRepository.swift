//
//  GroupRenderingControlRepository.swift
//  RxSonosLib
//
//  Created by Jesse Newland on 6/3/24.
//  Copyright © 2024 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol GroupRenderingControlRepository {

    func getGroupVolume(for room: Room) -> Single<Int>

    func setGroupVolume(volume: Int, for room: Room) -> Completable

    func setRelativeGroupVolume(volume: Int, for room: Room) -> Completable

    func snapshotGroupVolume(for room: Room) -> Completable

    func getGroupMute(for room: Room) -> Single<Bool>

    func setGroupMute(enabled: Bool, for room: Room) -> Completable

}
