import SwiftUI

struct ResultView: View {
    var speedData: [CGPoint]
    var accuracyData: [CGPoint]
    var timeElapsed: Double
    var wordsPerMinute: Double
    var accuracy: Double
    
    var body: some View {
        VStack {
            Text("Results")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Text("Time elapsed: \(timeElapsed, specifier: "%.2f") seconds")
                .font(.headline)
                .padding(.bottom, 10)
            Text("Words per minute: \(wordsPerMinute, specifier: "%.2f")")
                .font(.headline)
            Text("Accuracy: \(accuracy, specifier: "%.2f")%")
                .font(.headline)
                .padding(.bottom, 20)
            
            LineChartView(speedData: speedData, accuracyData: accuracyData)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}