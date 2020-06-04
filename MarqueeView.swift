//
//  MarqueeView.swift
//  TMDB
//
//  Created by Paul.Chou on 2020/6/5.
//  Copyright © 2020 paul.chou. All rights reserved.
//

import UIKit

protocol MarqueeAnimationDelegate: class {
    func marqueeAnimationDidStart(_ anim: CAAnimation)
    func marqueeAnimationDidStop(_ anim: CAAnimation, finished flag: Bool)
}

class Marquee: UIView {
    
    private let baseView = UIView()
    private var runnings: [String]
    private var configuration: MarqueeConfiguration
    private var runningLabels = [UILabel]()
    
    weak var delegate: MarqueeAnimationDelegate?
    
    init(with running: [String] = [], _ config: MarqueeConfiguration = MarqueeConfiguration()) {
        runnings = running
        configuration = config
        super.init(frame: .zero)
        self.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.backgroundColor = .red
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[base]", options: [], metrics: nil, views: ["base": baseView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[base]|", options: [], metrics: nil, views: ["base": baseView]))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        var previous: UILabel?
        for (idx, running) in runnings.enumerated() {
            previous?.sizeToFit()
            let label = UILabel()
            baseView.addSubview(label)
            label.text = running
            label.backgroundColor = .blue
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setContentHuggingPriority(.required, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
            setupConstraint(label, previous: previous, last: (idx == self.runnings.count-1))
            runningLabels.append(label)
            previous = label
        }
        baseView.setNeedsLayout()
        baseView.layoutSubviews()
    }
    
    func setupAni() {
        for label in runningLabels {
            let ani = self.createAni(with: label)
            label.layer.add(ani, forKey: nil)
        }
    }
    
    
}

private extension Marquee {
    func setupConstraint(_ label: UILabel, previous: UILabel?, last: Bool) {
        if let previousLabel = previous {
            if last {
                baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[previous]-[label]-|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: ["previous": previousLabel, "label": label]))
            } else {
                baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[previous]-[label]", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: ["previous": previousLabel, "label": label]))
            }
        } else {
            baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: ["label": label]))
        }
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label": label]))
    }
    
    func createAni(with label: UILabel) -> CABasicAnimation {
        let ani = CABasicAnimation.init(keyPath: "position.x")
        let width = baseView.frame.size.width
        ani.duration = CFTimeInterval(width / CGFloat(configuration.animateSpeed))
        ani.fromValue = label.frame.origin.x+(0.5*label.frame.size.width)
        ani.toValue = label.frame.origin.x-self.frame.size.width+(0.5*label.frame.size.width)
        ani.timingFunction = CAMediaTimingFunction.init(name: .linear)
        ani.repeatCount = configuration.repeatCount
        ani.delegate = MarqueeRemover(label)
        return ani
    }
}

class MarqueeConfiguration: NSObject {
    var repeatCount: Float = .greatestFiniteMagnitude
    var animateSpeed: Float = 60
}

private class MarqueeRemover: NSObject, CAAnimationDelegate {
    private weak var view: UIView?
    
    init(_ view: UIView) {
        self.view = view
        super.init()
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        print("animation did started!!! \(anim.isRemovedOnCompletion)")
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animation finished \(flag ? "YES": "NO")")
        view?.removeFromSuperview()
    }
}
