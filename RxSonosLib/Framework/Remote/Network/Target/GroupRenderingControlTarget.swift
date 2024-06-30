//
//  GroupRenderingControlTarget.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

enum GroupRenderingControlTarget: SonosTargetType {

    case getGroupMute
    case setGroupMute(Bool)
    case getGroupVolume
    case setGroupVolume(Int)
    case setRelativeGroupVolume(Int)
    case snapshotGroupVolume

    var action: String {
        switch self {
            case .getGroupMute:
                return "GetGroupMute"
            case .setGroupMute:
                return "SetGroupMute"
            case .getGroupVolume:
                return "GetGroupVolume"
            case .setGroupVolume:
                return "SetGroupVolume"
            case .setRelativeGroupVolume:
                return "SetRelativeGroupVolume"
            case .snapshotGroupVolume:
                return "SnapshotGroupVolume"
        }
    }

    var arguments: String? {
        switch self {
        case .getGroupMute:
            return "<InstanceID>0</InstanceID>"
        case .setGroupMute(let enable):
            return "<InstanceID>0</InstanceID><Channel>Master</Channel><DesiredMute>\(enable ? 1: 0)</DesiredMute>"
        case .getGroupVolume:
            return "<InstanceID>0</InstanceID>"
        case .setGroupVolume(let volume):
            // correct volume to be between 0 and 100
            let volume = max(min(volume, 100), 0)
            return "<InstanceID>0</InstanceID><DesiredVolume>\(volume)</DesiredVolume>"
        case .setRelativeGroupVolume(let volume):
            // correct volume to be between -100 and 100
            let volume = max(min(volume, 100), -100)
            return "<InstanceID>0</InstanceID><Adjustment>\(volume)</Adjustment>"
        case .snapshotGroupVolume:
            return "<InstanceID>0</InstanceID>"
        }
    }

    var controllUrl: String {
        return "/MediaRenderer/GroupRenderingControl/Control"
    }

    // var eventUrl: String {
    //     return "/MediaRenderer/GroupRenderingControl/Event"
    // }

    var schema: String {
        return "urn:schemas-upnp-org:service:GroupRenderingControl:1"
    }
}
