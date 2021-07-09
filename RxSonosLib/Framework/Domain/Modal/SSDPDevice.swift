//
//  SSDPDevice.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 01/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSSDP

open class SSDPDevice: Codable {
    public let ip: URL
    public let usn: String
    public let server: String
    public let ext: String
    public let st: String
    public let location: String
    public let cacheControl: String
    
    /* Sonos Specific SSDP Response */
    public let uuid: String?
    public let wifiMode: String?
    public let variant: String?
    public let household: String?
    public let bootseq: String?
    public let proxy: String?
    
    public init(ip: URL, usn: String, server: String, ext: String, st: String, location: String, cacheControl: String, uuid: String?, wifiMode: String?, variant: String?, household: String?, bootseq: String?, proxy: String?) {
        self.ip = ip
        self.usn = usn
        self.server = server
        self.ext = ext
        self.st = st
        self.location = location
        self.cacheControl = cacheControl
        self.uuid = uuid
        self.wifiMode = wifiMode
        self.variant = variant
        self.household = household
        self.bootseq = bootseq
        self.proxy = proxy
    
    }
    
}

extension SSDPDevice: Equatable {
    public static func == (lhs: SSDPDevice, rhs: SSDPDevice) -> Bool {
        return lhs.usn == rhs.usn
    }
}

extension SSDPDevice {
    
    var isSonosDevice: Bool {
        if let household = self.household,
            let uuid = self.uuid,
            !household.isEmpty,
            !uuid.isEmpty {
            return true
        }
        return false
    }
    
    var hasProxy: Bool {
        if let proxy = self.proxy,
            !proxy.isEmpty {
            return true
        }
        return false
    }
    
    class func map(_ response: SSDPResponse) throws -> SSDPDevice? {
        
        guard let usn: String = response["USN"],
            let server: String = response["SERVER"],
            let ext: String = response["EXT"],
            let st: String = response["ST"],
            let locationString: String = response["LOCATION"],
            let cacheControl: String = response["CACHE-CONTROL"],
            let ipString = try locationString.baseUrl(),
            let locationSuffix = try locationString.urlSuffix(),
            let ip = URL(string: ipString) else {
                return nil
        }
        
        let uuid: String? = try usn.extractUUID()
        let wifiMode: String? = response["X-RINCON-WIFIMODE"]
        let variant: String? = response["X-RINCON-VARIANT"]
        let household: String? = response["X-RINCON-HOUSEHOLD"]
        let bootseq: String? = response["X-RINCON-BOOTSEQ"]
        let proxy: String? = response["X-RINCON-PROXY"]
        
        return SSDPDevice(ip: ip, usn: usn, server: server, ext: ext, st: st, location: locationSuffix, cacheControl: cacheControl, uuid: uuid, wifiMode: wifiMode, variant: variant, household: household, bootseq: bootseq, proxy: proxy)
    }
}
