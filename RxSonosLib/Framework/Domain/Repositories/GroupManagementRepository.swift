//
//  GroupManagementRepository.swift
//  RxSonosLib
//
//  Created by Deno von Selasinsky on 08.07.21.
//  Copyright © 2021 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol GroupManagementRepository {
    
    func addMember(memberID: String, for room: Room) -> Completable
    
    func removeMember(memberID: String, for room: Room) -> Completable
    
}
