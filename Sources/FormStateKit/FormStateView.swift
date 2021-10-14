import SwiftUI

@available(iOS 15.0, tvOS 15.0, watchOS 8.0, macOS 12.0, *)
public struct FormStateView<Form: FormModel, Content: View>: View {
    public typealias Builder = (
        Binding<FormState<Form>>,
        PrefilledForm<Form>,
        FocusState<FormState<Form>.FocusedField?>.Binding
    ) -> Content

    @State private var state = FormState<Form>(form: .empty)
    @FocusState private var focus: FormState<Form>.FocusedField?

    private let prefill: (FormState<Form>) -> PrefilledForm<Form>
    private let builder: Builder

    public init(prefill: @escaping (FormState<Form>) -> PrefilledForm<Form>, builder: @escaping Builder) {
        self.prefill = prefill
        self.builder = builder
    }

    public init(builder: @escaping Builder) {
        self.prefill = { _ in PrefilledForm() }
        self.builder = builder
    }

    public var body: some View {
        builder($state, prefill(state), $focus)
    }
}
