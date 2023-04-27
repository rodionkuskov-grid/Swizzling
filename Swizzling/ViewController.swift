//
//  ViewController.swift
//  Swizzling
//
//  Created by Rodion Kuskov on 4/1/23.
//

import UIKit

class ViewController: UIViewController {
    private let framework = SomeFramework()

    override func viewDidLoad() {
        super.viewDidLoad()
        framework.printSun()
    }
}


// MARK: - Some framework

class SomeFramework {
    
    init() {
        swizzleFunctions()
    }
    
    // MARK: - Public function which could be used outside the framework
    @objc public dynamic func printSun() {
        print("🌞")
    }

    // MARK: - Private function which should record analytics when printSun() is called. Also need to call original method
    @objc private func logAnalytics() {
        print("Logging analytics.")
        printSun()
    }

    private func swizzleFunctions() {
        guard
            let originalMethod = class_getInstanceMethod(SomeFramework.self, #selector(SomeFramework.printSun)),
            let customMethod = class_getInstanceMethod(SomeFramework.self, #selector(SomeFramework.logAnalytics))
        else { return }

        method_exchangeImplementations(originalMethod, customMethod)
    }
}
