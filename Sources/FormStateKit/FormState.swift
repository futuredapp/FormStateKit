public struct FormState<Form> {
    public var form: Form

    private let validations: [FormValidation<Form>]
    private let fieldOrder: [PartialKeyPath<Form>]
    private var errors: [PartialKeyPath<Form>: [String]] = [:]

    public init(form: Form, validations: [FormValidation<Form>], fieldOrder: [PartialKeyPath<Form>] = []) {
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
            .filter { validation in
                if case let .synchronous(validate) = validation.action, !validate(form) {
                    return true
                }
                return false
            }
            .reduce(into: [:]) { result, validation in
                result[validation.field, default: []].append(validation.description)
            }
        self.errors = errors
        return errors.isEmpty
    }

    @discardableResult
    public mutating func validate<Field>(field: KeyPath<Form, Field>) -> Bool {
        let fieldErrors = validations
            .filter { validation in
                if validation.field == field, case let .synchronous(validate) = validation.action, !validate(form) {
                    return true
                }
                return false
            }
            .map(\.description)
            .reduce(into: []) { $0.append($1) }
        errors[field] = fieldErrors
        return fieldErrors.isEmpty
    }
    
    @discardableResult
    public mutating func validateAsync() async -> Bool {
        guard validate() else {
            return false
        }
        
        for validation in validations {
            do {
                if case let .asynchronous(validate) = validation.action, try await !validate(form) {
                    errors[validation.field, default: []].append(validation.description)
                }
            } catch {
                errors[validation.field, default: []].append(error.localizedDescription)
            }
        }
        return errors.isEmpty
    }
    
    @discardableResult
    public mutating func validateAsync<Field>(field: KeyPath<Form, Field>) async -> Bool {
        guard validate(field: field) else {
            return false
        }
        
        for validation in validations {
            do {
                if validation.field == field, case let .asynchronous(validate) = validation.action, try await !validate(form) {
                    errors[validation.field, default: []].append(validation.description)
                }
            } catch {
                errors[validation.field, default: []].append(error.localizedDescription)
            }
        }
        return errors.isEmpty
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
