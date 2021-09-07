#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public struct FormPrefill<Form> {
    let form: Form?

    public init(form: Form?) {
        self.form = form
    }

    public func prefill<Value>(_ keyPath: WritableKeyPath<Form, Value>, _ binding: Binding<FormState<Form>>) -> Binding<Value> {
        Binding {
            form?[keyPath: keyPath] ?? binding.form[dynamicMember: keyPath].wrappedValue
        } set: { newValue in
            binding.form[dynamicMember: keyPath].wrappedValue = newValue
        }
        .transaction(binding.transaction)
    }
}
#endif
