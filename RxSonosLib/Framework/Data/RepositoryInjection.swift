//
//  RepositoryInjection.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSSDP

class RepositoryInjection {
    internal static let shared: RepositoryInjection = RepositoryInjection()

    init() {
        CacheManager.shared.clear()
    }

    internal var ssdpRepository: SSDPRepository = SSDPRepositoryImpl()
    static public func provideSSDPRepository() -> SSDPRepository {
        return shared.ssdpRepository
    }

    internal var roomRepository: RoomRepository = RoomRepositoryImpl()
    static public func provideRoomRepository() -> RoomRepository {
        return shared.roomRepository
    }

    internal var groupRepository: GroupRepository = GroupRepositoryImpl()
    static public func provideGroupRepository() -> GroupRepository {
        return shared.groupRepository
    }

    internal var groupManagementRepository: GroupManagementRepository = GroupManagementRepositoryImpl()
    static public func provideGroupManagementRepository() -> GroupManagementRepository {
        return shared.groupManagementRepository
    }

    internal var transportRepository: TransportRepository = TransportRepositoryImpl()
    static public func provideTransportRepository() -> TransportRepository {
        return shared.transportRepository
    }

    internal var contentDirectoryRepository: ContentDirectoryRepository = ContentDirectoryRepositoryImpl()
    static public func provideContentDirectoryRepository() -> ContentDirectoryRepository {
        return shared.contentDirectoryRepository
    }

    internal var renderingControlRepository: RenderingControlRepository = RenderingControlRepositoryImpl()
    static public func provideRenderingControlRepository() -> RenderingControlRepository {
        return shared.renderingControlRepository
    }

    internal var groupRenderingControlRepository: GroupRenderingControlRepository = GroupRenderingControlRepositoryImpl()
    static public func provideGroupRenderingControlRepository() -> GroupRenderingControlRepository {
        return shared.groupRenderingControlRepository
    }

    internal var musicProvidersRepository: MusicProvidersRepository = MusicProvidersRepositoryImpl()
    static public func provideMusicProvidersRepository() -> MusicProvidersRepository {
        return shared.musicProvidersRepository
    }

}
