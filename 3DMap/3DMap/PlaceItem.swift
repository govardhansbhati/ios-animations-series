
import Foundation

struct PlaceItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
}

let mockPlaces = [
    PlaceItem(name: "Shaniwar Wada", description: "Historical fortification of the Peshwa.", imageName: "building.columns"),
    PlaceItem(name: "Aga Khan Palace", description: "Memorial to Mahatma Gandhi.", imageName: "building.2"),
    PlaceItem(name: "Sinhagad Fort", description: "Hill fortress with panoramic views.", imageName: "mountain.2"),
    PlaceItem(name: "Dagdusheth Halwai", description: "Famous Ganpati Temple.", imageName: "star"),
    PlaceItem(name: "Phoenix Marketcity", description: "Premier shopping destination.", imageName: "bag"),
    PlaceItem(name: "Osho Garden", description: "Serene meditation park.", imageName: "leaf")
]
