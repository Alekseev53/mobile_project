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
    var data: [Double]
    var colors: [Color]
    var title: String
    
    var transformedData: [Double] {
        let min = data.min() ?? 0.0
        return data.map { $0 + abs(min) + 5.0 }
    }
    
    var highestData: Double {
        let max = transformedData.max() ?? 1.0
        if max <= 0 { return 1.0 }
        return max + 1.0
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
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
                                .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .bottom, endPoint: .top))
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
    var data: [Double]
    var title: String
    var legend: String
    var color: Color
    
    var body: some View {
        CustomLineChartView(
            data: data,
            title: title,
            legend: legend,
            color: color
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
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    lineviewchart(data: self.data1, title: "Exp Process 1", legend: "Random Walk 1", color: .red).frame(height: geometry.size.height*0.30)
                    lineviewchart(data: self.data2, title: "Wiener Process 1", legend: "Random Walk 2", color: .red).frame(height: geometry.size.height*0.30)
                    lineviewchart(data: self.data3, title: "Exp Process 1", legend: "Random Walk 3", color: .red).frame(height: geometry.size.height*0.30)
                    Button("Take Data") {
                        self.data1 = generateRandomWalk_exp(steps: size_of_data, disp:self.dispValue)
                        self.data2 = generateRandomWalk(steps: size_of_data)
                        self.data3 = generateRandomWalk_exp(steps: size_of_data, disp:self.dispValue)
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
    @State private var dispValue: Double = my_disp
    @State private var data1: [Double] = generateRandomWalk_exp(steps: 9,disp:200*my_disp,last_n_elem:my_last_n_elem)
    @State private var data2: [Double] = generateRandomWalk_exp(steps: 9,disp:200*my_disp,last_n_elem:my_last_n_elem)
    @State private var data3: [Double] = generateRandomWalk_exp(steps: 9,disp:200*my_disp,last_n_elem:my_last_n_elem)
    
    // Создадим массив, содержащий различные цвета.
    let colors: [Color] = [.red, .green, .blue, .orange, .purple, .pink]
    @State private var selectedColors: [Color] = [.red, .blue]
    
    var body: some View {
        VStack {
            HStack {
                BarChartView(data: data1.map { CGFloat($0) }, colors: selectedColors,title:"1 Title")
                BarChartView(data: data2.map { CGFloat($0) }, colors: selectedColors,title:"2 Title")
            }
            GeometryReader { geometry in
                BarChartView(data: data3.map { CGFloat($0) }, colors: selectedColors,title:"3 Title")
                    .frame(height: geometry.size.height/2)
            }
            
            HStack {
                Button("Take Data") {
                    self.data1 = generateRandomWalk_exp(steps: 9,disp:self.dispValue*200)
                    self.data2 = generateRandomWalk_exp(steps: 9,disp:self.dispValue*200)
                    self.data3 = generateRandomWalk_exp(steps: 9,disp:self.dispValue*200)
                }
                .padding(.vertical)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                
                // Кнопка для генерации случайных цветов
                Button("Generate Random Colors") {
                    var index1: Int
                    var index2: Int
                    repeat {
                        index1 = Int.random(in: 0..<colors.count)
                        index2 = Int.random(in: 0..<colors.count)
                    } while index1 == index2
                    self.selectedColors = [colors[index1], colors[index2]]
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
