// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit
import SDWebImage

@IBDesignable
class ZoomableImageView : UIScrollView, UIScrollViewDelegate {
    
    private let contentImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    // scale to fill = 0, aspect fit = 1, aspect fill = 2, so on...
    @IBInspectable var imageViewContentMode: Int {
        get {
            return contentImageView.contentMode.rawValue
        }
        set {
            if let newMode = UIView.ContentMode(rawValue: newValue) {
                contentImageView.contentMode = newMode
            }
        }
    }
    
    @IBInspectable var image: UIImage? {
        get {
            return contentImageView.image
        }
        set {
            contentImageView.image = newValue
        }
    }
    
    @IBInspectable var minimumZoom : CGFloat {
        get {
            self.minimumZoomScale
        }set {
            self.minimumZoomScale = newValue
        }
    }
    
    @IBInspectable var maximumZoom : CGFloat {
        get {
            self.maximumZoomScale
        }set {
            self.maximumZoomScale = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        setupScrollView()
    }
    
    convenience init(frame : CGRect = .zero, image : UIImage) {
        self.init(frame: frame)
        contentImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScrollView()
    }
    
    private func setupScrollView() {
        addSubview(contentImageView)
        
        NSLayoutConstraint.activate([
            contentImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentImageView.topAnchor.constraint(equalTo: self.topAnchor),
            contentImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            contentImageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        // Enable zooming
        self.delegate = self
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 5.0
        
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        // Add double-tap gesture recognizer
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
        
        self.contentInsetAdjustmentBehavior = .never
        self.clipsToBounds = true
    }
    
    func setImage(using url : URL){
        contentImageView.sd_setImage(with: url, placeholderImage: image)
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let currentZoomScale = self.zoomScale
        let tapPoint = gesture.location(in: contentImageView)

        let zoomScale = currentZoomScale > 1.0 ? 1.0 : 2.5

//       Calculate the zoom rectangle ensuring full coverage and correct alignment
        let zoomRect = calculateZoomRect(for: zoomScale, center: tapPoint, imageSize: self.bounds.size)
        self.zoom(to: zoomRect, animated: true)
    }
    
    private func calculateZoomRect(for scale: CGFloat, center: CGPoint, imageSize: CGSize) -> CGRect {
        let viewSize = self.bounds.size
        let width = viewSize.width / scale
        let height = viewSize.height / scale

        // Calculate raw origin based on the center point
        var originX = center.x - (width / 2)
        var originY = center.y - (height / 2)

        print(originX, originY)
        // Ensure the zoom rect doesn't exceed the image bounds
        let maxX = imageSize.width - width
        let maxY = imageSize.height - height

        originX = max(0, min(originX, maxX))
        originY = max(0, min(originY, maxY))

        // Return the adjusted zoom rect
        return CGRect(x: originX, y: originY, width: width, height: height)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentImageView
    }

}
