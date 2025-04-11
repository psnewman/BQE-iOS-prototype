import SwiftUI
import Combine

class ReportCenterViewModel: ObservableObject {
    @Published var reports: [Report] = []
    @Published var expandedReportIds: Set<UUID> = []
    @Published var searchText: String = ""
    @Published var selectedReportType: ReportType? = nil
    @Published var selectedFolder: String = "All Reports"
    
    // Available folders
    let folders = ["All Reports", "Favorites", "Recent", "Shared with me"]
    
    init() {
        loadSampleReports()
    }
    
    func loadSampleReports() {
        reports = Report.sampleReports()
        // Initialize expanded state based on the isExpanded property
        expandedReportIds = Set(reports.filter { $0.isExpanded }.map { $0.id })
    }
    
    func toggleReportExpansion(reportId: UUID) {
        if expandedReportIds.contains(reportId) {
            expandedReportIds.remove(reportId)
        } else {
            expandedReportIds.insert(reportId)
        }
    }
    
    func isReportExpanded(reportId: UUID) -> Bool {
        return expandedReportIds.contains(reportId)
    }
    
    func filteredReports() -> [Report] {
        var filtered = reports
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { 
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.template.lowercased().contains(searchText.lowercased()) ||
                $0.owner.lowercased().contains(searchText.lowercased()) ||
                $0.viewAccess.lowercased().contains(searchText.lowercased())
            }
        }
        
        // Filter by report type
        if let selectedType = selectedReportType {
            filtered = filtered.filter { $0.type == selectedType }
        }
        
        // Sort by name (as shown in Figma)
        return filtered.sorted { $0.name < $1.name }
    }
    
    func runReport(reportId: UUID) {
        // Implementation for running a report
        print("Running report with ID: \(reportId)")
    }
    
    func editReport(reportId: UUID) {
        // Implementation for editing a report
        print("Editing report with ID: \(reportId)")
    }
    
    func deleteReport(reportId: UUID) {
        // Implementation for deleting a report
        withAnimation {
            reports.removeAll { $0.id == reportId }
            // Also remove from expanded set
            expandedReportIds.remove(reportId)
        }
    }
}
