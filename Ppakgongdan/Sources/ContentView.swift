import SwiftUI
import Feature
import Utils

public struct ContentView: View {
    public init() {}

    public var body: some View {
        FeatureView(store: .init(initialState: FeatureReducer.State(), reducer: {
            FeatureReducer()
        }))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
