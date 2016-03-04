import UIKit

/**
 
Badge view control similar to badge used on iOS home screen.
Project home: https://github.com/marketplacer/swift-badge
 
*/
@IBDesignable class SwiftBadge: UILabel {
  
  /// Width of the badge border
  @IBInspectable var borderWidth: CGFloat = 0 {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  /// Color of the bardge border
  @IBInspectable var borderColor: UIColor = UIColor.whiteColor() {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  /// Background color of the badge
  override var backgroundColor: UIColor? {
    get { return fillColor }
    set {
      if let color = newValue {
        fillColor = color
      } else {
        fillColor = UIColor.clearColor()
      }
      
      setNeedsDisplay()
    }
  }
  
  /// Use backgroudColor instead, this is for internal use.
  private var fillColor: UIColor = UIColor.redColor()
  
  /// Badge insets that describe the margin between text and the edge of the badge.
  @IBInspectable var insets: CGSize = CGSize(width: 2, height: 2) {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  // MARK: Badge shadow
  // --------------------------
  
  /// Opacity of the badge shadow
  @IBInspectable var shadowOpacityBadge: CGFloat = 0.5 {
    didSet {
      layer.shadowOpacity = Float(shadowOpacityBadge)
      setNeedsDisplay()
    }
  }
  
  /// Size of the badge shadow
  @IBInspectable var shadowRadiusBadge: CGFloat = 0.5 {
    didSet {
      layer.shadowRadius = shadowRadiusBadge
      setNeedsDisplay()
    }
  }
  
  /// Color of the badge shadow
  @IBInspectable var shadowColorBadge: UIColor = UIColor.blackColor() {
    didSet {
      layer.shadowColor = shadowColorBadge.CGColor
      setNeedsDisplay()
    }
  }
  
  /// Offset of the badge shadow
  @IBInspectable var shadowOffsetBadge: CGSize = CGSize(width: 0, height: 0) {
    didSet {
      layer.shadowOffset = shadowOffsetBadge
      setNeedsDisplay()
    }
  }
  
  convenience init() {
    self.init(frame: CGRect())
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setup()
  }
  
  /// Add custom insets around the text
  override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    let rect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)

    var insetsWithBorder = actualInsetsWithBorder()
    let rectWithDefaultInsets = CGRectInset(rect, -insetsWithBorder.width, -insetsWithBorder.height)
    
    // If width is less than height
    // Adjust the width insets to make it look round
    if rectWithDefaultInsets.width < rectWithDefaultInsets.height {
      insetsWithBorder.width = (rectWithDefaultInsets.height - rect.width) / 2
    }
    let result = CGRectInset(rect, -insetsWithBorder.width, -insetsWithBorder.height)

    return result
  }
  
  override func drawTextInRect(rect: CGRect) {
    layer.cornerRadius = rect.height / 2
    
    let insetsWithBorder = actualInsetsWithBorder()
    let insets = UIEdgeInsets(
      top: insetsWithBorder.height,
      left: insetsWithBorder.width,
      bottom: insetsWithBorder.height,
      right: insetsWithBorder.width)
    
    let rectWithoutInsets = UIEdgeInsetsInsetRect(rect, insets)

    super.drawTextInRect(rectWithoutInsets)
  }
  
  /// Draw the background of the badge
  override func drawRect(rect: CGRect) {
    let rectInset = CGRectInset(rect, borderWidth/2, borderWidth/2)
    let path = UIBezierPath(roundedRect: rectInset, cornerRadius: rect.height/2)
    
    fillColor.setFill()
    path.fill()
    
    if borderWidth > 0 {
      borderColor.setStroke()
      path.lineWidth = borderWidth
      path.stroke()
    }
    
    super.drawRect(rect)
  }
  
  private func setup() {
    textAlignment = NSTextAlignment.Center
    clipsToBounds = false // Allows shadow to spread beyond the bounds of the badge
  }
  
  /// Size of the insets plus the border
  private func actualInsetsWithBorder() -> CGSize {
    return CGSize(
      width: insets.width + borderWidth,
      height: insets.height + borderWidth
    )
  }
  
  /// Draw the stars in interface buidler
  @available(iOS 8.0, *)
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    
    setup()
    setNeedsDisplay()
  }
}
