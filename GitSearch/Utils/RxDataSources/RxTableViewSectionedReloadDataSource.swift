import UIKit
import RxSwift
import RxCocoa

class RxTableViewSectionedReloadDataSource<Section: SectionModelType>
: TableViewSectionedDataSource<Section>
, RxTableViewDataSourceType {

    public typealias Element = [Section]

    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
#if DEBUG
            dataSource._dataSourceBound = true
#endif
            dataSource.setSections(element)
            tableView.reloadData()
        }.on(observedEvent)
    }
}
