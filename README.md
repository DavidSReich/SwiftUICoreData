#  SwiftUICoreData

`SwiftUICoreData` is an example application using `CoreData` for persistent data storage.

## Screenshots
![Purchase Orders](http://github.com/DavidSReich/SwiftUICoreData/blob/main/Screenshots/PurchaseOrders.png)
![Purchase Order](http://github.com/DavidSReich/SwiftUICoreData/blob/main/Screenshots/PurchaseOrder.png)
![New Purchase Order](http://github.com/DavidSReich/SwiftUICoreData/blob/main/Screenshots/NewPurchaseOrder.png)
![New Item](http://github.com/DavidSReich/SwiftUICoreData/blob/main/Screenshots/NewItem.png)

## Assumptions

Because there are no rules or guarantees about internal consistency in each purchase order it isn't possible to verify that items in receipts are in the purchase order.
The downloaded sample data does NOT meet this requirement, so any attempt to validate the purchase order would reject it for that reason.  Therefore no such validation is attempted.

Purchase orders are displayed in last update descending order.
That way when we modify a PO we can see the list reorder.

See below for `Updating Rules`.

To create a `relational` database from the downloaded Purchase Orders each "owned" record has its owner's id as part of the table's constraint to make a "unique" key:  
* PurchaseOrder - `purchase_order_number`  
* Item - `product_item_id, purchaseOrder`  
* Invoice - `invoice_number, purchaseOrder`  
* Receipt - `product_item_id, invoice`  

The PurchaseOrder has no owner and so just has a single field as the constraint.
The owner ids are equivalent to foreign keys in a relational database like SQL.

Ideally the `product_item_id` in Receipt should be a "foreign key" and match an Item in the same PurchaseOrder.  (This is not enforced or verified for reasons previously mentioned.)

In a real application status fields (status, received_status, etc.) should map to an enum (or similar) so they can be better displayed to the user.

Most unrequired fields have been skipped, not imported, and ignored.

The PurchaseOrder view allows the user to change the `delivery note` and the `preferred delivery date`.  Items can be added.  Otherwise, Items, Invoices, and Receipts are not modifiable.

Decoding managed objects from JSON automatically updates the CoreData store.  This is not desirable since we only want to update the store with newer items.  

The solution (one solution) is to have two sets of data models. A managed set and an unmanaged set.  When downloading the JSON is initially decoded into an unmanaged object hierarchy.  This is then bridged to managed objects as needed.  If an entire Purchase Order is to be saved then a shortcut used is to convert the unmanaged Purchase Order back into `Data`, then to decode it directly into managed objects.  This has to be done individually for each Purchase Order and cannot be done on the entire download which can contain multiple Purchase Orders.

## Updating Rules

The specifcation says
> "[device] data ... must not be overridden by the data in the server unless the 
> last updated time in the server is greater than the last updated time on the local device"

This will be interpreted as ...
If a downloaded Purchase Order is newer than the one from CoreData then the entire Purchase Order will be updated.
If not ...
For items - for each Item if the downloaded Item is newer then update the Item.
For invoices - if a downloaded Invoice is newer then update the entire Invoice.
If not updating the entire invoice, then go through Receipts and update those where the downloaded Receipt is newer.

In the absence of a policy about what to do about objects that are no longer in the server feed ...
When updating an existing PurchaseOrder with a downloaded one all Items, Invoices, and Receipts are replaced.  Any Items added by the user are removed.
Any Items removed by the user (not currently implemented) will be restored if they are in the new PurchaseOrder.
If not updating the entire PurchaseOrder ... then update Items, Invoices, etc. with more recent ones, preserving any Items that have been added by the user.
Similarly for Invoices and Receipts added/modified/deleted by the user (not currently implemented).
