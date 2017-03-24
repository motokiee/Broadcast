//
//  Broadcast.swift
//  Broadcast
//
//  Created by motokiee on 2017/03/24.
//  Copyright © 2017年 motokiee. All rights reserved.
//

import Foundation


public final class Notification {
    public static let shared = Notification()
    private init() {}
    internal var observers: [Observer] = []

    public func post(_ type: Event) {
        for observer in observers {
            if observer.notificationType == type {
                observer.executeAction()
            }
        }
    }

    public func observe(type: Event, action: @escaping () -> ()) -> Disposable {
        let observer = Observer(type: type, action: action)
        observers += [observer]
        return Disposable(observer)
    }
}

public enum Event {
    case updated
}


public class Observer {
    fileprivate let id = UUID().uuidString
    let notificationType: Event
    let executeAction: (() -> ())

    init(type: Event, action: @escaping () -> ()) {
        notificationType = type
        executeAction = action
    }
}

public class DisposeBag {
    fileprivate var disposables: [Disposable] = []
}

public class Disposable {
    private let id: String

    init(_ observer: Observer) {
        id = observer.id
    }

    func addDisposable(to bag: DisposeBag) {
        bag.disposables += [self]
    }

    deinit {
        Notification.shared.observers.enumerated()
            .filter { $1.id == id }
            .map { $0.0 }
            .forEach { index in
                Notification.shared.observers.remove(at: index)
        }
    }
}
