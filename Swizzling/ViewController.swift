//
//  ViewController.swift
//  Swizzling
//
//  Created by Rodion Kuskov on 4/1/23.
//

import UIKit

class ViewController: UIViewController {
    private let foo = Foo()

    override func viewDidLoad() {
        super.viewDidLoad()
        foo.foo()
    }
}

class Foo {
    dynamic func foo() {
        print("foo called")
    }
}

extension Foo {
    @_dynamicReplacement(for: foo)
    func fooReplacement() {
        foo()
        print("fooReplacement")
    }
}
