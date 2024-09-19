//
//  ChartView.swift
//  TestApp1
//
//  Created by Raul Shafigin on 19.09.2024.
//

import SwiftUI
import Charts
import TestApp1Framework

struct ChartView: View {
    var testDate = ["05.03", "07.03", "09.03", "10.03", "11.03", "12.03", "13.03"]
    var normalDates = StorageManager.shared.normalDatesArray
    var dates: [Int: [Int]] = StorageManager.shared.dates
    var ids: [Int] = StorageManager.shared.userIds
    let stat = StorageManager.shared.statistics!
    var body: some View {
        Chart {
//            ForEach(testDate, id: \.self) { date in
//                LineMark(x: .value("Type", "\(date)"),
//                         y: .value("Population", 0.1))
//                       .foregroundStyle(.pink)
//            }
            LineMark(x: .value("Type", "\(testDate[0])"),
                     y: .value("Test", 1))
                   .foregroundStyle(.pink)
            LineMark(x: .value("Type", "\(testDate[1])"),
                     y: .value("Test", 2))
                   .foregroundStyle(.pink)
            LineMark(x: .value("Type", "\(testDate[2])"),
                     y: .value("Test", 3))
                   .foregroundStyle(.pink)
            LineMark(x: .value("Type", "\(testDate[3])"),
                     y: .value("Test", 1))
                   .foregroundStyle(.pink)
            LineMark(x: .value("Type", "\(testDate[4])"),
                     y: .value("Test", 3))
                   .foregroundStyle(.pink)
            LineMark(x: .value("Type", "\(testDate[5])"),
                     y: .value("Test", 5))
                   .foregroundStyle(.pink)
            LineMark(x: .value("Type", "\(testDate[6])"),
                     y: .value("Test", 6))
                   .foregroundStyle(.pink)
        }
//        .aspectRatio(1, contentMode: .fill)
               .padding()
    }
}

#Preview {
    ChartView()
}




