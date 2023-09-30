//
//  Knock21.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/21.
//

import SwiftUI

enum Knock21 {
    struct ContentView: View {
        @State var tapped = false
        
        var body: some View {
            ScrollView {
                HStack(alignment: .top, spacing: 8) {
                    VStack(alignment: .leading) {
                        Text(tapped ? text : String(text.prefix(30)) ).font(.caption)
                        if !tapped {
                            Button("Continue", action: {
                                tapped.toggle()
                            })
                        }
                    }
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    Spacer()
                }.padding()
                
            }
            
            
        }
    }
    
    
    
}

#Preview {
    Knock21.ContentView()
}


var text: String = """

SwiftUI100本ノック iOS16バージョン
かんたん（SwiftUIの簡単な構文だけで実装可能）
1. 画像をリサイズして表示（fit）
2. 画像をリサイズして表示（clip）
3. 画像を丸く切り取る
4. 画像を丸く切り取り、枠を付ける
5. 画像を等間隔で横に並べる
6. NavigationViewを使いラージタイトルを表示する
7. Pickerを表示する
8. TabViewを使って画面を切り替える
9. Buttonが押されたら文字を変える
10. Listを使ってセクションごとに表示する
11. 画面遷移時に値を渡す
12. NavigationViewの戻るボタンを非表示にする
13. Listのスタイルを変更する
14. アラートを表示する（その1）
15. アラートを表示する（その2）
16. アラートを出し分ける（その1）
17. アラートを出し分ける（その2）
18. Button内の画像やテキストの色を変えない
19. SwiftUIでアラートとシートを出し分ける
20. NavigationLinkではなくButtonを押して画面遷移する
21. 続きを読む。。。ボタンがあるViewを実装する
22. Text中の文字の太さや色を変える
23. FunctionBuilderを使ってViewに影をつける
24. ViewModifierを使ってViewに影をつける
25. リストを編集する
26. リストのセルをタップするとアラートが表示させる
27. 画面遷移先のViewから遷移元のメソッドを呼び出す
28. ListViewからそれぞれ別のViewに遷移する
29. 複数行のPickerを作成する
30. Sheetを表示する
31. 全画面でSheetを表示する
32. NavigationBarを隠す
33. Previewを横向きにする
34. 端末のシェイクを検知する
35. UICollectionViewのようにViewを並べる
36. アプリ起動時に画面を遷移させる
37. よくあるチュートリアル画面をUIPageViewControllerとSwiftUIで作る
38. 閉じることができないモーダルを表示する
39. モーダルからフルモーダルを表示する
40. フルスクリーンモーダルを表示する
41. 文字列中にタップ可能なリンクを追加する
42. GithubのAPIを叩き、リポジトリの情報をリストに表示する（Closure）
43. GithubのAPIを叩き、リポジトリの情報をリストに表示する（Combine）
44. GithubのAPIを叩き、リポジトリの情報をリストに表示する。一番下までスクロールされたら追加で取得してください。
45. GithubのAPIを叩き、リポジトリの情報をリストに表示する。一番下までスクロールされたら追加で取得してください。Indicator も表示してください。
46. SwiftUIのTextFieldで編集中と編集完了を検知する
47. SwiftUIのTextFieldで編集中と編集完了を検知する
48. SwiftUIでAppStorageを使ってUserDefaultの値を監視する
49. SwiftUIでViewの上にViewを重ねる
50. SwiftUIでMapを使う。Mapにピンを立てる
51. SwiftUIでImageを長押しするとContextMenuを表示する
52. SwiftUIを使ったTODOアプリのサンプル
53. SwiftUIでAVAudioPlayerで音楽を再生し、再生終了を検知する
54. SwiftUIでモーダルを表示する時に値を渡す
55. SwiftUIで複数のモーダルをEnumで出し分ける
56. @Stateと@Bindingの使い分け
57. SwiftUIでBMIを計算し、結果を別のViewで表示する
58. SwiftUIでボタンを押すとポップアップを表示する
59. SwiftUIでアラートを入れ子にして使うことができない
60. QGridを使ってCollectionViewを実装する
61. SwiftUIでViewを横スクロールで表示する
62. SwiftUIでButtonを有効にしたり無効にしたりする
63. SwiftUIのTextFieldで表示するキーボードを指定する
64. SwiftUIで初めの画面に遷移する（popToRootViewController）
65. SwiftUIでシートを表示し、プッシュ遷移後にシートを閉じる
66. SwiftUIでListをEditModeにして並び替える
67. SwiftUIのListでSpacerの部分にもタップ判定をつける
68. SwiftUIのListの中にボタンを複数設置する
69. SwiftUIでSearchBar(TextField)を使って検索する
70. SwiftUIでSearchBar(TextField)にクリアボタンをつける
71. SwiftUIでUIActivityViewControllerを表示する
72. SwiftUIでActivityIndicatorを表示する
73. SwiftUIで少しカスタマイズしたActivityIndicatorを表示する
74. SwiftUIでListにButtonを設定してパラメーターの違う画面に遷移する
75. SwiftUIのTabViewのタブをコードから動的に切り替える
76. Identifiableに適合していないStructでListを使う
77. SwiftUIでカメラを使う
78. SwiftUIでスライダーとスクロールを連動させる
79. SwiftUIでPHPickerViewControllerを使って画像を選択する
80. SwiftUIでMapViewの中央に十字を用意し、その中央の座標を取得する
81. SwiftUIでMapViewを使い複数の位置情報を選択する
82. SwiftUIで画像をピンチで拡大する（MagnificationGesture）
83. SwiftUIで画像をピンチで拡大する（PDFView）
84. SwiftUIで画像をピンチで拡大する（UIImageView + UIScrollView）
85. iOSのファイルアプリ（UIDocumentPickerViewController）を開いてドキュメントフォルダに保存したファイルを開く
86. SwiftUIでObservableObjectの@publishedなプロパティとBindingをする
87. Swiftのasync,awaitを使ってAPIをフェッチする
88. Swiftのasync,awaitを使ってAPIと画像を取得し、全てが揃ってから表示する
89. SwiftUIでさまざまなデバイスのプレビューを確認する
"""
