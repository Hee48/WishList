

import Foundation

struct WishListModel: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let brand: String
    let category: String
    let thumbnail: URL
    
}
