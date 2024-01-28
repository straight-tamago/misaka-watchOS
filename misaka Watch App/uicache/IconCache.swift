//
//  IconCache.swift
//  misaka
//
//  Created by mini on 2023/08/07.
//

import Foundation
import UniformTypeIdentifiers
import Dynamic
import UIKit

var connection: NSXPCConnection?

func RemoveIconCache(alert: Bool) {
    print("removing icon cache")
    if connection == nil {
        let myCookieInterface = NSXPCInterface(with: ISIconCacheServiceProtocol.self)
        connection = Dynamic.NSXPCConnection(machServiceName: "com.apple.iconservices", options: []).asObject as? NSXPCConnection
        connection!.remoteObjectInterface = myCookieInterface
        connection!.resume()
        print("Connection: \(connection!)")
    }
    
    (connection!.remoteObjectProxy as AnyObject).clearCachedItems(forBundeID: nil) { (a: Any, b: Any) in // passing nil to remove all icon cache
        print("Successfully responded (\(a), \(b ?? "(null)"))")
        if alert {
            UIApplication.shared.alert(title: MILocalizedString("Succeed"), body: MILocalizedString("All Caches are deleted"))
        }
    }
}
