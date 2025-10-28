//
//  WatchlistEditSheet.swift
//  FinanzNachrichten
//
//  Sheet for editing watchlist properties (name, color) and managing items
//

import SwiftUI

struct WatchlistEditSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var watchlistService: WatchlistService

    let watchlist: Watchlist

    @State private var name: String
    @State private var selectedColor: Color
    @State private var showDeleteConfirmation = false
    @State private var dragAmount = CGSize.zero

    init(watchlist: Watchlist) {
        self.watchlist = watchlist
        _name = State(initialValue: watchlist.name)
        _selectedColor = State(initialValue: watchlist.themeColor)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.Section.between) {
                    // Name Section
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                        Text("Name")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                            .textCase(.uppercase)

                        TextField("Watchlist Name", text: $name)
                            .font(DesignSystem.Typography.title2)
                            .padding(DesignSystem.Spacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                    .fill(DesignSystem.Colors.surface)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                            .stroke(DesignSystem.Colors.border, lineWidth: 1)
                                    )
                            )
                    }

                    // Color Section
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                        Text("Theme-Farbe")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                            .textCase(.uppercase)

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: DesignSystem.Spacing.md) {
                            ForEach(Watchlist.themeColors, id: \.name) { theme in
                                Button(action: {
                                    selectedColor = theme.color
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(theme.color)
                                            .frame(width: 50, height: 50)

                                        if selectedColor.toHex() == theme.color.toHex() {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Items Section
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                        Text("Wertpapiere (\(watchlist.items.count))")
                            .font(DesignSystem.Typography.caption2)
                            .foregroundColor(DesignSystem.Colors.secondary)
                            .textCase(.uppercase)

                        if watchlist.items.isEmpty {
                            DSCard(
                                backgroundColor: DesignSystem.Colors.surface,
                                borderColor: DesignSystem.Colors.border,
                                cornerRadius: DesignSystem.CornerRadius.lg,
                                padding: DesignSystem.Spacing.xl,
                                hasShadow: false
                            ) {
                                VStack(spacing: DesignSystem.Spacing.md) {
                                    Image(systemName: "tray")
                                        .font(.system(size: 32))
                                        .foregroundColor(DesignSystem.Colors.secondary.opacity(0.5))

                                    Text("Keine Wertpapiere")
                                        .font(DesignSystem.Typography.body2)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                            }
                        } else {
                            DSCard(
                                backgroundColor: DesignSystem.Colors.cardBackground,
                                borderColor: DesignSystem.Colors.border,
                                cornerRadius: DesignSystem.CornerRadius.lg,
                                padding: 0,
                                hasShadow: true
                            ) {
                                VStack(spacing: 0) {
                                    ForEach(Array(watchlist.items.enumerated()), id: \.element.id) { index, item in
                                        HStack {
                                            // Drag handle
                                            Image(systemName: "line.3.horizontal")
                                                .font(.system(size: 14))
                                                .foregroundColor(DesignSystem.Colors.tertiary)

                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(item.symbol)
                                                    .font(DesignSystem.Typography.body2)
                                                    .foregroundColor(DesignSystem.Colors.onCard)
                                                    .fontWeight(.semibold)

                                                Text(item.name)
                                                    .font(DesignSystem.Typography.caption2)
                                                    .foregroundColor(DesignSystem.Colors.secondary)
                                                    .lineLimit(1)
                                            }

                                            Spacer()

                                            Text(item.changePercent)
                                                .font(DesignSystem.Typography.caption1)
                                                .foregroundColor(item.isPositive ? DesignSystem.Colors.success : DesignSystem.Colors.error)
                                                .fontWeight(.semibold)
                                        }
                                        .padding(DesignSystem.Spacing.md)

                                        if index < watchlist.items.count - 1 {
                                            DSSeparator()
                                                .padding(.horizontal, DesignSystem.Spacing.md)
                                        }
                                    }
                                }
                            }

                            Text("Tipp: Verwende die WatchlistView um Wertpapiere hinzuzufügen oder zu entfernen")
                                .font(DesignSystem.Typography.caption2)
                                .foregroundColor(DesignSystem.Colors.tertiary)
                                .italic()
                        }
                    }

                    // Delete Section
                    if watchlistService.watchlists.count > 1 {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.Section.withinSection) {
                            Text("Löschen")
                                .font(DesignSystem.Typography.caption2)
                                .foregroundColor(DesignSystem.Colors.secondary)
                                .textCase(.uppercase)

                            Button(action: {
                                showDeleteConfirmation = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16))

                                    Text("Watchlist löschen")
                                        .font(DesignSystem.Typography.body2)
                                }
                                .foregroundColor(DesignSystem.Colors.error)
                                .frame(maxWidth: .infinity)
                                .padding(DesignSystem.Spacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                                        .stroke(DesignSystem.Colors.error.opacity(0.5), lineWidth: 1)
                                )
                            }
                        }
                    }
                }
                .padding(DesignSystem.Spacing.Page.horizontal)
                .padding(.top, DesignSystem.Spacing.lg)
                .padding(.bottom, DesignSystem.Spacing.Page.bottom)
            }
            .background(DesignSystem.Colors.background)
            .navigationTitle("Watchlist bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig") {
                        saveChanges()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .alert("Watchlist löschen?", isPresented: $showDeleteConfirmation) {
                Button("Abbrechen", role: .cancel) { }
                Button("Löschen", role: .destructive) {
                    watchlistService.deleteWatchlist(watchlist)
                    dismiss()
                }
            } message: {
                Text("Möchtest du '\(watchlist.name)' wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.")
            }
        }
        .offset(y: dragAmount.height)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        dragAmount = value.translation
                    }
                }
                .onEnded { value in
                    if value.translation.height > 100 {
                        dismiss()
                    } else {
                        withAnimation(.spring()) {
                            dragAmount = .zero
                        }
                    }
                }
        )
    }

    private func saveChanges() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        if !trimmedName.isEmpty && trimmedName != watchlist.name {
            watchlistService.renameWatchlist(watchlist, newName: trimmedName)
        }

        if selectedColor.toHex() != watchlist.color {
            watchlistService.updateWatchlistColor(watchlist, color: selectedColor)
        }
    }
}
