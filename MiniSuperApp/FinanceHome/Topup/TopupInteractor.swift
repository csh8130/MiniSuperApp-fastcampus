//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by korit on 2021/12/12.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TopupListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TopupInteractor: Interactor, TopupInteractable {
    
    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init() {}
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        print("did become active")
    }
    
    override func willResignActive() {
        super.willResignActive()
        
        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
}
