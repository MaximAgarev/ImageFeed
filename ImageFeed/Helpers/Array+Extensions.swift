import Foundation

extension Array {
    func withReplaced(itemAt: Int, newValue: Element) -> [Element] {
        var newArray = self
        newArray[itemAt] = newValue
        return newArray
    }
}
