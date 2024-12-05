//
//  Creature.swift
//  CatchEmAll
//
//  Created by Emerald on 27/11/24.
//

import Foundation

struct Creature: Codable, Identifiable{
	let id = UUID().uuidString
	var name : String
	var url: String //URL for detail pokemon
	
	enum CodingKeys: CodingKey { //ignore the ID property when decoding
		case name
		case url
	}
}
