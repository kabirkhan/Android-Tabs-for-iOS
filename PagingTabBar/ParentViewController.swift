//
//  ViewController.swift
//  PagingTabBar
//
//  Created by Kabir Khan on 5/29/16.
//  Copyright © 2016 Kabir Khan. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var topTabSegmentedControl: TopTabSegmentedControl!
  
  private var pages = [UIViewController]()
  private var views = [String: UIView]()
  private let segmentView = UIView()
  
  private lazy var firstChildTabVC : UIViewController? = {
    let firstChildTabVC = self.storyboard?.instantiateViewControllerWithIdentifier("First")
    return firstChildTabVC
  }()
  
  private lazy var secondChildTabVC : UIViewController? = {
    let secondChildTabVC = self.storyboard?.instantiateViewControllerWithIdentifier("Second")
    return secondChildTabVC
  }()
  
  private lazy var thirdChildTabVC : UIViewController? = {
    let thirdChildTabVC = self.storyboard?.instantiateViewControllerWithIdentifier("Third")
    return thirdChildTabVC
  }()
  
  private enum TabIndex : Int {
    case FirstChildTab = 0
    case SecondChildTab = 1
    case ThirdChildTab = 2
  }
  
  private func setupViewController(viewController: UIViewController) {
    viewController.view.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(viewController.view)
    addChildViewController(viewController)
    viewController.didMoveToParentViewController(self)
  }
  
  private func setTitle() -> String? {
    return topTabSegmentedControl.titleForSegmentAtIndex(topTabSegmentedControl.selectedSegmentIndex)
  }
  
  private struct Ratios {
    static let segmentViewHeightToSegmentControl: CGFloat = 10
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.delegate = self
    scrollView.pagingEnabled = true

    title = setTitle()
    
    // Setup animated segment view
    segmentView.frame = CGRectMake(topTabSegmentedControl.bounds.minX, topTabSegmentedControl.bounds.maxY - topTabSegmentedControl.bounds.height / Ratios.segmentViewHeightToSegmentControl, view.bounds.width / 3, topTabSegmentedControl.bounds.height / Ratios.segmentViewHeightToSegmentControl)
    segmentView.backgroundColor = UIColor.materialAmberAccent
    topTabSegmentedControl.addSubview(segmentView)
    
    // Setup Segmented Control
    topTabSegmentedControl.initUI()
    topTabSegmentedControl.selectedSegmentIndex = TabIndex.FirstChildTab.rawValue
    
    // Setup Navbar
    navigationController?.navigationBar.removeShadowOnBottomOfBarAndSetColorWith(UIColor.materialMainGreen)
    navigationController?.navigationBar.setNavbarFonts()
    
    // Unwrap Instantiated ViewControllers
    if let page1 = firstChildTabVC, page2 = secondChildTabVC, page3 = thirdChildTabVC {
      setupViewController(page1)
      setupViewController(page2)
      setupViewController(page3)
      pages = [page1, page2, page3]
      views = ["view": scrollView, "page1": page1.view, "page2": page2.view, "page3": page3.view]
    }
    
    // Setup view constraints to all fit in scrollView
    let verticalConstraints =
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|[page1(==view)]|", options: [], metrics: nil, views: views)
    NSLayoutConstraint.activateConstraints(verticalConstraints)
    
    let horizontalConstraints =
      NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|[page1(==view)][page2(==view)][page3(==view)]|", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: views)
    NSLayoutConstraint.activateConstraints(horizontalConstraints)
  }
  
  // Segments tapped, update page and segment view
  @IBAction private func pageChanged(sender: TopTabSegmentedControl) {
    let currentPage = sender.selectedSegmentIndex
    let pageWidth = CGRectGetWidth(scrollView.bounds)
    let targetContentOffsetX = CGFloat(currentPage) * pageWidth
    
    UIView.animateWithDuration(0.33, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
      self.scrollView.contentOffset.x = targetContentOffsetX
      self.segmentView.frame.origin.x = targetContentOffsetX / 3
    }, completion: { (success) in
        self.title = self.setTitle()
    })
  }
}

// User scrolls, update page and segment view
extension ParentViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let pageWidth = CGRectGetWidth(scrollView.bounds)
    let pageFraction = scrollView.contentOffset.x / pageWidth
    
    topTabSegmentedControl.selectedSegmentIndex = Int(round(pageFraction))
    segmentView.frame.origin.x = (scrollView.contentOffset.x
      ) / 3
    title = setTitle()
  }
}


