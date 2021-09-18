//
//  RepositorySearchTableViewCell.swift
//  RepositorySearchTableViewCell
//
//  Created by Valeriy Malishevskyi on 16.09.2021.
//

import UIKit

class RepositorySearchTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(title: String, stars: String, isWatched: Bool) {
        titleLabel.text = title
        starsLabel.text = stars
        titleLabel.textColor = isWatched ? .gray : .label
    }

    static func dequeueReusableCell(from table: UITableView, for indexPath: IndexPath) -> Self {
        table.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! Self
    }

    static func register(with tableView: UITableView) {
        tableView.register(UINib(nibName: "RepositorySearchTableViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
    }
}

extension RepositorySearchTableViewCell {
    func configure(withSearchResultItem item: SearchResultItem) {
        configure(title: item.title, stars: "\(item.stars)", isWatched: item.isWatched)
    }
}
