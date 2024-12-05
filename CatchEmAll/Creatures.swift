//
//  Creatures.swift
//  CatchEmAll
//
//  Created by Emerald on 27/11/24.
//

import Foundation

@Observable //Will watch objects for changes so that SwiftUI will redraw the interface when needed
class Creatures {
	
	private struct Returned: Codable {
		var count: Int
		var next: String?
		var results: [Creature]
	}
	
	var urlString = "https://pokeapi.co/api/v2/pokemon"
	var count = 0
	var creaturesArray: [Creature] = []
	var isLoading = false
	
	func getData() async {
		print("We are accessing the url: \(urlString)")
		isLoading = true
		
		//create a URL
		guard let url = URL(string: urlString) else {
			print("Error: could not create a URL from \(urlString)")
			isLoading = false
			return
		}
		
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			//Try to decode JSON data into our own data structures
			guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
				print("Error: could not decode returned JSON data")
				isLoading = false
				return
			}
			//Forcing UIRelated data inside mainThread
			Task { @MainActor in
				self.count = returned.count
				self.urlString = returned.next ?? ""
				self.creaturesArray = self.creaturesArray + returned.results
				isLoading = false
			}
		}catch{
			print("Error: could not get data from URLString: \(urlString)")
			isLoading = false
		}
	}
	
	//recursion
	func loadAll() async {
		Task {@MainActor in
			guard urlString.hasPrefix("http") else {return}
			
			await getData() //get nextPage of Data
			await loadAll() //call loadAll again - will stop when all pages are retrieved
		}
	}
	
	func loadNextIfNeeded(creature: Creature) async {
		guard let lastCreature = creaturesArray.last else {return}
		if creature.id == lastCreature.id &&
				urlString.hasPrefix("http"){
			await getData()
		}
	}
}
