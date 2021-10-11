import Foundation
import CoreLocation

struct GasStation: Decodable {
    let address: String
    let place: String
    let coordinates: CLLocationCoordinate2D
    let timetable: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case address = "Dirección"
        case timetable = "Horario"
        case latitude = "Latitud"
        case longitude = "Longitud (WGS84)"
        case price = "PrecioProducto"
        case place = "Localidad"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        address = try values.decode(String.self, forKey: .address)
        place = try values.decode(String.self, forKey: .place)
        timetable = try values.decode(String.self, forKey: .timetable)
        
        let lat = try values.decode(String.self, forKey: .latitude).replacingOccurrences(of: ",", with: ".")
        let lon = try values.decode(String.self, forKey: .longitude).replacingOccurrences(of: ",", with: ".")
        
        let latDouble = Double(lat)!
        let lonDouble = Double(lon)!
        coordinates = CLLocationCoordinate2D(latitude: latDouble, longitude: lonDouble)
        
        let priceString = try values.decode(String.self, forKey: .price).replacingOccurrences(of: ",", with: ".")
        price = Double(priceString)!
        
    }
}

extension GasStation: Identifiable {
    var id: UUID {
        return UUID()
    }
}
