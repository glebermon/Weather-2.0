//
//  TableView.swift
//  Clima
//
//  Created by Глеб on 18.11.2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

protocol TableViewDelegate : class {
    
    func didSelectItem(item: Int)
    
    func deleteRowAtIndexPath(indexPath : IndexPath)
    
}

class TableView : UITableView {
    
    var tableDelegate : TableViewDelegate?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseId)
        delegate = self
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseId)
    }
    
}

extension TableView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableDelegate?.didSelectItem(item: indexPath.row)
//        print("от туда. Как надо")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isUserInteractionEnabled = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.tableDelegate?.deleteRowAtIndexPath(indexPath: indexPath)
        }

        let share = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
            
        }

        share.backgroundColor = UIColor.blue

        return [delete, share]
    }
}
