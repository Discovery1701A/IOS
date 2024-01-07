//
//  FieldView.swift
//  Gausen
//
//  Created by Anna Rieckmann on 15.12.23.
//
// Struct für ein Zahlenfeld

import SwiftUI

struct FieldView: View {
    let field: ViewModel.Field

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)

                // Hintergrundfarbe mit Animation basierend auf den Feldattributen
                withAnimation {
                    shape.fill().foregroundColor(backColor())
                }
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)

                // Text im Feld mit flexibler Schriftgröße basierend auf der Anzahl der Ziffern
                withAnimation {
                    Text(String(field.content))
                        .font(font(in: geometry.size, content: String(field.content)))
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }

    // Bestimmt die Hintergrundfarbe basierend auf den Feldattributen
    private func backColor() -> Color {
        if field.winning {
            return .green
        } else if field.draged {
            return .cyan
        } else if field.selection {
            return Color(hex: 0x2080A5) // Benutzerdefinierte Farbe aus Hex-Wert ein Blauton
        } else if field.notDiv {
            return Color.red
        } else {
            return .orange
        }
    }

    private func font(in size: CGSize, content: String) -> Font {
        // Zuerst wird die Basisschriftgröße berechnet, die auf der kleineren Dimension des Feldes skaliert wird.
        let fontSize = min(size.width, size.height) * DrawingConstants.fontScale

        // Die Anzahl der Ziffern im Inhalt wird ermittelt.
        let numberCount = content.count

        // Wenn mehr als eine Ziffer vorhanden ist, wird die Schriftgröße für jede Ziffer entsprechend reduziert.
        // Andernfalls bleibt die ursprüngliche Basisschriftgröße unverändert.
        let newFontSize = numberCount > 1 ? fontSize * (1.0 / CGFloat(numberCount)) : fontSize

        // Die berechnete Schriftgröße wird als Systemfont mit dem angepassten Wert zurückgegeben.
        return Font.system(size: newFontSize)
    }

    // Konstanten für das Zeichnen von Feldern
    enum DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 2
        static let fontScale: CGFloat = 0.8
    }
}

// Modifier für die Berechnung und Verwaltung der Feldgröße
struct FieldSizeModifier: ViewModifier {
    // Bindung an die Größe des Feldes
    @Binding var fieldSize: CGSize

    // Zustandsvariablen zur Verfolgung der vorherigen Feldgrößen
    @State private var previousSize: CGSize = .zero

    // Körpereigenschaft für die Ansicht, die den Modifier verwendet
    func body(content: Content) -> some View {
        content
            .background(
                // GeometryReader, um die Größe der umgebenden Ansicht zu erhalten
                GeometryReader { geo in
                    Color.clear
                        // Aktualisiert die Größenpräferenz mit der aktuellen Größe des Feldes
                        .preference(key: SizePreferenceKey.self, value: geo.size)
                        .onAppear {
                            self.fieldSize = geo.size
                        }
                        .onChange(of: geo.size) { _, _ in
                            // Ein Timer wird verwendet, um regelmäßig die Größe des Feldes zu überprüfen
                            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                                // Setzt die Feldgröße, wenn sie zuvor noch nicht gesetzt wurde
                                if self.fieldSize == .zero {
                                    self.fieldSize = geo.size
                                }
                                //                                print(geo.size, fieldSize, previousSize)
                                // Überprüft, ob sich die aktuelle Größe von der vorherigen Feldgröße unterscheidet
                                if geo.size != self.fieldSize {
                                    //                                    print("aspera")
                                    // Überprüft auf signifikante Größenänderungen in Breite oder Höhe
                                    if (geo.size.width > self.fieldSize.width + 0.5)
                                        || (geo.size.width < self.fieldSize.width - 0.5) || geo.size.height > self.fieldSize.height + 0.5
                                        || geo.size.height < self.fieldSize.height - 0.5 {
                                        //                                        print("dupdidu")
                                        // Setzt die Feldgröße auf die vorherige Größe zurück
                                        if geo.size.width != 0.0 {
//                                            print("pikabu")
                                            self.fieldSize = geo.size
                                        }
                                    }
                                }
                            }
                        }
                }
            )
            .ignoresSafeArea(.keyboard)
            // Reagiert auf Änderungen der Größenpräferenz
            .onPreferenceChange(SizePreferenceKey.self) { size in
                if size != self.fieldSize {
//                    print("wölfchen")
                    // Aktualisiert die vorherigen Größen, um den Änderungsverlauf zu verfolgen
                    self.previousSize = size
                }
            }
    }
}

// Schlüssel für die Größenpräferenz in der Ansichtshierarchie
struct SizePreferenceKey: PreferenceKey {
    // Der Standardwert für die Größenpräferenz ist CGSize.zero
    static var defaultValue: CGSize = .zero

    // Reduziert die Größenpräferenzen zu einem einzelnen Wert
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// Erweiterung für die einfache Verwendung des SizeModifier in SwiftUI-Ansichten
extension View {
    // Funktion zum Hinzufügen des FieldSize-Modifiers mit einer Bindung an die Größe des Feldes
    func fieldSize(_ fieldSize: Binding<CGSize>) -> some View {
        modifier(FieldSizeModifier(fieldSize: fieldSize))
    }
}

// Erweiterung für die Erstellung von Farbobjekten aus Hexadezimalwerten
extension Color {
    // https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values Ideen suche
    // Konstruktor für die Erstellung einer Farbe aus einem Hexadezimalwert und einem optionalen Alpha-Wert
    init(hex: UInt, alpha: Double = 1.0) {
        // Initialisierung der Farbe im sRGB-Farbraum unter Verwendung der RGB-Werte aus dem Hexadezimalwert
        // Jeder Hexadezimalwert repräsentiert eine Farbkomponente (Rot, Grün, Blau)
        // Die Bitmasken (0xFF0000, 0x00FF00, 0x0000FF) werden verwendet, um die einzelnen Farbkomponenten zu isolieren
        // Die Werte werden dann auf den Bereich [0, 1] skaliert, indem sie durch 255.0 geteilt werden
        self.init(
            .sRGB,
            red: Double((hex & 0xFF0000) >> 16) / 255.0,
            green: Double((hex & 0x00FF00) >> 8) / 255.0,
            blue: Double(hex & 0x0000FF) / 255.0,
            opacity: alpha
        )
    }
}
