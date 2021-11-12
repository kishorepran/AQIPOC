//
//  Bindable.swift
//  AQIPOC
//
//  Created by User on 10/24/21.
//

//MARK:- Generic data type for data binding
import Foundation

class Bindable<T> {
    var value: T {
        didSet {
            listner?(value)
        }
    }
    private var listner: ((T) -> Void)?
    init(_ value: T) {
        self.value = value
    }
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listner = closure
    }
}
