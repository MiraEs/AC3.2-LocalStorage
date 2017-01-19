//
//  BlockGroundAPIManager.swift
//  AC3.2-LocalStorage
//
//  Created by Louis Tur on 1/16/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation
import UIKit


struct BlockGroundConstant {
    static let notSet = "Not Set"
    static let baseURL = "https://api.fieldbook.com/v1/"
    static let imageEndPoint = "/images"
}

// add in download delegation
internal class BlockGroundAPIManager: NSObject, URLSessionDownloadDelegate {
    private var bookId: String
    private var baseURL: String
    private var session: URLSession! //= URLSession.shared // wait why did we comment this out for line 33??
    
    static let shared: BlockGroundAPIManager = BlockGroundAPIManager()
    private override init() {
        bookId = BlockGroundConstant.notSet
        baseURL = BlockGroundConstant.baseURL
    }
    
    internal func configure(bookId: String, baseURL: String = BlockGroundConstant.baseURL) {
        self.bookId = bookId
        self.baseURL = baseURL
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    internal func requestAllBlockGrounds(completion: @escaping ([BlockGround]?, Error?)->Void) {
        var completionArray: [BlockGround]? = []
        
        // define URL from base + bookId + endpoint
        let url = URL(string: BlockGroundConstant.baseURL + bookId + BlockGroundConstant.imageEndPoint)!
        
        // create data task
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // check for errors
            if error != nil {
                print("Error during session \(error)")
            }
            
            // check for data
            guard let validData = data else { return }
            
            // parse model objects
            do {
                let validArr = try JSONSerialization.jsonObject(with: validData, options: []) as! [[String: AnyHashable]]
                //dump(validArr)
                for dict in validArr {
                    guard let validObject = BlockGround(json: dict) else { continue }
                    completionArray?.append(validObject)
                }
            } catch {
                print(error.localizedDescription)
            }
            
            // implement completions
            }.resume()
        
    }
    
    internal func downloadBlockGround(_ blockground: BlockGround, completion: @escaping (UIImage?)->Void) {
        // define url from blockground model
        let url = URL(string: blockground.imageFullResURL)!
        
        // create download task for session.. with or without handler?
//        session.downloadTask(with: url) {(url: URL?, response: URLResponse?, error: Error?) in
//            if error != nil {
//                print("Error during image download session \(error!.localizedDescription)")
//            }
//            
//            if url != nil {
//                do {
//                    let imageData = try Data(contentsOf: url!)
//                    
//                    if let imageFromData = UIImage(data: imageData) {
//                        
//                        completion(imageFromData)
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//            }.resume()
        

        // start task
        let downloadTask = session.downloadTask(with: url)
        
        // give task a description
        downloadTask.taskDescription = blockground.shortName
        downloadTask.resume()
    }
    
    // MARK: - Download Delegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // check for finished download
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //if you specift completion handler -- ignores delegate functions cuz assumes only using completion handlers (comment 75-92 with closure url)
        
        // keep track of periodic downloads
        
        // check for % completed and print
        
        // what do we do when the nsurl session transfer size is unknown?
        // lets display some info at least (MB)
    }
    
}
