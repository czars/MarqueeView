//
//  ViewController.swift
//  MarqueeViewExample
//
//  Created by Paul.Chou on 2020/6/5.
//  Copyright © 2020 Paul.Chou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let strings = ["Hello world!Hello world!Hello world!", "Testing Marquee!!", "This is sparta", "Fuck IQiYi", "FUCK FUCK FUCK FUCK FUCK FUCK"]
        let marquee = Marquee.init(with: strings)
        marquee.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(marquee)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[marquee]|", options: [], metrics: nil, views: ["marquee": marquee]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[marquee(44)]", options: [], metrics: nil, views: ["marquee": marquee]))
        marquee.setupUI()
        view.layoutSubviews()
        marquee.setupAni()
    }


}

