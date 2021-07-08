//
//  GroupManagementTarget.swift
//  RxSonosLib
//
//  Created by Deno von Selasinsky on 08.07.21.
//  Copyright © 2021 Uberweb. All rights reserved.
//

import Foundation

enum GroupManagementTarget: SonosTargetType {
    
    case addMember(memberId:String)
    case removeMember(memberId:String)
//    case groupAttributes
    
    var action: String {
        switch self {
        case .addMember:
            return "AddMember"
        case .removeMember:
            return "RemoveMember"
//
//        case .groupAttributes:
//            return "GetZoneGroupAttributes"
        }
    }
    
    var arguments: String? {
        switch self {
        case .addMember(let memberID):
            return "<MemberID>\(memberID)</MemberID><BootSeq>0</BootSeq>"
        case .removeMember(let memberID):
            return "<MemberID>\(memberID)</MemberID>"
    }
    
    var controllUrl: String {
        return "/GroupManagement/Control"
    }
    
    var schema: String {
        return "urn:schemas-upnp-org:service:GroupManagement:1"
    }
    
}
