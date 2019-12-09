//
//  ImageLoader.swift
//  MultiSelectionTable-Example
//
//  Created by Nuno Gonçalves on 12/12/16.
//
//

import UIKit

struct Cache {
    
    final class ImageLoader {
        
        static let shared = ImageLoader()
        
        fileprivate let cache: NSCache<NSString, UIImage> = {
            let cache = NSCache<NSString, UIImage>()
            cache.name = "ImageCache"
            return cache
        }()
        
        fileprivate let physicalCacheURL: URL = {
            var url = try! FileManager.default.url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            url = url.appendingPathComponent("ImageCache", isDirectory: true)
            
            try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            
            return url
        }()
        
        func cachedImage(with url: URL) -> UIImage? {
            let hash = "\(url.hashValue)" as NSString

            print(hash)
            // Check if image exists on volatile cache
            if let image = cache.object(forKey: hash) {
                return image
            }
            
            // Check if image exists on physical cache
            if let image = UIImage(contentsOfFile: pathOnPhysicalCacheForFile(with: hash)) {
                cache.setObject(image, forKey: hash)
                return image
            }
            
            return nil
        }
        
        func image(with url: URL, completionHandler: @escaping (UIImage) -> Void){
            let request = URLRequest(url: url)
            image(with: request, completionHandler: completionHandler)
        }
        
        private func image(with request: URLRequest, completionHandler: @escaping (UIImage) -> Void) {
            let hash = String(describing: request.url.hash) as NSString
            
            if let image = cache.object(forKey: hash) {
                completionHandler(image)
                return
            }
            
            if let image = UIImage(contentsOfFile: pathOnPhysicalCacheForFile(with: hash)) {
                cache.setObject(image, forKey: hash)
                completionHandler(image)
                return
            }
            
            // Download
            let task = URLSession.shared.downloadTask(with: request) { url, response, error in
                guard let tempUrl = url else {
                    print("Error downloading \(request)")
                    print("Error \(error)")
                    print("Response \(response)")
                    return
                }
                let finalUrl = self.URLOnPhysicalCacheForFile(with: hash)
                
                self.saveFile(in: finalUrl, with: hash, oldUrl: tempUrl, completionHandler: completionHandler)
                
            }
            task.resume()
        }
        
        private func saveFile(
            in url: URL,
            with hash: NSString,
            oldUrl: URL,
            completionHandler: @escaping (UIImage) -> Void
        ) {
            do {
                if FileManager.default.fileExists(atPath: url.path) {
                    try FileManager.default.removeItem(at: url)
                }
                
                try FileManager.default.moveItem(at: oldUrl, to: url)
                if let image = UIImage(contentsOfFile: url.path) {
                    self.cache.setObject(image, forKey: hash)
                    OperationQueue.main.addOperation {
                        completionHandler(image)
                    }
                }
                
            } catch {
                print("Error saving image to final location: \(error)")
            }
        }
        
        private func URLOnPhysicalCacheForFile(with hash: NSString) -> URL {
            let URL = physicalCacheURL.appendingPathComponent(hash as String)
            return URL
        }
        
        private func pathOnPhysicalCacheForFile(with hash: NSString) -> String {
            return URLOnPhysicalCacheForFile(with: hash).path
        }
    }
}
