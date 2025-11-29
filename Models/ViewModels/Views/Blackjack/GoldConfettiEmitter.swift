import SwiftUI

struct GoldConfettiEmitter: View {

    private struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var opacity: Double
    }

    @State private var particles: [Particle] = []
    @State private var hasStarted = false

    var body: some View {
        ZStack {
            ForEach(particles) { p in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.85, blue: 0.45),
                                Color(red: 0.95, green: 0.65, blue: 0.10)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: p.size, height: p.size)
                    .offset(x: p.x, y: p.y)
                    .opacity(p.opacity)
            }
        }
        .onAppear {
            if !hasStarted {
                hasStarted = true
                spawnAndAnimate()
            }
        }
    }

    private func spawnAndAnimate() {
        let count = 18
        var initial: [Particle] = []

        for _ in 0..<count {
            initial.append(
                Particle(
                    x: 0,
                    y: 0,
                    size: CGFloat.random(in: 6...12),
                    opacity: 1.0
                )
            )
        }

        particles = initial

        withAnimation(.easeOut(duration: 1.2)) {
            for index in particles.indices {
                particles[index].x = CGFloat.random(in: -50 ... 50)
                particles[index].y = CGFloat.random(in: -150 ... -90) // fixed!
                particles[index].opacity = 0.0
            }
        }
    }
}
