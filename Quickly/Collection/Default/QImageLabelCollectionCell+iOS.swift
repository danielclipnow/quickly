//
//  Quickly
//

#if os(iOS)

    open class QImageLabelCollectionCell< ItemType: QImageLabelCollectionItem >: QBackgroundColorCollectionCell< ItemType > {

        internal var pictureView: QImageView!
        internal var label: QLabel!
        internal var pictureConstraints: [NSLayoutConstraint] = [] {
            willSet { self.pictureView.removeConstraints(self.pictureConstraints) }
            didSet { self.pictureView.addConstraints(self.pictureConstraints) }
        }
        internal var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func size(
            item: ItemType,
            layout: UICollectionViewLayout,
            section: IQCollectionSection,
            size: CGSize
        ) -> CGSize {
            guard let imageSource: QImageSource = item.imageSource, let text: IQText = item.text else {
                return CGSize.zero
            }
            let availableWidth: CGFloat = size.width - (item.edgeInsets.left + item.edgeInsets.right)
            var imageSize: CGSize = item.imageSize
            if item.imageCentering == false {
                imageSize = imageSource.size(CGSize(
                    width: availableWidth, height: availableWidth
                ))
            }
            let textSize: CGSize = text.size(width: availableWidth)
            return CGSize(
                width: item.edgeInsets.left + max(imageSize.width, textSize.width) + item.edgeInsets.right,
                height: item.edgeInsets.top + imageSize.height + item.spacing + textSize.height + item.edgeInsets.bottom
            )
        }

        open override func setup() {
            super.setup()

            self.pictureView = QImageView(frame: self.contentView.bounds)
            self.pictureView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.pictureView)

            self.label = QLabel(frame: self.contentView.bounds)
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.label)
        }

        open override func set(item: ItemType) {
            super.set(item: item)
            self.apply(item: item)
        }

        open override func update(item: ItemType) {
            super.update(item: item)
            self.apply(item: item)
        }

        private func apply(item: QImageLabelCollectionItem) {
            var selfConstraints: [NSLayoutConstraint] = [
                self.pictureView.topLayout == self.contentView.topLayout + item.edgeInsets.top,
                self.pictureView.bottomLayout == self.label.topLayout - item.edgeInsets.bottom,

                self.label.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left,
                self.label.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right,
                self.label.bottomLayout == self.contentView.bottomLayout - item.edgeInsets.bottom
            ]
            var pictureConstraints: [NSLayoutConstraint] = []
            if item.imageCentering == true {
                selfConstraints.append(contentsOf: [
                    self.pictureView.leadingLayout >= self.contentView.leadingLayout + item.edgeInsets.left,
                    self.pictureView.trailingLayout <= self.contentView.trailingLayout - item.edgeInsets.right,
                    self.pictureView.centerXLayout == self.contentView.centerXLayout
                ])
                pictureConstraints.append(contentsOf: [
                    self.pictureView.widthLayout == item.imageSize.width,
                    self.pictureView.heightLayout == item.imageSize.height
                ])
            } else {
                selfConstraints.append(contentsOf: [
                    self.pictureView.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left,
                    self.pictureView.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right
                ])
            }
            self.selfConstraints = selfConstraints
            self.pictureConstraints = pictureConstraints

            self.pictureView.roundCorners = item.imageRoundCorners
            self.pictureView.source = item.imageSource

            self.label.contentAlignment = item.textContentAlignment
            self.label.padding = item.textPadding
            self.label.numberOfLines = item.textNumberOfLines
            self.label.lineBreakMode = item.textLineBreakMode
            self.label.text = item.text
        }

    }

#endif
