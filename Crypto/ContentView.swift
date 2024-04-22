import SwiftUI
import SwiftUICharts
import WebKit
import Foundation // Для использования функции exp




struct BarView: View {
    var datum: Double
    var colors: [Color]
    
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        Rectangle()
            .fill(gradient)
            .opacity(datum == 0.0 ? 0.0 : 1.0)
    }
}


struct BarChartView: View {
    var chartData: ChartDataModel
    
    var transformedData: [Double] {
        let min = chartData.data.min() ?? 0.0
        return chartData.data.map { $0 + abs(min) + 5.0 }
    }
    
    var highestData: Double {
        let max = transformedData.max() ?? 1.0
        if max <= 0 { return 1.0 }
        return max + 1.0
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(chartData.title)
                    .font(.system(size: 16))
                    .minimumScaleFactor(0.1)
                Spacer()
            }
            .padding()
            .frame(maxWidth: 200, maxHeight: 1) 
            
            GeometryReader { geometry in
                let barWidth = geometry.size.width / CGFloat(transformedData.count)
                
                HStack(alignment: .bottom, spacing: barWidth / 24 ) {
                    ForEach(transformedData.indices, id: \.self) { index in
                        let height = geometry.size.height * CGFloat(transformedData[index] / highestData)
                        
                        VStack(spacing: 2) {
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: [chartData.color,Color.red]), startPoint: .bottom, endPoint: .top))
                                .opacity(transformedData[index] == 0.0 ? 0.0 : 0.8 )
                                .frame(width: barWidth, height: height, alignment: .bottom)
                            
                            Text("\(index + 1)")
                                .font(.footnote)
                        }
                    }
                }
            }
            .padding([.horizontal])
        }
    }
}

struct CustomLineChartView: View {
    var data: [Double]
    var title: String
    var legend: String
    var color: Color

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            Text(legend)
                .font(.caption)
            
            GeometryReader { geometry in
                Path { path in
                    let maxValue = CGFloat(data.max() ?? 1)
                    let minValue = CGFloat(data.min() ?? 0)
                    let dataRange = maxValue - minValue

                    let xScale = geometry.size.width / CGFloat(data.count - 1)
                    let yScale = geometry.size.height / dataRange

                    for i in data.indices {
                        let x = xScale * CGFloat(i)
                        let y = yScale * CGFloat(data[i] - minValue)
                        let point = CGPoint(x: x, y: geometry.size.height - y)
                        
                        if i == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(color, lineWidth: 2)
            }
        }
        .padding()
    }
}
struct lineviewchart: View {
    var chartData: ChartDataModel
    
    var body: some View {
        CustomLineChartView(
            data: chartData.data,
            title: chartData.title,
            legend: chartData.legend,
            color: chartData.color
        )
    }
}

struct FirstContentView: View {
    @State private var dispValue: Double = my_disp
    @State private var data1: [Double] = generateRandomWalk_exp(steps: size_of_data, disp: my_disp, last_n_elem: my_last_n_elem)
    @State private var data2: [Double] = generateRandomWalk(steps: size_of_data)
    @State private var data3: [Double] = generateRandomWalk_exp(steps: size_of_data, disp: my_disp, last_n_elem: my_last_n_elem)
    @State private var lastElements: Double = Double(my_last_n_elem)
    @State private var dispText = "\(my_disp)"
    @State private var graphColor1 = Color.red
    @State private var graphColor2 = Color.blue
    
    @State private var chartData1 = ChartDataModel(id: 1, data: generateRandomWalk_exp(steps: size_of_data, disp: my_disp, last_n_elem: my_last_n_elem), color: Color.blue, title: "Random Walk 1", legend: "Line Chart 1")
    @State private var chartData2 = ChartDataModel(id: 2, data: generateRandomWalk(steps: size_of_data), color: Color.red, title: "Random Walk 2", legend: "Line Chart 2")
    @State private var chartData3 = ChartDataModel(id: 3, data: generateRandomWalk_exp(steps: size_of_data, disp: my_disp, last_n_elem: my_last_n_elem), color: Color.green, title: "Random Walk 2", legend: "Line Chart 3")
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    lineviewchart(chartData: self.chartData1).frame(height: geometry.size.height*0.30)
                    lineviewchart(chartData: self.chartData2).frame(height: geometry.size.height*0.30)
                    lineviewchart(chartData: self.chartData3).frame(height: geometry.size.height*0.30)
                    Button("Take Data") {
                        self.data1 = generateRandomWalk_exp(steps: size_of_data, disp:self.dispValue)
                        self.data2 = generateRandomWalk(steps: size_of_data)
                        self.data3 = generateRandomWalk_exp(steps: size_of_data, disp:self.dispValue)
                        chartData1 = ChartDataModel(id: 1, data: data1, color: Color.blue, title: "Random Walk 1", legend: "Line Chart 1")
                        chartData2 = ChartDataModel(id: 2, data: data2, color: Color.red, title: "Random Walk 2", legend: "Line Chart 2")
                        chartData3 = ChartDataModel(id: 3, data: data3, color: Color.green, title: "Random Walk 2", legend: "Line Chart 3")
                    }
                    .padding([.horizontal, .bottom])
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }//VStack
            }//ScrollView
        }
        }//body
}//FirstContentView

struct SecondContentView: View {
    @State private var chartData1: ChartDataModel = ChartDataModel(id: 1, data: generateRandomWalk_exp(steps: 9,disp:200*my_disp,last_n_elem:my_last_n_elem), color: .blue, title: "Bar Chart 1", legend: "Random Walk 1")
    @State private var chartData2: ChartDataModel = ChartDataModel(id: 2, data: generateRandomWalk_exp(steps: 9,disp:200*my_disp,last_n_elem:my_last_n_elem), color: .red, title: "Bar Chart 2", legend: "Random Walk 2")
    @State private var chartData3: ChartDataModel = ChartDataModel(id: 3, data: generateRandomWalk_exp(steps: 9,disp:200*my_disp,last_n_elem:my_last_n_elem), color: .purple, title: "Bar Chart 3", legend: "Random Walk 3")

    // Создадим массив, содержащий различные цвета.
    let colors: [Color] = [.red, .green, .blue, .orange, .purple, .pink]
    @State private var selectedColors: [Color] = [.red, .blue]
    
    var body: some View {
        VStack {
            HStack {
                BarChartView(chartData: chartData1)
                BarChartView(chartData: chartData2)
            }
            GeometryReader { geometry in
                BarChartView(chartData: chartData3)
                    .frame(height: geometry.size.height/2)
            }
            
            HStack {
                Button("Take Data") {
                    chartData1 = ChartDataModel(id: 1, data: generateRandomWalk_exp(steps: 9,disp:200*my_disp,last_n_elem:my_last_n_elem), color: .blue, title: "Bar Chart 1", legend: "Random Walk 1")
                    chartData2 = ChartDataModel(id: 2, data: generateRandomWalk_exp(steps: 9,disp:200*my_disp,last_n_elem:my_last_n_elem), color: .red, title: "Bar Chart 2", legend: "Random Walk 2")
                    chartData3 = ChartDataModel(id: 3, data: generateRandomWalk_exp(steps: 9,disp:200*my_disp,last_n_elem:my_last_n_elem), color: .purple, title: "Bar Chart 3", legend: "Random Walk 3")
                }
                .padding(.vertical)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                
                // Кнопка для генерации случайных цветов
                Button("Generate Random Colors") {
                    self.chartData1.color = colors[Int.random(in: 0..<colors.count)]
                    self.chartData2.color = colors[Int.random(in: 0..<colors.count)]
                    self.chartData3.color = colors[Int.random(in: 0..<colors.count)]
                }
                .padding(.vertical)
                .padding(.vertical)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(20)
            }
        }
        .padding(.vertical) // Добавить пространство сверху и снизу
        .padding()
    }
}


struct ThirdContentView: View {
    
    @State private var users = [User]()
    @State private var loadingTime = 0.0
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
            List(users) { user in
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                }
            }
            .padding(.bottom)
            
            Button("Load Data") {
                self.loadData()
                self.startTimer()
            }
            .padding(.vertical)
            .padding(.horizontal)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(20)
            
            Text("Request time: \(loadingTime, specifier: "%.2f") seconds")
        }
    }
    
    func loadData() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            print("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([User].self, from: data)
                    DispatchQueue.main.async {
                        self.users = decodedData
                        self.stopTimer()  // Остановить таймер здесь
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                }
            }
        }
        task.resume()
    }
    
    func startTimer() {
        self.loadingTime = 0.0
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.loadingTime += 0.1
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
}



struct ContentView: View {
    @State private var selectedView = 0
    @State private var dispValue: Double = my_disp
    @State private var data1: [Double] = generateRandomWalk_exp(steps: size_of_data,disp:my_disp,last_n_elem:my_last_n_elem)
    @State private var lastElements: Double = Double(my_last_n_elem)
    @State private var dispText = "\(my_disp)"
    
    var views: [AnyView] = [AnyView(FirstContentView()),
                            AnyView(SecondContentView()),
                            AnyView(ThirdContentView())]
    
    var body: some View {
        VStack {
            Picker(selection: $selectedView, label: Text("What is your favorite color?")) {
                Text("View 1").tag(0)
                Text("View 2").tag(1)
                Text("View 3").tag(2)
            }.pickerStyle(SegmentedPickerStyle())
            
            Divider()
            
            self.views[selectedView]
        }
    }
}
