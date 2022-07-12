//
//  ViewController.swift
//  HowBig
//
//  Created by Anton Kolesnikov on 07.07.2022.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var arButton: UIButton!
    @IBOutlet private weak var dogButton: UIButton!
    @IBOutlet private weak var breedLabel: UILabel!
    @IBOutlet private weak var dogImage: UIImageView!
    private let predictor = Predictor()
    public var dogBreed: String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        dogImage.isHidden = true
        breedLabel.isHidden = true
        arButton.isHidden = true
    }
  
    @IBAction func buttonTapped(_ sender: UIButton) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .photoLibrary
        present(imagePickerVC, animated: true)
    }
  
    private func showPrediction(_ preditions: [Prediction]?) {
        DispatchQueue.main.async {
            let predictionsStr = preditions?.reduce(into: "") {
                $0.append("\($1.0)\n\($1.1)\n")
            }
            let predictionConfidence = Float(predictionsStr?.split(separator: "\n")[1] ?? "0")
            print(predictionConfidence)
            if predictionConfidence! > 0.7 {
                if let index = predictionsStr?.firstIndex(of: "\n") {
                    let breed = predictionsStr?.prefix(upTo: index)
                    self.dogBreed = String(breed!).capitalized.replacingOccurrences(of: "_", with: " ")
                    self.breedLabel.text = self.dogBreed
                }
                self.arButton.isHidden = false
                self.breedLabel.textColor = .black
            } else {
                self.breedLabel.text = "Dog not recognized"
                self.breedLabel.textColor = .red
                self.arButton.isHidden = true
            }
            self.dogImage.isHidden = false
            self.breedLabel.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toAR":
            let destination = segue.destination as! ARViewController
            destination.dogBreed = dogBreed
        default: break
        }
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        dogImage.image = image
        DispatchQueue.global(qos: .userInteractive).async {
          self.predictor.predict(image: image, completion: self.showPrediction)
        }
        picker.dismiss(animated: true)
    }
}
