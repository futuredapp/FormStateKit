import Foundation.NSPredicate

private extension NSPredicate {
    static let email: NSPredicate = NSPredicate(
        format: "SELF MATCHES %@",
        "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    )
}

public extension FormValidationRule where Value == String {
    static let email: Self = .init(NSPredicate.email.evaluate)
}
