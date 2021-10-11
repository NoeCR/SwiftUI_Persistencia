import Foundation
import Combine

protocol GasStationsLocalDataSourceType {
    func getCCAA() -> AnyPublisher<[CCAA], Error>
    func save(ccaaList: [CCAA]) -> AnyPublisher<[CCAA], Error>
    func deleteAllCCAAs() -> AnyPublisher<Int, Error>
    
    func getProvinces() -> AnyPublisher<[Province], Error>
    func save(provincesList: [Province]) -> AnyPublisher<[Province], Error>    
    func deleteAllProvinces() -> AnyPublisher<Int, Error>
}

struct GasStationsLocalDataSource {
    private let persistenceController: PersistenceControllerType
    
    init(persistenceController: PersistenceControllerType = PersistenceController.shared) {
        self.persistenceController = persistenceController
    }
}

extension GasStationsLocalDataSource: GasStationsLocalDataSourceType {
    func getCCAA() -> AnyPublisher<[CCAA], Error> {
        print("GasStationsLocalDataSource going to GET all CCAAs from local data source")
        return persistenceController.getCCAA()
    }
    
    func save(ccaaList: [CCAA]) -> AnyPublisher<[CCAA], Error> {
        print("GasStationsLocalDataSource going to SAVE \(ccaaList.count) CCAAs")
        return persistenceController.save(ccaaList: ccaaList)
    }
    
    func deleteAllCCAAs() -> AnyPublisher<Int, Error> {
        print("GasStationsLocalDataSource going to DELETE ALL CCAAs")
        return persistenceController.deleteAllCCAAs()
    }
    
    func getProvinces() -> AnyPublisher<[Province], Error> {
        print("GasStationsLocalDataSource going to GET all PROVINCES from local data source")
        return persistenceController.getProvinces()
    }
    
    func save(provincesList: [Province]) -> AnyPublisher<[Province], Error> {
        print("GasStationsLocalDataSource going to persist \(provincesList.count) elements")
        return persistenceController.save(provincesList: provincesList)
    }
    
    func deleteAllProvinces() -> AnyPublisher<Int, Error> {
        print("GasStationsLocalDataSource going to DELETE ALL PROVINCES")
        return persistenceController.deleteAllProvinces()
    }
}
