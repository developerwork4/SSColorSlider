//
//  SSColorSlider.swift
//  SSColorSlider
//
//  Created by Sweta on 29/09/19.
//  Copyright © 2019 Sweta. All rights reserved.
//

import UIKit

class SSColorSlider: UISlider {
    
    var color:UIColor{
        get{
            return UIColor(hue: CGFloat(self.value),saturation: 1.0,brightness: 1.0,alpha: 1.0)
        }
        set{
            var hue:CGFloat = 0
            newValue.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
            self.value = Float(hue)
        }
    }
    
    override var value: Float {
        didSet {
            self.removeIndicator()
        }
    }
    
    @IBInspectable public var sliderBackgroundColor:UIColor = .clear {
        didSet {
            colorTrackImageView.backgroundColor = sliderBackgroundColor
        }
    }
    
    @IBInspectable public var indicatorHeight:CGFloat = 0 {
        didSet {
            self.setIndicatorRect()
        }
    }
    
    @IBInspectable public var colorTrackHeight:Int = 0 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    @IBInspectable public var isColorSlider:Bool = false {
        didSet {
            if self.isColorSlider {
                self.colorTrackImageView.image = UIImage(named: "slider-color")
            }
            self.updateIndicatorRect()
        }
    }
    
    @IBInspectable public var thumbColor:UIColor = .clear {
        didSet {
            self.updateIndicatorRect()
        }
    }
    
    var colorTrackImageView:UIImageView!
    var indicatorThumbView:SSIndicatorThumbView!
    var indicatorView:SSIndicatorView!
    var indicatorApprearAnimationDuration:TimeInterval = 0.07
    var indicatorDismissAnimationDuration:TimeInterval = 0.06
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        colorTrackImageView = UIImageView()
        addSubview(colorTrackImageView)
        sendSubviewToBack(colorTrackImageView)
        
        var newRect:CGRect = currentThumbRect().insetBy(dx: -1, dy: -1)
        newRect.origin.x = currentThumbRect().midX - newRect.width/2;
        indicatorThumbView = previewViewWithFrame(frame: newRect, color: UIColor(hue: CGFloat(self.value),saturation: 1.0,brightness: 1.0,alpha: 1.0))
        addSubview(indicatorThumbView)
        
        if self.isColorSlider {
            indicatorThumbView.color = UIColor(hue: CGFloat(self.value),saturation: 1.0,brightness: 1.0,alpha: 1.0)
        }else {
            indicatorThumbView.color = thumbColor
        }
        
        let rect:CGRect = currentThumbRect().insetBy(dx: -1, dy: -1).offsetBy(dx: 0, dy: -50)
        self.indicatorView = previewIndicatorViewWithFrame(frame: rect, color: UIColor(hue: CGFloat(self.value),saturation: 1.0,brightness: 1.0,alpha: 1.0))
        addSubview(indicatorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colorTrackImageView.frame = trackRect(forBounds: self.bounds)
        let center:CGPoint = colorTrackImageView.center
        var rect:CGRect = colorTrackImageView.frame
        rect.size.height = CGFloat(colorTrackHeight)
        colorTrackImageView.frame = rect
        colorTrackImageView.center = center
        colorTrackImageView.clipsToBounds = true
        colorTrackImageView.layer.cornerRadius = colorTrackImageView.frame.size.height / 2
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let tracking:Bool = super.beginTracking(touch, with: event)
        self.updateIndicatorRect()
        return tracking
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let cont:Bool = super.continueTracking(touch, with: event)
        self.updateIndicatorRect()
        return cont
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        self.removeIndicator()
    }
    
    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        self.removeIndicator()
    }
    
    func setIndicatorRect() {
        let inset = indicatorHeight - 31
        var newRect:CGRect = currentThumbRect().insetBy(dx: -1, dy: -1).offsetBy(dx: 0, dy: -inset/2)
        newRect.origin.x = currentThumbRect().midX - newRect.width/2;
        newRect.size.width = indicatorHeight
        newRect.size.height = indicatorHeight
        self.indicatorThumbView.frame = newRect
        self.indicatorThumbView.layer.cornerRadius = self.indicatorThumbView.frame.width/2
        self.indicatorThumbView.inset = abs(inset/2)
        
        let rect:CGRect = currentThumbRect().insetBy(dx: -1, dy: -1).offsetBy(dx: 0, dy: -indicatorHeight)
        self.indicatorView.frame = rect
        self.indicatorView.alpha = 0
    }
    
    func updateIndicatorRect() {
        var thumbRect:CGRect = self.indicatorThumbView.frame
        thumbRect.origin.x = currentThumbRect().midX - thumbRect.width/2;
        indicatorThumbView.frame = thumbRect
        if self.isColorSlider {
            self.indicatorThumbView.color = Color.centerThumbColor //UIColor(hue: CGFloat(self.value),saturation: 1.0,brightness: 1.0,alpha: 1.0)
            
            var rect:CGRect = self.indicatorView.frame
            rect.origin.x = currentThumbRect().midX - rect.width/2;
            indicatorView.frame = rect
            indicatorView.color = UIColor(hue: CGFloat(self.value),saturation: 1.0,brightness: 1.0,alpha: 1.0)
            
            UIView.animate(withDuration: indicatorApprearAnimationDuration, animations: {
                self.indicatorView.alpha = 1
            })
        }else {
            self.indicatorThumbView.color = self.thumbColor
            self.indicatorView.alpha = 0
        }
    }
    
    func currentThumbRect() -> CGRect {
        return thumbRect(forBounds: self.bounds, trackRect: trackRect(forBounds: self.bounds), value: self.value)
    }
    
    func removeIndicator() {
        self.updateIndicatorRect()
        self.indicatorThumbView.color = self.isColorSlider ? UIColor(hue: CGFloat(self.value),saturation: 1.0,brightness: 1.0,alpha: 1.0) : self.thumbColor
        UIView.animate(withDuration: indicatorDismissAnimationDuration, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.indicatorView.alpha = 0.0
        })
    }
    
    func previewIndicatorViewWithFrame(frame:CGRect?, color:UIColor) -> SSIndicatorView {
        let indicator:SSIndicatorView = SSIndicatorView(frame: frame!)
        indicator.tintColor = UIColor.white
        indicator.layer.cornerRadius = indicator.frame.width/2
        indicator.alpha = 1
        indicator.color = color
        return indicator
    }
    
    func previewViewWithFrame(frame:CGRect?, color:UIColor) -> SSIndicatorThumbView {
        let indicator:SSIndicatorThumbView = SSIndicatorThumbView(frame: frame!)
        indicator.tintColor = UIColor.white
        indicator.layer.cornerRadius = indicator.frame.width/2
        indicator.alpha = 1
        indicator.isUserInteractionEnabled = false
        indicator.color = color
        return indicator
    }
}
