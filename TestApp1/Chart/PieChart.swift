//
//  PieChart.swift
//  TestApp1
//
//  Created by Raul Shafigin on 19.09.2024.
//

import Foundation
import SwiftUI
import Charts
import TestApp1Framework

struct SectorChartExample: View {
    @State private var gender: [Gender] = [
        .init(sex: "Мужчины \(Double(StorageManager.shared.male) / Double((StorageManager.shared.female + StorageManager.shared.male)) * 100)%", value: Double(StorageManager.shared.male / StorageManager.shared.female)),
        
        .init(sex: "Женщины\(Double(StorageManager.shared.male) / Double((StorageManager.shared.female + StorageManager.shared.male)) * 100)%", value: Double(StorageManager.shared.female / StorageManager.shared.male))
        
    ]
    
    var body: some View {
        Chart(gender) { gender in
            SectorMark(
                angle: .value(
                    Text(verbatim: gender.sex),
                    gender.value
                ),
                innerRadius: .ratio(0.9),
                angularInset: 8
            )
            .foregroundStyle(
                by: .value(
                    Text(verbatim: gender.sex), gender.sex
                )
                
            )
            
        }
    }
}

struct Gender: Identifiable {
    let id = UUID()
    let sex: String
    let value: Double
}
