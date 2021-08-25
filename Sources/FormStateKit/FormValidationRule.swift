import Foundation

public struct FormValidationRule<Value> {
    let validate: (Value) -> Bool

    public init(_ validate: @escaping (Value) -> Bool) {
        self.validate = validate
    }

    public func callAsFunction(value: Value) -> Bool {
        validate(value)
    }

    static public func && (_ lhs: Self, _ rhs: Self) -> Self {
        Self.init { value in
            lhs.validate(value) && rhs.validate(value)
        }
    }

    static public func || (_ lhs: Self, _ rhs: Self) -> Self {
        Self.init { value in
            lhs.validate(value) || rhs.validate(value)
        }
    }

    static public prefix func !(_ rule: Self) -> Self {
        Self.init { value in
            !rule.validate(value)
        }
    }
}
