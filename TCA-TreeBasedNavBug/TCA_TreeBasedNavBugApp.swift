//
//  TCA_TreeBasedNavBugApp.swift
//  TCA-TreeBasedNavBug
//
//  Created by Eskil Aronsen on 9/26/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCA_TreeBasedNavBugApp: App {
    var body: some Scene {
        WindowGroup {
//            AppView(
//                store: Store(
//                    initialState: AppReducer.State(),
//                    reducer: { AppReducer()._printChanges() }
//                )
//            )

            AppView(
                store: Store(
                    initialState: AppReducer.State(
                        destination: .first(
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
                    ),
                    reducer: { AppReducer()._printChanges() }
                )
            )
        }
    }
}
