//
//  Quickly
//

import XCTest
import Quickly

class QuicklyJsonTests: XCTestCase {

    private func fakeJson() -> QJson {
        return QJson(root: [
            "bool": true,
            "int": "1",
            "uint": "1",
            "float": "1.9",
            "double": "1.9",
            "numberString": "1",
            "string": "test",
            "date": "183548353",
            "color_gg": "#aa",
            "color_rgb": "#4da",
            "color_rrggbb": "#40d0a0",
            "color_rrggbbaa": "#40d0a070"
       ])
    }

    func testDebugJson() {
        let json = self.fakeJson()
        print(json.debugString())
    }

    func testSimpleGetJson() {
        let json = self.fakeJson()
        XCTAssert(try json.boolean(at: "bool") == true)
        XCTAssert(try json.int(at: "int") == 1)
        XCTAssert(try json.uint(at: "uint") == 1)
        XCTAssert(try json.float(at: "float") == 1.9)
        XCTAssert(try json.double(at: "double") == 1.9)
        XCTAssert(try json.uint(at: "numberString") == 1)
        XCTAssert(try json.string(at: "string") == "test")
        XCTAssert(try json.date(at: "date") == Date(timeIntervalSince1970: 183548353))
        XCTAssert(try json.color(at: "color_gg") == QPlatformColor(hex: 0xaaaaaaff))
        XCTAssert(try json.color(at: "color_rgb") == QPlatformColor(hex: 0x44ddaaff))
        XCTAssert(try json.color(at: "color_rrggbb") == QPlatformColor(hex: 0x40d0a0ff))
        XCTAssert(try json.color(at: "color_rrggbbaa") == QPlatformColor(hex: 0x40d0a070))
    }

    func testSimpleOperatorGetJson() throws {
        let json = self.fakeJson()

        var existReguiredBool = false
        try existReguiredBool <<< (json, "bool")
        XCTAssert(existReguiredBool == true)

        var existOptionalBool: Bool?
        existOptionalBool <<< (json, "bool")
        let value = existOptionalBool {
            XCTAssert(value == true)
        } else {
            XCTFail("")
        }

        var notFoundReguiredBool = false
        do {
            try notFoundReguiredBool <<< (json, "not_found")
        } catch let error as NSError {
            XCTAssert(error.domain == QJsonErrorDomain)
        }

        var notFoundOptionalBool: Bool?
        notFoundOptionalBool <<< (json, "not_found")
        XCTAssert(notFoundOptionalBool == nil)

        var dict: [String: String] = [:]
        dict <<< json
    }

    func testSimpleSetJson() {
        let json = QJson()
        "USD" >>> (json, "RUR")

        var existReguiredString = ""
        do {
            try existReguiredString <<< (json, "RUR")
            XCTAssert(existReguiredString == "USD")
        } catch let error {
            XCTFail("")
        }
    }
    
}
