public struct FormState<Form: FormModel> {
    public var form: Form

    private var validations: [FormValidation<Form>] { form.validations }
    private var fieldOrder: [PartialKeyPath<Form>] { form.fieldOrder }
    private var errors: [PartialKeyPath<Form>: [String]] = [:]

    public init(form: Form)  {
        self.form = form
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
            .filter { $0.field == field && !$0.validate(form) }
            .map(\.description)
            .reduce(into: []) { $0.append($1) }
        errors[field] = fieldErrors
        return fieldErrors.isEmpty
    }

    public func errors<Field>(for field: KeyPath<Form, Field>) -> [String] {
        errors[field, default: []]
    }

    public mutating func clearErrors<Field>(for field: KeyPath<Form, Field>) {
        errors.removeValue(forKey: field)
    }

    public mutating func clearErrors() {
        errors.removeAll()
    }

    @discardableResult
    public mutating func submit<Field>(field: KeyPath<Form, Field>) -> PartialKeyPath<Form>? {
        guard validate(field: field) else {
            return field
        }
        return nextField(after: field)
    }

    public mutating func submit<Field>(field: KeyPath<Form, Field>, updating focus: inout PartialKeyPath<Form>?) {
        focus = submit(field: field)
    }

    public func nextField(after field: PartialKeyPath<Form>) -> PartialKeyPath<Form>? {
        fieldOrder.drop { $0 != field }.dropFirst().first
    }
}
