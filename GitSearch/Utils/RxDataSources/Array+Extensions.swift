#if os(iOS) || os(tvOS)
import Foundation

extension Array where Element: SectionModelType {
    mutating func moveFromSourceIndexPath(_ sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        let sourceSection = self[sourceIndexPath.section]
        var sourceItems = sourceSection.items

        let sourceItem = sourceItems.remove(at: sourceIndexPath.item)

        let sourceSectionNew = Element(original: sourceSection, items: sourceItems)
        self[sourceIndexPath.section] = sourceSectionNew

        let destinationSection = self[destinationIndexPath.section]
        var destinationItems = destinationSection.items
        destinationItems.insert(sourceItem, at: destinationIndexPath.item)

        self[destinationIndexPath.section] = Element(original: destinationSection, items: destinationItems)
    }
}
#endif
