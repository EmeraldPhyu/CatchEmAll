//
//  CreatureDetail.swift
//  CatchEmAll
//
//  Created by Emerald on 27/11/24.
//

import Foundation


@Observable //Will watch objects for changes so that SwiftUI will redraw the interface when needed
class CreatureDetail {
	
	private struct Returned: Codable {
		var height: Double
		var weight: Double
		var base_experience: Double
		var sprites: Sprite
//		var types: CreatureTypes
	}
	
	struct Sprite: Codable {
		var other: Other
	}
	struct Other: Codable {
		var  officialArtwork : OfficialArtwork
		enum CodingKeys: String, CodingKey {
			case officialArtwork = "official-artwork"
		}
	}
	struct OfficialArtwork: Codable{
		var front_default: String? //This might return null
	}
	
//	struct CreatureTypes: Codable {
//		var creatureType: CreatureType
//		enum CodingKeys: String, CodingKey {
//			case creatureType = "type"
//		}
//	}
//	struct CreatureType: Codable {
//		var name: String?
//		var url: String?
//	}
	
	var urlString = ""
	var height = 0.0
	var weight = 0.0
	var baseExperience = 0.0
	var imageURL = ""
	var creatureTypes = ""

	func getData() async {
		print("We are accessing the url\(urlString)")
		
		//create a URL
		guard let url = URL(string: urlString) else {
			print("Error: could not create a URL from \(urlString)")
			return
		}
		
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			//Try to decode JSON data into our own data structures
			guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
				print("Error: could not decode returned JSON data")
				return
			}
			self.height = returned.height
			self.weight = returned.weight
			self.baseExperience = returned.base_experience
			self.imageURL = returned.sprites.other.officialArtwork.front_default ?? "n/a"
//			self.creatureTypes = returned.types.creatureType.name ?? "n/a"
			
		}catch{
			print("Error: could not get data from URLString: \(urlString)")
		}
	}
}
