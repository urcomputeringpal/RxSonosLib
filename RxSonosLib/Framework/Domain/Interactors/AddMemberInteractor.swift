//
//  AddMemberInteractor.swift
//  RxSonosLib
//
//  Created by Deno von Selasinsky on 08.07.21.
//  Copyright © 2021 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

struct AddMemberValues: RequestValues {
    let room: Room
    let memberId: String
}

class AddMemberInteractor: CompletableInteractor {
    
    typealias T = AddMemberValues
    
    private let renderingControlRepository: RenderingControlRepository
    
    init(renderingControlRepository: RenderingControlRepository) {
        self.renderingControlRepository = renderingControlRepository
    }
    
    func buildInteractorObservable(values: AddMemberValues?) -> Completable {
        guard let room = values?.room,
              let memberId = values?.memberId else {
            return Completable.error(SonosError.invalidImplementation)
        }
        
        return renderingControlRepository
            .addMember(memberId: memberId, for: room)
    }
}
