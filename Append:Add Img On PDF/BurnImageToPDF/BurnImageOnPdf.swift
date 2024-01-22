   import UIKit
   
   class BurnImageOnPdf {
    
   class func drawOnPDF(cgPDFDucomunt:CGPDFDocument, signatureImage:UIImage ,pageIndex:Int, x:CGFloat , y:CGFloat  ,width:CGFloat ,height:CGFloat) -> Data? {
    
    let pdf = cgPDFDucomunt
    
    let pageCount = pdf.numberOfPages
        
    let mutableData = NSMutableData()
    UIGraphicsBeginPDFContextToData(mutableData,CGRect.zero, nil)
    
    for index in 1...pageCount {
        
        let page =  pdf.page(at: index)
        
        let pageFrame = page?.getBoxRect(.mediaBox)
        
        UIGraphicsBeginPDFPageWithInfo(pageFrame!, nil)

        guard let ctx = UIGraphicsGetCurrentContext() else {return nil}
   
        ctx.saveGState()
        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -pageFrame!.size.height)
        
        ctx.drawPDFPage(page!)
        ctx.restoreGState()
        
        if index == pageIndex {
            let image = signatureImage
            var newRectImage: CGRect?
            
            newRectImage = CGRect(x: x, y: ((pageFrame?.height)! - y) - height , width: width, height: height)
            
            if let newRectImage = newRectImage{
                image.draw(in: newRectImage)
            }
      
        }
        
    }
  
    UIGraphicsEndPDFContext()
    
    let pdfData = mutableData as Data
        
    return pdfData

   }
   
   }
  

