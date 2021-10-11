import SwiftUI

struct GasStationsListView: View {
    @ObservedObject private var viewModel: GasStationListViewModel
    
    private let province: DomainProvince
    private let product: DomainProduct
    
    init(province: DomainProvince, product: DomainProduct) {
        self.province = province
        self.product = product
        self.viewModel = GasStationListViewModel(idProvince: province.id,
                                                 idProduct: product.id)
    }
    
    var body: some View {
        List(viewModel.elements) { currentGasStation in
            GasStationElementRow(elem: currentGasStation)
        }
    }
}

struct GasStationElementRow: View {
    var elem: DomainGasStation

    var body: some View {
        VStack {
            HStack {
                Text(elem.place)
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: .infinity)
                Text("\(elem.price)€")
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: .infinity)
                Spacer()
            }
            Text(elem.address)
                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: .infinity)
        }
    }
}
