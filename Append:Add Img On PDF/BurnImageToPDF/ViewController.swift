////
//ViewController.swift
//BurnImageToPDF


import UIKit
import PDFKit

class ViewController: UIViewController {

    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let path = Bundle.main.url(forResource: "sample", withExtension: "pdf") else { return }

        if let document = PDFDocument(url: path) {
            
            pdfView.autoScales = true
            pdfView.displayMode = .singlePage
            pdfView.displayDirection = .vertical
            pdfView.usePageViewController(true)
            
            pdfView.document = document
        }

    }

    @IBAction func BurnImageToPDFTapped(_ sender: Any) {
        
        guard let signatureImage = UIImage(named: "signature")
        else { return print("signatureImage is nil") }
        
         let width = signatureImage.size.width
         let height = signatureImage.size.height
         let x : CGFloat = 0
         let y : CGFloat = 0
        
        guard let currentPageIndex = pdfView.currentPage?.pageRef?.pageNumber else { return print("currentPageIndex is nil") }

        guard let cgPDFDucomunt = pdfView.document?.documentRef else { return print("cgPDFDucomunt is nil") }

        guard let pdfData = BurnImageOnPdf.drawOnPDF(cgPDFDucomunt: cgPDFDucomunt, signatureImage: signatureImage, pageIndex: currentPageIndex, x: x, y: y, width: width, height: height)
        else { return print("pdfData is nil") }
        
        guard let document = PDFDocument(data: pdfData) else { return print("document is nil") }
        
        pdfView.document = document
     
    }
    
}

