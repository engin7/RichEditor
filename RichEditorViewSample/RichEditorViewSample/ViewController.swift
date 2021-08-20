//
//  ViewController.swift
//  RichEditorViewSample
//
//  Created by Caesar Wirth on 4/5/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit
import RichEditorView

@available(iOS 9.0, *)
class ViewController: UIViewController {

    @IBOutlet var editorView: RichEditorView!
    @IBOutlet var htmlTextView: UITextView!

    lazy var toolbar: RichEditorToolbar = {
        let tb = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        tb.layer.cornerRadius = 8
        tb.layer.borderWidth = 0
        if #available(iOS 11.0, *) {
            tb.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        tb.clipsToBounds = true
        tb.options = RichEditorDefaultOption.allWithoutSave
        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editorView.delegate = self
        editorView.customAccessoryView = toolbar
        editorView.placeholder = "Type some text..."

        toolbar.delegate = self
        toolbar.editor = editorView
        self.view.addSubview(toolbar)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: htmlTextView.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: htmlTextView.leadingAnchor),
            toolbar.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44)
        ])
 
    }

}

@available(iOS 9.0, *)
extension ViewController: RichEditorDelegate {

    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
            htmlTextView.text = "HTML Preview"
        } else {
            htmlTextView.text = content
        }
    }
    
}

@available(iOS 9.0, *)
extension ViewController: RichEditorToolbarDelegate {
    
    fileprivate func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }

    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }

    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }
    
    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        if  let link = toolbar.searchBarImg.text {
            toolbar.editor?.insertImage(link, alt: "")
        }
        toolbar.searchBarImg.text = nil
        toolbar.resetBars()
    }

    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        toolbar.editor?.backupElement()
        if  let link = toolbar.searchBar.text {
            toolbar.editor?.insertLink(link, title: "")
        }
        toolbar.searchBar.text = nil
        toolbar.resetBars()
    }
    
    func richEditorTookFocus(_ editor: RichEditorView) {
        // reset menu
        guard let iav = editor.inputAccessoryView as? RichEditorToolbar else { return }
        iav.searchBarImg.text = nil
        iav.searchBar.text = nil
        iav.resetBars()
    }
}
