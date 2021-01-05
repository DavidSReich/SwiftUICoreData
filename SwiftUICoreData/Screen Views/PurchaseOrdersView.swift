//
//  PurchaseOrdersView.swift
//  SwiftUICoreData
//
//  Created by David S Reich on 15/11/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI
import CoreData

struct PurchaseOrdersView: View {

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PurchaseOrder.last_updated, ascending: false)],
        animation: .default)
    private var purchaseOrders: FetchedResults<PurchaseOrder>

    @ObservedObject var purchaseOrdersViewModel: PurchaseOrdersViewModel

    @State var showNewPurchase = false

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(purchaseOrders) { purchaseOrder in
                        NavigationLink(destination: PurchaseOrderView(purchaseOrdersViewModel: purchaseOrdersViewModel, purchaseOrder: purchaseOrder))  {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("PO ID: \(purchaseOrder.purchase_order_number)")
                                    Spacer()
                                    Text("\(purchaseOrder.items?.count ?? 0) items")
                                }
                                Text("Last updated: \(purchaseOrder.last_updated, formatter: itemFormatter)")
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        EditButton()
                    }

                    ToolbarItem(placement: .principal) {
                        Text("Purchase Orders")
                    }

                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            showNewPurchase = true
                        } label: {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showNewPurchase) {
                NewPurchaseOrderView(isPresented: $showNewPurchase, purchaseOrdersViewModel: purchaseOrdersViewModel)
            }
            .alert(isPresented: $purchaseOrdersViewModel.showingAlert) {
                Alert(title: Text("Something went wrong!"),
                      message: Text(purchaseOrdersViewModel.errorString),
                      dismissButton: .default(Text("OK ... I guess")))
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            purchaseOrdersViewModel.deleteItems(offsets: offsets)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct PurchaseOrdersView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseOrdersView(purchaseOrdersViewModel:
                            PurchaseOrdersViewModel(viewContext: PersistenceController.preview.container.viewContext, dataSource: DataSource(networkService: NetworkService())))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
