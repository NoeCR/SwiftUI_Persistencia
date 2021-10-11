import Foundation
import Combine
import CoreLocation
import SwiftUI

class ContentViewModel: ObservableObject {
    private let getCCAAUseCase: GetCCAAUseCaseType
    private let getProvincesUseCase: GetProvincesUseCaseType
    
    private var cancellables = Set<AnyCancellable>()
    
//    @Binding var selectedCCAA: DomainCCAA?
//    @Binding var selectedProvince: DomainProvince?
//    @Binding var selectedProduct: DomainProduct?
//    
    init(getCCAAUseCase: GetCCAAUseCaseType = GetCCAAUseCase(),
         getProvincesUseCase: GetProvincesUseCaseType = GetProvincesUseCase()) {
        self.getCCAAUseCase = getCCAAUseCase
        self.getProvincesUseCase = getProvincesUseCase
    }
}
