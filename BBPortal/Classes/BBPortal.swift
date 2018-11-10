//
//  BBPortal.swift
//
//  Created by Dejan on 30/07/2017.
//  Copyright © 2017 Dejan. All rights reserved.
//

import Foundation
import DAFileMonitor

public protocol BBPortalProtocol {
    func send(data: Any, onCompleted: ((NSError?) -> ())?)
    var onDataAvailable: ((Any) -> ())? { get set }
}

open class BBPortal: BBPortalProtocol
{
    public var onDataAvailable: ((Any) -> ())?
    
    private let objectID = UUID()
    
    private let groupID: String
    private let portalID: String
    
    private var coordinator: NSFileCoordinator?
    
    private var portalQueue: OperationQueue?
    
    
    // MARK: - Initialization
    
    public init(withGroupIdentifier group: String, andPortalID portal: String)
    {
        self.groupID = group
        self.portalID = portal
        
        self.coordinator = NSFileCoordinator()
        
        self.portalQueue = OperationQueue()
        self.portalQueue?.maxConcurrentOperationCount = 1
        
        startObservingFileChanges()
    }
    
    deinit {
        self.coordinator?.cancel()
        self.portalQueue?.cancelAllOperations()
    }
    
    
    // MARK: - Sender/Observer
    
    private enum DictKey: String {
        case sender, payload
    }
    
    public func send(data: Any, onCompleted: ((NSError?) -> ())? = nil) {
        if let url = fileURL() {
            
            portalQueue?.addOperation {
                [weak self] in
                var error: NSError?
                self?.coordinator?.coordinate(writingItemAt: url, options: .forReplacing, error: &error, byAccessor: { (url) in
                    
                    let dictToSave: [String: Any?] = [DictKey.sender.rawValue: self?.objectID,
                                                      DictKey.payload.rawValue: data]
                    
                    let dictData = NSKeyedArchiver.archivedData(withRootObject: dictToSave)
                    try? dictData.write(to: url)
                    
                    onCompleted?(nil)
                })
                
                if let error = error {
                    onCompleted?(error)
                }
            }
        }
    }
    
    private var fileMonitor: DAFileMonitor?
    private func startObservingFileChanges()
    {
        guard let filePath = fileURL()?.path else {
            return
        }
        self.fileMonitor = DAFileMonitor(withFilePath: filePath)
        self.fileMonitor?.onFileEvent = {
            [weak self] in
            let dict = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [String: Any?] ?? [:]
            
            // Don't call the closure if you're the one sending the data through the portal.
            if let senderID = dict[DictKey.sender.rawValue] as? UUID, senderID != self?.objectID {
                guard let payload = dict[DictKey.payload.rawValue], payload != nil else {
                    return
                }
                self?.onDataAvailable?(payload!)// Safe to force unwrap because of the guard.
            }
        }
    }
    
    
    // MARK: - Utility
    
    private func containerURL() -> URL? {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)
    }
    
    private func fileURL() -> URL? {
        return containerURL()?.appendingPathComponent(portalID).appendingPathExtension("bbportal")
    }
}

