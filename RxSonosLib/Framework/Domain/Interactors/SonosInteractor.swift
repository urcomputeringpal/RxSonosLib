//
//  SonosInteractor.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 16/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

open class SonosInteractor {
    internal static let shared: SonosInteractor = SonosInteractor()
    internal let allRooms: BehaviorSubject<[Room]> = BehaviorSubject(value: [])
    internal let allGroups: BehaviorSubject<[Group]> = BehaviorSubject(value: [])
    internal let activeGroup: BehaviorSubject<Group?> = BehaviorSubject(value: nil)
    internal let disposebag = DisposeBag()
    internal var renewingGroupDisposable: Disposable?

    init() {
        observerRooms()
        // disable internal activeGroup management
        // observerGroups()
        startRenewingRooms()
    }

    static public func setActive(group: Group) throws {
        let all = try shared.allGroups.value()
        if all.contains(group) {
            shared.setActive(group: group)
        }
    }

    static public func setActive(roomName: String) throws {
        let all = try shared.allGroups.value()
        if let group = all.first(where: { $0.master.name == roomName }) {
            shared.setActive(group: group)
        }
    }

    static public func getActiveGroup() -> Observable<Group> {
        return shared
            .activeGroup
            .asObserver()
            .flatMap(ignoreNil)
    }

    static public func getAllGroups() -> Observable<[Group]> {
        return shared.allGroups.asObserver()
    }

    static public func getAllRooms() -> Observable<[Room]> {
        return shared.allRooms.asObserver()
    }

    static public func getAllMusicProviders() -> Single<[MusicProvider]> {
        return shared
            .allGroups
            .filter({ $0.count > 0 })
            .take(1)
            .asSingle()
            .flatMap { (groups) -> Single<[MusicProvider]> in
                return GetMusicProvidersInteractor(musicProvidersRepository: RepositoryInjection.provideMusicProvidersRepository())
                    .get(values: GetMusicProvidersValues(room: groups.first?.master))
        }
    }

    /* Group */
    static public func getTrack(_ group: Group) -> Observable<Track?> {
        return GetNowPlayingInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetNowPlayingValues(group: group))
    }

    static public func getProgress(_ group: Group) -> Observable<GroupProgress> {
        return GetGroupProgressInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetGroupProgressValues(group: group))
    }

    static public func getQueue(_ group: Group) -> Observable<[MusicProviderTrack]> {
        return GetGroupQueueInteractor(contentDirectoryRepository: RepositoryInjection.provideContentDirectoryRepository())
            .get(values: GetGroupQueueValues(group: group))
    }

    static public func addTrackToQueuePlayNext(uri: String, metadata: String, group: Group) -> Completable {
        return AddTrackToQueuePlayNextInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: AddTrackToQueuePlayNextValues(group: group, uri: uri, metadata: metadata))
    }

    static public func addTrackToQueue(uri: String, metadata: String, number: Int, group: Group) -> Completable {
        return AddTrackToQueueInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: AddTrackToQueueValues(group: group, uri: uri, metadata: metadata, number: number))
    }

    static public func removeTrackFromQueue(track: Int, group: Group) -> Completable {
        return RemoveTrackFromQueueInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: RemoveTrackFromQueueValues(group: group, track: track))
    }

    static public func removeAllTracksFromQueue(_ group: Group) -> Completable {
        return RemoveAllTracksFromQueueInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: RemoveAllTracksFromQueueValues(group: group))
    }

    static public func getFavorites(_ group: Group) -> Observable<[FavProviderItem]> {
        return GetFavoritesQueueInteractor(contentDirectoryRepository: RepositoryInjection.provideContentDirectoryRepository())
            .get(values: GetFavoritesQueueValues(group: group))
    }

    static public func getTransportState(_ group: Group) -> Observable<TransportState> {
        return GetTransportStateInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetTransportStateValues(group: group))
    }

    static public func setTransport(state: TransportState, for group: Group) -> Completable {
        return SetTransportStateInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: SetTransportStateValues(group: group, state: state))
    }

    static public func seekTrack(time: String, for group: Group) -> Completable {
        return SeekTrackInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: SeekTrackValues(group: group, time: time))
    }

    static public func changeTrack(number: Int, for group: Group) -> Completable {
        return ChangeTrackInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: ChangeTrackValues(group: group, number: number))
    }

    static public func setNextTrack(_ group: Group) -> Completable {
        return SetNextTrackInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: SetNextTrackValues(group: group))
    }

    static public func setPreviousTrack(_ group: Group) -> Completable {
        return SetPreviousTrackInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: SetPreviousTrackValues(group: group))
    }

    static public func setPlayUri(_ uri:String, _ group:Group) -> Completable {
        return SetPlayUriInteractor(transportRepository: RepositoryInjection.provideTransportRepository()).get(values: SetPlayUriValues(group: group, uri: uri))
    }

    static public func getVolume(_ group: Group) -> Observable<Int> {
        return GetVolumeInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: GetVolumeValues(group: group))
    }

    static public func set(volume: Int, for group: Group) -> Completable {
        return SetVolumeInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: SetVolumeValues(group: group, volume: volume))
    }

    static public func change(volume: Int, for group: Group) -> Completable {
        return RepositoryInjection.provideRenderingControlRepository().change(volume: volume, for: group)
    }


    /* Room */
    static public func addMember(memberId: String, for room: Room) -> Completable {
        return AddMemberInteractor(groupManagementRepository: RepositoryInjection.provideGroupManagementRepository())
            .get(values: AddMemberValues(room: room, memberId: memberId))
    }

    static public func removeMember(memberId: String, for room: Room) -> Completable {
        return RemoveMemberInteractor(groupManagementRepository: RepositoryInjection.provideGroupManagementRepository())
            .get(values: RemoveMemberValues(room: room, memberId: memberId))
    }

    static public func getMute(for room: Room) -> Observable<Bool> {
        return GetMuteInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: GetMuteValues(room: room))
    }

    static public func set(mute enabled: Bool, for room: Room) -> Completable {
        return SetMuteInteractor(renderingControlRepository: RepositoryInjection.provideRenderingControlRepository())
            .get(values: SetMuteValues(room: room, enabled: enabled))
    }

    static public func setAVTransportURI(masterUrl: String, metadata: String, for group: Group) -> Completable {
        return SetAVTransportURIInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: SetAVTransportURIValues(group: group, masterUrl: masterUrl, metadata: metadata))
    }

    static public func setBecomeCoordinatorOfStandaloneGroup(idx: Int, for group: Group) -> Completable {
        return SetBecomeCoordinatorOfStandaloneGroupInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: SetBecomeCoordinatorOfStandaloneGroupValues(group: group, idx: idx))
    }

    /* Track */
    static public func getTrackImage(_ track: Track) -> Observable<Data?> {
        return GetTrackImageInteractor(transportRepository: RepositoryInjection.provideTransportRepository())
            .get(values: GetTrackImageValues(track: track))
    }

    // MARK: Singles

    static public func singleProgress(_ group: Group) -> Single<GroupProgress> {
        return RepositoryInjection.provideTransportRepository().getNowPlayingProgress(for: group.master)
    }

    static public func singleTrack(_ group: Group) -> Single<Track?> {
        return RepositoryInjection.provideTransportRepository().getNowPlaying(for: group.master)
    }

    static public func singleImage(_ track: Track) -> Maybe<Data> {
        return RepositoryInjection.provideTransportRepository().getImage(for: track)
    }

    static public func singleTransportState(_ group: Group) -> Single<TransportState> {
        return RepositoryInjection.provideTransportRepository().getTransportState(for: group.master)
    }

    static public func singleVolume(_ group: Group) -> Single<Int> {
        return RepositoryInjection.provideRenderingControlRepository().getVolume(for: group)
    }

    static public func singleMute(_ group: Group) -> Single<Bool> {
        return Observable<Room>
            .from(group.rooms)
            .flatMap { Room in
                return RepositoryInjection.provideRenderingControlRepository().getMute(room: Room).asObservable()
            }
            .reduce(true) { $0 && $1 }
            .asSingle()
    }
}

extension SonosInteractor {
    private func activeGroupValue() -> Group? {
        do {
            return try activeGroup.value()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    private func observerRooms() {
        allRooms
            .asObserver()
            .subscribe(onNext: { [weak self] (rooms) in
                self?.startRenewingGroups(with: rooms)
            })
            .disposed(by: disposebag)
    }

    private func startRenewingRooms() {
        GetRoomsInteractor(ssdpRepository: RepositoryInjection.provideSSDPRepository(), roomRepository: RepositoryInjection.provideRoomRepository())
            .get()
            .subscribe(allRooms)
            .disposed(by: disposebag)
    }

    private func observerGroups() {
        allGroups
            .asObserver()
            .subscribe(onNext: { (groups) in
                guard let active = self.activeGroupValue() else {
                    self.setActive(group: groups.first)
                    return
                }

                if !groups.contains(active) {
                    if let firstGroupWithSameMasterRoom = groups.filter({ $0.master == active.master }).first {
                        self.setActive(group: firstGroupWithSameMasterRoom)
                        return
                    }
                    self.setActive(group: groups.first)
                    return
                }
            })
            .disposed(by: disposebag)
    }

    private func startRenewingGroups(with rooms: [Room]) {
        guard rooms.count > 0 else { return }
        renewingGroupDisposable?.dispose()

        renewingGroupDisposable = createTimer(SonosSettings.shared.renewGroupsTimer)
            .flatMap({ _ -> Observable<[Group]> in
                return GetGroupsInteractor(groupRepository: RepositoryInjection.provideGroupRepository())
                    .get(values: GetGroupsValues(rooms: rooms))
                    .catchError({ _ in Single<[Group]>.just([]) })
                    .asObservable()
            })
            .subscribe(allGroups)
    }

    private func setActive(group: Group?) {
        guard activeGroupValue() != group else { return }
        activeGroup.onNext(group)
    }
}
