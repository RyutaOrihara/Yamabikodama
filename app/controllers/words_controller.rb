class WordsController < ApplicationController
  # before_action :実行したいメソッド名, only: [:適用するアクション名]
  # アクション内のメソッドが実行される前に指定したメソッド、、この場合はset_wordを実行できる
  # onlyオプションを使用することで、指定されたアクションが実行された場合(ここでは、show,edit,update,destroy)のみbefore_actionが実行される
### #が3つついてる処理部分は重複しているためコメントアウトしている
  before_action :set_word, only: [:show,:edit,:update,:destroy]
  # 一覧
  def index
    @words = Word.all
  end

  # 新規作成
  def new
    @word = Word.new
  end

  # 新規作成を保存
  def create
    # バリデーション処理が追加されたためcreateアクションなどの保存処理
    # に変更を加える。
    # バリデーションが許されたのか、許されないのかによってレコードが保存されるか決まる
    # そのため保存ができる場合とできない場合の条件分岐を追記する必要がある
    @word = Word.new(word_params)
    # 戻るボタンが実行されたかはparams[:back]で確認
    # 戻るボタンが押されている場合は値を保持しつつ、新規投稿に戻る
    # 一度戻るボタンを押すと再度確認画面に進まないで登録できてしまう
    # 原因はform_withのurl指定しているヘルパーメソッドである
    # ヘルパーメソッドにはアクションがnewだった場合しか一覧画面へ遷移していない。createも記述する
    if params[:back]
      render :new
    else
      if @word.save
        # redirectは指定したURLにアクセスする際、一からデータ全てを取得し直す
        # noticeはリダイレクト先にメッセージを表示する
        redirect_to words_path, notice: "ツイートを投稿しました！"
      else
        # renderはredirectと違い画面をもう一度描画するという意味なのでデータの状態をそのままにする
        render :new
        # 20200213 renderするのはいいが、new.html.erbにエラーメッセージを表示させる
      end
    end
  end

  # 詳細画面
  def show
    # showアクションの中でどうやってリクエストされたidが5のブログを取得する処理を書けば良いのか
    # レコードを1件取得するためにはfindメソッドを使用する
    # findメソッドの引数にどのブログのidを渡せば良いのかを教えてあげる
    # <%= link_to '詳細を確認する', blog_path(blog.id) %>
    # 上記のリンクをクリックした時にサーバにはクリックしたツイートのidでGETメソッドでリクエストが飛んでいる。
    # findメソッドに引数(params[:id])でリクエストされたツイートにidを取得する
    # Viewに取得したデータを渡すため、インスタンス変数@wordを定義して代入する
### @word = Word.find(params[:id])
  end

  # 編集
  def edit
    # 0から作るnewとは違い、すでに存在しているデータを編集するして再度保持するアクション
    # そのため、保存しているデータをデータベースから取り出してインスタンス変数に代入する
    # 編集するデータを決めるにはオブジェクトのidが必要。
    # なので、findメソッドで見つける、何を？オブジェクトのidを。
    # インスタンス.findメソッド(引数)
    # オブジェクトに対してメソッドになるので、Prametersはparamsに置き換わる。
### @word = Word.find(params[:id])
  end

  # 編集を保存
  def update
    # 値を更新するため
    # 予め更新したいツイートを取得しておく
    # updateアクションもeditアクション同様にアクションが起動すると、parametersで(ブログの)idが送られてくるようになっています。
### @word = Word.find(params[:id])
    # 持ってきたオブジェクトの値で更新ができたら
    # 一覧ページに遷移する
    if @word.update(word_params)
      redirect_to words_path, notice:"ツイートを編集しました"
    else
    # バリデーションに失敗したらもう一度編集画面に戻る
      render :edit
    end
  end
  # updateアクションで値を更新する際は、editと同様にid値を取得する必要がある。

 # 削除機能
 # 削除したいブログを取得し、削除させるメソッドを使用して削除するという実装
  def destroy
    # 削除対象の値をインスタンス変数@wordに取得する(before_actionでset_wordメソッドにより@word = Word.find(params[:id])で対象情報を取得済み)
    # モデルに対するメソッドdestroyを使用して削除を実行
    # 削除したあとに一覧画面に遷移する
    if @word.destroy
      redirect_to words_path, notice:"ツイートを削除しました"
    end
  end

 # 確認画面
  def confirm
    # newアクションからcreateアクションを実行する流れになっている。
    # viewファイル_form.html.erbのform_withの引数でアクセスするURL先をconfirmアクションを実行させる動きにする必要がある
    # form_withのデフォルト設定
    # 引数がレコードに存在しない場合、createアクションへ送信します。
    # 引数がレコードに存在している場合、updateアクションへ送信します。
    @word = Word.new(word_params)
    # 新規投稿時に空欄でも確認画面へ行けてしまう
    # バリデーションの性質はDBにレコードが保存される前に動作するからである
    # 手導でバリデーション発生させるためにはvalid,invalidメソッドを使う
    # そのバリデーションに許されなかった場合は render :newとする
    # invalid? バリデーションを失敗してるなら = ture
    # .invalid?はバリデーションを実行し、boolean型の戻り値を受け取ります。
    # バリデーションが失敗 => true
    # バリデーションが成功 => false
    render :new if @word.invalid?
  end



  private
  # Parameterを取得する際に「何を許可するか」を指定する
  # Parameterの中身をセキュリティ観点からの許可設定をStrongParameterという
  def word_params
    params.require(:word).permit(:content)
  end
  #クリックしたツイートのidをインスタンス変数に代入する処理は
  # show,edit,updateの重複している
  # private配下に記述してメソッド化しておく
  # なぜprivateに句の中に書くのかというと、
  # 固有のコントローラにアクションに必要な値を渡すメソッドは他のところでは基本使われないからである
  # このメソッドをアクションが行われる前に実行するため先頭にbefore_actionメソッドを記述する
  def set_word
    @word = Word.find(params[:id])
  end
end
