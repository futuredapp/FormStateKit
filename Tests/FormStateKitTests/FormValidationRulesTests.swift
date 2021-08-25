import XCTest
import FormStateKit

final class FormValidationRulesTests: XCTestCase {
    func testHasToBeOnWhenOn() {
        let rule = FormValidationRule.hasToBeOn
        XCTAssertTrue(rule(value: true))
    }

    func testHasToBeOnWhenOff() {
        let rule = FormValidationRule.hasToBeOn
        XCTAssertFalse(rule(value: false))
    }

    func testHasToBeOffWhenOff() {
        let rule = FormValidationRule.hasToBeOff
        XCTAssertTrue(rule(value: false))
    }

    func testHasToBeOffWhenOn() {
        let rule = FormValidationRule.hasToBeOff
        XCTAssertFalse(rule(value: true))
    }

    func testRequiredOnSomeString() {
        let rule = FormValidationRule<String>.required
        XCTAssertTrue(rule(value: "someString"))
    }

    func testRequiredOnEmptyString() {
        let rule = FormValidationRule<String>.required
        XCTAssertFalse(rule(value: ""))
    }

    func testRequiredOnArrayContainingElements() {
        let rule = FormValidationRule<[Int]>.required
        XCTAssertTrue(rule(value: [0, 1]))
    }

    func testRequiredOnEmptyArray() {
        let rule = FormValidationRule<[Int]>.required
        XCTAssertFalse(rule(value: []))
    }

    func testRequiredOnSetContainingElements() {
        let rule = FormValidationRule<Set<Int>>.required
        XCTAssertTrue(rule(value: [0, 1]))
    }

    func testRequiredOnEmptySet() {
        let rule = FormValidationRule<Set<Int>>.required
        XCTAssertFalse(rule(value: []))
    }

    func testRequiredOnSomeDate() {
        let rule = FormValidationRule<Date?>.required
        XCTAssertTrue(rule(value: Date()))
    }

    func testRequiredOnNilDate() {
        let rule = FormValidationRule<Date?>.required
        XCTAssertFalse(rule(value: nil))
    }

    func testEmptyOnSomeString() {
        let rule = FormValidationRule<String>.empty
        XCTAssertFalse(rule(value: "someString"))
    }

    func testEmptyOnEmptyString() {
        let rule = FormValidationRule<String>.empty
        XCTAssertTrue(rule(value: ""))
    }

    func testEmptyOnArrayContainingElements() {
        let rule = FormValidationRule<[Int]>.empty
        XCTAssertFalse(rule(value: [0, 1]))
    }

    func testEmptyOnEmptyArray() {
        let rule = FormValidationRule<[Int]>.empty
        XCTAssertTrue(rule(value: []))
    }

    func testEmptyOnSetContainingElements() {
        let rule = FormValidationRule<Set<Int>>.empty
        XCTAssertFalse(rule(value: [0, 1]))
    }

    func testEmptyOnEmptySet() {
        let rule = FormValidationRule<Set<Int>>.empty
        XCTAssertTrue(rule(value: []))
    }

    func testEmptyOnSomeDate() {
        let rule = FormValidationRule<Date?>.empty
        XCTAssertFalse(rule(value: Date()))
    }

    func testEmptyOnNilDate() {
        let rule = FormValidationRule<Date?>.empty
        XCTAssertTrue(rule(value: nil))
    }

    func testValidAddresses() {
        let rule = FormValidationRule.email
        XCTAssertTrue(rule(value: "email@example.com"))
        XCTAssertTrue(rule(value: "firstname.lastname@example.com"))
        XCTAssertTrue(rule(value: "email+service@example.com"))
        XCTAssertTrue(rule(value: "email@example.co.jp"))
        XCTAssertTrue(rule(value: "_______@example.com"))
        XCTAssertTrue(rule(value: "email@example.museum"))
        XCTAssertTrue(rule(value: "1234567890@example.com"))
    }

    func testInvalidAddresses() {
        let rule = FormValidationRule.email
        XCTAssertFalse(rule(value: "plainaddress"))
        XCTAssertFalse(rule(value: "#@%^%#$@#$@#.com"))
        XCTAssertFalse(rule(value: "@example.com"))
        XCTAssertFalse(rule(value: "Joe Smith <email@example.com>"))
        XCTAssertFalse(rule(value: "email.example.com"))
        XCTAssertFalse(rule(value: "email@example@example.com"))
        XCTAssertFalse(rule(value: "email@example.com (Joe Smith)"))
        XCTAssertFalse(rule(value: "email@example"))
    }
}
