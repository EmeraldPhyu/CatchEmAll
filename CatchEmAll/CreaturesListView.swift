//
//  ContentView.swift
//  CatchEmAll
//
//  Created by Emerald on 26/11/24.
//

import SwiftUI

struct CreaturesListView: View {
	var creatures = ["PIkachu", "Squirtle", "Charzard"]
    var body: some View {
			List(creatures, id: \.self) { creature in
				Text(creature)
			}.listStyle(.plain)
				.navigationTitle("Pokemon")
    }
}

#Preview {
    CreaturesListView()
}
