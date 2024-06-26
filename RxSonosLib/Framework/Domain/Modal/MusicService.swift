//
//  MusicService.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 27/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

public enum MusicService {
    case musicProvider(sid: Int, flags: Int?, sn: Int?)
    case tv
    case library
    case airConnect
    case airplay
    case linein
}

extension MusicService: Equatable {
    
    private var rawValue: Int {
        switch self {
        case .musicProvider(let sid, _, _):
            return sid
        case .tv:
            return 9999
        case .library:
            return 9998
        case .airConnect:
            return 9997
        case .airplay:
            return 9996
        case .linein:
            return 9995
        }

    }
    
    public static func == (lhs: MusicService, rhs: MusicService) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension MusicService {
    
    var sid: Int? {
        switch self {
        case .musicProvider(let sid, _, _):
            return sid
        default:
            return nil
        }
    }
    
    var flags: Int? {
        switch self {
        case .musicProvider(_, let flags, _):
            return flags
        default:
            return nil
        }
    }
    
    var sn: Int? {
        switch self {
        case .musicProvider(_, _, let sn):
            return sn
        default:
            return nil
        }
    }
    
    static func map(url: String) throws -> MusicService? {
        
        let urlComponents = URLComponents(string: url)
        if let sid = urlComponents?.queryItems?["sid"]?.int {
            let flags = urlComponents?.queryItems?["flags"]?.int
            let sn = urlComponents?.queryItems?["sn"]?.int
            return MusicService.musicProvider(sid: sid, flags: flags, sn: sn)
        }
        
        if let service = try url.match(with: "([a-zA-Z0-9-]+):")?.first {
            switch service {
            case "x-sonos-htastream":
                return .tv
            case "x-file-cifs":
                return .library
            case "x-sonos-vli":
                if url.contains("airplay:") {
                    return .airplay
                }
            case "x-sonos-http", "http":
                return .airConnect
            case "x-rincon-stream":
                return .linein
            default:
                return nil
            }
        }
        
        return nil
    }
}
