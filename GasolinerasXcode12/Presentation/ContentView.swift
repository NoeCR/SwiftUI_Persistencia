import Foundation
import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ContentViewModel()
    
    private let selectedProvince = DomainProvince(id: "10", name: "CAceres")
    private let selectedProduct = DomainProduct(id: "1", name: "Gasolina 95 E5", shortName: "G95E5")
    
    private var ccaaTitleText: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Regions")) {
                    NavigationLink(destination: CCAAListView()) {
                        Text(ccaaTitleText)
                    }
                    NavigationLink(destination: ProvinceListView()) {
                        Text("Provinces")
                    }
                }

                Section(header: Text("Product")) {
                    NavigationLink(destination: ProductsListView()) {
                        Text("Choose product")
                    }
                    
                }
                
                Section(header: Text("Go")) {
                    NavigationLink(destination: GasStationsListView(province: selectedProvince, product: selectedProduct)) {
                        Text("Choose product")
                    }
                }
            }
        }
    }
}
