public extension FormValidationRule where Value: Collection {
    static var required: Self {
        Self.init { !$0.isEmpty }
    }

    static var empty: Self {
        Self.init(\.isEmpty)
    }
}
