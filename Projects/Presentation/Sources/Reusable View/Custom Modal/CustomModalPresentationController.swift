//
//  CustomModalPresentationController.swift
//  Presentation
//
//  Created by 유현진 on 8/1/24.
//

import UIKit

public class CustomModalPresentationController: UIPresentationController {
    
    private var modalHeight: CGFloat
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, modalHeight: CGFloat) {
        self.modalHeight = modalHeight
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        let screenBounds = UIScreen.main.bounds
        let size = CGSize(width: screenBounds.width, height: self.modalHeight)
        let origin = CGPoint(x: .zero, y: screenBounds.height - modalHeight)
        return CGRect(origin: origin, size: size)
    }
    
    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else { return }
        
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.insertSubview(dimmingView, at: 0)
        
        dimmingView.alpha = 0
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            dimmingView.alpha = 1
        })
    }
    
    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.containerView?.subviews.first?.alpha = 0
        })
    }
    
}


public class CustomTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private var modalHeight: CGFloat
    
    public init(modalHeight: CGFloat) {
        self.modalHeight = modalHeight
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomModalPresentationController(presentedViewController: presented, presenting: presenting, modalHeight: modalHeight)
    }
}
