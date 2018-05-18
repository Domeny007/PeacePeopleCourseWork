//
//  PartnersViewController.swift
//  PeacePeople
//
//  Created by Азат Алекбаев on 18.05.2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import Firebase
class PartnersPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newPartnerViewController(with: "HWVC"),
                self.newPartnerViewController(with: "CBSVC"),
                ]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func newPartnerViewController(with name : String) -> UIViewController {
        return UIStoryboard(name: mainStoryboardString, bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0  else { return nil }
        guard orderedViewControllers.count > previousIndex else { return nil }
        
        
        
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else { return nil }
        
        guard orderedViewControllersCount > nextIndex else { return nil }
        
        return orderedViewControllers[nextIndex]
    }
}
