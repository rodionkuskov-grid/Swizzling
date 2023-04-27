//
//  ViewController.swift
//  Swizzling
//
//  Created by Rodion Kuskov on 4/1/23.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        SomeFramework().printSun()
    }

    @objc dynamic func printSunModified() {
        print("🌞🌞")
    }
}

extension SomeFramework {
    static func swizzleFrameworkFunction() {
        guard
            let originalMethod = class_getInstanceMethod(SomeFramework.self, #selector(SomeFramework.printSun)),
            let customMethod = class_getInstanceMethod(ViewController.self, #selector(ViewController.printSunModified))
        else { return }

        method_exchangeImplementations(originalMethod, customMethod)
    }
}

// MARK: - Some framework

class SomeFramework {
    private static var isSwizzlingCompleted: Bool = false

    init() {
        guard !SomeFramework.isSwizzlingCompleted else { return }
        swizzleFunctions()
    }
    
    // MARK: - Public function which could be used outside the framework
    @objc public dynamic func printSun() {
        print("🌞")
    }

    // MARK: - Private function which should record analytics when printSun() is called. Also need to call original method
    @objc private dynamic func logAnalytics() {
        print("Logging analytics.")
        logAnalytics()
    }

    private func swizzleFunctions() {
        guard
            let originalMethod = class_getInstanceMethod(SomeFramework.self, #selector(SomeFramework.printSun)),
            let customMethod = class_getInstanceMethod(SomeFramework.self, #selector(SomeFramework.logAnalytics))
        else { return }

        method_exchangeImplementations(originalMethod, customMethod)
        SomeFramework.isSwizzlingCompleted = true
    }
}
