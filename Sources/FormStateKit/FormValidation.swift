enum ValidationAction<Form> {
    case synchronous((Form) -> Bool)
    case asynchronous((Form) async throws -> Bool)
}

public struct FormValidation<Form> {
    let field: PartialKeyPath<Form>
    let description: String
    let action: ValidationAction<Form>

    public init<Value>(for field: KeyPath<Form, Value>, description: String, validateValue: @escaping (Value) -> Bool) {
        self.field = field
        self.description = description
        self.action = .synchronous { form in
            validateValue(form[keyPath: field])
        }
    }

    public init<R>(for field: KeyPath<Form, R>, description: String, validateForm: @escaping (Form) -> Bool) {
        self.field = field
        self.description = description
        self.action = .synchronous(validateForm)
    }

    public init<Value>(for field: KeyPath<Form, Value>, description: String, rule: FormValidationRule<Value>) {
        self.field = field
        self.description = description
        self.action = .synchronous { form in
            rule(value: form[keyPath: field])
        }
    }
    
    public init<Value>(for field: KeyPath<Form, Value>, description: String, validateValue: @escaping (Value) async throws -> Bool) {
        self.field = field
        self.description = description
        self.action = .asynchronous { form in
            try await validateValue(form[keyPath: field])
        }
    }

    public init<R>(for field: KeyPath<Form, R>, description: String, validateForm: @escaping (Form) async throws -> Bool) {
        self.field = field
        self.description = description
        self.action = .asynchronous(validateForm)
    }
}
