import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let friendLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        button.backgroundColor = .white
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    
    private let friends: [(name: String, phone: String, image: UIImage?)] = [
        (name: "Alice", phone: "010-1111-1111", image: UIImage(named: "alice")),
        (name: "Bob", phone: "010-2222-2222", image: UIImage(named: "bob")),
        (name: "Charlie", phone: "010-3333-3333", image: UIImage(named: "charlie")),
        // Add more friends as needed
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }

    @objc
    private func buttonTapped() {
        self.navigationController?.pushViewController(AddFriendViewController(), animated: true)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [
            friendLabel,
            plusButton,
            tableView
        ].forEach { view.addSubview($0) }
        
        friendLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(70)
        }
        
        plusButton.snp.makeConstraints {
            $0.leading.equalTo(friendLabel.snp.trailing).offset(70)
            $0.centerY.equalTo(friendLabel)
            $0.height.equalTo(100)
            $0.width.equalTo(100)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(friendLabel.snp.bottom).offset(40)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let friend = friends[indexPath.row]
        cell.configure(name: friend.name, phone: friend.phone, image: friend.image)
        return cell
    }
}
