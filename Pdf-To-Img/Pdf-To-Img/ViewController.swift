//
//  ViewController.swift
//  Pdf-To-Img
//
//  Created by EOO61 on 29/01/22.
//

import UIKit
import PDFKit

class ViewController: UIViewController {

    @IBOutlet weak var page1Img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let path = Bundle.main.path(forResource: "file-sample_150kB", ofType: "pdf") {
            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                
              //  pdfView.document = pdfDocument //pdf view
               let img =  self.drawPDFfromURL(url: URL(fileURLWithPath: path))
                self.page1Img.image = img
                
            }
        }
    }

    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return img
    }
    

}

