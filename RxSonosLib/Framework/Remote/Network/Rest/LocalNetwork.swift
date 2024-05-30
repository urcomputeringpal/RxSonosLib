//
//  LocalNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift
import AEXML

class LocalNetwork<Target: SonosTargetType>: Network {

    func request(_ action: Target, on room: Room) -> Single<[String: String]> {
        let url = room.ip.appendingPathComponent(action.controllUrl)
        var urlRequest = URLRequest(url: url, timeoutInterval: SonosSettings.shared.requestTimeout)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("\"\(action.soapAction)\"", forHTTPHeaderField: "SOAPACTION")
        urlRequest.setValue(nil, forHTTPHeaderField: "Accept-Language")
        urlRequest.setValue(nil, forHTTPHeaderField: "Accept-Encoding")
        urlRequest.setValue(nil, forHTTPHeaderField: "Accept")
        urlRequest.setValue(nil, forHTTPHeaderField: "User-Agent")
        urlRequest.httpBody = action.requestBody.data(using: .utf8)

        return perform(request: urlRequest).map(openEnvelope(for: action))
    }

    internal func openEnvelope(for target: Target) -> ((Data) throws -> [String: String]) {
        return { data in
            let xml = try AEXMLDocument.create(data)
            let element = xml?["Envelope"]["Body"]["\(target.action)Response"]

            var soapData: [String: String] = [:]
            element?.children.forEach({ (row) in
                soapData[row.name] = row.string
            })

            return soapData
        }
    }
}
