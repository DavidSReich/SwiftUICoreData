//
//  NewPurchaseOrderView.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 15/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI

struct NewPurchaseOrderView: View {
    @Binding var isPresented: Bool
    @ObservedObject var purchaseOrdersViewModel: PurchaseOrdersViewModel

    @State private var deliveryNote = ""
    @State private var preferredDate = Date()
    private var dateRange: ClosedRange<Date> {
        let min = Date()
        let max = Calendar.current.date(byAdding: .day, value: 60, to: Date())!
        return min...max
    }

    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("New Purchase Order Number:")
                    Spacer()
                    Text("PO\(purchaseOrdersViewModel.getLastPurchaseOrderNumberUsed() + 1)")
                }

                Section(header: Text("Delivery Note").font(.subheadline)) {
                    TextField("Enter a delivery note ...", text: $deliveryNote)
                }

                Section(header: Text("Delivery Date").font(.subheadline)) {
                    DatePicker("Preferred delivery date", selection: $preferredDate, in: dateRange, displayedComponents: .date)
                }
            }
            .listStyle(GroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New Purchase Order")
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        savePurchaseOrder()
                        isPresented = false
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func savePurchaseOrder() {
        withAnimation {
            //we want to keep the process of getting purchase order numbers separate from the process of setting them, and both separate from the code that saves new purchase orders.
            let newPurchaseOrderNumber = purchaseOrdersViewModel.getLastPurchaseOrderNumberUsed() + 1
            purchaseOrdersViewModel.setLastPurchaseOrderNumberUsed(lastPurchaseOrderNumber: newPurchaseOrderNumber)
            purchaseOrdersViewModel.saveNewPurchaseOrder(newPurchaseOrderId: "PO\(newPurchaseOrderNumber)", deliveryNote: deliveryNote, preferredDate: preferredDate)
        }
    }
}

struct NewPurchaseOrderView_Previews: PreviewProvider {
    @State static var isPresented = true
    @ObservedObject static var purchaseOrdersViewModel = PurchaseOrdersViewModel(viewContext: PersistenceController.preview.container.viewContext, dataSource: DataSource(networkService: NetworkService()))

    static var previews: some View {
        NewPurchaseOrderView(isPresented: $isPresented, purchaseOrdersViewModel: purchaseOrdersViewModel)
    }
}
