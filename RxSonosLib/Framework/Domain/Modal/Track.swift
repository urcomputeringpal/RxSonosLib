//
//  Track.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 26/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

/**
 * Options for a tracks description
 */
public enum TrackDescription: String {
    case title = "TITLE"
    case artist = "ARTIST"
    case album = "ALBUM"
    case information = "INFORMATION"
}

/// Contant type of the track
public enum TrackContentType {
    case musicTrack,
         longMusicTrack,
         podcast,
         lineInHomeTheater,
         audioBroadcast,
         lineIn,
         airplay
    
    static let LongplayTrackDuration: UInt = 60*15
    
    static func by(class mediaClass: String?, duration: UInt) -> Self? {
        guard let mediaClass = mediaClass, !mediaClass.isEmpty else {
            return nil
        }
        switch mediaClass {
        case "object.item.audioItem.podcast":
            return .podcast
        case "object.item.audioItem.linein.homeTheater":
            return .lineInHomeTheater
        case "object.item.audioItem.audioBroadcast":
            return .audioBroadcast
        case "object.item.audioItem.musicTrack":
            return duration < LongplayTrackDuration ? musicTrack : longMusicTrack
        case "object.item.audioItem.linein":
        return .lineIn
        case "object.item.audioItem.linein.airplay":
            return.airplay
        default:
            return nil
        }
    }
}

extension TrackDescription: Comparable {
    
    private var intValue: Int {
        switch self {
        case .title:
            return 1
        case .information:
            return 2
        case .artist:
            return 3
        case .album:
            return 4
        }
    }
    
    public static func < (lhs: TrackDescription, rhs: TrackDescription) -> Bool {
        return lhs.intValue < rhs.intValue
    }
    
    public static func == (lhs: TrackDescription, rhs: TrackDescription) -> Bool {
        return lhs.intValue == rhs.intValue
    }
}

/**
 * Some `Track`'s have an image, these tracks response to the `TrackImage` protocol
 */
internal protocol TrackImage {
    
    /**
     * image url (optional)
     * can be downloaded with:
     *      SonosInteractor.provideTrackImageInteractor()
     *      .get(values: GetTrackImageValues(track: Track))
     */
    var imageUri: URL { get }
}

/**
 * Every item in the queue is a `Track`
 */
public protocol Track {
    /**
     * Number item in the queue
     */
    var queueItem: Int { get }
    
    /**
     * Track duration time in seconds, example: 264 for 0:04:24
     */
    var duration: UInt { get }
    
    /**
     * track url
     */
    var uri: String { get }
    
    /**
     * collection of all Tracks description items
     */
    var description: [TrackDescription: String] { get }
    
    var contentType: TrackContentType { get }
    
    var progress: GroupProgress? { get }

    var mediaInfo: [String: String] { get }

}

extension Track {
    
    public func description(filterd: [TrackDescription]) -> [String] {
        return description
            .compactMap({ (key, value) -> String? in
                if filterd.contains(key) {
                    return nil
                }
                return value
            })
            .sorted(by: { $0 < $1 })
    }
        
    /**
     * track title
     */
    public var title: String? { return description[TrackDescription.title] }
    
    /**
     * track artist
     */
    public var artist: String? { return description[TrackDescription.artist] }
    
    /**
     * track album
     */
    public var album: String? { return description[TrackDescription.album] }
    
    /**
     * track information
     */
    public var information: String? { return description[TrackDescription.information] }
    
    public var contentType: TrackContentType { .musicTrack }
}

extension ObservableType where E == Track {
    public func getImage() -> Observable<Data?> {
        return
            self
            .flatMap({ (track) -> Observable<Data?> in
                return SonosInteractor.getTrackImage(track)
            })
    }
    
}
