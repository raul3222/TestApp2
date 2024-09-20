//
//  SwiftUIView.swift
//  TestApp1
//
//  Created by Raul Shafigin on 19.09.2024.
//

import SwiftUI
import Charts
import TestApp1Framework

struct ChartData: Identifiable, Equatable {
    let type: String
    let count: Int

    var id: String { return type }
}
struct BarChart: View {
    var body: some View {

        AgeElement(age1: 15, age2: 21)
        AgeElement(age1: 22, age2: 25)
        AgeElement(age1: 26, age2: 30)
        AgeElement(age1: 31, age2: 35)
        AgeElement(age1: 36, age2: 40)
        AgeElement(age1: 40, age2: 50)
//        AgeElement(age: "15-21")
//        AgeElement(age: "22-25")
//        AgeElement(age: "26-30")
//        AgeElement(age: "31-35")
//        AgeElement(age: "36-40")
//        AgeElement(age: "40-50")
//        AgeElement(age: ">50    ")
    }
}


struct AgeElement: View {
  
    let age1: Int
    let age2: Int
    
    @State private var chartData: [ChartData] = []
    
    //[ChartData(type: " ", count: StorageManager.shared.getUsersCountBy(age1: 15, age2: 21).0),
                    //ChartData(type: "", count: StorageManager.shared.getUsersCountBy(age1: 15, age2: 21).1)]
    var body: some View {
        HStack {
            Text("\(age1)-\(age2)")
                .padding(.trailing)
            Chart(chartData) { dataPoint in
                BarMark(x: .value("X", dataPoint.count),
                        y: .value("Y", dataPoint.type))
                .foregroundStyle(by: .value("Type", dataPoint.type))
                .annotation(position: .trailing) {
                    Text(String(dataPoint.count))
                        .foregroundColor(.gray)
                }
            }
            .chartLegend(.hidden)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                }
            }
            .aspectRatio(4, contentMode: .fit)
        }
        .onAppear {
            chartData = getData(age1: age1, age2: age2)
        }
        
    }
    
    func getData(age1: Int, age2: Int) -> [ChartData] {
        var maleAge = Int(StorageManager.shared.getUsersCountBy(age1: age1, age2: age2).0)
        if maleAge == 0 {
            
        }
        let data = [
            ChartData(type: " ", count: maleAge),
            ChartData(type: "", count: Int(StorageManager.shared.getUsersCountBy(age1: age1, age2: age2).1))]
        return data
    }
}
