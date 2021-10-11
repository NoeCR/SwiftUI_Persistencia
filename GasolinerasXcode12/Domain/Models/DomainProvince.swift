import Foundation

struct DomainProvince: Identifiable {
    let id: String
    let name: String
}

extension DomainProvince {
    init(province: Province) {
        self.id = province.idProvince
        self.name = province.provinceName
    }
}
