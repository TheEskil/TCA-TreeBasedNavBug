//
//  FirstReducer.swift
//  TCA-TreeBasedNavBug
//
//  Created by Eskil Aronsen on 9/26/23.
//

import ComposableArchitecture
import SwiftUI

struct FirstReducer: Reducer {
    struct State: Equatable {
        @PresentationState public var destination: Destination.State?
    }

    enum Action: Equatable {
        case secondTapped
        case destination(PresentationAction<Destination.Action>)
    }

    public struct Destination: Reducer {
        public enum State: Equatable {
            case second(SecondReducer.State)
        }

        public enum Action: Equatable {
            case second(SecondReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: /State.second, action: /Action.second) {
                SecondReducer()
            }
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .secondTapped:
                state.destination = .second(SecondReducer.State())

                return .none

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}

struct FirstView: View {
    let store: StoreOf<FirstReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button(
                action: {
                    viewStore.send(.secondTapped)
                },
                label: {
                    Text("Go to Second")
                }
            )
            .navigationTitle("First")
            .navigationDestination(
                store: store.scope(state: \.$destination, action: { .destination($0) }),
                state: /FirstReducer.Destination.State.second,
                action: FirstReducer.Destination.Action.second
            ) { store in
                SecondView(store: store)
            }
        }
    }
}
