//
//  ViewController.swift
//  Day01_create_write
//
//  Created by xiaozao on 2019/4/2.
//  Copyright © 2019 Tony. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let viewModel = ViewModel()
    let tableViewModel = TableViewModel()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.modelDelegate = self
        tableViewModel.delegate = self
        /// 增加右上角add按钮
        viewModel.bindBarButtonItem(navigationItem)
        /// bind一下tableView
        tableViewModel.bindTable(tableView)
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension ViewController: ViewModelDelegate {
    
    /// 增加model
    func addModel(_ color: UIColor, date: Date) {
        // 点击了add增加按钮
        ModelDB.default.container.viewContext.perform {
            let _ = ModelDB.default.insert(color, time: date)
            try! ModelDB.default.container.viewContext.save()
        }
    }
}

extension ViewController: TableViewModelDelegate {
    
    /// tableView 显示某一行
    func showRow(cell: CellDelegate, color: UIColor?, date: Date?) {
        guard let color = color, let date = date else { return }
        cell.setModel(color, date: date)
    }
    
    /// tableView 点击某一行
    func selectRow(_ color: UIColor?, date: Date?) {
        Log(date ?? "")
    }
    
}
