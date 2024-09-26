import Bool "mo:base/Bool";
import Text "mo:base/Text";

import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";

actor {
  // Define the structure for a shopping list item
  type ShoppingItem = {
    id: Nat;
    text: Text;
    completed: Bool;
  };

  // Store the shopping list items
  stable var items : [ShoppingItem] = [];
  stable var nextId : Nat = 0;

  // Add a new item to the shopping list
  public func addItem(text: Text) : async Nat {
    let id = nextId;
    nextId += 1;
    let newItem : ShoppingItem = {
      id = id;
      text = text;
      completed = false;
    };
    items := Array.append(items, [newItem]);
    id
  };

  // Get all items in the shopping list
  public query func getItems() : async [ShoppingItem] {
    items
  };

  // Toggle the completed status of an item
  public func toggleItem(id: Nat) : async Bool {
    let itemIndex = Array.indexOf<ShoppingItem>({ id = id; text = ""; completed = false }, items, func(a, b) { a.id == b.id });
    switch (itemIndex) {
      case null { false };
      case (?index) {
        let item = items[index];
        let updatedItem = {
          id = item.id;
          text = item.text;
          completed = not item.completed;
        };
        items := Array.tabulate(items.size(), func (i : Nat) : ShoppingItem {
          if (i == index) { updatedItem } else { items[i] }
        });
        true
      };
    }
  };

  // Delete an item from the shopping list
  public func deleteItem(id: Nat) : async Bool {
    let newItems = Array.filter<ShoppingItem>(items, func(item) { item.id != id });
    if (newItems.size() < items.size()) {
      items := newItems;
      true
    } else {
      false
    }
  };
}
