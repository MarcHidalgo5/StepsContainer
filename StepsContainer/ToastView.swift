
import SwiftUI


enum ToastStyle {
    case teamSelection1
    case teamSelection2
}

extension ToastStyle {
    var themeColor: Color {
        switch self {
        case .teamSelection1: return Color.red
        case .teamSelection2: return Color.blue
        }
    }
}

struct Toast: Equatable {
    var type: ToastStyle
    var title: String
    var message: String
    var duration: Double = 1.5
}

#warning("Create custom toast view for MLB, this is an example")
struct ToastView: View {
    var type: ToastStyle
    var title: String
    var message: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(systemName: "person.fill")
                    .foregroundColor(Color.white)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.white)
                    
                    Text(message)
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.6))
                }
                Spacer(minLength: 10)
            }
            .padding()
        }
        .interactiveDismissDisabled(false)
        .background(type.themeColor)
        .overlay(
            Rectangle()
                .fill(type.themeColor)
                .frame(width: 6)
                .clipped()
            , alignment: .leading
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}

#warning("Hardcoded offset")
struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                Group {
                    if let toast {
                        VStack {
                            Spacer()
                            ToastView(
                                type: toast.type,
                                title: toast.title,
                                message: toast.message)
                        }
                        .transition(.move(edge: .bottom))
                    }
                }
                    .offset(y: -20)
                    .animation(.spring(), value: toast)
            )
            .onChange(of: toast) { value in
                configureToast()
            }
    }
    
    @ViewBuilder func toastView() -> some View {
        if let toast = toast {
            VStack {
                Spacer()
                ToastView(
                    type: toast.type,
                    title: toast.title,
                    message: toast.message)
            }
            .transition(.move(edge: .bottom))
        }
    }
    
    private func configureToast() {
        guard let toast = toast else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if toast.duration > 0 {
            workItem?.cancel()
            let task = DispatchWorkItem {
               dismissToast()
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}


extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

//MARK: Preview

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(type: .teamSelection1, title: "Test", message: "Test message")
    }
}
