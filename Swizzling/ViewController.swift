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
        /* SomeFramework().printSun() */
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

// MARK: - Какой-нибудь фреймворк

class SomeFramework {
    private static var isSwizzleCompleted: Bool = false

    init() {
        guard !SomeFramework.isSwizzleCompleted else { return }
        swizzleFunctions()
    }
    
    // MARK: - Открытая функция, которую могут использовать вне фреймворка
    @objc public dynamic func printSun() {
        print("🌞")
    }

    // MARK: - Закрытая функция, которая собирает аналитку и вызывает открытую функцию printSun()
    /// В случае, если нужно вызывать оригинальную функцию тоже, необходимо добавить dynamic keyword.
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
        SomeFramework.isSwizzleCompleted = true
    }
}
