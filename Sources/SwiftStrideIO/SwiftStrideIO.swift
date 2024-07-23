//
//  SwiftStrideIO.swift
//
//  Created by rayhaanalykhan on 09/05/2024.
//
//  This file is part of SwiftStrideIO. For licensing information, see the LICENSE file.
//

import Foundation
import CipherEncryption

/// `SwiftStrideIO `A utility class for caching, retrieving, and fetching data from URLs or local directories.
public class SwiftStrideIO {
    
    public static var defaultKeyEncryption: String.Encryption = .SHA1
    
    private init() { }
    
    /// Caches data asynchronously to disk by generating a cache key from a URL.
    ///
    /// You can change the default encryption type by modifying the `defaultKeyEncryption` static variable.
    ///
    /// - Parameters:
    ///   - data: The data to be cached.
    ///   - url: The URL from where the data was fetched.
    ///   - keyEncryption: The type of encryption used for creating the cache key (default is `defaultKeyEncryption`).
    ///   - completion: A closure called with the cached URL if the operation is successful (default implementation does nothing).
    ///
    public static func cacheData(data: Data?, url: URL, keyEncryption: String.Encryption = defaultKeyEncryption, completion: @escaping (_ cacheUrl: URL?) -> Void = { _ in }) {
        
        // Generates a unique cache key using the URL and encryption type.
        guard let cacheKey = url.absoluteString.encrypt(keyEncryption) else {
            
            print("SwiftStrideIO -> Error: Couldn't generate unique cache key using the URL: \(url)")
            
            DispatchQueue.main.async {
                completion(nil)
            }
            
            return
        }
        
        // Cache the data using the generated key and call the completion handler.
        cacheData(data: data, cacheKey: cacheKey + "." + url.pathExtension, completion: completion)
    }
    
    /// Cache data asynchronously using a given cache key.
    ///
    /// - Parameters:
    ///   - data: Data to be cached.
    ///   - cacheKey: Unique identifier for the data being cached.
    ///   - completion: A closure called with the cached URL if the operation is successful (default implementation does nothing).
    ///
    public static func cacheData(data: Data?, cacheKey: String, completion: @escaping (_ cacheUrl: URL?) -> Void = { _ in }) {

        guard let data else {
            
            print("SwiftStrideIO -> Error: Data is nil")
            
            DispatchQueue.main.async {
                completion(nil)
            }
            
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            
            do {
                let cachesDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                
                let folderUrl = cachesDirectory.appendingPathComponent("SwiftStrideIO")
                
                if !FileManager.default.fileExists(atPath: folderUrl.path) {
                    try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
                }
                
                let destinationUrl = folderUrl.appendingPathComponent(cacheKey)
                
                try data.write(to: destinationUrl, options: .atomic)
                
                DispatchQueue.main.async {
                    completion(destinationUrl)
                }
                
            } catch {
                
                print("SwiftStrideIO -> Error: Couldn't write data: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    /// Retrieve cached data asynchronously based on the original resource URL and a key encryption type.
    ///
    /// You can change the default encryption type by modifying the `defaultKeyEncryption` static variable.
    ///
    /// - Parameters:
    ///   - url: Original URL the data was associated with.
    ///   - keyEncryption: The type of encryption used for creating the cache key (default is `defaultKeyEncryption`).
    ///   - completion: Closure called with the data and cached URL if retrieval is successful.
    ///
    public static func getCachedData(from url: URL, keyEncryption: String.Encryption = defaultKeyEncryption, completion: @escaping (_ data: Data?, _ cacheUrl: URL?) -> Void) {
        
        // Generate a key for looking up the cached data.
        guard let cacheKey = url.absoluteString.encrypt(keyEncryption) else {
            
            print("SwiftStrideIO -> Error: Couldn't generate unique cache key using the URL: \(url)")
            
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            
            return
        }
        
        // Retrieve cached data using the generated cache key and original file extension.
        getCachedData(cacheKey: cacheKey + "." + url.pathExtension, completion: completion)
    }
    
    /// Retrieve cached data asynchronously using a specific cache key.
    ///
    /// - Parameters:
    ///   - cacheKey: The cache key associated to the data.
    ///   - completion: Closure called with the data and cached URL if retrieval is successful.
    ///
    public static func getCachedData(cacheKey: String, completion: @escaping (_ data: Data?, _ cacheUrl: URL?) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            
            do {
                
                let cachesDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                
                let folderUrl = cachesDirectory.appendingPathComponent("SwiftStrideIO")
                
                if !FileManager.default.fileExists(atPath: folderUrl.path) {
                    try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
                }
                
                let sourceUrl = folderUrl.appendingPathComponent(cacheKey)
                
                let data = try Data(contentsOf: sourceUrl)
                
                DispatchQueue.main.async {
                    completion(data, sourceUrl)
                }
                
            } catch {
                
                print("SwiftStrideIO -> Error: Couldn't read data: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
            }
        }
    }
    
    /// Fetches data from a URL string or local directory, which can be optionally combined with a base URL.
    ///
    /// You can change the default encryption type by modifying the `defaultKeyEncryption` static variable.
    ///
    /// - Parameters:
    ///   - urlString: The URL string of the data to fetch.
    ///   - baseUrlString: Optional base URL to be combined with urlString.
    ///   - keyEncryption: The type of encryption used for creating the cache key (default is `defaultKeyEncryption`).
    ///   - completion: Closure called with the data and file URL if retrieval is successful.
    ///
    public static func getData(with urlString: String?, baseUrlString: String?, keyEncryption: String.Encryption = defaultKeyEncryption, completion: @escaping (_ data: Data?, _ localUrl: URL?) -> Void) {
        
        guard let urlString else {
            
            print("SwiftStrideIO -> Error: Missing URL string")
            
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            
            return
        }
        
        guard let url = URL(string: "\(baseUrlString ?? "")\(urlString)") else {
            
            print("SwiftStrideIO -> Error: Invalid URL: \(baseUrlString ?? "")\(urlString)")
            
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            
            return
        }
        
        getData(from: url, keyEncryption: keyEncryption, completion: completion)
    }
    
    /// Fetches data from a URL string or local directory, which can be optionally combined with a base URL.
    ///
    /// You can change the default encryption type by modifying the `defaultKeyEncryption` static variable.
    ///
    /// - Parameters:
    ///   - url: Server or local url
    ///   - baseUrlString: Optional base URL to be combined with urlString.
    ///   - keyEncryption: The type of encryption used for creating the cache key (default is `defaultKeyEncryption`).
    ///   - completion: Closure called with the data and file URL if retrieval is successful.
    ///   
    public static func getData(from url: URL, keyEncryption: String.Encryption = defaultKeyEncryption, completion: @escaping (_ data: Data?, _ localUrl: URL?) -> Void) {
        
        if url.isFileURL {
            
            getLocalData(from: url) { data in
                
                DispatchQueue.main.async {
                    completion(data, url)
                }
            }
            
            return
        }
        
        getCachedData(from: url, keyEncryption: keyEncryption) { data, cacheUrl  in
            
            if data != nil {
                
                DispatchQueue.main.async {
                    completion(data, cacheUrl)
                }
                
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error {
                    
                    print("SwiftStrideIO -> Error: Data couldn't be fetched: \(error)")
                    
                    DispatchQueue.main.async {
                        completion(nil, nil)
                    }
                    
                    return
                }
                
                guard let data else {
                    
                    print("SwiftStrideIO -> Error: No data received")
                    
                    DispatchQueue.main.async {
                        completion(nil, nil)
                    }
                    
                    return
                }
                
                self.cacheData(data: data, url: url, keyEncryption: keyEncryption) { cacheUrl in
                    
                    DispatchQueue.main.async {
                        completion(data, cacheUrl)
                    }
                }
                
            }.resume()
        }
    }
    
    /// Clears all the cache files stored by this package
    ///
    /// Clears the cache by deleting and recreating the `SwiftStrideIO` folder in the cache directory.
    ///
    public static func clearCache() {
        
        DispatchQueue.global(qos: .background).async {
            
            do {
                
                let cachesDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                
                let folderUrl = cachesDirectory.appendingPathComponent("SwiftStrideIO")
                
                // Attempt to remove the folder and its contents, catching any error if it doesn't exist
                try FileManager.default.removeItem(at: folderUrl)
                
                // Create the folder again
                try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
                
                print("SwiftStrideIO -> Success: All cache cleared")
                
            } catch {
                
                print("SwiftStrideIO -> Error: Couldn't clear cache: \(error.localizedDescription)")
            }
        }
    }
    
    // The 'getLocalData' method is private to restrict its use within the class, because our 'getData' function retreives data from local url as well as server url, so we don't have to worry about url type.
    private static func getLocalData(from url: URL, completion: @escaping (_ data: Data?) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            
            do {
                
                let data = try Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    completion(data)
                }
                
            } catch {
                
                print("SwiftStrideIO -> Error: Couldn't read data: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
