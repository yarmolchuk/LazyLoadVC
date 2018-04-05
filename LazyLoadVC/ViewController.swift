//
//  ViewController.swift
//  LazyLoadVC
//
//  Created by Dima Yarmolchuk on 4/1/18.
//  Copyright © 2018 Dima Yarmolchuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableViewController: TableViewController = {
        return self.storyboard!.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
    }()
    
    lazy var placeholderViewController: PlaceholderViewController = {
        return self.storyboard!.instantiateViewController(withIdentifier: "PlaceholderViewController") as! PlaceholderViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { // change 2 to desired number of seconds
            self.presentPrompt(viewController: self.placeholderViewController)
        }
    }
    
    @IBOutlet weak var promptContainerView: UIView?
    var visiblePrompt: UIViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presentPrompt(viewController: self.tableViewController)
    }

    func presentPrompt(viewController: UIViewController, animate: ((UIView?, UIView, () -> Void) -> Void) = { _, _, block in block() }){
        
        self.visiblePrompt?.willMove(toParentViewController: nil)
        self.addChildViewController(viewController)
        
        guard let contentView = viewController.view else { return }
        guard let containerView = self.promptContainerView else { return }

        containerView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: contentView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: contentView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: contentView,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: contentView,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: 0.0),
            ])
        
        animate(self.visiblePrompt?.view, viewController.view) {
            self.visiblePrompt?.view.removeFromSuperview()
            self.visiblePrompt?.removeFromParentViewController()
            
            viewController.didMove(toParentViewController: self)
            self.visiblePrompt = viewController
        }
    }
}

