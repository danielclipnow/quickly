//
//  Quickly
//

#if os(iOS)

    @IBDesignable
    open class QRoundView : QView {

        open override func setup() {
            super.setup()

            self.clipsToBounds = true
        }

        open override var frame: CGRect {
            didSet { self.updateCornerRadius() }
        }

        open override var bounds: CGRect {
            didSet { self.updateCornerRadius() }
        }

        private func updateCornerRadius() {
            let boundsSize = self.bounds.integral.size
            self.layer.cornerRadius = ceil(min(boundsSize.width - 1, boundsSize.height - 1) / 2)
        }

    }

#endif
