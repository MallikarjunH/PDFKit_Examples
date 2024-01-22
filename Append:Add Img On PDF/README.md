# Burn Image On PDF

This is project show how to burn image into PDF (Save As Flatten)

### Things you need to know
- PDFKit doesn't have any function to save Image As Flatten.
- You need to use Core Graphics for this purpose.
- The coordinate space used in this example is PDF coordinate not UIView coordinate.
- You can convert UIView coordinate to PDF coordinator using [this](https://developer.apple.com/documentation/pdfkit/pdfview/1505316-convert). if needed.
- The image will burn to current page.
- After an image is burned to PDF you will get the PDF Data you can save it to the user device or just display it as on the example.


#### Signature image
![signature](https://user-images.githubusercontent.com/16876982/112380885-fbd9ce00-8cfa-11eb-85a4-3c7a4a772be6.png)

#### PDF
[sample.pdf](https://github.com/X901/BurnImageToPDF/files/6200365/sample.pdf)

#### Result
![Simulator Screen Shot - iPad Pro (9 7-inch) - 2021-03-24 at 23 22 41](https://user-images.githubusercontent.com/16876982/112381029-288de580-8cfb-11eb-9714-5fe02ee8ab96.png)


