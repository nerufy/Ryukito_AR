//
//  ViewController.swift
//  Ryukito_AR
//
//  Created by 又吉琉稀斗 on 2020/05/26.
//  Copyright © 2020 又吉琉稀斗. All rights reserved.
//
import UIKit
import SceneKit
import ARKit
import AVFoundation

extension UIColor {
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}



class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, AVAudioPlayerDelegate{

    @IBOutlet var sceneView: ARSCNView!
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet weak var shotButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: "kinkyu", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        audioPlayer.delegate = self
        audioPlayer.numberOfLoops = -1   // ループ再生する
        audioPlayer.prepareToPlay()
        //再生する
        audioPlayer.play()
            
        //ワイヤーフレームを表示
        //sceneView.debugOptions = .showWireframe
        //シーンビューのデリゲートになる
        sceneView.delegate = self
        //fpsなどを表示
        sceneView.showsStatistics = true
        //シーンを作る
        //let scene = SCNScene()
        sceneView.scene.physicsWorld.contactDelegate = self
        
        // スクリーンの横縦幅
        //let screenWidth:CGFloat = self.view.frame.width
        //let screenHeight:CGFloat = self.view.frame.height
        shotButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)  // 1
               //shotButton.center = self.view.center  // 2
        shotButton.layer.position = CGPoint(x: self.view.frame.width/2, y:600)
               
        shotButton.backgroundColor = .red  // 3
        shotButton.setTitleColor(UIColor.white, for: UIControl.State.normal)  // 4
        
        shotButton.layer.borderWidth = 1  // 5
        shotButton.layer.borderColor = UIColor.black.cgColor  // 6
        
        shotButton.layer.cornerRadius = 50  // 7
               
        shotButton.layer.shadowOffset = CGSize(width: 3, height: 3 )  // 8
        shotButton.layer.shadowOpacity = 0.5  // 9
        shotButton.layer.shadowRadius = 10  // 10
        shotButton.layer.shadowColor = UIColor.gray.cgColor  // 11
        
        enemy(-5, 1.0, -5, 0, 0, 0, 1, "enemy1")
    }
    
    var Targets = 0
    
    func enemy(_ positionX: Float,_ positionY: Float,_ positionZ: Float,_ red: Int,_ green: Int,_ blue: Int,_ alpha: Int,_ NodeName: String) {
        //球体を生成 --rediusは半径
        let enemyObj = SCNSphere(radius: 0.5)
        let enemyNode = SCNNode(geometry: enemyObj)
        enemyNode.position = SCNVector3(positionX, positionY, positionZ)
        enemyNode.name = NodeName
        
        //マテリアル（表面）を生成する
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.rgba(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
        enemyNode.geometry?.firstMaterial = material
        
        //物理情報の設定
        let physicsShape = SCNPhysicsShape(geometry: enemyObj, options: nil)
        let sphereBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        sphereBody.restitution = 0
        sphereBody.physicsShape = physicsShape
        
        //接触を検知する処理
        sphereBody.contactTestBitMask = 0
        sphereBody.collisionBitMask = 1
        sphereBody.categoryBitMask = 1
        
        //Body情報をノードにセット
        enemyNode.physicsBody = sphereBody
        
            //着弾まで?秒間かかるアニメーション
        let enemymoving = SCNAction.move(by: SCNVector3(5, 1.0, -5), duration: TimeInterval(5))
        let enemystoping = SCNAction.wait(duration: 0.5)
        enemyNode.runAction(
            SCNAction.repeatForever(
                SCNAction.sequence([
                    enemymoving,
                    enemystoping,
                    enemymoving.reversed()
                ])
            )
        )


        //AR空間に球体を追加
        sceneView.scene.rootNode.addChildNode(enemyNode)
    }

    
    
    
    @objc func ShotType(_ BulletSize: Float,_ BulletColor: Any,_ BulletRange: Float,_ BulletVelocity: Double) {
        //弾を生成 --rediusは半径
        let bullet = SCNSphere(radius: CGFloat(BulletSize))
        let bulletNode = SCNNode(geometry: bullet)
        bulletNode.name = "Tama"
        
        //マテリアル（表面）を生成する
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        bullet.materials = [material]
        guard let camera = sceneView.pointOfView else {
           return
        }
        
        //物理情報の設定
        let physicsBullet = SCNPhysicsShape(geometry: bullet, options: nil)
        let BulletBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        BulletBody.restitution = 1
        BulletBody.physicsShape = physicsBullet
        bulletNode.physicsBody?.isAffectedByGravity = false
        
        //接触を検知する処理
        BulletBody.contactTestBitMask = 1
        BulletBody.collisionBitMask = 1
        BulletBody.categoryBitMask = 1
        
        //発射時の弾の位置　--カメラの位置
        bulletNode.position = camera.position
        //着弾後の弾の位置
        let targetPosCamera = SCNVector3Make(0, 0, BulletRange)
        let target = camera.convertPosition(targetPosCamera, to: nil)
        
        
        //着弾まで?秒間かかるアニメーション
        let action = SCNAction.move(to: target, duration: TimeInterval(BulletVelocity))
        bulletNode.runAction(action)
        
        //Body情報をノードにセット
        bulletNode.physicsBody = BulletBody
        //AR空間に球体を追加
        sceneView.scene.rootNode.addChildNode(bulletNode)
        //発射から?秒後に弾を削除
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + BulletVelocity) {
          bulletNode.removeFromParentNode()
        }
    }
    
    
    // ボタンを押すと弾を発射 --ハンドガン
    @IBAction func shot(_ sender: Any) {
        ShotType(0.005, "black", -7.0, 1.8)
    }
    // ボタンを押すと弾を発射 --マシンガン
    @objc func MachineGun () {
        ShotType(0.005, "red", -4.5, 1.8)
    }
    
    var timer: Timer?
    @IBAction func TapDown(_ sender: Any) {
        self.timer = Timer.scheduledTimer( //TimerクラスのメソッドなのでTimerで宣言
          timeInterval: 0.1, //処理を行う間隔の秒
          target: self,  //指定した処理を記述するクラスのインスタンス
            selector: #selector(self.MachineGun), //実行されるメソッド名
          userInfo: nil, //selectorで指定したメソッドに渡す情報
          repeats: true //処理を繰り返すか否か
        )
    }
    @IBAction func TapUp(_ sender: Any) {
        self.timer?.invalidate()
    }
    
    
    @IBOutlet weak var testlab: UILabel!
    
    var RedColorNo = 0
    var BlueColorNo = 255
    var enemyHP = 52
    //接触を検知したらテキストを表示
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        if nodeB.name == "Tama" {
            nodeB.removeFromParentNode()
        }
        self.testlab.text = nodeB.name! + " が " + nodeA.name! + " に当たった！!！ " + String(BlueColorNo)
        
        RedColorNo += 5
        BlueColorNo -= 5
        nodeA.geometry?.firstMaterial?.diffuse.contents = UIColor.rgba(red: RedColorNo, green: 0, blue: BlueColorNo, alpha: 1)
        
        enemyHP -= 10
        if enemyHP <= 0 {
            nodeA.removeFromParentNode()
            
            var isFirst = true
            if isFirst {
                isFirst = false
                
                let audioPath_EnemyDestruction = Bundle.main.path(forResource: "EnemyDestruction", ofType:"mp3")!
                let audioUrl = URL(fileURLWithPath: audioPath_EnemyDestruction)
                // auido を再生するプレイヤーを作成する
                var audioError:NSError?
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
                } catch let error as NSError {
                    audioError = error
                    audioPlayer = nil
                }
                // エラーが起きたとき
                if let error = audioError {
                    print("Error \(error.localizedDescription)")
                }
                audioPlayer.delegate = self
                audioPlayer.prepareToPlay()
                //再生する
                audioPlayer.play()
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                //Storyboardを指定
                let Resultstoryboard = UIStoryboard(name: "Result", bundle: nil)
                //生成するViewControllerを指定
                let next2 = Resultstoryboard.instantiateViewController(withIdentifier: "ResultViewController")
                //表示
                self.present(next2, animated: true)
            }
            
        }
        //self.Targets -= 1
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //セッションのコンフィグを作る
        let configuration = ARWorldTrackingConfiguration()
        //環境マッピングを有効にする
        configuration.environmentTexturing = .automatic
        //平面の検出を有効化 --今回は特に意味なし
        //configuration.planeDetection = .horizontal
        //セッションを開始
        sceneView.session.run(configuration)
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //セッションを停止
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    
        
    /*
        // Override to create and configure nodes for anchors added to the view's session.
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            let node = SCNNode()
         
            return node
        }
    */
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            // Present an error message to the user
            
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            // Inform the user that the session has been interrupted, for example, by presenting an overlay
            
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            // Reset tracking and/or remove existing anchors if consistent tracking is required
            
        }
    
}


