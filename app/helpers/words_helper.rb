module WordsHelper
  # ヘルパー"メソッド"なのでメソッド名を決める
  def choose_new_or_edit
    if action_name == 'new' || action_name == 'create'
      confirm_words_path
    elsif action_name == 'edit'
      word_path
    end
  end
end

# editアクションからupdateアクションに移る際
# PATCH “/blogs/confirmというroutingは存在しないためエラーとなる
# updateアクションへ送信するためには、PATCH /blogs/:id(.:format) blogs#updateと送る必要がある。
# 従って、newアクションの時は、url: confirm_blogs_pathオプションに、
# updateアクションのときはblog_pathオプションが生成されるようにする

# カリキュラムは編集時には確認画面に行かないようにしている

# アクションで分岐したい場合、ヘルパーメソッドを定義する
# action_nameを使用すると簡単に実装できる。
# ヘルパーメソッドに定義したメソッドは、どのビューからも使用できるようになります。
# newアクションとeditアクションの時に適切なパスを返すヘルパーメソッドを定義する。


# ヘルパーメソッドを使用することで、通常の処理に例外的な処理を組み込むことができる。
