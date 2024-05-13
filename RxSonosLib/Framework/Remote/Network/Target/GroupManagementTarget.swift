//
//  GroupManagementTarget.swift
//  RxSonosLib
//
//  Created by Deno von Selasinsky on 08.07.21.
//  Copyright © 2021 Uberweb. All rights reserved.
//

import Foundation

enum GroupManagementTarget: SonosTargetType {
    
    case addMember(memberId: String)
    case removeMember(memberId: String)
    
    var action: String {
        switch self {
        case .addMember:
            return "AddMember"
        case .removeMember:
            return "RemoveMember"

        }
    }
    
    var arguments: String? {
        switch self {
        case .addMember(let memberId):
            return "<MemberID>\(memberId)</MemberID><BootSeq>0</BootSeq>"
        case .removeMember(let memberId):
            return "<MemberID>\(memberId)</MemberID>"
        }
    }
    
    var controllUrl: String {
        return "/GroupManagement/Control"
    }
    
    var schema: String {
        return "urn:schemas-upnp-org:service:GroupManagement:1"
    }
    
}
