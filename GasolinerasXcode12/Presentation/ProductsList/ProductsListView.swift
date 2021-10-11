import SwiftUI
import Combine

struct ProductsListView: View {
    @ObservedObject private var viewModel = ProductListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.elements) { currentProduct in
                ProductElementRow(elem: currentProduct)
            }
            .navigationTitle("product_title")
        }
    }
}

struct ProductElementRow: View {
    var elem: DomainProduct

    var body: some View {
        HStack {
            Text(elem.name)
                .frame(maxWidth: .infinity, minHeight: 80, maxHeight: .infinity)
            Spacer()
        }
    }
}
