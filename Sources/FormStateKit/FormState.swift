public struct FormState<Form> {
    public var form: Form
    public let validations: [FormValidation<Form>]
    public var isValidating: Bool = false

    public init(form: Form, validations: [FormValidation<Form>]) {
        self.form = form
        self.validations = validations
    }

    public init(emptyForm: Form, validations: [FormValidation<Form>]) {
        self.form = emptyForm
        self.validations = validations
    }

    public mutating func validate() -> Bool {
        isValidating = true
        return validations.allSatisfy { validation in
            validation.validate(form)
        }
    }

    public func errors<Field>(for field: KeyPath<Form, Field>) -> [String] {
        guard isValidating else {
            return []
        }
        return validations
            .filter { $0.field == AnyHashable(field) && !$0.validate(form) }
            .map(\.description)
            .reduce(into: []) { $0.append($1) }
    }
}
