//
//  SecondReducer.swift
//  TCA-TreeBasedNavBug
//
//  Created by Eskil Aronsen on 9/26/23.
//

import ComposableArchitecture
import SwiftUI

struct SecondReducer: Reducer {
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
    }

    enum Action: Equatable {
        case thirdTapped
        case destination(PresentationAction<Destination.Action>)
    }

    public struct Destination: Reducer {
        public enum State: Equatable {
            case third(ThirdReducer.State)
        }

        public enum Action: Equatable {
            case third(ThirdReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: /State.third, action: /Action.third) {
                ThirdReducer()
            }
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .thirdTapped:
                state.destination = .third(ThirdReducer.State())

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

struct SecondView: View {
    let store: StoreOf<SecondReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button(
                action: {
                    viewStore.send(.thirdTapped)
                },
                label: {
                    Text("Go to Third")
                }
            )
            .navigationTitle("Second")
            .navigationDestination(
                store: store.scope(state: \.$destination, action: { .destination($0) }),
                state: /SecondReducer.Destination.State.third,
                action: SecondReducer.Destination.Action.third
            ) { store in
                ThirdView(store: store)
            }
        }
    }
}
