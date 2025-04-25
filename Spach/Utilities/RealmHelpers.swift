// Utilities/RealmHelpers.swift
import Foundation
import RealmSwift

/// Гарантує, що папка під default.realm існує
func ensureRealmFolderExists() {
    guard let fileURL = Realm.Configuration.defaultConfiguration.fileURL else {
        return
    }
    let folderURL = fileURL.deletingLastPathComponent()
    try? FileManager.default.createDirectory(
        at: folderURL,
        withIntermediateDirectories: true,
        attributes: nil
    )
}
