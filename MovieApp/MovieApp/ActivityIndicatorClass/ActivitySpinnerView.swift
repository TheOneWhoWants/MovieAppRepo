//
//  ActivitySpinnerView.swift
//  MovieApp
//
//  Created by Matthew  on 26.05.2022.
//

import UIKit

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension SpinnerViewController {
    func createSpinnerView(frame: UIViewController) {
        frame.addChild(self)
        self.view.frame = frame.view.frame
        frame.view.addSubview(self.view)
        self.didMove(toParent: frame)
    }
    
    func deleteSpinerView() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
