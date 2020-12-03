// Copyright author 2020
// Created by Jesus Manresa Parres
//

import Foundation
import Gdk
import Gtk


let status = Application.run(startupHandler: nil) { app in
    let window = ApplicationWindowRef(application: app)
    window.title = "Bitfinex Tickers"
    window.setDefaultSize(width: 300, height: 500)
    window.set(resizable: false)


    // let box = Box(orientation: .vertical, spacing: 0)
    
    // let label = TextViewRef()
    // label.text = "Search Bar"
    // box.add(widget: label)
    
    
    // let sw = ScrolledWindow()
    // sw.hexpand = true
    // sw.vexpand = true
    // sw.setPolicy(hscrollbarPolicy: .never, vscrollbarPolicy: .always)
    // box.add(widget: sw)

    if let view = CryptoList().view {
        readCssFile(forResource: view.cssFileName)
        window.add(widget: view)    
    }

    //window.add(box)

    window.showAll()
}

guard let status = status else {
    fatalError("Could not create Application")
}
guard status == 0 else {
    fatalError("Application exited with status \(status)")
}

func readCssFile(forResource: String) {
    var css = ""
    if let fileURL = Bundle.main.url(forResource: forResource, withExtension: "css") { //subdirectory: 
        if let fileContents = try? String(contentsOf: fileURL) {
            css = fileContents
            if let screen = ScreenRef.getDefault(), let css = try? CSSProvider(from: css) {
                screen.add(provider: css, priority: STYLE_PROVIDER_PRIORITY_APPLICATION)
            }
        }
    }
}