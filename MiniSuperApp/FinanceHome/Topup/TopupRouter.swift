//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by korit on 2021/12/12.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
    
    private var navigationControllable: NavigationControllerable?
    
    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    
    private let enterAmountBuildable: EnterAmountBuildable
    private var enterAmountRouting: Routing?
    
    private let cardsOnFileBuildable: CardOnFileBuildable
    private var cardsOnFileRouting: Routing?
    
    init(
        interactor: TopupInteractable,
        viewController: ViewControllable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable,
        enterAmountBuildable: EnterAmountBuildable,
        cardsOnFileBuildable: CardOnFileBuildable
    ) {
        self.viewController = viewController
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.enterAmountBuildable = enterAmountBuildable
        self.cardsOnFileBuildable = cardsOnFileBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func cleanupViews() {
        if viewController.uiviewController.presentedViewController != nil, navigationControllable != nil {
            navigationControllable?.dismiss(completion: nil)
        }
    }
    
    func attachAddPaymentMethod() {
        if addPaymentMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethodBuildable.build(withListener: interactor)
        presentInsideNavigation(router.viewControllable)
        attachChild(router)
        addPaymentMethodRouting = router
        
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymentMethodRouting else {
            return
        }
        
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        addPaymentMethodRouting = nil
    }
    
    func attachEnterAmount() {
        if enterAmountRouting != nil {
            return
        }
        
        let router = enterAmountBuildable.build(withListener: interactor)
        presentInsideNavigation(router.viewControllable)
        attachChild(router)
        enterAmountRouting = router
    }
    
    func detachEnterAmount() {
        guard let router = enterAmountRouting else {
            return
        }
        
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        enterAmountRouting = nil
    }
    
    func attachCardOnFile() {
        if cardsOnFileRouting != nil {
            return
        }
        
        let router = cardsOnFileBuildable.build(withListener: interactor)
        navigationControllable?.pushViewController(router.viewControllable, animated: true)
        cardsOnFileRouting = router
        attachChild(router)
    }
    
    func detachCardOnFile() {
        guard let router = cardsOnFileRouting else {
            return
        }
        
        navigationControllable?.popViewController(animated: true)
        detachChild(router)
        cardsOnFileRouting = nil
    }
    
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        self.navigationControllable = navigation
        viewController.present(navigation, animated: true, completion: nil)
    }
    
    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if self.navigationControllable == nil {
            return
        }
        
        viewController.dismiss(completion: completion)
        self.navigationControllable = nil
    }
    
    // MARK: - Private
    
    private let viewController: ViewControllable
}
