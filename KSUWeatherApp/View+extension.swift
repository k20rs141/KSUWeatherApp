import Foundation
import SwiftUI

extension View {
    func cardStyle(appearanceMode: ColorScheme, cornerRadius: CGFloat) -> some View {
        self
            .font(.system(size: 17))
            .background(appearanceMode == .dark ? Color(red: 0.11, green: 0.12, blue: 0.27) : Color(red: 0.95, green: 0.95, blue: 0.95))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
