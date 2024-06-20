import Foundation

extension Bundle {
    func path(forResource name: String, withExtension extensionName: String? = nil) -> String? {
        path(forResource: name, ofType: extensionName)
    }
}
