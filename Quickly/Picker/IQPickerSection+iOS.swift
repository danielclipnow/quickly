//
//  Quickly
//

#if os(iOS)

    public protocol IQPickerSection : class {

        typealias CellType = IQPickerCell.DequeueType.Type

        var controller: IQPickerController? { get }
        var cellType: CellType { get }
        var size: CGSize { get }
        var index: Int? { get }
        var rows: [IQPickerRow] { set get }

        func bind(_ controller: IQPickerController, _ index: Int)
        func rebind(_ index: Int)
        func unbind()

        func prependRow(_ row: IQPickerRow)
        func prependRow(_ rows: [IQPickerRow])
        func appendRow(_ row: IQPickerRow)
        func appendRow(_ rows: [IQPickerRow])
        func insertRow(_ row: IQPickerRow, index: Int)
        func insertRow(_ rows: [IQPickerRow], index: Int)
        func deleteRow(_ row: IQPickerRow)
        func deleteRow(_ rows: [IQPickerRow])

    }

    public extension IQPickerSection {

        public func prependRow(_ row: IQPickerRow) {
            self.insertRow([ row ], index: self.rows.startIndex)
        }

        public func prependRow(_ rows: [IQPickerRow]) {
            self.insertRow(rows, index: self.rows.startIndex)
        }

        public func appendRow(_ row: IQPickerRow) {
            self.insertRow([ row ], index: self.rows.endIndex)
        }

        public func appendRow(_ rows: [IQPickerRow]) {
            self.insertRow(rows, index: self.rows.endIndex)
        }

        public func insertRow(_ row: IQPickerRow, index: Int) {
            self.insertRow([ row ], index: index)
        }

        public func deleteRow(_ row: IQPickerRow) {
            self.deleteRow([ row ])
        }

    }

#endif
