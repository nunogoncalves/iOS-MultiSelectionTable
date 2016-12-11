//
//  TableViewHeader.swift
//  MultiSelectionTableView
//
//  Created by Nuno Gonçalves on 08/12/16.
//
//

class TableViewHeader : UIView {
    
    let title: String
    
    init(title: String) {
        self.title = title

        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        let label = UILabel()
        addSubview(label)
        label.text = title
        label.textColor = .gray
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
