//
//  PublicKey+CoreDataProperties.swift
//  StorageV1
//
//  Created by Ray Chen on 10/20/21.
//
//

import Foundation
import CoreData


extension PublicKey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PublicKey> {
        return NSFetchRequest<PublicKey>(entityName: "PublicKey")
    }

    @NSManaged public var keyBody: Data?
    @NSManaged public var contact: Contact?
    @NSManaged public var encryptedSender: Encrypted?
    @NSManaged public var identity: Identity?

}

extension PublicKey : Identifiable {

}
