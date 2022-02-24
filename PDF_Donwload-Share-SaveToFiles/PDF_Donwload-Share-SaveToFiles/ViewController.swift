//
//  ViewController.swift
//  PDF_Donwload-Share-SaveToFiles
//
//  Created by EOO61 on 30/08/21.
//

import UIKit

class ViewController: UIViewController {
    
    var pdfUrl:URL?

    @IBOutlet weak var downloadButtonOutlet: UIButton!
    
    var spinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        downloadButtonOutlet.layer.cornerRadius = 5
        downloadButtonOutlet.clipsToBounds = true
        
        //Spiner code
        spinner.center = view.center
        spinner.color = UIColor.black
        view.addSubview(spinner)
    }


    @IBAction func downloadButtonClicked(_ sender: Any) {
        
        spinner.startAnimating()
        
        guard let url = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf")else {return}
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
}


extension ViewController : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File Downloaded Location- ",  location)
        
        guard let url = downloadTask.originalRequest?.url else {
            return
        }
        let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationPath = docsPath.appendingPathComponent(url.lastPathComponent)
        
        try? FileManager.default.removeItem(at: destinationPath)
        
        do{
            try FileManager.default.copyItem(at: location, to: destinationPath)
            self.pdfUrl = destinationPath
            print("File Downloaded Location- ",  self.pdfUrl ?? "NOT")
        }catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
        
        //Single PDF with Name of the PDF to save into files
       // let activityViewController = UIActivityViewController(activityItems: ["Sample PDF", self.pdfUrl!], applicationActivities: nil) // single doc
        
        //multi doc - in this case doc name will not same same - need to check
        let activityViewController = UIActivityViewController(activityItems: [self.pdfUrl!, self.pdfUrl!].compactMap { $0 }, applicationActivities: nil)
        
        DispatchQueue.main.async{
            
            OperationQueue.main.addOperation {
                
                self.spinner.stopAnimating()
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
        
    }
}
