import SwiftUI

struct LineChartShape: Shape {
    var data: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard !data.isEmpty else {
            return path
        }
        
        let minX = data.map { $0.x }.min() ?? 0
        let maxX = data.map { $0.x }.max() ?? 1
        let minY = data.map { $0.y }.min() ?? 0
        let maxY = data.map { $0.y }.max() ?? 1
        
        let scaleX = rect.width / (maxX - minX)
        let scaleY = rect.height / (maxY - minY)
        
        path.move(to: CGPoint(x: (data.first!.x - minX) * scaleX, y: rect.height - (data.first!.y - minY) * scaleY))
        
        for point in data {
            let x = (point.x - minX) * scaleX
            let y = rect.height - (point.y - minY) * scaleY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
}

struct LineChartView: View {
    var speedData: [CGPoint]
    var accuracyData: [CGPoint]

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    .shadow(radius: 5)
                
                VStack {
                    LineChartShape(data: speedData)
                        .stroke(Color.blue, lineWidth: 2)
                    
                    LineChartShape(data: accuracyData)
                        .stroke(Color.green, lineWidth: 2)
                }
                .padding()
                
                GridShape()
                    .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [5]))
                
                VStack {
                    HStack {
                        Text("Speed (WPM)")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Spacer()
                        Text("Accuracy (%)")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            .frame(height: 300)
            .padding()
        }
    }
}

struct GridShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let rows = 5
        let columns = 5
        let rowHeight = rect.height / CGFloat(rows)
        let columnWidth = rect.width / CGFloat(columns)
        
        for i in 0...rows {
            let y = CGFloat(i) * rowHeight
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        for i in 0...columns {
            let x = CGFloat(i) * columnWidth
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        return path
    }
}