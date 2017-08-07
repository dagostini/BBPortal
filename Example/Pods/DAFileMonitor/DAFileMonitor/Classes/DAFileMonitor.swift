//
//  DAFileMonitor.swift
//
//  Created by Dejan on 01/08/2017.
//  Copyright © 2017 Dejan. All rights reserved.
//

import Foundation

open class DAFileMonitor {
    
    private let filePath: String
    private let fileSystemEvent: DispatchSource.FileSystemEvent
    private let dispatchQueue: DispatchQueue
    
    private var eventSource: DispatchSourceFileSystemObject?
    
    public var onFileEvent: (() -> ())? {
        willSet {
            self.eventSource?.cancel()
        }
        didSet {
            if (onFileEvent != nil) {
                self.startObservingFileChanges()
            }
        }
    }
    
    public init?(withFilePath path: String, observeEvent event: DispatchSource.FileSystemEvent = .write, queue: DispatchQueue = DispatchQueue.global(), createFile create: Bool = true) {
        self.filePath = path
        self.fileSystemEvent = event
        self.dispatchQueue = queue
        
        if self.fileExists() == false && create == false {
            return nil
        } else if self.fileExists() == false {
            createFile()
        }
    }
    
    deinit {
        self.eventSource?.cancel()
    }
    
    private func fileExists() -> Bool {
        return FileManager.default.fileExists(atPath: self.filePath)
    }
    
    private func createFile() {
        if self.fileExists() == false {
            FileManager.default.createFile(atPath: self.filePath, contents: nil, attributes: nil)
        }
    }
    
    private func startObservingFileChanges()
    {
        guard fileExists() == true else {
            return
        }
        
        let descriptor = open(self.filePath, O_EVTONLY)
        if descriptor == -1 {
            return
        }
        
        self.eventSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: descriptor, eventMask: self.fileSystemEvent, queue: self.dispatchQueue)
        
        self.eventSource?.setEventHandler {
            [weak self] in
            self?.onFileEvent?()
        }
        
        self.eventSource?.setCancelHandler() {
            close(descriptor)
        }
        
        self.eventSource?.resume()
    }
}
