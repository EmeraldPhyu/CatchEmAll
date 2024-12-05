//
//  CreatureDetailView.swift
//  CatchEmAll
//
//  Created by Emerald on 27/11/24.
//

import SwiftUI

struct CreatureDetailView: View {
	
	let creature: Creature
	@State private var creatureDetail = CreatureDetail()
	
	var body: some View {
		VStack (alignment: .leading, spacing: 0){
			Text(creature.name.capitalized)
				.font(Font.custom("Avenir Next Condensed", size: 60))
				.bold()
				.minimumScaleFactor(0.5)
				.lineLimit(1)
			
			Rectangle()
				.frame(height: 1)
				.foregroundStyle(.gray)
				.padding(.bottom)
			
			HStack{
				
			 CreatureImage
				
				VStack (alignment: .leading){
					HStack (alignment: .top) {
						Text("Height:")
							.font(.title2)
							.bold()
							.foregroundStyle(.red)
						
						Text(String(format: "%.1f", creatureDetail.height))
							.font(.largeTitle)
							.bold()
					}
					HStack (alignment: .top) {
						Text("Weight:")
							.font(.title2)
							.bold()
							.foregroundStyle(.red)
						
						Text(String(format: "%.1f", creatureDetail.weight))
							.font(.largeTitle)
							.bold()
					}
				}
				
			}
//TODO: Phase 2 to add in more details of pokemon
//			HStack (alignment: .top) {
//				Text("Type: ")
//					.font(.caption)
//					.foregroundStyle(.red)
//				
//				Text(String(format: "%.1f", creatureDetail.type))
//					.font(.caption)
//					.bold()
//			}
			
//			HStack (alignment: .top) {
//				Text("Base Experience: ")
//					.font(.caption)
//					.foregroundStyle(.red)
//				
//				Text(String(format: "%.1f", creatureDetail.baseExperience))
//					.font(.caption)
//					.bold()
//			}
			Spacer()
			
		}.padding()
			.task {
				creatureDetail.urlString = creature.url //use URL passed over in
				await creatureDetail.getData()
			}
			.background(.yellow)
	}
}

extension CreatureDetailView {
	var CreatureImage: some View {
		AsyncImage(url: URL(string: creatureDetail.imageURL)) { phase in
			
			if let image = phase.image { // valid image
				
				image
					.resizable()
					.scaledToFit()
					.background(.white)
					.frame(width: 96,height: 96)
					.clipShape(RoundedRectangle(cornerRadius: 16))
					.shadow(radius: 8,x: 5, y: 5)
					.overlay {
						RoundedRectangle(cornerRadius: 16)
							.stroke(.gray.opacity(0.5), lineWidth: 1)
					}
				
			}else if phase.error != nil { // error
				
				Image(systemName: "questionmark.square.dashed")
					.resizable()
					.scaledToFit()
					.background(.white)
					.frame(width: 96,height: 96)
					.clipShape(RoundedRectangle(cornerRadius: 16))
					.shadow(radius: 8,x: 5, y: 5)
					.overlay {
						RoundedRectangle(cornerRadius: 16)
							.stroke(.gray.opacity(0.5), lineWidth: 1)
					}
				
			}else { // place holder
				
				ProgressView()
					.tint(.yellow)
					.scaleEffect(2)
				
//				Default place holder below
//				RoundedRectangle(cornerRadius: 10)
//					.foregroundStyle(.clear)
			}
			
		}.padding(.trailing)
			.frame(width: 96, height: 96)
		
	}
}

#Preview {
	CreatureDetailView(creature: Creature(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
}
