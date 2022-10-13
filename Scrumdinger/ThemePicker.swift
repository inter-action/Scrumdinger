//
//  ThemePicker.swift
//  Scrumdinger
//

//

import SwiftUI

struct ThemePicker: View {
    @Binding var selection: Theme
    
    var body: some View {
        Picker("Theme", selection: $selection) {
            ForEach(Theme.allCases) { theme in
                ThemeView(theme: theme)
                    // binds the picker value to Theme type
                    .tag(theme)
            }
        }
    }
}

struct ThemePicker_Previews: PreviewProvider {
    static var previews: some View {
        // todo: constant
        ThemePicker(selection: Binding.constant(.periwinkle))
    }
}
