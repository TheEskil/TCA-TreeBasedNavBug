//
//  ThirdReducer.swift
//  TCA-TreeBasedNavBug
//
//  Created by Eskil Aronsen on 9/26/23.
//

import ComposableArchitecture
import SwiftUI

struct ThirdReducer: Reducer {
    struct State: Equatable {}

    enum Action: Equatable {}

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {}
        }
    }
}

struct ThirdView: View {
    let store: StoreOf<ThirdReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("🎉")
                .navigationTitle("Third")
        }
    }
}
