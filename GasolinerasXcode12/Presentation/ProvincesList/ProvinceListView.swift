import SwiftUI

// 1. View recalculates body
// 2. ViewModel gets data into its @Published variable
// 3. UseCase goes out looking for the needed data
// 4. Repository looks for needed data in local data source + API data source

struct ProvinceListView: View {
    @ObservedObject private var viewModel = ProvinceListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.elements) { currentProvince in
                ProvinceElementRow(elem: currentProvince)
            }
        }
    }
}

struct ProvinceElementRow: View {
    var elem: DomainProvince

    var body: some View {
        HStack {
            Text(elem.name)
                .frame(maxWidth: .infinity, minHeight: 80, maxHeight: .infinity)
            Spacer()
        }
    }
}
