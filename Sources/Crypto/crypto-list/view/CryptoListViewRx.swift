// Copyright author 2020
// Created by __sh0l1n@
//

import GLibObject
import Gdk
import Gtk
import Foundation


class CryptoListViewRx: Box {
    init(controller: CryptoListControllerRxProtocol?) {
        super.init(orientation: .vertical, spacing: 0)
        self.controller = controller  
        draw()
    }

    //TODO: convert to weak
    private let listStore = ListStore(.string, .double, .double)
    private var treeIter = TreeIter()
    private var renderers = [CellRenderer]()
    private var listView: ListView?
    private var entrySearch: EntryRef?

    var count = 0
    
    private var controller: CryptoListControllerRxProtocol?
    
    var cssFileName: String {
        return ""
    }
}

private extension CryptoListViewRx {
    private func draw() {
        guard entrySearch == nil && listView == nil else {
            return
        } 

        // // SearchBar
        // let searchBarBox = BoxRef(orientation: .horizontal, spacing: 0)
        // add(widget: searchBarBox)

        // entrySearch = EntryRef()
        // entrySearch?.setPlaceholder(text: "Search...")
        // entrySearch?.setMaxLength(max: 10) 
        // if let entrySearch = entrySearch {
        //     searchBarBox.add(widget: entrySearch)
        // }

        // let searchButton = ButtonRef(label: "Search")
        // searchButton.connect(signal: .clicked, to: ({ [weak self] in 
        //     let text = self?.entrySearch?.text ?? ""
        //     self?.controller?.filter(query: text)
        // }))
        // searchBarBox.add(widget: searchButton)

        // // Button for hacking the user jjjj
        // let refreshButton = ButtonRef(label: "Refresh")
        // refreshButton.connect(signal: .clicked, to: ({ [weak self] in 
        //     let text = self?.entrySearch?.text ?? ""
        //     self?.controller?.filter(query: text)
        // }))
        // searchBarBox.add(widget: refreshButton)
        
        // List
        let sw = ScrolledWindow()
        sw.vexpand = true
        sw.setPolicy(hscrollbarPolicy: .never, vscrollbarPolicy: .always)
        add(widget: sw)
        listView = ListView(model: listStore)
        let columns = [
            ("pair",  "text", CellRendererText()),
            ("ask",  "text", CellRendererText()),
            ("bid",  "text", CellRendererText()),
        ].enumerated().map {
                (i: Int, c: (title: String, kind: PropertyName, renderer: CellRenderer)) -> TreeViewColumn in
                let column = TreeViewColumn(i, title: c.title, renderer: c.renderer, attribute: c.kind)
                renderers.append(c.renderer)
                return column
        }
        listView?.append(columns)
        if let listView = listView {
            sw.add(widget: listView)
        }
    }

    func clearList() {
        if let model = listView?.getModel() {
            var index = model.getIterFirst(iter: treeIter)
            while index {
                _ = listStore.remove(iter: treeIter)
                index = model.getIterFirst(iter: treeIter)
            }
        }
    }
}

extension CryptoListViewRx: CryptoListViewRxProtocol {
    func update(items: [CryptoListItem]) {
        clearList()
        for index in 0..<items.count {
            let item = items[index]
            listStore.append(asNextRow: treeIter, Value(item.id), Value(item.ask), Value(item.bid))
        }
        // threadsAddIdle(function: ({ id in
        //     //print(id)
        //     let oo = CryptoListViewRxProtocol(raw: id)
        //    // print(oo)
        //     //var oo = CryptoListViewRx(raw: id)
        //     if let x = id as? CryptoListViewRx {
        //         print("isview")
        //     }

        //     // guard let this = self else {
        //     //     return 0
        //     // }
        //     // this.clearList()
        //     // for index in 0..<items.count {
        //     //     let item = items[index]
        //     //     this.listStore.append(asNextRow: this.treeIter, Value(item.id), Value(item.ask), Value(item.bid))
        //     // }
        //     return 1
        // }), data: self.ptr)
    }
}