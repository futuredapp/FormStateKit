public struct FormState<Form> {
    private let prefilledForm: Form?
    public var form: Form
    public let validations: [FormValidation<Form>]
    public var isValidating: Bool = false

    public init(form: Form, validations: [FormValidation<Form>]) {
        self.prefilledForm = nil
        self.form = form
        self.validations = validations
    }

    public init(prefilledForm: Form?, emptyForm: Form, validations: [FormValidation<Form>]) {
        self.prefilledForm = prefilledForm
        self.form = emptyForm
        self.validations = validations
    }

    public func prefilled(using prefilledForm: Form) -> FormState<Form> {
        FormState(
            prefilledForm: prefilledForm,
            emptyForm: form,
            validations: validations
        )
    }

    public mutating func validate() -> Bool {
        isValidating = true
        return validations.allSatisfy { validation in
            validation.validate(prefilledForm, form)
        }
    }

    public func errors<Field>(for field: KeyPath<Form, Field>) -> [String] {
        guard isValidating else {
            return []
        }
        return validations
            .filter { $0.field == AnyHashable(field) && !$0.validate(prefilledForm, form) }
            .map(\.description)
            .reduce(into: []) { $0.append($1) }
    }
}
