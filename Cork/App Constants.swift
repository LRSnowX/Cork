//
//  App Constants.swift
//  Cork
//
//  Created by David Bureš on 03.07.2022.
//

import Foundation
import OSLog
import UserNotifications

enum AppConstants
{
    // MARK: - Logging

    static let logger: Logger = .init(subsystem: "com.davidbures.cork", category: "Cork")

    // MARK: - Notification stuff

    static let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()

    // MARK: - Proxy settings

    static let proxySettings: (host: String, port: Int)? = {
        let proxySettings: [String: Any]? = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() as? [String: Any]

        guard let httpProxyHost = proxySettings?[kCFNetworkProxiesHTTPProxy as String] as? String
        else
        {
            AppConstants.logger.error("Could not get proxy host")

            return nil
        }
        guard let httpProxyPort = proxySettings?[kCFNetworkProxiesHTTPPort as String] as? Int
        else
        {
            AppConstants.logger.error("Could not get proxy port")

            return nil
        }

        return (host: httpProxyHost, port: httpProxyPort)
    }()

    // MARK: - Basic executables and file locations

    static let brewExecutablePath: URL = {
        /// If a custom Homebrew path is defined, use it. Otherwise, use the default paths
        if let homebrewPath = UserDefaults.standard.string(forKey: "customHomebrewPath"), !homebrewPath.isEmpty
        {
            let customHomebrewPath: URL = .init(string: homebrewPath)!

            return customHomebrewPath
        }
        else
        {
            if FileManager.default.fileExists(atPath: "/opt/homebrew/bin/brew")
            { // Apple Sillicon
                return URL(string: "/opt/homebrew/bin/brew")!
            }
            else
            { // Intel
                return URL(string: "/usr/local/bin/brew")!
            }
        }
    }()

    static let brewCellarPath: URL = {
        if FileManager.default.fileExists(atPath: "/opt/homebrew/Cellar")
        { // Apple Sillicon
            return URL(filePath: "/opt/homebrew/Cellar")
        }
        else
        { // Intel
            return URL(filePath: "/usr/local/Cellar")
        }
    }()

    static let brewCaskPath: URL = {
        if FileManager.default.fileExists(atPath: "/opt/homebrew/Caskroom")
        { // Apple Sillicon
            return URL(filePath: "/opt/homebrew/Caskroom")
        }
        else
        { // Intel
            return URL(filePath: "/usr/local/Caskroom")
        }
    }()

    static let tapPath: URL = {
        if FileManager.default.fileExists(atPath: "/opt/homebrew/Library/Taps")
        { // Apple Sillicon
            return URL(filePath: "/opt/homebrew/Library/Taps")
        }
        else
        { // Intel
            return URL(filePath: "/usr/local/Homebrew/Library/Taps")
        }
    }()

    // MARK: - Storage for tagging

    static let documentsDirectoryPath: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Cork", conformingTo: .directory)
    static let metadataFilePath: URL = documentsDirectoryPath.appendingPathComponent("Metadata", conformingTo: .data)

    // MARK: - Brew Cache

    static let brewCachePath: URL = URL.libraryDirectory.appendingPathComponent("Caches", conformingTo: .directory).appendingPathComponent("Homebrew", conformingTo: .directory) // /Users/david/Library/Caches/Homebrew

    /// These two have the symlinks to the actual downloads
    static let brewCachedFormulaeDownloadsPath: URL = brewCachePath
    static let brewCachedCasksDownloadsPath: URL = brewCachePath.appendingPathComponent("Cask", conformingTo: .directory)

    /// This one has all the downloaded files themselves
    static let brewCachedDownloadsPath: URL = brewCachePath.appendingPathComponent("downloads", conformingTo: .directory)

    // MARK: - Licensing

    static let demoLengthInSeconds: Double = 604_800 // 7 days

    static let authorizationEndpointURL: URL = .init(string: "https://automation.tomoserver.eu/webhook/38aacca6-5da8-453c-a001-804b15751319")!
    static let licensingAuthorization: (username: String, passphrase: String) = ("cork-authorization", "choosy-defame-neon-resume-cahoots")

    // MARK: - Temporary OS version submission

    static let osSubmissionEndpointURL: URL = .init(string: "https://automation.tomoserver.eu/webhook/3a971576-fa96-479e-9dc4-e052fe33270b")!

    // MARK: - Misc Stuff

    static let backgroundUpdateInterval: TimeInterval = 10 * 60
    static let backgroundUpdateIntervalTolerance: TimeInterval = 1 * 60

    static let osVersionString: (lookupName: String, fullName: String) = {
        let versionDictionary: [Int: (lookupName: String, fullName: String)] = [
            15: ("sequoia", "Sequoia"),
            14: ("sonoma", "Sonoma"),
            13: ("ventura", "Ventura"),
            12: ("monterey", "Monterey"),
            11: ("big_sur", "Big Sur"),
            10: ("legacy", "Legacy")
        ]

        let macOSVersionTheUserIsRunning: Int = ProcessInfo.processInfo.operatingSystemVersion.majorVersion

        return versionDictionary[macOSVersionTheUserIsRunning, default: ("legacy", "Legacy")]
    }()
}
