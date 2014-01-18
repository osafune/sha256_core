SHA-256 Core
====================

SHA-256のハッシュ値を計算するVHDLモジュールです。


使い方
==========

`rtl`以下のVHDLファイルを各々のプロジェクトに追加します。詳細な動作については`testbench`のシミュレーション結果を参照してください。


インスタンス
-----------------------------
	sha256_inst : sha256_calc port map(
			reset		=> reset_sig,
			clk			=> clk_sig,
			clk_ena		=> '1',
			init		=> init_sig,
			start		=> start_sig,
			ready		=> ready_sig,
			m_in		=> m_in_sig,
			m_in_ack	=> m_in_ack_sig,
			hash		=> hash_sig,
			hash_valid	=> hash_valid_sig
		);

### ポート説明 ###

`reset`
非同期リセット。'1'でアクティブ。
`clk`
コンポーネントの同期クロック。立ち上がりエッジ駆動。
`clk_ena`
予約。'1'に固定。
`init`
１クロック幅の'1'で内部ハッシュレジスタ初期化。ready信号がアサートされている時のみ有効。start信号とは排他にすること。
`start`
１クロック幅の'1'で演算開始。ready信号がアサートされている時のみ有効。init信号とは排他にすること。
`ready`
内部ステート示唆。内部ステートが受付可能状態の時に'1'を返す。
`m_in`
メッセージ入力ポート。M(0)～M(15)を順に投入する。m_in_ackがアサートされたら次のメッセージに進む。
`m_in_ack`
メッセージ入力アクノリッジ。メッセージを受け付けたら'1'を返す。
`hash`
ハッシュ値出力ポート。hash_valid信号がアサート状態の時に有効値を返す。計算結果はreadyが'0'→'1'に変化したタイミングで更新される。
`hash_valid`
ハッシュ値有効信号。hashが有効なデータの場合に'1'を返す。


ライセンス
=========

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
