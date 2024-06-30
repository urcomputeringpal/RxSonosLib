//
//  TransportTarget.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 31/08/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

enum TransportTarget: SonosTargetType {

    case play
    case pause
    case stop
    case previous
    case next
    case positionInfo
    case transportInfo
    case mediaInfo
    case changeTrack(number: Int)
    case seekTime(time: String)
    case reorderTracksInQueue(startingIndex: Int, numberOfTracks: Int, insertBefore: Int)
    case removeTrackFromQueue(number: Int)
    case removeAllTracksFromQueue
    case addTrackToQueue(uri: String, metadata: String, number: Int)
    case addTrackToQueuePlayNext(uri: String, metadata: String)
    case setQueue(uri: String, metadata: String)
    case setAVTransportURI(uri: String, metadata: String)
    case setBecomeCoordinatorOfStandaloneGroup

    var action: String {
        switch self {
        case .play:
            return "Play"
        case .pause:
            return "Pause"
        case .stop:
            return "Stop"
        case .previous:
            return "Previous"
        case .next:
            return "Next"
        case .changeTrack, .seekTime:
            return "Seek"
        case .addTrackToQueue, .addTrackToQueuePlayNext:
            return "AddURIToQueue"
        case .removeTrackFromQueue:
            return "RemoveTrackFromQueue"
        case .positionInfo:
            return "GetPositionInfo"
        case .transportInfo:
            return "GetTransportInfo"
        case .mediaInfo:
            return "GetMediaInfo"
        case .removeAllTracksFromQueue:
            return "RemoveAllTracksFromQueue"
        case .reorderTracksInQueue:
            return "ReorderTracksInQueue"
        case .setQueue:
            return "SetAVTransportURI"
        case .setAVTransportURI:
            return "SetAVTransportURI"
        case .setBecomeCoordinatorOfStandaloneGroup:
            return "BecomeCoordinatorOfStandaloneGroup"
        }
    }

    var arguments: String? {
        switch self {
        case .play, .pause, .stop, .previous, .next:
            return "<InstanceID>0</InstanceID><Speed>1</Speed>"
        case .addTrackToQueuePlayNext(let uri, let metadata):
            return "<InstanceID>0</InstanceID><EnqueuedURI>\(uri)</EnqueuedURI><EnqueuedURIMetaData>\(metadata)</EnqueuedURIMetaData><DesiredFirstTrackNumberEnqueued>0</DesiredFirstTrackNumberEnqueued><EnqueueAsNext>1</EnqueueAsNext>"
        case .addTrackToQueue(let uri, let metadata, let number):
            return "<InstanceID>0</InstanceID><EnqueuedURI>\(uri)</EnqueuedURI><EnqueuedURIMetaData>\(metadata)</EnqueuedURIMetaData><DesiredFirstTrackNumberEnqueued>\(number)</DesiredFirstTrackNumberEnqueued><EnqueueAsNext>0</EnqueueAsNext>"
        case .removeTrackFromQueue(let number):
            return "<InstanceID>0</InstanceID><ObjectID>Q:0/\(number)</ObjectID>"
        case .seekTime(let time):
            return "<InstanceID>0</InstanceID><Unit>REL_TIME</Unit><Target>\(time)</Target>"
        case .changeTrack(let number):
            return "<InstanceID>0</InstanceID><Unit>TRACK_NR</Unit><Target>\(number)</Target>"
        case .positionInfo, .transportInfo, .mediaInfo, .setBecomeCoordinatorOfStandaloneGroup:
            return "<InstanceID>0</InstanceID><Channel>Master</Channel>"
        case .reorderTracksInQueue(let startingIndex, let numberOfTracks, let insertBefore):
            return "<InstanceID>0</InstanceID><StartingIndex>\(startingIndex)</StartingIndex><NumberOfTracks>\(numberOfTracks)</NumberOfTracks><InsertBefore>\(insertBefore)</InsertBefore><UpdateID>0</UpdateID>"
        case .removeAllTracksFromQueue:
            return "<InstanceID>0</InstanceID>"
        case .setQueue(let uri, let metadata), .setAVTransportURI(let uri, let metadata):
            return "<InstanceID>0</InstanceID><CurrentURI>\(uri)</CurrentURI><CurrentURIMetaData>\(metadata)</CurrentURIMetaData>"
        }
    }

    var controllUrl: String {
        return "/MediaRenderer/AVTransport/Control"
    }

    //    var eventUrl: String {
    //        return "/MediaRenderer/AVTransport/Event"
    //    }

    var schema: String {
        return "urn:schemas-upnp-org:service:AVTransport:1"
    }

}
