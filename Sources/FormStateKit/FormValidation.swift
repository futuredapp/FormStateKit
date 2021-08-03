public struct FormValidation<Form> {
    public let field: AnyHashable
    public let description: String
    let validate: (Form?, Form) -> Bool

    public init<R>(field: KeyPath<Form, R>, description: String, validate: @escaping (Form) -> Bool) {
        self.field = AnyHashable(field)
        self.description = description
        self.validate = { _, model in
            validate(model)
        }
    }

    public init<R>(field: KeyPath<Form, R>, description: String, validate: @escaping (Form?, Form) -> Bool) {
        self.field = AnyHashable(field)
        self.description = description
        self.validate = validate
    }
}
