//
//  GetQueueNetwork.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 04/04/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation

class GetQueueNetwork: SoapNetwork {
    
    init(room: Room) {
        super.init(room: room, action: .browse)
    }
    
}
