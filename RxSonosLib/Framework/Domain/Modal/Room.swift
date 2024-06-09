//
//  Room.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 02/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

open class Room: Codable {

    public let ssdpDevice: SSDPDevice
    public let deviceDescription: DeviceDescription

    public var hasProxy: Bool { return ssdpDevice.hasProxy }
    public var name: String { return deviceDescription.name }
    public var ip: URL { return ssdpDevice.ip }
    public var uuid: String { return ssdpDevice.uuid! }
    public var userAgent: String { return ssdpDevice.server }

    public init(ssdpDevice: SSDPDevice, deviceDescription: DeviceDescription) {
        self.ssdpDevice = ssdpDevice
        self.deviceDescription = deviceDescription
    }

}

extension ObservableType where E == [Room] {
    public func getMute() -> Observable<[Bool]> {
        return
            self
            .foreachRoom(perform: { (room) -> Observable<Bool> in
                return Observable.just(room).getMute()
            })
    }

    public func set(mute enabled: Bool) -> Completable {
        return
            self
                .take(1)
                .foreachRoom(perform: { (room) -> Completable in
                    return SonosInteractor.set(mute: enabled, for: room)
                })
    }

    internal func foreachRoom<T>(perform: @escaping ((Room) -> (Observable<T>))) -> Observable<[T]> {
        return
            self
            .flatMap({ (rooms) -> Observable<[T]> in
                let collection = rooms.map({ (room) -> Observable<T> in
                    return perform(room)
                })
                return Observable.zip(collection)
            })
    }

    internal func foreachRoom(perform: @escaping ((Room) -> (Completable))) -> Completable {
        return
            self
                .take(1)
                .asSingle()
                .flatMapCompletable({ (rooms) -> Completable in
                    let events = rooms.map({ (room) -> Completable in
                        return perform(room)
                    })
                    return Completable.merge(events)
                })
    }

}

extension ObservableType where E == Room {
    public func getMute() -> Observable<Bool> {
        return
            self
            .flatMap({ (room) -> Observable<Bool> in
                return SonosInteractor.getMute(for: room)
            })
    }

    public func set(mute enabled: Bool) -> Completable {
        return
            self
            .take(1)
            .asSingle()
            .flatMapCompletable({ (room) -> Completable in
                return SonosInteractor.set(mute: enabled, for: room)
            })
    }
}

extension Room: Equatable {
    public static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.ssdpDevice.usn == lhs.ssdpDevice.usn && lhs.ssdpDevice.ip == rhs.ssdpDevice.ip && lhs.deviceDescription == rhs.deviceDescription
    }
}
