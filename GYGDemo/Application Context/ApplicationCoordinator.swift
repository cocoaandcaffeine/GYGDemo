//
//  ApplicationCoordinator.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

class ApplicationCoordinator: NSObject {
    
    // MARK: - Public properties
    let applicationContext: ApplicationContext
    
    // MARK: - Private properties
    private lazy var ratingBrowserModel: RatingCommentsViewModel = {
        return RatingCommentsViewModel(applicationContext: applicationContext)
    }()
    
    private lazy var ratingBrowserViewController: RatingCommentsViewController = {
        guard let viewController = ratingBrowserModel.provideViewController() as? RatingCommentsViewController else {
            fatalError("Could not instantiate RatingBrowserViewController")
        }
        return viewController
    }()
    
    // MARK: - Lifecycle
    init(applicationContext: ApplicationContext) {
        self.applicationContext = applicationContext
    }
    
    // MARK: - Startup
    func start(in window: UIWindow) {
        
        if let font = UIFont(name: "AvenirNext-Bold", size: 20) {
            let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white] as [NSAttributedStringKey : Any]
            UINavigationBar.appearance().titleTextAttributes = attributes
        }
        UINavigationBar.appearance().barTintColor = UIColor.barTintColor
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().tintColor = .white
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let navigationController = wrappedInNavigationController(viewController: ratingBrowserViewController)
        
        window.backgroundColor = .white
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    // MARK: - Presentation
    func present(_ route: PresentationRoute, completionHandler: (() -> Void)? = nil) {
        
        let viewController = viewControllerFromDestination(route.destination)
        viewController.transitioningDelegate = route.transitioningDelegate
        
        return present(
            viewController: viewController,
            with: route.preferredPresentationStyle,
            animated: route.prefersAnimatedPresentation,
            completionHandler: completionHandler
        )
    }
    
    // MARK: - Helper
    private func viewControllerFromDestination(_ destination: PresentationRoute.Destination) -> UIViewController {
        switch destination {
        case .settings(let viewModel): return viewModel.provideViewController()
        case .createComment(let viewModel): return viewModel.provideViewController()
        }
    }
    
    private func present(viewController: UIViewController, with preferredPresentationStyle: PresentationRoute.PresentationStyle, animated: Bool, completionHandler: (() -> Void)?) {
        switch preferredPresentationStyle {
        case .push:
            push(viewController: viewController, animated: animated, completionHandler: completionHandler)
        case .modal:
            presentModal(viewController: viewController, animated: animated, completionHandler: completionHandler)
        case .modalWithNavigationController:
            let navController = wrappedInNavigationController(viewController: viewController)
            presentModal(viewController: navController, animated: animated, completionHandler: completionHandler)
        case .popoverFromBarButtonItem(let barButtonItem):
            presentInPopover(viewController: viewController, animated: animated, from: barButtonItem, completionHandler: completionHandler)
        }
    }
    
    private func push(viewController: UIViewController, animated: Bool, completionHandler: (() -> Void)?) {
        ratingBrowserViewController.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    private func presentModal(viewController: UIViewController, animated: Bool, completionHandler: (() -> Void)?) {
        let present = { [weak self] () -> Void in
            self?.ratingBrowserViewController.present(viewController, animated: animated, completion: completionHandler)
        }
        
        if ratingBrowserViewController.presentedViewController != nil {
            ratingBrowserViewController.presentedViewController?.dismiss(animated: true, completion: {
                present()
            })
        } else {
            present()
        }
    }
    
    private func presentInPopover(viewController: UIViewController, animated: Bool, from barButtonItem: UIBarButtonItem, completionHandler: (() -> Void)?) {
        
        viewController.modalPresentationStyle = .popover
        
        let presentationController = viewController.popoverPresentationController
        presentationController?.permittedArrowDirections = .any
        presentationController?.barButtonItem = barButtonItem
        presentationController?.delegate = self
        presentationController?.backgroundColor = viewController.view.backgroundColor
        
        presentModal(viewController: viewController, animated: animated, completionHandler: completionHandler)
    }
    
    private func wrappedInNavigationController(viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.delegate = self
        navigationController.modalPresentationStyle = viewController.modalPresentationStyle
        navigationController.transitioningDelegate = viewController.transitioningDelegate
        viewController.transitioningDelegate = nil
        return navigationController
    }
}

extension ApplicationCoordinator: UINavigationControllerDelegate {
    
}

extension ApplicationCoordinator: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

