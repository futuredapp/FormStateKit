public protocol FormModel {
    static var empty: Self { get }

    var validations: [FormValidation<Self>] { get }
    var fieldOrder: [PartialKeyPath<Self>] { get }
}

public extension FormModel {
    var fieldOrder: [PartialKeyPath<Self>] { [] }
}
