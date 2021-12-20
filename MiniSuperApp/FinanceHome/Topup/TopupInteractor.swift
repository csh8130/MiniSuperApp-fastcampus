//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by korit on 2021/12/12.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    
    func attachAddPaymentMethod()
    func detachAddPaymentMethod()
    func attachEnterAmount()
    func detachEnterAmount()
}

protocol TopupListener: AnyObject {
    func topupDidClose()
}

protocol TopupInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {
    
    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private let dependency: TopupInteractorDependency
    
    init(
        dependency: TopupInteractorDependency
    ) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
        super.init()
        self.presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        if dependency.cardsOnFileRepository.cardOnFile.value.isEmpty {
            // 카드 추가 화면
            router?.attachAddPaymentMethod()
        } else {
            // 금액 입력 화면
            router?.attachEnterAmount()
        }
    }
    
    override func willResignActive() {
        super.willResignActive()
        
        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func presentationControllerDidDismiss() {
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
        
    }
    
    func enterAmountDidTapClose() {
        router?.detachEnterAmount()
        listener?.topupDidClose()
    }
}
