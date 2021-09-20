# FormStateKit

A Swift package for simple management of forms and its fields. Focused on SwiftUI.

## Features

- Declarative form and validation definition.
- Single state for the whole form with its fields.
- Support for non-`String` validations and fields like toggles, sliders, selection, multi-selection and more.
- Cross-field validation, comparing values of more fields with each other (like password and password again fields).
- Some standard built-in validations (required, empty, email and methods for combining validation rules).
- Works nicely with the new `@FocusState` APIs.

## Usage

You can define a form state like this as a simple struct instead of defining more state properies for each field:

```swift
struct SignupForm {
    var name: String
    var email: String
    var password: String
    var acceptedPrivacyPolicy: Bool
}
```

To setup prefilled values for the field you can use default property values (or some static instance if you prefer):

```swift
struct SignupForm {
    var name = String()
    var email = String()
    var password = String()
    var acceptedPrivacyPolicy = false
}
```

To declare validation logic for the form you can create an array of validations:

```swift
let validations: [FormValidation<SignupForm>] = [
    FormValidation(for: \.name, description: "Name must be filled in.", rule: .required),
    FormValidation(for: \.email, description: "Email must be filled in.", rule: .required),
    FormValidation(for: \.email, description: "Email is not in in valid format.", rule: .email),
    FormValidation(for: \.password, description: "Password is required.", rule: .required),
    FormValidation(for: \.password, description: "Password must be longer than 6 characters") { $0.count > 6 },
    FormValidation(for: \.acceptedPrivacyPolicy, description: "You need to accept privacy policy.", rule: .hasToBeOn)
]
```

And if you want to use the package for focus management you can define array of key paths as a field order.

```swift
let fieldOrder: [PartialKeyPath<Self>] = [\.name, \.email, \.password]
```

When you have your form declared you can you it in the view:

```swift
struct SignupView: View {
    @State private var state = FormState(form: SignupForm())

    @FocusState private var focus: PartialKeyPath<SignupForm>?

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $state.form.name)
                    .focused($focus, equals: \.name)
                    .onSubmit {
                        state.submit(field: \.name, updating: &focus)
                    }
                ForEach(errors, id: \.self, content: Text.init)
                    .font(.footnote)
                    .foregroundColor(.red)
            }

            ...

            Section {
                Button(action: submit) {
                    Label("Submit", systemImage: "arrow.right")
                }
            }
        }
    }

    private func submit() {
        if state.validate() {
            ...
        } else {
            ...
        }
    }
}
```

## Installation

When using Swift package manager install using Xcode 11+ or add following line to your dependencies:

```swift
.package(url: "https://github.com/futuredapp/FormStateKit.git", from: "0.1.0")
```

## Contributing

All contributions are welcome.

Current maintainer and main contributor is [Matěj Kašpar Jirásek](https://github.com/mkj-is), <matej.jirasek@futured.app>.

## License

FormStateKit is available under the MIT license. See the [LICENSE file](LICENSE) for more information.
