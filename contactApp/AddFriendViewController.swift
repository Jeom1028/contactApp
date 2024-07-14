import UIKit
import SnapKit

class AddFriendViewController: UIViewController {
    
    private let contactLabel: UILabel = {
        let label = UILabel()
        label.text = "연락처 추가"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("적용", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private lazy var imageButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(fetchRandomPokemonImage), for: .touchUpInside)
        return button
    }()
    
    private let randomImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100 // Adjust the corner radius as needed
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "전화번호"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewdidLod")
        view.backgroundColor = .white
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [
            contactLabel,
            applyButton,
            randomImage,
            imageButton,
            nameTextField,
            phoneTextField
        ].forEach { view.addSubview($0) }
        
        contactLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(65)
        }
        
        applyButton.snp.makeConstraints {
            $0.leading.equalTo(contactLabel.snp.trailing).offset(20) // Adjusted for spacing
            $0.centerY.equalTo(contactLabel)
            $0.height.equalTo(100)
            $0.width.equalTo(200)
        }
        
        randomImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contactLabel.snp.bottom).offset(30)
            $0.width.height.equalTo(200) // Adjust size as needed
        }
        
        imageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(randomImage.snp.bottom).offset(20)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(imageButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }

        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
    }
    
    @objc private func fetchRandomPokemonImage() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 1...898))/") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let sprites = json?["sprites"] as? [String: Any], let imageUrlString = sprites["front_default"] as? String {
                    if let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl) {
                        DispatchQueue.main.async {
                            self?.randomImage.image = UIImage(data: imageData)
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

#Preview {
    let rc = AddFriendViewController()
    return rc
}
