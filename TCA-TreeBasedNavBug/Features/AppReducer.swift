//
//  AppReducer.swift
//  TCA-TreeBasedNavBug
//
//  Created by Eskil Aronsen on 9/26/23.
//

import ComposableArchitecture
import SwiftUI

struct AppReducer: Reducer {
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
    }

    enum Action: Equatable {
        case firstTapped
        case secondTapped
        case thirdTapped
        case destination(PresentationAction<Destination.Action>)
    }

    public struct Destination: Reducer {
        public enum State: Equatable {
            case first(FirstReducer.State)
        }

        public enum Action: Equatable {
            case first(FirstReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: /State.first, action: /Action.first) {
                FirstReducer()
            }
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .firstTapped:
                state.destination = .first(FirstReducer.State())

                return .none

            case .secondTapped:
                state.destination = .first(
                    FirstReducer.State(
                        destination: .second(
                            SecondReducer.State()
                        )
                    )
                )

                return .none

            case .thirdTapped:
                state.destination = .first(
                    FirstReducer.State(
                        destination: .second(
                            SecondReducer.State(
                                destination: .third(
                                    ThirdReducer.State()
                                )
                            )
                        )
                    )
                )

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

struct AppView: View {
    let store: StoreOf<AppReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                VStack {
                    Button(
                        action: {
                            viewStore.send(.firstTapped)
                        },
                        label: {
                            Text("Go to First")
                        }
                    )

                    Button(
                        action: {
                            viewStore.send(.secondTapped)
                        },
                        label: {
                            Text("Go to Second")
                        }
                    )

                    Button(
                        action: {
                            viewStore.send(.thirdTapped)
                        },
                        label: {
                            Text("Go to Third")
                        }
                    )
                }
                .navigationTitle("Start")
                .navigationDestination(
                    store: store.scope(state: \.$destination, action: { .destination($0) }),
                    state: /AppReducer.Destination.State.first,
                    action: AppReducer.Destination.Action.first
                ) { store in
                    FirstView(store: store)
                }
            }
        }
    }
}
