//
//  CoreDataModel.swift
//  Day01_create_write
//
//  Created by xiaozao on 2019/4/2.
//  Copyright © 2019 Tony. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var formate: DateFormatter = {
    let formate = DateFormatter.init()
    formate.dateFormat = "MM:dd HH:mm:ss"
    return formate
}()

func Log(_ info: Any, _ funcName: String = #function, _ file: String = #file, _ line: Int = #line) {
    guard let last = file.split(separator: "/").last?.description else { return }
    debugPrint("\(formate.string(from: Date()))" + " " + last + " " + funcName + " " + "\(line)" + ": " + "\(info)")
}

class ModelDB {
    static let `default` = ModelDB()
    let container: NSPersistentContainer
    init() {
        container = NSPersistentContainer(name: "CellModel")
    }
    func createDB(_ completion: @escaping (NSPersistentContainer) -> ()) {
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                Log(error.debugDescription)
                fatalError()
            }
            DispatchQueue.main.async {
                Log("success")
                completion(self.container)
            }
        }
    }
    
    func insert(_ color: UIColor, time: Date) -> TimeColorModel {
        let k_model: TimeColorModel = container.viewContext.insertObject()
        k_model.color = color
        k_model.time = time
        return k_model
    }
}

@objc(TimeColorModel)
final public class TimeColorModel: NSManagedObject {
    
    @NSManaged public var color: UIColor?
    @NSManaged public var time: Date?
    
    static func insert(_ manager: NSManagedObjectContext, color: UIColor, time: Date) -> TimeColorModel {
        return manager.insertObject() as TimeColorModel
    }
}

extension TimeColorModel: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(time), ascending: false)]
    }
}

extension Managed {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let requet = NSFetchRequest<Self>(entityName: entityName)
        requet.sortDescriptors = defaultSortDescriptors
        return requet
    }
}

extension Managed where Self: NSManagedObject {
    static var entityName: String { return entity().name! }
}


protocol Managed: class, NSFetchRequestResult {
    static var entityName: String {get}
    static var defaultSortDescriptors: [NSSortDescriptor] {get}
}

extension NSManagedObjectContext {
    
    func insertObject<T>() -> T where T: Managed {
        guard let objc = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T else {
            fatalError("Insert Object Error")
        }
        return objc
    }
}
