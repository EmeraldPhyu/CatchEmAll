//
//  CreaturesListView.swift
//  CatchEmAll
//
//  Created by Emerald on 26/11/24.
//

import SwiftUI

struct CreaturesListView: View {
	@State var creatures = Creatures()
	@State private var searchText = ""
	var body: some View {
		
		NavigationStack{
			
			ZStack {
				List(searchResults) { creature in
					LazyVStack {
						NavigationLink {
							CreatureDetailView(creature: creature)
						} label: {
							Text("\(returnIndex(of: creature)). \(creature.name.capitalized)")
								.font(.title2)
						}
					}
					.task { //This code handle the next page of JSON
						await creatures.loadNextIfNeeded(creature: creature)
					}
					
				}.listStyle(.plain)
					.navigationTitle("Pokemon")
					.toolbar{
						ToolbarItem(placement: .bottomBar) {
							Button ("Load All") {
								Task {
									await creatures.loadAll()
								}
							}
						}
						
						ToolbarItem(placement: .status) {
							Text("\(creatures.creaturesArray.count) of \(creatures.count) creatures")
						}
					}
					.navigationBarTitleDisplayMode(.inline)
					.background(.yellow)
					.searchable(text: $searchText)
				
				if creatures.isLoading {
					ProgressView()
						.tint(.yellow)
						.scaleEffect(2)
				}
			}
		}
		.task {
			await creatures.getData()
		}
	}
	
	var searchResults: [Creature] {
		if (searchText.isEmpty){
			return creatures.creaturesArray
		}else {
			return creatures.creaturesArray.filter {
				$0.name.capitalized.contains(searchText)
			}
		}
	}
	
	func returnIndex(of creature: Creature) -> Int{
		guard let index = creatures.creaturesArray.firstIndex(where: {$0.id == creature.id})
		else {return 0}
		return index + 1
	}
}

#Preview {
	CreaturesListView()
}
