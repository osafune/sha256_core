SHA-256 Core
====================

SHA-256�̃n�b�V���l���v�Z����VHDL���W���[���ł��B


�g����
==========

`rtl`�ȉ���VHDL�t�@�C�����e�X�̃v���W�F�N�g�ɒǉ����܂��B�ڍׂȓ���ɂ��Ă�`testbench`�̃V�~�����[�V�������ʂ��Q�Ƃ��Ă��������B


�C���X�^���X
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

### �|�[�g���� ###

`reset`
�񓯊����Z�b�g�B'1'�ŃA�N�e�B�u�B
`clk`
�R���|�[�l���g�̓����N���b�N�B�����オ��G�b�W�쓮�B
`clk_ena`
�\��B'1'�ɌŒ�B
`init`
�P�N���b�N����'1'�œ����n�b�V�����W�X�^�������Bready�M�����A�T�[�g����Ă��鎞�̂ݗL���Bstart�M���Ƃ͔r���ɂ��邱�ƁB
`start`
�P�N���b�N����'1'�ŉ��Z�J�n�Bready�M�����A�T�[�g����Ă��鎞�̂ݗL���Binit�M���Ƃ͔r���ɂ��邱�ƁB
`ready`
�����X�e�[�g�����B�����X�e�[�g����t�\��Ԃ̎���'1'��Ԃ��B
`m_in`
���b�Z�[�W���̓|�[�g�BM(0)�`M(15)�����ɓ�������Bm_in_ack���A�T�[�g���ꂽ�玟�̃��b�Z�[�W�ɐi�ށB
`m_in_ack`
���b�Z�[�W���̓A�N�m���b�W�B���b�Z�[�W���󂯕t������'1'��Ԃ��B
`hash`
�n�b�V���l�o�̓|�[�g�Bhash_valid�M�����A�T�[�g��Ԃ̎��ɗL���l��Ԃ��B�v�Z���ʂ�ready��'0'��'1'�ɕω������^�C�~���O�ōX�V�����B
`hash_valid`
�n�b�V���l�L���M���Bhash���L���ȃf�[�^�̏ꍇ��'1'��Ԃ��B


���C�Z���X
=========

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
