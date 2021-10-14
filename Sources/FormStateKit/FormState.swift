public struct FormState<Form> {
    public typealias FocusedField = PartialKeyPath<Form>

    public var form: Form

    private let validations: [FormValidation<Form>]
    private let fieldOrder: [FocusedField]
    private var errors: [FocusedField: [String]] = [:]

    public init(form: Form, validations: [FormValidation<Form>], fieldOrder: [FocusedField] = []) {
        self.form = form
        self.validations = validations
        self.fieldOrder = fieldOrder
    }

    public init(form: Form) where Form: FormModel {
        self.form = form
        self.validations = form.validations
        self.fieldOrder = form.fieldOrder
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
    public mutating func submit<Field>(field: KeyPath<Form, Field>) -> FocusedField? {
        guard validate(field: field) else {
            return field
        }
        return nextField(after: field)
    }

    public mutating func submit<Field>(field: KeyPath<Form, Field>, updating focus: inout FocusedField?) {
        focus = submit(field: field)
    }

    public func nextField(after field: FocusedField) -> FocusedField? {
        fieldOrder.drop { $0 != field }.dropFirst().first
    }
}
