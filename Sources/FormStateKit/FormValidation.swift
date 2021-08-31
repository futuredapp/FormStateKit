public struct FormValidation<Form> {
    let field: PartialKeyPath<Form>
    public let description: String
    let validate: (Form) -> Bool

    public init<Value>(for field: KeyPath<Form, Value>, description: String, validateValue: @escaping (Value) -> Bool) {
        self.field = field
        self.description = description
        self.validate = { form in
            validateValue(form[keyPath: field])
        }
    }

    public init<R>(for field: KeyPath<Form, R>, description: String, validateForm: @escaping (Form) -> Bool) {
        self.field = field
        self.description = description
        self.validate = validateForm
    }

    public init<Value>(for field: KeyPath<Form, Value>, description: String, rule: FormValidationRule<Value>) {
        self.field = field
        self.description = description
        self.validate = { form in
            rule(value: form[keyPath: field])
        }
    }
}
