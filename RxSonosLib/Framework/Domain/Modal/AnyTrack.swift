//
//  DLNATrack.swift
//  RxSonosLib
//
//  Created by Roman Sokolov on 29.07.2021.
//

import Foundation

open class ANyTrack: Track, TrackImage {
    
    public var description: [TrackDescription: String]
    
    public var queueItem: Int = 0
    
    public var duration: UInt = 0
    
    public var uri: String = ""
    
    public var contentType: TrackContentType
    
    public var progress: GroupProgress?

    public let mediaInfo: [String: String]

    var imageUri: URL
    
    init(queueItem: Int, duration: UInt, uri: String, imageUri: URL, description: [TrackDescription: String], mediaInfo: [String: String], contentType: TrackContentType?, progress: GroupProgress? = nil) {
        self.queueItem = queueItem
        self.queueItem = queueItem
        self.duration = duration
        self.uri = uri
        self.imageUri = imageUri
        self.description = description
        self.contentType = contentType ?? .musicTrack
        self.progress = progress
        self.mediaInfo = mediaInfo
    }
    
}
