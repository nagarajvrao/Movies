import Foundation
extension String {
    var removingExtension: String {
        split(separator: ".").first?.description ?? self
    }
}
