//
//  GetFavoritesQueueInteractor.swift
//  RxSonosLib
//
//  Created by Deno von Selasinsky on 21.09.21.
//  Copyright © 2021 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

class GetFavoritesQueueValues: RequestValues {
    let group: Group
    
    init(group: Group) {
        self.group = group
    }
}

class GetFavoritesQueueInteractor: ObservableInteractor {
    
    typealias T = GetFavoritesQueueValues
    
    private let contentDirectoryRepository: ContentDirectoryRepository
    
    init(contentDirectoryRepository: ContentDirectoryRepository) {
        self.contentDirectoryRepository = contentDirectoryRepository
    }
    
    func buildInteractorObservable(values: GetFavoritesQueueValues?) -> Observable<[FavProviderItem]> {
        
        guard let masterRoom = values?.group.master else {
            return Observable.error(SonosError.invalidImplementation)
        }
        
        return createTimer(SonosSettings.shared.renewGroupQueueTimer)
            .flatMap(mapToQueue(for: masterRoom))
            .distinctUntilChanged()
    }
}

private extension GetFavoritesQueueInteractor {
    func mapToQueue(for masterRoom: Room) -> ((Int) -> Observable<[FavProviderItem]>) {
        return { _ in
            return self.contentDirectoryRepository
                .getFavorites(for: masterRoom)
                .asObservable()
        }
    }
}
