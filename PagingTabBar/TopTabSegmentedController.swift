//
//  TopTabSegmentedController.swift
//  smatch_1
//
//  Created by Kabir Khan on 3/23/16.
//  Copyright © 2016 Kabir Khan. All rights reserved.
//

import UIKit

@IBDesignable
public class TopTabSegmentedControl: UISegmentedControl {

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  @IBInspectable
  public var shadow: Bool = false
  
  @IBInspectable
  public var barColor: UIColor? {
    didSet {
      setBackground()
    }
  }
  
  @IBInspectable
  public var fontName: String = ".SFUIText-Regular" {
    didSet {
      setFonts()
    }
  }
  
  @IBInspectable
  public var fontSize: CGFloat = 14.0 {
    didSet {
      setFonts()
    }
  }
  
  @IBInspectable
  public var fontColor: UIColor = UIColor.darkTextColor() {
    didSet {
      setFonts()
    }
  }
  
  public func initUI() {
    setBackground()
    setFonts()
    if shadow == true {
      addShadow()
    }
  }
  
  private func setBackground() {
    setBackgroundImage(UIImage(), forState: .Normal, barMetrics: .Default)
    backgroundColor = UIColor.materialMainGreen
  }
  
  private func addShadow() {
    layer.shadowColor = UIColor.shadowColor.CGColor
    layer.shadowOpacity = 0.8
    layer.shadowRadius = 2.0
    layer.shadowOffset = CGSizeMake(0.0, 2.0)
  }
  
  private func setFonts() {
  
    var font = UIFont()
    
    if let setFont = UIFont(name: fontName, size: fontSize) {
      font = setFont
    } else {
      font = UIFont.systemFontOfSize(14)
    }
    
    setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName: fontColor ?? UIColor.darkTextColor()], forState: .Normal)
  }
}
