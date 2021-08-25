public extension FormValidationRule where Value: ExpressibleByNilLiteral & Equatable {
    static var required: Self {
        Self.init { $0 != Value.init(nilLiteral: ()) }
    }
}
