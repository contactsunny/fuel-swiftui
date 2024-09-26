//
//  AnalyticsFilterView.swift
//  Fuel Records
//
//  Created by Sunny Srinidhi on 26/09/24.
//

import SwiftUI

struct AnalyticsFilterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var fromDate: Date
    @Binding var toDate: Date
    
    var body: some View {
        NavigationStack {
            List {
                DatePicker(
                    selection: $fromDate,
                    displayedComponents: .date
                ) {
                    Text("From Date")
                }
                
                DatePicker(
                    selection: $toDate,
                    displayedComponents: .date
                ) {
                    Text("To Date")
                }
            }
            .navigationTitle(Text("Filter Reports"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AnalyticsFilterView(
        fromDate: .constant(Calendar.current.date(
            bySettingHour: 00, minute: 00, second: 00, of: CustomUtil.addOrSubtractMonth(month: -6)
        )!),
        toDate: .constant(Calendar.current.date(
            bySettingHour: 23, minute: 59, second: 59, of: Date()
        )!)
    )
}
