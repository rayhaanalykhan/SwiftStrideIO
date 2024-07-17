# SwiftStrideIO

A Swift library for easy caching and retrieval of data from URLs, featuring automatic caching and support for custom key encryption strategies.

## Features

- Easy access throughout your project via a unified interface.
- Asyncronous data caching and retrieval.
- Customizable encryption for cache keys using various encryption [algorithms](https://github.com/rayhaanalykhan/CipherEncryption/blob/main/README.md#algorithms-list) provided by [CipherEncryption](https://github.com/rayhaanalykhan/CipherEncryption).
- Fetch data with ease, regardless of whether the URL points to a local or remote resource.
- Automatically cache data while retrieving data from server.
- Option to cache and retrieve data using your own (unique) identifier.

## Installation

### Swift Package Manager (SPM) using Xcode

To integrate SwiftStrideIO into your Xcode project using Swift Package Manager, follow these steps:

1. Open your project in Xcode.
2. Navigate to the menu bar and click `File` > `Swift Packages` > `Add Package Dependency...`.
3. In the search bar of the new window that appears, paste the following URL: `https://github.com/rayhaanalykhan/SwiftStrideIO.git`
4. Follow the on-screen instructions to choose the package options and the version you want to integrate.
5. Once completed, Xcode will download the package and add it to your project navigator.

By installing SwiftStrideIO using above instructions, you will also automatically resolve [CipherEncryption](https://github.com/rayhaanalykhan/CipherEncryption) dependency used by this package.

## Usage

To use SwiftStrideIO in your project, you can call its static methods directly:

1. **Caching Data:**

    To cache data from a URL, use the `cacheData` method:

    ```swift
    // replace Data() with your Data
    SwiftStrideIO.cacheData(data: Data(), url: URL(string: "https://www.someurl.com/dummy")!)
    ```
    Handle cache url if needed

    ```swift
    // replace Data() with your Data
    SwiftStrideIO.cacheData(data: Data(), url: URL(string: "https://www.someurl.com/dummy")!) { cacheUrl in }
    ```

    Similary cache data using your own key

    ```swift
    // replace Data() with your Data
    SwiftStrideIO.cacheData(data: Data(), cacheKey: "someKey")
    ```
    Handle cache url if needed

    ```swift
    // replace Data() with your Data
    SwiftStrideIO.cacheData(data: Data(), cacheKey: "someKey") { cacheUrl in }
    ```

2. **Retrieving Cached Data:**

    To retrieve data from cache, use the `getCachedData` method:

    ```swift
    SwiftStrideIO.getCachedData(from: URL(string: "https://www.someurl.com/dummy")!) { (data, cacheUrl) in
        // Use the retrieved data from cache or use/pass cache url
    }
    ```
    Or use a cache key to retrieve data

    ```swift
    SwiftStrideIO.getCachedData(cacheKey: "someKey") { (data, cacheUrl) in
        // Use the retrieved data from cache or use/pass cache url
    }
    ```

3. **Fetching Data:**

    To retrieve data from a local URL or to <strong>retrieve and cache data</strong> from server url, use the `getData` method:
   
    ```swift
    SwiftStrideIO.getData(from: URL(string: "https://www.someurl.com/dummy")!) { (data, localUrl) in
        // Process the fetched data
    }
    ```
    Alternatively you can use a string url with optional base url string parameter
    ```swift
    SwiftStrideIO.getData(with: "path/or/url", baseUrlString: "optional/baseUrl") { (data, localUrl) in
        // Process the fetched data
    }
    ```


## License

SwiftStrideIO is released under the MIT License. See the [LICENSE](LICENSE) file for further details.

## Contribution

Contributors are welcomed to fork the project and submit pull requests. Please include unit tests if possible for any new or existing functionality. Also, update the README accordingly.

## Contact

For further information, contact me via email [rayhaanalykhan@gmail.com](mailto:rayhaanalykhan@gmail.com).
