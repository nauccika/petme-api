-- 게시글1
INSERT INTO tb_petme_qna (tb_user_id, category, title, content, writer, write_time)
VALUES(2, '훈련 | 교정', '아이 성격때문에 산책하기가 힘든데 팁좀 주세요',
    '요크 남자애인데 산책할때 성격이 급해서 꼭 뛰어가려고 해요.태어날 때부터 뒷다리가 안 좋아서 수술했었는데 제가 천천히 걸으면 두 발로 서서 껑충껑충 뛰고 빨리 가려고 난리가 나요. 그렇게 1시간 정도 산책 후 집에 오면 항상 이틀 정도는 한 쪽 다리를 절고 밤에 아프다고 낑낑대요..어떻게 훈련시켜줘야 천천히 걸으면서 냄새도 맡으면서 얌전하게 산책할 수 있을까요? ㅠㅠ',
    '루피', now());
-- 게시글1 댓글1
INSERT INTO tb_petme_qna (tb_user_id, content, writer, write_time, parent_id, `order`, `depth`)
VALUES(null, '훈련사한테 한번 문의해보세요!', '우리집댕댕이최고', now(), 2, 1, 1);  
-- 게시글1 댓글2
INSERT INTO tb_petme_qna (tb_user_id, content, writer, write_time, parent_id, `order`, `depth`)
VALUES(null, '왜 그런데요', '귀여운 댕댕이', now(), 2, 2, 1);  
-- 게시글1 댓글3
INSERT INTO tb_petme_qna (tb_user_id, content, writer, write_time, parent_id, `order`, `depth`)
VALUES(null, '에구ㅜㅜ 저는 훈련쪽은 모르지만 아직 애기라 잘 몰라서 그런거 아닌가 싶네요 ㅜ', '하남토리', now(), 2, 3, 1);  
-- 게시글1 댓글4
INSERT INTO tb_petme_qna (tb_user_id, content, writer, write_time, parent_id, `order`, `depth`)
VALUES(null, '교육 잘 시켜보세요', '백문이네', now(), 2, 4, 1);  
