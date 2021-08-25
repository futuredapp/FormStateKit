import XCTest
import FormStateKit

final class FormValidationRuleOperatorTests: XCTestCase {
    func testOrOperatorValid() {
        let rule: FormValidationRule<String> = .empty || .email
        XCTAssertTrue(rule(value: ""))
        XCTAssertTrue(rule(value: "email@example.com"))
    }

    func testOrOperatorInvalid() {
        let rule: FormValidationRule<String> = .empty || .email
        XCTAssertFalse(rule(value: "just text"))
    }

    func testAndOperatorValid() {
        let customRule = FormValidationRule<String> { $0.hasSuffix("futured.app") }
        let combinedRule: FormValidationRule<String> = .email && customRule
        XCTAssertTrue(combinedRule(value: "email@futured.app"))
    }

    func testAndOperatorInvalid() {
        let customRule = FormValidationRule<String> { $0.hasSuffix("futured.app") }
        let combinedRule: FormValidationRule<String> = .email && customRule
        XCTAssertFalse(combinedRule(value: "email@example.com"))
        XCTAssertFalse(combinedRule(value: "user.futured.app"))
    }

    func testNotOperatorValid() {
        let rule: FormValidationRule<String> = !.empty
        XCTAssertTrue(rule(value: "some text"))
    }

    func testNotOperatorInvalid() {
        let rule: FormValidationRule<String> = !.empty
        XCTAssertFalse(rule(value: ""))
    }
}
