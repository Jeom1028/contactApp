import UIKit

class TableViewCell: UITableViewCell {
    
    static let id = "TableViewCell"
    
    private let friendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30 // Adjust the corner radius as needed
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String, phone: String, image: UIImage?) {
        nameLabel.text = name
        phoneLabel.text = phone
        friendImageView.image = image
    }
    
    private func configureUI() {
        [friendImageView, nameLabel, phoneLabel].forEach { contentView.addSubview($0) }
        
        friendImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(friendImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        phoneLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-30)
            $0.centerY.equalToSuperview()
        }
    }
}
