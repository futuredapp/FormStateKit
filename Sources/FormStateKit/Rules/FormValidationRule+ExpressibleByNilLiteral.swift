public extension FormValidationRule where Value: ExpressibleByNilLiteral {
    static var required: Self {
        Self.init { $0 != .init(nilLiteral: ()) }
    }
}
