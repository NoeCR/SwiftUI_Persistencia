import Foundation
import Combine

protocol GetProvincesUseCaseType {
    func execute() -> AnyPublisher<[DomainProvince], Error>
}

struct GetProvincesUseCase: GetProvincesUseCaseType {
    private let gasStationsRepository: GasStationsRepositoryType
    
    init(gasStationsRepository: GasStationsRepositoryType = GasStationsRepository()) {
        self.gasStationsRepository = gasStationsRepository
    }
    
    func execute() -> AnyPublisher<[DomainProvince], Error> {
        print("GetProvincesUseCase going to retrieve provinces")
        return gasStationsRepository.getProvinces()
    }
}
