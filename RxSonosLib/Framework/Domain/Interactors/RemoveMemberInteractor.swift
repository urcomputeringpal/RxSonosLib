//
//  RemoveMemberInteractor.swift
//  RxSonosLib
//
//  Created by Deno von Selasinsky on 08.07.21.
//  Copyright © 2021 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct RemoveMemberValues: RequestValues {
    let room: Room
    let memberId: String
}

class RemoveMemberInteractor: CompletableInteractor {
    
    typealias T = RemoveMemberValues
    
    private let groupManagementRepository: GroupManagementRepository
    
    init(groupManagementRepository: GroupManagementRepository) {
        self.groupManagementRepository = groupManagementRepository
    }
    
    func buildInteractorObservable(values: RemoveMemberValues?) -> Completable {
        guard let room = values?.room,
              let memberId = values?.memberId else {
            return Completable.error(SonosError.invalidImplementation)
        }
        
        return groupManagementRepository
            .removeMember(memberId: memberId, for: room)
    }
}
