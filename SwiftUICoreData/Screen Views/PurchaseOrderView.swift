//
//  PurchaseOrderView.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI

struct PurchaseOrderView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var purchaseOrdersViewModel: PurchaseOrdersViewModel

    @State var purchaseOrder: PurchaseOrder
    @State var showNewItem = false

    var dateRange: ClosedRange<Date> {
        let min = Date()
        let max = Calendar.current.date(byAdding: .day, value: 60, to: min) ?? Date()
        return min...max
    }

    var body: some View {
        ZStack {
            List {
                Section(header: Text("Delivery Note").font(.subheadline)) {
                    TextField("Enter a delivery note ...", text: $purchaseOrder.delivery_note)
                }

                Section(header: Text("Delivery Date").font(.subheadline)) {
                    DatePicker("Preferred delivery date", selection: $purchaseOrder.preferred_delivery_date, in: dateRange, displayedComponents: .date)
                }

                Section(header: VStack(alignment: .leading) {
                    Text("Items").font(.subheadline)
                    HStack {
                        Text("Product Item Id")
                        Spacer()
                        Text("Quantity")
                    }
                }) {
                    if let items = purchaseOrder.items?.sortedArray(using: [NSSortDescriptor(keyPath: \Item.product_item_id, ascending: true)]) as? Array<Item> {
                        if items.count > 0 {
                            ForEach(items) { item in
                                HStack {
                                    Text("\(item.product_item_id)")
                                    Spacer()
                                    Text("\(item.quantity)")
                                }
                            }
                        } else {
                            Text("No items")
                        }
                    } else {
                        Text("No items")
                    }
                }

                Section(header: VStack(alignment: .leading) {
                    Text("Invoices").font(.subheadline)
                    HStack {
                        Text("Invoice Number")
                        Spacer()
                        Text("Status")
                    }
                }) {
                    if let invoices = purchaseOrder.invoices?.sortedArray(using: [NSSortDescriptor(keyPath: \Invoice.invoice_number, ascending: true)]) as? Array<Invoice> {
                        if invoices.count > 0 {
                            ForEach(invoices) { invoice in
                                HStack {
                                    Text("\(invoice.invoice_number)")
                                    Spacer()
                                    Text("\(invoice.received_status)")
                                }
                            }
                        } else {
                            Text("No invoices")
                        }
                    } else {
                        Text("No invoices")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("PO ID: \(purchaseOrder.purchase_order_number)")
                }
                ToolbarItemGroup(placement: .primaryAction) {
                    HStack {
                        Button {
                            showNewItem = true
                        } label: {
                            Label("Add Item", systemImage: "plus")
                        }
                        Divider()
                        Button("Save") {
                            savePurchaseOrder()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .sheet(isPresented: $showNewItem) {
                NewItemView(isPresented: $showNewItem, purchaseOrdersViewModel: purchaseOrdersViewModel, purchaseOrder: purchaseOrder)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func savePurchaseOrder() {
        withAnimation {
            purchaseOrder.last_updated = Date()
            purchaseOrdersViewModel.savePurchaseOrder()
        }
    }
}

struct PurchaseOrderView_Previews: PreviewProvider {
    @ObservedObject static var purchaseOrdersViewModel = PurchaseOrdersViewModel(viewContext: PersistenceController.preview.container.viewContext, dataSource: DataSource(networkService: NetworkService()))

    static var previews: some View {
        NavigationView {
            PurchaseOrderView(purchaseOrdersViewModel: purchaseOrdersViewModel, purchaseOrder: makeNewPO())
        }
    }

    static func makeNewPO() -> PurchaseOrder {
        let newPO = purchaseOrdersViewModel.makePurchaseOrder()
        newPO.purchase_order_number = "aa"
        newPO.delivery_note = "note"
        let now = Date()
        newPO.preferred_delivery_date = now
        newPO.last_updated = now
        newPO.issue_date = now

        return newPO
    }
}
