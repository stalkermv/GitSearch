//
//  HistoryTableViewCell.swift
//  GitSearch
//
//  Created by Valeriy Malishevskyi on 18.09.2021.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(title: String, time: String) {
        repositoryNameLabel.text = title
        openTimeLabel.text = time
    }

    static func dequeueReusableCell(from table: UITableView, for indexPath: IndexPath) -> Self {
        table.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! Self
    }

    static func register(with tableView: UITableView) {
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "historyCell")
    }
}

extension HistoryTableViewCell {
    func configure(withSearchResultItem item: HistoryItem) {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated

        let relativeDate = formatter.localizedString(for: item.openTime, relativeTo: Date())

        configure(title: item.repoName, time: relativeDate)
    }
}
