//
//  NowPlayingTrackFactory.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class NowPlayingTrackFactory {
    
    private let room: URL
    private let positionInfo: [String: String]
    private let mediaInfo: [String: String]
    
    private let trackMeta: [String: String]?
    private let currentURIMetaData: [String: String]?
    private let progress: GroupProgress
    
    init(room: URL, positionInfo: [String: String], mediaInfo: [String: String], progress: GroupProgress) throws {
        self.room = room
        self.positionInfo = positionInfo
        self.mediaInfo = mediaInfo
        self.trackMeta = try positionInfo["TrackMetaData"]?.mapMetaItem()
        self.currentURIMetaData = try mediaInfo["CurrentURIMetaData"]?.mapMetaItem()
        self.progress = progress
    }
    
    func create() throws -> Track? {
        guard let (uri, type) = try getMusicService() else { return nil }
        switch type {
        case .tv:
            return createTVTrack()
        case .library:
            return createLibraryTrack(uri: uri)
        case .airConnect, .airplay:
            return createTrack(uri: uri, usingTrackTitle: true)
        default:
            return createMusicProviderTrack(uri: uri, type: type)
        }
    }
    
    private func createLibraryTrack(uri: String?) -> LibraryTrack? {
        
        guard let duration = positionInfo["TrackDuration"]?.timeToSeconds(),
            let queueItemString = positionInfo["Track"],
            let queueItem = Int(queueItemString),
            let uri = uri,
            let imageUri = URL(string: room.absoluteString + "/getaa?u=" + uri.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!),
            let description = getDescription() else {
                return nil
        }
        
        return LibraryTrack(queueItem: queueItem, duration: duration, uri: uri, imageUri: imageUri, description: description, progress: self.progress)
    }
    
    private func createMusicProviderTrack(uri: String?, type: MusicService) -> MusicProviderTrack? {
        
        guard let duration = positionInfo["TrackDuration"]?.timeToSeconds(),
            let queueItemString = positionInfo["Track"],
            let sid = type.sid,
            let queueItem = Int(queueItemString),
            let uri = uri,
            let imageUri = self.getImageUrl(uri: uri),
            let description = getDescription() else {
                return nil
        }
        
        return MusicProviderTrack(sid: sid, flags: type.flags, sn: type.sn, queueItem: queueItem, duration: duration, uri: uri, imageUri: imageUri, description: description, contentType: self.getContentType(), progress: self.progress)
    }
    
    private func createTVTrack() -> TVTrack? {
        
        guard let queueItemString = positionInfo["Track"],
            let queueItem = Int(queueItemString),
            let uri = positionInfo["TrackURI"] else {
                return nil
        }
        
        return TVTrack(queueItem: queueItem, uri: uri, contentType: self.getContentType())
    }
    
    private func createTrack(uri: String?, usingTrackTitle: Bool) -> ANyTrack? {
        
        guard let duration = positionInfo["TrackDuration"]?.timeToSeconds(),
            let queueItemString = positionInfo["Track"],
            let queueItem = Int(queueItemString),
            let uri = uri,
            let imageUri = self.getImageUrl(uri: uri),
            let description = getDescription(usingTrackTitle: usingTrackTitle) else {
                return nil
        }
        
        return ANyTrack(queueItem: queueItem, duration: duration, uri: uri, imageUri: imageUri, description: description, contentType: self.getContentType(), progress: self.progress)
    }

    private func getImageUrl(uri: String) -> URL? {
        var urlString = trackMeta?["albumArtURI"] ?? "/getaa?s=1&u=" + uri
        if urlString.hasPrefix("/") {
            urlString = room.absoluteString + urlString
        }
        return URL(string: urlString)
    }
    private func getContentType() -> TrackContentType? {
        let duration = (self.positionInfo["TrackDuration"] ?? self.mediaInfo["TrackDuration"])?.timeToSeconds() ?? 0
        return TrackContentType.by(class: trackMeta?["class"], duration: duration)
            ?? TrackContentType.by(class: currentURIMetaData?["class"], duration: duration)
    }
    
    private func getMusicService() throws -> (url: String, service: MusicService)? {
        if let url = mediaInfo["CurrentURI"], let service = try MusicService.map(url: url) {
            return (url, service)
        }
        
        if let url = positionInfo["TrackURI"], let service = try MusicService.map(url: url) {
            return (url, service)
        }
        return nil
    }
    
    private func getDescription(usingTrackTitle: Bool = false) -> [TrackDescription: String]? {
        guard let title = usingTrackTitle ?
                (trackMeta?["title"] ?? currentURIMetaData?["title"])
                : (currentURIMetaData?["title"] ?? trackMeta?["title"]) else { return nil }
        var description = [TrackDescription.title: title]
        
        if let artist = trackMeta?["creator"] {
            description[TrackDescription.artist] = artist
        } else if let podcast = trackMeta?["podcast"] {
            description[TrackDescription.artist] = podcast
        }
        
        if let album = trackMeta?["album"] {
            description[TrackDescription.album] = album
        }
        
        if let information = trackMeta?["streamContent"]?.nilIfEmpty() {
            description[TrackDescription.information] = information
        }
        
        return description
    }
}
