//
//  PlayViewController.swift
//  Radio
//
//  Created by Elton Souza on 06/09/21.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController {
    var isLoading = false {
        didSet {
            if isLoading {
                loading.startAnimating()
            } else {
                loading.stopAnimating()
            }
        }
    }
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadMusic("http://strm112.1.fm/acountry_mobile_mp3")
        loadMusic("https://r15.ciclano.io:14385/stream")
        
    }
    
    func loadMusic(_ stringUrl: String) {
        isLoading = true
        guard let url = URL(string: stringUrl) else {
            print("Erro na URL")
            isLoading = false
            return
        }
        
        preparePlayer(with: AVAsset(url: url)) { (success, asset) in
            guard success, let asset = asset else {
                print("ERRO AO BAIXAR A MUSICA")
                self.isLoading = false
                return
            }
            self.isLoading = false
            self.playerItem = AVPlayerItem(asset: asset)
            self.player = AVPlayer(playerItem: self.playerItem)
            self.play()
        }
    }
    
    func play() {
        player?.play()
    }
    
    func stop() {
   
        //player?.pause()
        player?.seek(to: CMTime.zero)
    }

    private func preparePlayer(with asset: AVAsset?, completionHandler: @escaping (_ isPlayable: Bool, _ asset: AVAsset?) -> ()) {
        guard let asset = asset else {
            completionHandler(false, nil)
            return
        }
        
        let requestedKey = ["playable"]
        
        asset.loadValuesAsynchronously(forKeys: requestedKey) {
            
            DispatchQueue.main.async {
                var error: NSError?
                
                let keyStatus = asset.statusOfValue(forKey: "playable", error: &error)
                if keyStatus == AVKeyValueStatus.failed || !asset.isPlayable {
                    completionHandler(false, nil)
                    return
                }
                
                completionHandler(true, asset)
            }
        }
    }
    
    
    @IBAction func onTouchStop(_ sender: Any) {
        stop()
    }
    
    @IBAction func onTouchPlay(_ sender: Any) {
        play()
    }
}
