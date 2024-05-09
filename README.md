# SwiftStrideIO

A Swift library to manage easy caching and retrieval of data from URLs with support for custom key encryption strategies.

## Features

- Easy access throughout your project via a unified interface
- Asyncronous data caching and retrieval
- Customizable encryption for cache keys using SHA1 or SHA256
- Fetch data with ease, regardless of whether the URL points to a local or remote resource
- Automatically cache data while retrieving data from server
- Option to cache and retrieve data using your own (unique) identifier.

## Installation

### Swift Package Manager (SPM) using Xcode

To integrate SwiftStrideIO into your Xcode project using Swift Package Manager, follow these steps:

1. Open your project in Xcode.
2. Navigate to the menu bar and click `File` > `Swift Packages` > `Add Package Dependency...`.
3. In the search bar of the new window that appears, paste the following URL: `https://github.com/rayhaanalykhan/SwiftStrideIO.git`
4. Follow the on-screen instructions to choose the package options and the version you want to integrate.
5. Once completed, Xcode will download the package and add it to your project navigator.

By installing SwiftStrideIO using above instructions, you will also automatically resolve dependencies such as the CipherEncryption library used by this package.

## Usage

To use SwiftStrideIO in your project, you will typically follow these steps:

1. **Default Encryption for Key:**

    Set a default encryption type for key using as follows:

    ```swift
    SwiftStrideIO.shared.defaultKeyEncryption = .sha1
    ```

2. **Caching Data:**

    To cache data from a URL, use the `cacheData` method:

    ```swift
    SwiftStrideIO.shared.cacheData(data: someData, url: someURL)
    ```
    Handle cache url if needed

    ```swift
    SwiftStrideIO.shared.cacheData(data: someData, url: someURL) { cacheUrl in }
    ```

    Similary cache data using your own key

    ```swift
    SwiftStrideIO.shared.cacheData(data: someData, cacheKey: "someKey")
    ```
    Handle cache url if needed

    ```swift
    SwiftStrideIO.shared.cacheData(data: someData, cacheKey: "someKey") { cacheUrl in }
    ```

3. **Retrieving Cached Data:**

    To retrieve data from cache , use the `getCachedData` method:

    ```swift
    SwiftStrideIO.shared.getCachedData(from: someURL) { (data, cacheUrl) in
        // Use the retrieved data from cache or use/pass cache url
    }
    ```
    Or use a cache key to retrieve data

    ```swift
    SwiftStrideIO.shared.getCachedData(cacheKey: "someKey") { (data, cacheUrl) in
        // Use the retrieved data from cache or use/pass cache url
    }
    ```

4. **Fetching Data:**

    To retrieve from a local URL or to retrieve and cache data from server url, use the `getData` method:
   
    ```swift
    SwiftStrideIO.shared.getData(from: someURL) { (data, localUrl) in
        // Process the fetched data
    }
    ```
    Alternatively you can use a string url with optional base url string parameter
    ```swift
    SwiftStrideIO.shared.getData(with: "path/or/url", baseUrlString: "optional/baseUrl") { (data, localUrl) in
        // Process the fetched data
    }
    ```


## License

SwiftStrideIO is released under the MIT License. See the [LICENSE](LICENSE) file for further details.

## Contribution

Contributors are welcomed to fork the project and submit pull requests. Please include unit tests if possible for any new or existing functionality. Also, update the README accordingly.

## Contact

For further information, contact rayhaanalykhan at their [GitHub profile](https://github.com/rayhaanalykhan).
