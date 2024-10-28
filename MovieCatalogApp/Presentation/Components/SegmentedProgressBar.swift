//
//  SegmentedProgressBar.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 28.10.2024.
//

import Foundation
import UIKit

protocol SegmentedProgressBarDelegate: AnyObject {
    func segmentedProgressBarChangedIndex(index: Int)
    func segmentedProgressBarFinished()
}

class SegmentedProgressBar: UIView {
    
    weak var delegate: SegmentedProgressBarDelegate?
    
    var gradientColors: [CGColor] = [] {
        didSet {
            self.updateColors()
        }
    }
    
    var bottomColor = UIColor.gray.withAlphaComponent(0.25) {
        didSet {
            self.updateColors()
        }
    }
    var padding: CGFloat = 2.0
    var isPaused: Bool = false {
        didSet {
            if isPaused {
                for segment in segments {
                    let layer = segment.topSegmentView.layer
                    let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
                    layer.speed = 0.0
                    layer.timeOffset = pausedTime
                }
            } else {
                let segment = segments[currentAnimationIndex]
                let layer = segment.topSegmentView.layer
                let pausedTime = layer.timeOffset
                layer.speed = 1.0
                layer.timeOffset = 0.0
                layer.beginTime = 0.0
                let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
                layer.beginTime = timeSincePause
            }
        }
    }
    
    private var segments = [Segment]()
    private let duration: TimeInterval
    private var hasDoneLayout = false
    private var currentAnimationIndex = 0
    
    init(numberOfSegments: Int, duration: TimeInterval = 5.0, gradientColors: [CGColor]) {
        self.duration = duration
        self.gradientColors = gradientColors
        super.init(frame: CGRect.zero)
        
        for _ in 0..<numberOfSegments {
            let segment = Segment()
            addSubview(segment.bottomSegmentView)
            addSubview(segment.topSegmentView)
            segments.append(segment)
        }
        self.updateColors()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if hasDoneLayout {
            return
        }
        let width = (frame.width - (padding * CGFloat(segments.count - 1))) / CGFloat(segments.count)
        for (index, segment) in segments.enumerated() {
            let segFrame = CGRect(x: CGFloat(index) * (width + padding), y: 0, width: width, height: frame.height)
            segment.bottomSegmentView.frame = segFrame
            segment.topSegmentView.frame = segFrame
            segment.topSegmentView.frame.size.width = 0
            
            let cr = frame.height / 2
            segment.bottomSegmentView.layer.cornerRadius = cr
            segment.topSegmentView.layer.cornerRadius = cr
        }
        hasDoneLayout = true
    }
    
    func startAnimation() {
        layoutSubviews()
        animate()
    }
    
    func continueAnimation() {
        let currentSegment = segments[currentAnimationIndex]
        currentSegment.topSegmentView.layer.removeAllAnimations()
        currentSegment.topSegmentView.frame.size.width = 0
        currentSegment.gradientLayer?.removeAllAnimations()
        currentSegment.gradientLayer?.frame.size.width = 0
        self.animate(animationIndex: currentAnimationIndex)
        self.delegate?.segmentedProgressBarChangedIndex(index: currentAnimationIndex)
    }
    
    private func animate(animationIndex: Int = 0) {
        let nextSegment = segments[animationIndex]
        currentAnimationIndex = animationIndex
        self.isPaused = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = nextSegment.topSegmentView.bounds
        gradientLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.position = CGPoint(x: 0, y: nextSegment.topSegmentView.bounds.midY)
        nextSegment.topSegmentView.layer.insertSublayer(gradientLayer, at: 0)
        nextSegment.gradientLayer = gradientLayer

        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            nextSegment.topSegmentView.frame.size.width = nextSegment.bottomSegmentView.frame.width
        }, completion: { finished in
            if finished {
                gradientLayer.frame.size.width = nextSegment.bottomSegmentView.frame.width
                self.next()
            }
        })
        
        let gradientAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        gradientAnimation.fromValue = 0
        gradientAnimation.toValue = nextSegment.bottomSegmentView.frame.width
        gradientAnimation.duration = duration
        gradientAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        gradientLayer.add(gradientAnimation, forKey: "bounds.size.width")
    }
    
    private func updateColors() {
        for segment in segments {
            segment.bottomSegmentView.backgroundColor = bottomColor
            segment.gradientLayer?.colors = gradientColors
        }
    }
    
    private func next() {
        let newIndex = (currentAnimationIndex + 1) % segments.count
        
        if newIndex == 0 {
            for segment in segments {
                segment.topSegmentView.frame.size.width = 0
                segment.gradientLayer?.removeAllAnimations()
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                segment.gradientLayer?.frame.size.width = 0
                CATransaction.commit()
            }
        }
        
        animate(animationIndex: newIndex)
        self.delegate?.segmentedProgressBarChangedIndex(index: newIndex)
    }
    
    func skip() {
        let currentSegment = segments[currentAnimationIndex]
        currentSegment.topSegmentView.frame.size.width = currentSegment.bottomSegmentView.frame.width
        currentSegment.topSegmentView.layer.removeAllAnimations()
        currentSegment.gradientLayer?.frame.size.width = currentSegment.bottomSegmentView.frame.width
        currentSegment.gradientLayer?.removeAllAnimations()
        self.next()
    }
    
    func rewind() {
        let currentSegment = segments[currentAnimationIndex]
        currentSegment.topSegmentView.layer.removeAllAnimations()
        currentSegment.topSegmentView.frame.size.width = 0
        currentSegment.gradientLayer?.removeAllAnimations()
        currentSegment.gradientLayer?.frame.size.width = 0
        let newIndex = max(currentAnimationIndex - 1, 0)
        let prevSegment = segments[newIndex]
        prevSegment.topSegmentView.frame.size.width = 0
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        prevSegment.gradientLayer?.frame.size.width = 0
        prevSegment.gradientLayer?.removeAllAnimations()
        CATransaction.commit()
        self.animate(animationIndex: newIndex)
        self.delegate?.segmentedProgressBarChangedIndex(index: newIndex)
    }
}

fileprivate class Segment {
    let bottomSegmentView = UIView()
    let topSegmentView = UIView()
    var gradientLayer: CAGradientLayer?
    init() {}
}
