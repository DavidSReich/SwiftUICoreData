//
//  NewItemView.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 16/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI

struct NewItemView: View {
    @Binding var isPresented: Bool
    @ObservedObject var purchaseOrdersViewModel: PurchaseOrdersViewModel

    @State var purchaseOrder: PurchaseOrder

    @State private var quantity = 0

    let maxQuantity = 1000000

    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("New Product Item Number:")
                    Spacer()
                    Text("\(getNextProductItemId())")
                }

                Section(header: Text("Quantity").font(.subheadline)) {
                    Stepper(value: $quantity, in: 1...maxQuantity) {
                        Text("\(quantity)")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New Item")
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        saveItem()
                        isPresented = false
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func saveItem() {
        withAnimation {
            purchaseOrdersViewModel.saveItem(purchaseOrder: purchaseOrder, productItemId: getNextProductItemId(), quantity: quantity)
        }
    }

    // there should be some business logic about this
    private func getNextProductItemId() -> Int64 {
        if let sortedItems = purchaseOrder.items?.sortedArray(using: [NSSortDescriptor(keyPath: \Item.product_item_id, ascending: false)]) as? [Item] {
            return (sortedItems.first?.product_item_id ?? 0) + 1
        }

        return 0
    }
}

struct NewItemView_Previews: PreviewProvider {
    @State static var isPresented = true
    @ObservedObject static var purchaseOrdersViewModel = PurchaseOrdersViewModel(viewContext: PersistenceController.preview.container.viewContext, dataSource: DataSource(networkService: NetworkService()))

    static var previews: some View {
        NewItemView(isPresented: $isPresented, purchaseOrdersViewModel: purchaseOrdersViewModel, purchaseOrder: makeNewPO())
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
