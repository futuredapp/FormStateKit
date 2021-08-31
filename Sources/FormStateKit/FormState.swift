@propertyWrapper
public struct FormState<Form> {
    public var form: Form
    private let validations: [FormValidation<Form>]
    private var errors: [AnyHashable: [String]] = [:]

    public init(form: Form, validations: [FormValidation<Form>]) {
        self.form = form
        self.validations = validations
    }

    public init(wrappedValue: Form, validations: [FormValidation<Form>]) {
        self.form = wrappedValue
        self.validations = validations
    }

    public var wrappedValue: Form {
        get {
            form
        }
        set {
            form = newValue
        }
    }

    public var allErrors: [String] {
        errors.flatMap(\.value)
    }

    @discardableResult
    public mutating func validate() -> Bool {
        let errors = validations
            .filter { !$0.validate(form) }
            .reduce(into: [:]) { result, validation in
                result[validation.field, default: []].append(validation.description)
            }
        self.errors = errors
        return errors.isEmpty
    }

    @discardableResult
    public mutating func validate<Field>(field: KeyPath<Form, Field>) -> Bool {
        let fieldErrors = validations
            .filter { $0.field == AnyHashable(field) && !$0.validate(form) }
            .map(\.description)
            .reduce(into: []) { $0.append($1) }
        errors[AnyHashable(field)] = fieldErrors
        return fieldErrors.isEmpty
    }

    public func errors<Field>(for field: KeyPath<Form, Field>) -> [String] {
        errors[AnyHashable(field), default: []]
    }

    public mutating func clearErrors<Field>(for field: KeyPath<Form, Field>) {
        errors.removeValue(forKey: AnyHashable(field))
    }

    public mutating func clearErrors() {
        errors.removeAll()
    }
}
