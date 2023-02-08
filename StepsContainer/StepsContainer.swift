
import SwiftUI

struct StepsContainer: View{
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ViewContainers.initialView.getView()
                .navigationDestination(for: ViewContainers.self) { view in
                    view.getView()
                }
        }
        .safeAreaInset(edge: .bottom, alignment: .center, spacing: 10) {
            NextButton(path: $path)
        }
    }
}

struct NextButton: View {
    
    @Binding var path: NavigationPath
    
    var body: some View {
        Button("Next") {
            path.append(ViewContainers.secondView)
        }
        .buttonStyle(MLBRoundedButtonStyle( isUserInteractionEnabled: true))
        .accessibilityIdentifier("loginSubmitButton")
        .frame(maxWidth: .infinity)
        .padding(.bottom, 30)
        .padding(.top, 5)
        .padding([.leading, .trailing])
        .background(.white.opacity(0.97))
    }
}

struct StepsContainer_Previews: PreviewProvider {
    static var previews: some View {
        StepsContainer()
    }
}


struct MLBRoundedButtonStyle: ButtonStyle {
    
    let isUserInteractionEnabled: Bool
    
    /// provides a style for common submit buttons
    /// - parameters:
    ///   - theme:  a theme to use to define fonts and colors
    ///   - isUserInteractionEnabled: if set to false will disable and grey out the button
    init(isUserInteractionEnabled: Bool = true) {
        self.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    /// The background color for the button, dependent on whether
    /// the button is enabled, or disabled.
    private func backgroundColor(configuration: Configuration) -> Color {
        if configuration.isPressed {
            return Color.blue.opacity(0.5)
        } else if isUserInteractionEnabled {
            return Color.blue
        } else {
            return Color.gray
        }
    }
    
    private var foregroundColor: Color {
        isUserInteractionEnabled ? Color.white : Color.gray
    }
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration
            .label
            .padding([.top, .bottom])
            .frame(maxWidth: .infinity)
            .background(backgroundColor(configuration: configuration))
            .foregroundColor(foregroundColor)
            .clipShape(Capsule())
    }
}

enum ViewContainers {
    case initialView
    case secondView
    
    @ViewBuilder func getView() -> some View {
        Group {
            switch self {
            case .initialView:
                StepsContainer1()
            case .secondView:
                StepsContainer2()
            }
        }
        .safeAreaInsetModifier()
    }
}

#warning("It is necessary to dynamically calculate the height of the next button in order to correctly adjust the bottom inset of the list")
struct SafeAreaInsetModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Spacer()
                    .frame(height: 75)
            }
    }
}


extension View {
    func safeAreaInsetModifier() -> some View {
        self.modifier(SafeAreaInsetModifier())
    }
}
