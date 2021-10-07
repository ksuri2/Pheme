//
//  ContentView.swift
//  StorageV1
//
//  Created by Ray Chen on 10/6/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
//	sort message with timeCreated, can be changed to different entity to test CRUD functions
//	to test other entities, they need to be fetchrequested as well
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Message.timeCreated, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Message>

//	add more var here to test create with multiple input item
    @State private var newItem = ""

    var body: some View {
        NavigationView {
			List {
				Section(header: Text("Add message")) {
					HStack{
//						add more TextField here to test create with multiple input item
						TextField("New message", text: self.$newItem)
						Button(action: {
//						change the function here to test other CRUD
							creatMessage(body: self.newItem)
						}){
							Image(systemName: "plus.circle.fill")
								 .foregroundColor(.blue)
								 .imageScale(.large)
						}
					}
				}
				ForEach(items) { item in
//				change what to show here to check succeeful creation
					Text(item.messageBody ?? "Unspecified")
				}.onDelete(perform: deleteItem(offsets:))
			}
			.navigationTitle("Items")
		}
    }
//	sample functions for creation an entity
    private func creatMessage(body: String) {
        withAnimation {
            let newMessage = Message(context: viewContext)
            newMessage.timeCreated = Date()
            newMessage.messageBody = body
            saveContext()
        }
    }
    
//    private func createIdentity(nickname: String) {
//		withAnimation {
//            let newIdentity = Identity(context: viewContext)
//            newIdentity.nickname = nickname
//            saveContext()
//        }
//	}

	
    
//    sample function to delete entity by swiping to left, more delete functions are needed like deleteMessage() below
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
//		sample functions for creation an entity
	private func deleteMessage(item: Message) {
		withAnimation {
			viewContext.delete(item)
			saveContext()
		}
	}
    
//    used at the end of all CRUD functions
    private func saveContext() {
		do {
                try viewContext.save()
            } catch {let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
	}
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}