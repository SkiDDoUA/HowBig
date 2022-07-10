import Foundation

// MARK: - Dog
struct Dog: Codable {
    let weight, height: Eight
    let id: Int
    let name: String
    let bredFor: String?
    let breedGroup: BreedGroup?
    let lifeSpan: String
    let temperament, origin: String?
    let referenceImageID: String
    let image: Image
    let countryCode: CountryCode?
    let dogDescription, history: String?

    enum CodingKeys: String, CodingKey {
        case weight, height, id, name
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
        case lifeSpan = "life_span"
        case temperament, origin
        case referenceImageID = "reference_image_id"
        case image
        case countryCode = "country_code"
        case dogDescription = "description"
        case history
    }
}

enum BreedGroup: String, Codable {
    case empty = ""
    case herding = "Herding"
    case hound = "Hound"
    case mixed = "Mixed"
    case nonSporting = "Non-Sporting"
    case sporting = "Sporting"
    case terrier = "Terrier"
    case toy = "Toy"
    case working = "Working"
}

enum CountryCode: String, Codable {
    case ag = "AG"
    case au = "AU"
    case us = "US"
}

// MARK: - Eight
struct Eight: Codable {
    let imperial, metric: String
}

// MARK: - Image
struct Image: Codable {
    let id: String
    let width, height: Int
    let url: String
}
