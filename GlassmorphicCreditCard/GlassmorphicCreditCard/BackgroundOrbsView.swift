import SwiftUI

struct BackgroundOrbsView: View {
    @State private var movePurble = false
    @State private var moveBlue = false
    
    var body: some View {
        ZStack {
            // Dark base background
            Color.black.ignoresSafeArea()
            
            // Purple Orb
            Circle()
                .fill(Color.purple)
                .frame(width: 250, height: 250)
                .blur(radius: 80)
                .offset(x: movePurble ? -100 : 100, y: movePurble ? -100 : 100)
                .animation(
                    Animation.easeInOut(duration: 5)
                        .repeatForever(autoreverses: true),
                    value: movePurble
                )
            
            // Blue Orb
            Circle()
                .fill(Color.blue)
                .frame(width: 250, height: 250)
                .blur(radius: 80)
                .offset(x: moveBlue ? 100 : -100, y: moveBlue ? 150 : -50)
                .animation(
                    Animation.easeInOut(duration: 7)
                        .repeatForever(autoreverses: true),
                    value: moveBlue
                )
        }
        .onAppear {
//            movePurble.toggle()
//            moveBlue.toggle()
        }
    }
}

#Preview {
    BackgroundOrbsView()
}
