//
//  DocumentTableViewController.swift
//  DocumentApp
//
//  Created by Hugo RAGUIN on 11/18/24.
//

import UIKit
import QuickLook

// MARK: - Extension de Int
extension Int {
    func formattedSize() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        formatter.includesUnit = true // Inclut les unités comme "KB", "MB", etc.
        return formatter.string(fromByteCount: Int64(self))
    }
}

// MARK: - Classe DocumentTableViewCell
class DocumentTableViewCell: UITableViewCell {
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Subtitle: UILabel!
}

// MARK: - Classe DocumentTableViewController
class DocumentTableViewController: UITableViewController, UISearchResultsUpdating {

    struct DocumentFile {
        var title: String
        var size: Int
        var imageName: String? = nil
        var url: URL
        var type: String
    }

    var importedDocuments: [DocumentFile] = []
    var bundleDocuments: [DocumentFile] = []

    var filteredImportedDocuments: [DocumentFile] = []
    var filteredBundleDocuments: [DocumentFile] = []

    var selectedDocument: DocumentFile?

    var isFiltering: Bool {
        return navigationItem.searchController?.isActive == true && !(navigationItem.searchController?.searchBar.text?.isEmpty ?? true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        listFiles()
        tableView.reloadData()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument))

        // Initialiser le UISearchController
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Rechercher un document"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    @objc func addDocument() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }

    func copyFileToDocumentsDirectory(fromUrl url: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)

        do {
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                // Si le fichier existe déjà, le supprimer avant de le copier
                try FileManager.default.removeItem(at: destinationUrl)
            }
            try FileManager.default.copyItem(at: url, to: destinationUrl)
        } catch {
            print("Error copying file: \(error)")
        }
    }

    func listFiles() {
        importedDocuments = []
        bundleDocuments = []

        // List files in the app's documents directory (imported files)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentItems = try! FileManager.default.contentsOfDirectory(atPath: documentsDirectory.path)

        for item in documentItems {
            let currentUrl = documentsDirectory.appendingPathComponent(item)
            let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])

            importedDocuments.append(DocumentFile(
                title: resourcesValues.name!,
                size: resourcesValues.fileSize ?? 0,
                imageName: nil,
                url: currentUrl,
                type: resourcesValues.contentType?.description ?? "Unknown"
            ))
        }

        // List files in the app bundle
        let bundlePath = Bundle.main.resourcePath!
        let bundleItems = try! FileManager.default.contentsOfDirectory(atPath: bundlePath)

        for item in bundleItems {
            if !item.hasSuffix("DS_Store") {
                let currentUrl = URL(fileURLWithPath: bundlePath).appendingPathComponent(item)
                let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])

                bundleDocuments.append(DocumentFile(
                    title: resourcesValues.name!,
                    size: resourcesValues.fileSize ?? 0,
                    imageName: item,
                    url: currentUrl,
                    type: resourcesValues.contentType?.description ?? "Unknown"
                ))
            }
        }
    }

    // MARK: - Filtrage

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        filterContentForSearchText(searchText)
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredImportedDocuments = importedDocuments.filter { document in
            return document.title.lowercased().contains(searchText)
        }

        filteredBundleDocuments = bundleDocuments.filter { document in
            return document.title.lowercased().contains(searchText)
        }

        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Importés et Bundle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return isFiltering ? filteredImportedDocuments.count : importedDocuments.count
        } else {
            return isFiltering ? filteredBundleDocuments.count : bundleDocuments.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Importés"
        } else {
            return "Bundle"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DocumentTableViewCell

        let document: DocumentFile

        if indexPath.section == 0 {
            document = isFiltering ? filteredImportedDocuments[indexPath.row] : importedDocuments[indexPath.row]
        } else {
            document = isFiltering ? filteredBundleDocuments[indexPath.row] : bundleDocuments[indexPath.row]
        }

        cell.Title.text = document.title
        cell.Subtitle.text = "\(document.size.formattedSize()) - \(document.type)"
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: - Sélection d'une ligne dans le TableView

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            selectedDocument = isFiltering ? filteredImportedDocuments[indexPath.row] : importedDocuments[indexPath.row]
        } else {
            selectedDocument = isFiltering ? filteredBundleDocuments[indexPath.row] : bundleDocuments[indexPath.row]
        }

        let previewController = QLPreviewController()
        previewController.dataSource = self

        navigationController?.pushViewController(previewController, animated: true)
    }
}

// MARK: - Extension pour QLPreviewControllerDataSource
extension DocumentTableViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return selectedDocument!.url as QLPreviewItem
    }
}

// MARK: - Extension pour UIDocumentPickerDelegate
extension DocumentTableViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else { return }
        copyFileToDocumentsDirectory(fromUrl: selectedURL)

        listFiles()
        tableView.reloadData()
    }
}
