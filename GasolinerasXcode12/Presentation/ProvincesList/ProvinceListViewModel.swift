import Foundation
import Combine
import CoreLocation

class ProvinceListViewModel: ObservableObject {
    private let getProvincesUseCase: GetProvincesUseCaseType
    
    private var cancellables = Set<AnyCancellable>()
    
    // 2. Receive, store and relay all provinces retrieved
    @Published var elements: [DomainProvince] = []
    
    init(getProvincesUseCase: GetProvincesUseCaseType = GetProvincesUseCase()) {
        print("init ProvinceListViewModel")
        self.getProvincesUseCase = getProvincesUseCase
        
        self.getProvincesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { completionResult in
                switch completionResult {
                case let .failure(error):
                    print("F: \(error)")
                case .finished:
                    print("Todo OK")
                }
            } receiveValue: { [weak self] allProvinces in
                guard let self = self else { return }
                print("We received \(allProvinces.count) elements!")
                self.elements = allProvinces
            }
            .store(in: &cancellables)
    }
}
