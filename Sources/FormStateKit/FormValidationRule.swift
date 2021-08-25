import Foundation

public struct FormValidationRule<Value> {
    let validate: (Value) -> Bool

    public init(_ validate: @escaping (Value) -> Bool) {
        self.validate = validate
    }

    public func callAsFunction(value: Value) -> Bool {
        validate(value)
    }
}
