//
//  GroupManagementRepositoryImpl.swift
//  RxSonosLib
//
//  Created by Deno von Selasinsky on 08.07.21.
//  Copyright © 2021 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import AEXML

class GroupManagementRepositoryImpl: GroupManagementRepository {
    
    private let network = LocalNetwork<GroupManagementTarget>()
    
    func addMember(memberId: String, for room: Room) -> Completable {
        return network
            .request(.addMember(memberId: memberId), on: room)
            .asCompletable()
    }
    
    func removeMember(memberId: String, for room: Room) -> Completable {
        return network
            .request(.removeMember(memberId: memberId), on: room)
            .asCompletable()
    }
    
}
