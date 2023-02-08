
import SwiftUI

/// View examples

struct StepsContainer1: View{
    @State private var toast: Toast? = nil
    @State private var selection: String?
    
    let names = [
            "Hello World",
            "Hello World1",
            "Hello World2",
            "Hello World3",
            "Hello World4",
            "Hello World5",
            "Hello World6",
            "Hello World7",
            "Hello World8",
            "Hello World9",
            "Hello World10",
            "Hello World11",
            "Hello World12",
            "Hello World13",
            "Hello World14",
    ]
    
    var body: some View {
        List(names, id: \.self, selection: $selection) { name in
            Button(name) {
                if name == "Hello World" {
                    toast = Toast(type: .teamSelection2, title: "Test", message: "grwfed")
                } else {
                    toast = Toast(type: .teamSelection1, title: "Toast info", message: "Toast message")
                }
            }
            .foregroundColor(.black)
            .bold()
            .padding()
        }
        .toastView(toast: $toast)
        .navigationTitle("Steps container 1")
    }
}

struct StepsContainer2: View{
    
    var body: some View {
        List {
            ForEach(Array(stride(from: 0, to: 21, by: 1)), id: \.self) { index in
                    Text("Hello, world!")
                        .padding()
                }
        }
        .navigationTitle("Steps container 2")
    }
}


struct StepsContainer1_Previews: PreviewProvider {
    static var previews: some View {
        StepsContainer1()
    }
}


struct StepsContainer2_Previews: PreviewProvider {
    static var previews: some View {
        StepsContainer2()
    }
}
