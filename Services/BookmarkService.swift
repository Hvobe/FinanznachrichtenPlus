//
//  BookmarkService.swift
//  FinanzNachrichten
//
//  Service für die Verwaltung von gebookmarkten Nachrichten-Artikeln
//
//  FUNKTIONEN:
//  - Speichert Article-IDs und vollständige Article-Details
//  - Persistierung über UserDefaults mit JSON-Encoding
//  - Automatisches Laden beim Start
//  - ObservableObject für automatische UI-Updates
//

import SwiftUI

/// Service managing bookmarked news articles with persistence
/// Stores both article IDs for quick lookup and full article details for display
class BookmarkService: ObservableObject {
    /// Array of bookmarked article IDs for quick bookmark status checks
    @Published var bookmarkedArticles: [String] = []

    /// Full article details for displaying bookmarked articles in lists
    @Published var bookmarkedArticleDetails: [BookmarkedArticle] = []

    private let bookmarksKey = "bookmarkedArticles"        // IDs persistence key
    private let articlesKey = "bookmarkedArticleDetails"    // Details persistence key
    private let toastShownKey = "hasShownBookmarkToast"    // First-time toast flag

    /// Initializes service and loads persisted bookmarks
    init() {
        loadBookmarks()
        loadArticleDetails()
    }

    // MARK: - First-Time Bookmark Experience

    /// Checks if the user has bookmarked an article before
    /// Used to show first-time bookmark toast notification
    /// - Returns: True if user has bookmarked at least once
    func hasUserBookmarkedBefore() -> Bool {
        return UserDefaults.standard.bool(forKey: toastShownKey)
    }

    /// Marks that the user has seen the first-time bookmark toast
    /// Should be called after showing the toast for the first time
    func markFirstBookmarkSeen() {
        UserDefaults.standard.set(true, forKey: toastShownKey)
    }

    /// Checks if an article is currently bookmarked
    /// - Parameter articleId: The article ID to check
    /// - Returns: True if the article is bookmarked
    func isBookmarked(_ articleId: String) -> Bool {
        bookmarkedArticles.contains(articleId)
    }

    /// Toggles bookmark status for an article ID
    /// Note: This only toggles the ID, use bookmarkArticle() for full article bookmarking
    /// - Parameter articleId: The article ID to toggle
    func toggleBookmark(_ articleId: String) {
        if isBookmarked(articleId) {
            removeBookmark(articleId)
        } else {
            addBookmark(articleId)
        }
    }
    
    /// Adds an article ID to bookmarks (internal use only)
    /// - Parameter articleId: The article ID to bookmark
    private func addBookmark(_ articleId: String) {
        bookmarkedArticles.append(articleId)
        saveBookmarks()
    }

    /// Removes an article ID from bookmarks (internal use only)
    /// - Parameter articleId: The article ID to remove
    private func removeBookmark(_ articleId: String) {
        bookmarkedArticles.removeAll { $0 == articleId }
        saveBookmarks()
    }

    /// Persists bookmarked article IDs to UserDefaults
    private func saveBookmarks() {
        UserDefaults.standard.set(bookmarkedArticles, forKey: bookmarksKey)
    }

    /// Loads bookmarked article IDs from UserDefaults
    private func loadBookmarks() {
        if let bookmarks = UserDefaults.standard.array(forKey: bookmarksKey) as? [String] {
            bookmarkedArticles = bookmarks
        }
    }

    /// Bookmarks a news article with full details
    /// Stores both the article ID for quick checks and full article data for display
    /// - Parameter article: The news article to bookmark
    func bookmarkArticle(_ article: NewsArticle) {
        let bookmarkedArticle = BookmarkedArticle(
            id: article.id.uuidString,
            title: article.title,
            category: article.category,
            time: article.time,
            source: article.source,
            hasImage: article.hasImage,
            bookmarkedDate: Date()
        )
        
        bookmarkedArticleDetails.append(bookmarkedArticle)
        bookmarkedArticles.append(article.id.uuidString)
        saveArticleDetails()
        saveBookmarks()
    }
    
    /// Removes a bookmarked article completely
    /// Removes both the article ID and full article details
    /// - Parameter articleId: The article ID to remove
    func removeBookmarkedArticle(_ articleId: String) {
        bookmarkedArticleDetails.removeAll { $0.id == articleId }
        bookmarkedArticles.removeAll { $0 == articleId }
        saveArticleDetails()
        saveBookmarks()
    }

    /// Persists article details to UserDefaults with JSON encoding
    private func saveArticleDetails() {
        if let encoded = try? JSONEncoder().encode(bookmarkedArticleDetails) {
            UserDefaults.standard.set(encoded, forKey: articlesKey)
        }
    }

    /// Loads article details from UserDefaults
    func loadArticleDetails() {
        if let data = UserDefaults.standard.data(forKey: articlesKey),
           let decoded = try? JSONDecoder().decode([BookmarkedArticle].self, from: data) {
            bookmarkedArticleDetails = decoded
        }
    }
}