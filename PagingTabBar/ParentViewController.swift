//
//  ViewController.swift
//  PagingTabBar
//
//  Created by Kabir Khan on 5/29/16.
//  Copyright © 2016 Kabir Khan. All rights reserved.
//

import UIKit

public class ParentViewController: UIViewController {
  
  @IBOutlet public weak var scrollView: UIScrollView!
  @IBOutlet public weak var topTabSegmentedControl: TopTabSegmentedControl!
  
  public var storyBoardIdentifiers = ["First", "Second"]

  private var views = [String: UIView]()
  private let segmentView = UIView()
  
  private func setupChildViewController(storyBoardIdentifier identifier: String) -> UIViewController {
    guard let viewController = storyboard?.instantiateViewControllerWithIdentifier(identifier) else { return UIViewController() }
    viewController.view.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(viewController.view)
    addChildViewController(viewController)
    viewController.didMoveToParentViewController(self)
    return viewController
  }
  
  private func setTitle() -> String? {
    return topTabSegmentedControl.titleForSegmentAtIndex(topTabSegmentedControl.selectedSegmentIndex)
  }
  
  private struct Ratios {
    static let segmentViewHeightToSegmentControlHeight: CGFloat = 15
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.delegate = self
    scrollView.pagingEnabled = true

    title = setTitle()
    
    // Setup animated segment view
    segmentView.frame = CGRectMake(topTabSegmentedControl.bounds.minX, topTabSegmentedControl.bounds.maxY - topTabSegmentedControl.bounds.height / Ratios.segmentViewHeightToSegmentControlHeight, view.bounds.width / CGFloat(storyBoardIdentifiers.count), topTabSegmentedControl.bounds.height / Ratios.segmentViewHeightToSegmentControlHeight)
    segmentView.backgroundColor = UIColor.materialAmberAccent
    segmentView.layer.cornerRadius = 2.0
    topTabSegmentedControl.addSubview(segmentView)
    
    // Setup Segmented Control
    topTabSegmentedControl.initUI()
    topTabSegmentedControl.selectedSegmentIndex = 0
    
    // Setup Navbar
    navigationController?.navigationBar.removeShadowOnBottomOfBarAndSetColorWith(UIColor.materialMainGreen)
    navigationController?.navigationBar.setNavbarFonts()
    
    // Instantiate ViewControllers and Horizontal Constraints based on number of ViewControllers
    views = ["view": scrollView]
    
    var horizontalConstraintsString = "H:|"
    
    for i in storyBoardIdentifiers.range() {
      views["page\(i + 1)"] = setupChildViewController(storyBoardIdentifier: storyBoardIdentifiers[i]).view
      horizontalConstraintsString += "[page\(i + 1)(==view)]"
    }
    
    horizontalConstraintsString += "|"
    
    // Setup view constraints to all fit in scrollView
    let verticalConstraints =
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|[page1(==view)]|", options: [], metrics: nil, views: views)
    NSLayoutConstraint.activateConstraints(verticalConstraints)
    
    let horizontalConstraints =
      NSLayoutConstraint.constraintsWithVisualFormat(
        horizontalConstraintsString, options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: views)
    
    NSLayoutConstraint.activateConstraints(horizontalConstraints)
  }
  
  // Segments tapped, update page and segment view
  @IBAction private func pageChanged(sender: TopTabSegmentedControl) {
    let currentPage = sender.selectedSegmentIndex
    let pageWidth = CGRectGetWidth(scrollView.bounds)
    let targetContentOffsetX = CGFloat(currentPage) * pageWidth
    
    UIView.animateWithDuration(0.33, delay: 0, options: .CurveEaseInOut, animations: { [unowned _self = self] in
      _self.scrollView.contentOffset.x = targetContentOffsetX
      _self.segmentView.frame.origin.x = targetContentOffsetX / CGFloat(_self.storyBoardIdentifiers.count)
    }, completion: { [unowned _self = self] (success) in
        _self.title = _self.setTitle()
    })
  }
}

extension Int {
  public func range() -> Range<Int> {
    return 0..<self
  }
}

extension Array {
  public func range() -> Range<Int> {
    return self.count.range()
  }
}

// User scrolls, update page and segment view
extension ParentViewController: UIScrollViewDelegate {
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    let pageWidth = CGRectGetWidth(scrollView.bounds)
    let pageFraction = scrollView.contentOffset.x / pageWidth
    
    topTabSegmentedControl.selectedSegmentIndex = Int(round(pageFraction))
    segmentView.frame.origin.x = (scrollView.contentOffset.x) / CGFloat(storyBoardIdentifiers.count)
    title = setTitle()
  }
}
