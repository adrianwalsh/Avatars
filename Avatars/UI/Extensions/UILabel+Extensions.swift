import UIKit

extension UILabel {
    func style(_ style: UIFont.TextStyle) -> Self {
        font = UIFontMetrics(forTextStyle: style).scaledFont(for: UIFont.preferredFont(forTextStyle: style))
        return self
    }
    
    func layout(lines: Int? = nil, alignment: NSTextAlignment? = nil) -> Self {
        lines.map { numberOfLines = $0 }
        alignment.map { textAlignment = $0 }
        return self
    }
}
