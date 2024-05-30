//
//  TVTrack.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

open class TVTrack: Track {
    
    /**
     * Number item in the queue
     */
    public let queueItem: Int
    
    /**
     * Track duration time in seconds, example: 264 for 0:04:24
     */
    public let duration: UInt = 0
    
    /**
     * track url
     */
    public var uri: String
    
    public let progress: GroupProgress?

    public var contentType: TrackContentType
    
    /**
     * collection of all Tracks description items
     */
    public var description = [TrackDescription: String]()
    
    public let mediaInfo: [String: String]

    internal init(queueItem: Int, uri: String, mediaInfo: [String: String], contentType: TrackContentType?) {
        self.queueItem = queueItem
        self.uri = uri
        self.contentType = contentType ?? .lineInHomeTheater
        self.progress = nil
        self.mediaInfo = mediaInfo
    }
    
}
