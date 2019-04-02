//
//  TableViewModel.swift
//  Day01_create_write
//
//  Created by xiaozao on 2019/4/2.
//  Copyright © 2019 Tony. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol CellDelegate {
    func setModel(_ color: UIColor, date: Date)
    static var name: String {get}
}

protocol TableViewModelDelegate: class {
    func showRow(cell: CellDelegate, color: UIColor?, date: Date?)
    func selectRow(_ color: UIColor?, date: Date?)
}

class TableViewModel: NSObject {
    
    weak var delegate: TableViewModelDelegate?
    var tableView: UITableView?
    
    lazy var dataSource: NSFetchedResultsController<TimeColorModel> = {
        let request = TimeColorModel.sortedFetchRequest
        request.fetchBatchSize = 10
        request.returnsObjectsAsFaults = false
        let fetchResult = NSFetchedResultsController(fetchRequest: request, managedObjectContext: ModelDB.default.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResult.delegate = self
        return fetchResult
    }()
    
    func bindTable(_ table: UITableView) {
        tableView = table
        table.delegate = self
        table.dataSource = self
        table.register(TimeTableViewCell.self, forCellReuseIdentifier: TimeTableViewCell.name)
        try! dataSource.performFetch()
        tableView?.reloadData()
    }
    
    
}

extension TableViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = dataSource.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableViewCell.name) as! TimeTableViewCell
        let element = dataSource.object(at: indexPath)
        delegate?.showRow(cell: cell, color: element.color, date: element.time)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let element = dataSource.object(at: indexPath)
        delegate?.selectRow(element.color, date: element.time)
    }
}

extension TableViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView?.insertRows(at: [newIndexPath!], with: UITableView.RowAnimation.bottom)
        case .update:
            ()
        case .move:
            ()
        case .delete:
            print("delete")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}
