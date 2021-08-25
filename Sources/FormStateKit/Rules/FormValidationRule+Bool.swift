public extension FormValidationRule where Value == Bool {
    static let hasToBeOn: Self = .init { $0 }
    static let hasToBeOff: Self = .init { !$0 }
}
