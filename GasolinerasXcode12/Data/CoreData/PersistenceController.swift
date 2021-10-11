import Foundation
import CoreData
import Combine

protocol PersistenceControllerType {
    func getCCAA() -> AnyPublisher<[CCAA], Error>
    func save(ccaaList: [CCAA]) -> AnyPublisher<[CCAA], Error>
    func deleteAllCCAAs() -> AnyPublisher<Int, Error>
    
    func getProvinces() -> AnyPublisher<[Province], Error>
    func save(provincesList: [Province]) -> AnyPublisher<[Province], Error>
    func deleteAllProvinces() -> AnyPublisher<Int, Error>
}

struct PersistenceController {
    static let shared = PersistenceController()
    
    private let container: NSPersistentContainer
    
    var mainMOC: NSManagedObjectContext {
        let context = container.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // Helper background MOC, not used anywhere in this code!!
//    var backgroundContext: NSManagedObjectContext {
//        let newbackgroundContext = container.newBackgroundContext()
//        newbackgroundContext.automaticallyMergesChangesFromParent = true
//        newbackgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        return newbackgroundContext
//    }
    
    init() {
        container = NSPersistentContainer(name: "Gasolineras")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("There was an error initializing CoreData: \(error)")
            }
        }
    }
}

/// ----->                       ------>
///     ----------------->
///

extension PersistenceController: PersistenceControllerType {
    func getCCAA() -> AnyPublisher<[CCAA], Error> {
        return Future<[CCAA], Error>() { promise in
            container.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<CDCCAA> = CDCCAA.fetchRequest()
                fetchRequest.predicate = nil
                
                var result: [CDCCAA]?
                do {
                    result = try context.fetch(fetchRequest)
                } catch {
                    promise(Result.failure(error))
                }
                
                if let result = result {
                    let convertedResult = result.map { CCAA(cdCCAA: $0) }
                    promise(Result.success(convertedResult))
                } else {
                    promise(Result.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(ccaaList: [CCAA]) -> AnyPublisher<[CCAA], Error> {
        return Future<[CCAA], Error>() { promise in
            container.performBackgroundTask { context in
                ccaaList.forEach { currentCCAA in
                    let newCCAAEntry = CDCCAA(context: context)
                    newCCAAEntry.ccaaName = currentCCAA.ccaaName
                    newCCAAEntry.idCCAA = currentCCAA.idCCAA
                }
                
                do {
                    try context.save()
                    promise(.success(ccaaList))
                } catch {
                    print("There was an error saving \(ccaaList.count) CCAAs in batch: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteCCAAs(with ccaaNames: [String]) -> AnyPublisher<Int, Error> {
        return Future<Int, Error>() { promise in
            container.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCCAA.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "self.ccaaName in %@", ccaaNames)
                
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                
                var deleteResult: NSBatchDeleteResult?
                do {
                    deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
                } catch {
                    print("There was an error deleting all CCAAs in batch: \(error)")
                    promise(.failure(error))
                }
                
                if let deleteResult = deleteResult?.result as? [NSManagedObjectID] {
                    promise(.success(deleteResult.count))
                } else {
                    promise(.failure(APIError.invalidData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func deleteAllCCAAs() -> AnyPublisher<Int, Error> {
        return Future<Int, Error>() { promise in
            container.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCCAA.fetchRequest()
                fetchRequest.predicate = nil
                
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                
                var deleteResult: NSBatchDeleteResult?
                do {
                    deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
                } catch {
                    print("There was an error deleting all CCAAs in batch: \(error)")
                    promise(.failure(error))
                }
                
                if let deleteResult = deleteResult?.result as? [NSManagedObjectID] {
                    promise(.success(deleteResult.count))
                } else {
                    promise(.failure(APIError.invalidData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getProvinces() -> AnyPublisher<[Province], Error> {
        return Future<[Province], Error>() { promise in
            container.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<CDProvince> = CDProvince.fetchRequest()
                fetchRequest.predicate = nil
                
                var result: [CDProvince]?
                do {
                    result = try context.fetch(fetchRequest)
                } catch {
                    promise(Result.failure(error))
                }
                
                if let result = result {
                    let convertedResult = result.map { Province(cdProvince: $0) }
                    promise(.success(convertedResult))
                } else {
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func save(provincesList: [Province]) -> AnyPublisher<[Province], Error> {
        Future { promise in
            container.performBackgroundTask { context in
                
                var indexedEntries: [String: [CDProvince]] = [:]
                
                provincesList.forEach { currentProvince in
                    
                    let newEntry = CDProvince(context: context)
                    newEntry.provinceName = currentProvince.provinceName
                    newEntry.idProvince = currentProvince.idProvince
                    
                    if let existingProvinces = indexedEntries[currentProvince.idCCAA] {
                        indexedEntries[currentProvince.idCCAA] = existingProvinces + [newEntry]
                    } else {
                        indexedEntries[currentProvince.idCCAA] = [newEntry]
                    }
                }
                
                indexedEntries.forEach { (key: String, value: [CDProvince]) in
                    self.addProvinces(value, idCCAA: key, context: context)
                }
                
                do {
                    try context.save()
                    promise(.success(provincesList))
                } catch {
                    print("Something went wrong: \(error)")
                    promise(.failure(error))
                    context.rollback()
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func addProvinces(_ provinces: [CDProvince],
                              idCCAA: String,
                              context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<CDCCAA> = CDCCAA.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "self.idCCAA like %@", idCCAA)
        
        var result: [CDCCAA]?
        do {
            result = try context.fetch(fetchRequest)
        } catch {
            print("There was an error adding provinces list to existing CCAA")
        }
        
        if let result = result?.first {
            result.addToContains(NSSet.init(array: provinces))
            print("We just added \(provinces.count) CDProvinces to \(result.ccaaName ?? "NO CCAA name")")
        }
    }
    
    func deleteAllProvinces() -> AnyPublisher<Int, Error> {
        return Future<Int, Error>() { promise in
            container.performBackgroundTask { context in
                
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDProvince.fetchRequest()
                fetchRequest.predicate = nil
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                
                var deleteResult: NSBatchDeleteResult?
                do {
                    deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
                } catch {
                    print("There was an error deleting all CCAAs in batch: \(error)")
                    promise(.failure(error))
                }
                
                if let deleteResult = deleteResult?.result as? [NSManagedObjectID] {
                    promise(.success(deleteResult.count))
                } else {
                    promise(.failure(APIError.invalidData))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
