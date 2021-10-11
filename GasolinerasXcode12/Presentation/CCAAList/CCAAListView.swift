import SwiftUI

struct CCAAListView: View {
    @ObservedObject private var viewModel = CCAAListViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(viewModel.elements) { currentCCAA in
                CCAAElementRow(elem: currentCCAA).onTapGesture {                    
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("Comunidades Autónomas")
    }
}

struct CCAAElementRow: View {
    var elem: DomainCCAA

    var body: some View {
        HStack {
            Text(elem.name)
                .frame(maxWidth: .infinity, minHeight: 80, maxHeight: .infinity)
            Spacer()
        }
    }
}
