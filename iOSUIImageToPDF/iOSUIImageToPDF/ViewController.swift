//
//  ViewController.swift
//  iOSUIImageToPDF
//
//  Created by Anupam Chugh on 09/10/19.
//  Copyright © 2019 Anupam Chugh. All rights reserved.
//

import UIKit
import VisionKit
import PDFKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var btnPdf: UIButton!
    
    var pdfView : PDFView!
    var imagesArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnPdf.isHidden = false
        addPDFView()
    }
    
    func addPDFView()
    {
        pdfView = PDFView()

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: btnScan.bottomAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: btnPdf.topAnchor).isActive = true
        
        //CGFloat height = self.bounds.size.height
       // let pdfHeightView =  self.pdfView.bounds.size.height
       // print("Height is: \(pdfHeightView)")
    }

    @IBAction func btnViewPDF(_ sender: Any) {
        
        
        let screenSize: CGRect = UIScreen.main.bounds
        let deviceScreenWidth = screenSize.width
        let deviceScreenHeight = screenSize.height
        
        DispatchQueue.main.async {

            let pdfDocument = PDFDocument()

            for i in 0 ..< self.imagesArray.count {
              //  if let image = self.imagesArray[i].resize(toWidth: 250){
                if let image = self.imagesArray[i].resize(toWidth: deviceScreenWidth, height: deviceScreenHeight){
                    print("image size is \(image.size.width), \(image.size.height)")
                    print("iPhone Device size is \(deviceScreenWidth), \(deviceScreenHeight)")
                    // Create a PDF page instance from your image
                    let pdfPage = PDFPage(image: image)
                    // Insert the PDF page into your document
                    pdfDocument.insert(pdfPage!, at: i)
                }
            }
            
            
            // Get the raw data of your PDF document
            let data = pdfDocument.dataRepresentation()
            
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let docURL = documentDirectory.appendingPathComponent("Scanned-Docs.pdf")
            do{
            try data?.write(to: docURL)
            }catch(let error)
            {
                print("error is \(error.localizedDescription)")
            }
            
        }
        
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let docURL = documentDirectory.appendingPathComponent("Scanned-Docs.pdf")
        
        
        if fileManager.fileExists(atPath: docURL.path){
            pdfView.document = PDFDocument(url: docURL)
        }
        else{
            print("file does not exist..")
        }
        
    }
    
    @IBAction func btnScanDocument(_ sender: Any) {
        
//        let scannerViewController = VNDocumentCameraViewController()
//        scannerViewController.delegate = self
//        present(scannerViewController, animated: true)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        myPickerController.allowsEditing = true
        self.present(myPickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let editImage = info[.editedImage] as? UIImage{
            self.imagesArray.append(editImage)
        }
        
        else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imagesArray.append(pickedImage)
        }
        
        else if let image = info[.originalImage] as? UIImage {
            self.imagesArray.append(image)
        }
        picker.dismiss(animated: true,completion: nil)
    }
    
    /*
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        DispatchQueue.main.async {

            let pdfDocument = PDFDocument()

            for i in 0 ..< scan.pageCount {
                if let image = scan.imageOfPage(at: i).resize(toWidth: 250){
                    print("image size is \(image.size.width), \(image.size.height)")
                    // Create a PDF page instance from your image
                    let pdfPage = PDFPage(image: image)
                    // Insert the PDF page into your document
                    pdfDocument.insert(pdfPage!, at: i)
                }
            }
            
            
            // Get the raw data of your PDF document
            let data = pdfDocument.dataRepresentation()
            
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let docURL = documentDirectory.appendingPathComponent("Scanned-Docs.pdf")
            do{
            try data?.write(to: docURL)
            }catch(let error)
            {
                print("error is \(error.localizedDescription)")
            }
            
        }
        controller.dismiss(animated: true)
        btnPdf.isHidden = false
        
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    */
    
}

extension UIImage{
    func resize(toWidth width: CGFloat, height:CGFloat) -> UIImage? {
       // let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let canvas = CGSize(width: width, height: height)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

