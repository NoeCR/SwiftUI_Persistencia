import Foundation
import Combine
import CoreLocation

class GasStationListViewModel: ObservableObject {
    private let getGasStations: GetGasStationsType
    private let idProvince: String
    private let idProduct: String
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var elements: [DomainGasStation] = []
    
    init(idProvince: String,
         idProduct: String,
         getGasStations: GetGasStationsType = GetGasStations()) {
        self.idProvince = idProvince
        self.idProduct = idProduct
        self.getGasStations = getGasStations
        
        let startDate = Date()
        
        self.getGasStations.execute(idProvince: idProvince, idProduct: idProduct)
            .sink(receiveCompletion: { _ in }) { [weak self] allGasStations in
                guard let self = self else { return }
                self.elements = allGasStations.sorted()
                let endDate = Date()
                
                let elapsedTime = fabs(endDate.timeIntervalSince(startDate))
                
                print("It took \(elapsedTime) seconds to process all the data")
            }
            .store(in: &cancellables)
    }
}
