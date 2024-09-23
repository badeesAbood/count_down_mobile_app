//
//  File.swift
//  countDown
//
//  Created by MASARAT on 22/9/2024.
//

import Foundation
import UIKit
import QuartzCore
class CircularProgressView: UIView {
    private var oldValue : Float = 0.0
    private var progressLayer = CAShapeLayer()
    private var tracklayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureProgressViewToBeCircular()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureProgressViewToBeCircular()
    }
    
    var setProgressColor: UIColor = UIColor.red {
        didSet {
            progressLayer.strokeColor = setProgressColor.cgColor
        }
    }
    
    var setTrackColor: UIColor = UIColor.white {
        didSet {
            tracklayer.strokeColor = setTrackColor.cgColor
        }
    }
    /**
     A path that consists of straight and curved line segments that you can render in your custom views.
     Meaning our CAShapeLayer will now be drawn on the screen with the path we have specified here
     */
    private var viewCGPath: CGPath? {
        return UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                            radius: (frame.size.width - 1.5)/2,
                            startAngle: CGFloat(-0.5 * Double.pi),
                            endAngle: CGFloat(1.5 * Double.pi), clockwise: true).cgPath
    }
    
    private func configureProgressViewToBeCircular() {
        self.drawsView(using: tracklayer, startingPoint: 20, ending: 1.0)
        self.drawsView(using: progressLayer, startingPoint: 20, ending: 0.0)
    }
    
    private func drawsView(using shape: CAShapeLayer, startingPoint: CGFloat, ending: CGFloat) {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2.0
        
        shape.path = self.viewCGPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = setProgressColor.cgColor
        shape.lineWidth = startingPoint
        shape.strokeEnd = ending
        
        self.layer.addSublayer(shape)
    }
    
    var isAnimating = false
    var currentProgress: Float = 0

    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        // Check if already animating
       
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        isAnimating = true
        currentProgress = value
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0 // Start animation at point 0
        animation.toValue = value // End animation at point specified
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        // Set the final value immediately so that the layer reflects it after the animation
        progressLayer.strokeEnd = CGFloat(value)
        
        // Add the animation
        progressLayer.add(animation, forKey: "animateCircle")
    }

    // Function to pause the animation
    func pauseAnimation() {
        guard isAnimating else { return }

        // Get the current animation state
        let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
    }

    // Function to resume the animation
    func resumeAnimation() {
        guard !isAnimating else { return }

        let pausedTime = progressLayer.timeOffset
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        let timeSincePause = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePause
        isAnimating = true
        
        // Optionally, you can start a new animation from the current progress if needed
        // setProgressWithAnimation(duration: desiredDuration, value: currentProgress)
    }
    
    func stopAnimation(){
      setProgressWithAnimation(duration: 0, value: oldValue )
    }
}
