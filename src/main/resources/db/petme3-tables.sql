#************************************************************************************************/
# Web Crawling 데이터 관련 테이블들
#************************************************************************************************/
#------------------------------------------------------------
# tb_place_business_hours : 해당 장소(가게)의 영업시간 데이타가 저장되는 테이블
#------------------------------------------------------------

  DROP TABLE IF EXISTS `tb_place_business_hours`;
  DROP TABLE IF EXISTS `tb_place_business_hours`;
  CREATE TABLE `tb_place_business_hours` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_place_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `content` text NOT NULL COMMENT '영업시간 전체정보',
    `all_year_round_yn` varchar(1) DEFAULT NULL COMMENT '연중무휴 여부',
    `closed_days` varchar(2048) DEFAULT NULL COMMENT '특정 휴무일',
    `regular_holiday` varchar(8) DEFAULT NULL COMMENT '정기 휴무일',
    `weekly_regular_holiday_yn` varchar(1) DEFAULT NULL COMMENT '매주 정기휴무일 여부',
    `monthly_regular_holiday_yn` varchar(1) DEFAULT NULL COMMENT '매월 정기휴무일 여부',
    `monday_hours` varchar(32) DEFAULT NULL COMMENT '월요일 영업시간',
    `tuesday_hours` varchar(32) DEFAULT NULL COMMENT '화요일 영업시간',
    `wednesday_hours` varchar(32) DEFAULT NULL COMMENT '수요일 영업시간',
    `thursday_hours` varchar(32) DEFAULT NULL COMMENT '목요일 영업시간',
    `friday_hours` varchar(32) DEFAULT NULL COMMENT '금요일 영업시간',
    `saturday_hours` varchar(32) DEFAULT NULL COMMENT '토요일 영업시간',
    `sunday_hours` varchar(32) DEFAULT NULL COMMENT '일요일 영업시간',
    `monday_break_time` varchar(32) DEFAULT NULL COMMENT '월요일 휴게시간',
    `tuesday_break_time` varchar(32) DEFAULT NULL COMMENT '화요일 휴게시간',
    `wednesday_break_time` varchar(32) DEFAULT NULL COMMENT '수요일 휴게시간',
    `thursday_break_time` varchar(32) DEFAULT NULL COMMENT '목요일 휴게시간',
    `friday_break_time` varchar(32) DEFAULT NULL COMMENT '금요일 휴게시간',
    `saturday_break_time` varchar(32) DEFAULT NULL COMMENT '토요일 휴게시간',
    `sunday_break_time` varchar(32) DEFAULT NULL COMMENT '일요일 휴게시간',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `index_tb_place_business_hours_tb_place_id` (`tb_place_id`)    
    -- FOREIGN KEY (`tb_place_id`) REFERENCES `tb_place_id` (`id`),
    -- FULLTEXT `index_tb_place_id_content` (`content`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='영업시간 테이블';
#------------------------------------------------------------
# tb_server : 서버에 대한 정보가 저장되는 테이블
#------------------------------------------------------------
  CREATE TABLE `tb_server` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `hostname` varchar(64) NOT NULL COMMENT '서버 호스트명',
    `nickname` varchar(64) NOT NULL COMMENT '서버 닉네임(별명)',
    `model` varchar(64) NOT NULL COMMENT '서버 모델명',
    `ip1` varchar(15) DEFAULT NULL COMMENT '서버 ip 주소1',
    `ip2` varchar(15) DEFAULT NULL COMMENT '서버 ip 주소2',
    `status` varchar(32) DEFAULT NULL COMMENT '서버 상태',
    `load_average` tinyint(8) DEFAULT '0' COMMENT '서버 로드평균(로드 애버리지)',
    `concurrent_user` int(11) unsigned DEFAULT '0' COMMENT '서버 동접자수',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `index_tb_server_nickname` (`nickname`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='서버 정보 테이블';
#------------------------------------------------------------
# tb_file : 파일에 대한 정보가 저장되는 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_file`;
  DROP TABLE IF EXISTS `tb_file`;
  CREATE TABLE `tb_file` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    -- `tb_server_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_place_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_blog_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_bulletin_board_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_pet_raboratory_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_petme_notice_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_event_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `original_name` varchar(512) NOT NULL COMMENT '원본 파일명',
    `save_name` varchar(512) NOT NULL COMMENT '저장 파일명',
    `full_path` varchar(1024) NOT NULL COMMENT '파일 저장 전체경로명',
    `size` int(11) NOT NULL COMMENT '파일크기(Byte)',
    `hash_type` varchar(32) NOT NULL COMMENT '해시종류',
    `hash` varchar(512) NOT NULL COMMENT '파일해시',
    `mimetype` varchar(32) DEFAULT NULL COMMENT '파일 마인타입',
    `gubun` varchar(64) DEFAULT NULL COMMENT '파일 구분',
    `source` varchar(32) DEFAULT NULL COMMENT '파일 source',
    `main_image_yn` varchar(1) DEFAULT NULL COMMENT '대표이미지여부',
    `exposure_order` smallint(6) unsigned DEFAULT NULL COMMENT '노출순서',
    `encoding` varchar(32) DEFAULT NULL COMMENT '파일 엔코딩',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `index_tb_file_save_name` (`save_name`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='파일 정보 테이블';
#------------------------------------------------------------
# tb_review : 후기 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_review`;
  DROP TABLE IF EXISTS `tb_review`;
  CREATE TABLE `tb_review` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_place_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_blog_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `writer` varchar(256) DEFAULT NULL COMMENT '리뷰 작성자',
    `content` text NOT NULL COMMENT '리뷰 내용',
    `grade` varchar(10) DEFAULT NULL COMMENT '평점',
    `keyword` varchar(20) DEFAULT NULL COMMENT '리뷰 키워드',
    `read_count` int(11) unsigned DEFAULT '0' COMMENT '리뷰 조회수',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='후기 정보 테이블';
#------------------------------------------------------------
# tb_blog : 블로그 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_blog`;
  DROP TABLE IF EXISTS `tb_blog`;
  CREATE TABLE `tb_blog` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_place_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `url` varchar(1024) NOT NULL COMMENT '블로그 주소',
    `title` varchar(512) DEFAULT NULL COMMENT '블로그 제목',
    `content` text NOT NULL COMMENT '블로그 내용',
    `writer` varchar(256) DEFAULT NULL COMMENT '블로그 작성자',
    `hashtag` varchar(1024) DEFAULT NULL COMMENT '블로그 해시태그',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    KEY `index_tb_blog_title` (`title`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='블로그 정보 테이블';
#------------------------------------------------------------
# tb_crawling_naver_map : 네이버 맵(지도)에서 크롤링한 데이터가 저장되는 테이블 = tb_place
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_crawling_naver_map`;
  DROP TABLE IF EXISTS `tb_crawling_naver_map`;
  CREATE TABLE `tb_crawling_naver_map` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `name` varchar(1024) NOT NULL COMMENT '장소이름',
    `ranking` varchar(10) DEFAULT NULL COMMENT '랭킹(순위)',
    `blog_review_count` int(11) unsigned DEFAULT '0' COMMENT '블로그 리뷰수',
    `visitor_review_count` int(11) unsigned DEFAULT '0' COMMENT '방문자 리뷰수',
    `street_name_address` varchar(1024) DEFAULT NULL COMMENT '도로명 주소',
    `lot_number_address` varchar(1024) DEFAULT NULL COMMENT '지번 주소',
    `zipcode` varchar(20) DEFAULT NULL COMMENT '우편번호',
    `phone` varchar(20) DEFAULT NULL COMMENT '전화번호(대표)',
    `payment_method` varchar(80) DEFAULT NULL COMMENT '결제 수단',
    `content` text DEFAULT NULL COMMENT '장소 소개/설명',
    `information_use` text DEFAULT NULL COMMENT '이용안내/정보(부가서비스포함)',
    `homepage_url` varchar(1024) DEFAULT NULL COMMENT '홈페이지 주소',
    `blog_url` varchar(1024) DEFAULT NULL COMMENT '블로그 주소',
    `instagram_url` varchar(1024) DEFAULT NULL COMMENT '인스타그램 주소',
    `facebook_url` varchar(1024) DEFAULT NULL COMMENT '페이스북 주소',
    `youtube_url` varchar(1024) DEFAULT NULL COMMENT '유튜브 주소',
    `hashtag` varchar(1024) NOT NULL COMMENT '해시태그',
    `business_gubun` varchar(32) DEFAULT 'bt00' COMMENT '장소 구분',
    `latitude` double DEFAULT NULL COMMENT '위도좌표(y좌표)',
    `longitude` double DEFAULT NULL COMMENT '경도좌표(x좌표)',
    `summary` varchar(1024) DEFAULT NULL COMMENT '장소 요약',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='네이버맵 정보 크롤링 테이블';
#------------------------------------------------------------
# tb_crawling_dogpalza : 네이버 카페 강사모에서 크롤링한 데이터가 저장되는 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_crawling_dogpalza`;
  DROP TABLE IF EXISTS `tb_crawling_dogpalza`;
  CREATE TABLE `tb_crawling_dogpalza` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `category` varchar(64) DEFAULT NULL COMMENT '카테고리',
    `title` varchar(512) NOT NULL COMMENT '게시글 제목',
    `content` text NOT NULL COMMENT '게시글 내용',
    `writer` varchar(256) DEFAULT NULL COMMENT '커뮤니티 게시판 게시글 작성자',
    `write_time` datetime DEFAULT NULL COMMENT '커뮤니티 게시판 게시글 작성자',
    `read_count` int(11) unsigned DEFAULT '0' COMMENT 'Q&A 조회수',
    `parent_id` bigint(20) unsigned DEFAULT NULL COMMENT '부모 게시글 아이디',
    `order` tinyint(2) unsigned NOT NULL COMMENT '답변순서',
    `depth` tinyint(2) unsigned DEFAULT '0' COMMENT '댓글 레벨/깊이',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='강사모 크롤링 정보 테이블';
#------------------------------------------------------------
# tb_bulletin_board : tb_crawling_dogpalza 테이블의 clone 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_bulletin_board`;
  DROP TABLE IF EXISTS `tb_bulletin_board`;
  CREATE TABLE `tb_bulletin_board` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'tb_user.id',
    `category` varchar(64) DEFAULT NULL COMMENT '카테고리',
    `title` varchar(512) NOT NULL COMMENT '게시글 제목',
    `content` text NOT NULL COMMENT '게시글 내용',
    `writer` varchar(256) DEFAULT NULL COMMENT '커뮤니티 게시판 게시글 작성자',
    `write_time` datetime DEFAULT NULL COMMENT '커뮤니티 게시판 게시글 작성자',
    `read_count` int(11) unsigned DEFAULT '0' COMMENT 'Q&A 조회수',
    `parent_id` bigint(20) unsigned DEFAULT NULL COMMENT '부모 게시글 아이디',
    `order` tinyint(2) unsigned NOT NULL COMMENT '답변순서',
    `depth` tinyint(2) unsigned DEFAULT '0' COMMENT '댓글 레벨/깊이',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='강사모 크롤링 정보 테이블';
#------------------------------------------------------------
# tb_place : 장소 상세 정보 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_place`;
  DROP TABLE IF EXISTS `tb_place`;
  CREATE TABLE `tb_place` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `name` varchar(1024) NOT NULL COMMENT '장소이름',
    `ranking` varchar(10) DEFAULT NULL COMMENT '랭킹(순위)',
    `blog_review_count` int(11) unsigned DEFAULT '0' COMMENT '블로그 리뷰수',
    `visitor_review_count` int(11) unsigned DEFAULT '0' COMMENT '방문자 리뷰수',
    `street_name_address` varchar(1024) DEFAULT NULL COMMENT '도로명 주소',
    `lot_number_address` varchar(1024) DEFAULT NULL COMMENT '지번 주소',
    `zipcode` varchar(20) DEFAULT NULL COMMENT '우편번호',
    `phone` varchar(20) DEFAULT NULL COMMENT '전화번호(대표)',
    `payment_method` varchar(80) DEFAULT NULL COMMENT '결제 수단',
    `content` text DEFAULT NULL COMMENT '장소 소개/설명',
    `information_use` text DEFAULT NULL COMMENT '이용안내/정보(부가서비스포함)',
    `homepage_url` varchar(1024) DEFAULT NULL COMMENT '홈페이지 주소',
    `blog_url` varchar(1024) DEFAULT NULL COMMENT '블로그 주소',
    `instagram_url` varchar(1024) DEFAULT NULL COMMENT '인스타그램 주소',
    `facebook_url` varchar(1024) DEFAULT NULL COMMENT '페이스북 주소',
    `youtube_url` varchar(1024) DEFAULT NULL COMMENT '유튜브 주소',
    `hashtag` varchar(1024) NOT NULL COMMENT '해시태그',
    `business_gubun` varchar(64) DEFAULT NULL COMMENT '장소 구분',
    `latitude` double DEFAULT NULL COMMENT '위도좌표(y좌표)',
    `longitude` double DEFAULT NULL COMMENT '경도좌표(x좌표)',
    `place_summary` varchar(1024) DEFAULT NULL COMMENT '장소 요약',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='장소 정보 테이블';
#------------------------------------------------------------
# tb_pet_raboratory : 애견에 관한 컨텐츠 정보 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_pet_raboratory`;
  DROP TABLE IF EXISTS `tb_pet_raboratory`;
  CREATE TABLE `tb_pet_raboratory` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `category` varchar(64) NOT NULL COMMENT '펫연구소 콘텐츠 카테고리',
    `title` varchar(512) NOT NULL COMMENT '펫연구소 콘텐츠 제목',
    `hashtag` varchar(1024) DEFAULT NULL COMMENT '펫연구소 콘텐츠 해시태그',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    KEY `idx_tb_pet_raboratory_category` (`category`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='애견 컨텐츠 정보 테이블';
#------------------------------------------------------------
# tb_event : 이벤트 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_event`;
  DROP TABLE IF EXISTS `tb_event`;
  CREATE TABLE `tb_event` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `title` varchar(512) NOT NULL COMMENT '이벤트 제목',
    `writer` varchar(256) DEFAULT NULL COMMENT '이벤트 작성자',
    `content` text NOT NULL COMMENT '이벤트 내용',
    `content1` text DEFAULT NULL COMMENT '이벤트 내용1',
    `content2` text DEFAULT NULL COMMENT '이벤트 내용2',
    `read_count` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '이벤트 읽음 조회수', 
    `applicant_limit` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '응모자수 제한',
    `applicant_number` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '응모자 인원수',
    `link_url` varchar(1024) NOT NULL COMMENT '링크 주소',
    `html_yn` varchar(1) DEFAULT NULL COMMENT 'HTML 사용여부',
    `event_start_date` datetime DEFAULT NULL COMMENT '이벤트 시작일',
    `event_end_date` datetime DEFAULT NULL COMMENT '이벤트 종료일',
    `use_yn` varchar(4) DEFAULT 'y' COMMENT '사용여부/노출여부',    
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='이벤트 정보 테이블';
#------------------------------------------------------------
# tb_point_use_history : 포인트 정보 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_point_history`;
  DROP TABLE IF EXISTS `tb_point_history`;
  CREATE TABLE `tb_point_history` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '로그인 아이디',
    `login_id` int(11) NOT NULL COMMENT '로그인 아이디',
    `point_gubun` varchar(64) DEFAULT NULL COMMENT '포인트 타입',
    `billing_method` varchar(128) DEFAULT NULL COMMENT '빌링 형태',
    `billing_status` varchar(64) DEFAULT NULL COMMENT '빌링 상태',
    `use_type` varchar(128) DEFAULT NULL COMMENT '포인트 이용 형태',
    `used_point` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '이용 포인트',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    KEY `idx_tb_point_history_login_id` (`login_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='로그인 히스토리 테이블';
#------------------------------------------------------------
# tb_gifticon_history : 기프티콘 정보 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_gifticon_history`;
  DROP TABLE IF EXISTS `tb_gifticon_history`;
  CREATE TABLE `tb_gifticon_history` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '로그인 아이디',
    `login_id` int(11) NOT NULL COMMENT '로그인 아이디',
    `gifticon_code` varchar(256) NOT NULL COMMENT '기프티콘 코드',
    `get_date` datetime DEFAULT NULL COMMENT '기프티콘 취득일',
    `used_point` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '이용 포인트',
    `used_date` datetime DEFAULT NULL COMMENT '기프티콘 사용일',
    `use_type` varchar(128) DEFAULT NULL COMMENT '기프티콘 이용 형태',
    PRIMARY KEY (`id`),
    KEY `idx_ttb_gifticon_history_login_id` (`login_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='기프티콘 히스토리 테이블';
#------------------------------------------------------------
# tb_coupon_history : 쿠폰 정보 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_coupon_history`;
  DROP TABLE IF EXISTS `tb_coupon_history`;
  CREATE TABLE `tb_coupon_history` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '로그인 아이디',
    `login_id` int(11) NOT NULL COMMENT '로그인 아이디',
    `coupon_code` varchar(256) NOT NULL COMMENT '쿠폰 코드',
    `used_point` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '이용 포인트',
    `get_date` datetime DEFAULT NULL COMMENT '쿠폰 취득일',
    `used_date` datetime DEFAULT NULL COMMENT '쿠폰 사용일',
    `use_type` varchar(128) DEFAULT NULL COMMENT '쿠폰 이용 형태',
    PRIMARY KEY (`id`),
    KEY `idx_tb_coupon_history_login_id` (`login_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='로그인 히스토리 테이블';
#------------------------------------------------------------
# tb_admin_user : 관리자 정보 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_admin_user`;
  DROP TABLE IF EXISTS `tb_admin_user`;
  CREATE TABLE `tb_admin_user` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `login_id` varchar(256) NOT NULL COMMENT '관리자 아이디',
    `user_name` varchar(256) DEFAULT NULL COMMENT '관리자명',
    `password` varchar(64) DEFAULT NULL COMMENT '로그인 패스워드',
    `email` varchar(512) DEFAULT NULL COMMENT '사용자 이메일',
    `phone` varchar(20) DEFAULT NULL COMMENT '전화번호',
    `resident_registration_number` varchar(18) DEFAULT NULL COMMENT '주민등록번호',
    `street_name_address` varchar(1024) DEFAULT NULL COMMENT '도로명 주소',
    `lot_number_address` varchar(1024) DEFAULT NULL COMMENT '지번 주소',
    `gender` varchar(16) DEFAULT NULL COMMENT '성별',
    `department` varchar(128) DEFAULT NULL COMMENT '부서명',
    `position` varchar(128) DEFAULT NULL COMMENT '직위',
    `last_login` datetime DEFAULT NULL COMMENT '최근 로그인 시간',
    `login_times` int(11) NOT NULL DEFAULT '0' COMMENT '로그인 횟수',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `index_tb_admin_user_login_id` (`login_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='관리자정보';
#------------------------------------------------------------
# tb_user : 사용자 정보 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_user`;
  DROP TABLE IF EXISTS `tb_user`;
  CREATE TABLE `tb_user` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `login_id` varchar(256) NOT NULL COMMENT '사용자(회원) 아이디',
    `user_name` varchar(256) DEFAULT NULL COMMENT '사용자(회원) 이름',
    `password` varchar(64) DEFAULT NULL COMMENT '로그인 패스워드',
    `email` varchar(512) DEFAULT NULL COMMENT '사용자 이메일',
    `phone` varchar(20) DEFAULT NULL COMMENT '전화번호',
    `resident_registration_number` varchar(18) DEFAULT NULL COMMENT '주민등록번호',
    `street_name_address` varchar(1024) DEFAULT NULL COMMENT '도로명 주소',
    `lot_number_address` varchar(1024) DEFAULT NULL COMMENT '지번 주소',
    `gender` varchar(16) DEFAULT NULL COMMENT '성별',
    `receive_information_yn` varchar(1) DEFAULT '0' COMMENT '정보수신여부',
    `receive_event_yn` varchar(1) DEFAULT '0' COMMENT '이벤트수신여부',
    `access_token` varchar(4) DEFAULT '0' COMMENT '2차 oAuth 엑세스 토큰',
    `oauth_type` varchar(1) DEFAULT '0' COMMENT '2차 인증 타입',
    `pet_type` varchar(32) DEFAULT NULL COMMENT '애완동물 타입',
    `current_point` int(11) NOT NULL DEFAULT '0' COMMENT '현재 포인트',
    `last_login` datetime DEFAULT NULL COMMENT '최근 로그인 시간',
    `login_times` int(11) NOT NULL DEFAULT '0' COMMENT '로그인 횟수',
    `withdrawal_date` datetime DEFAULT NULL COMMENT '탈퇴일',
    `withdrawal_cause` varchar(512) DEFAULT NULL COMMENT '탈퇴이유',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `index_tb_user_login_id` (`login_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='회원정보';
#------------------------------------------------------------
# tb_user_login_history : 로그인 히스토리 정보 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_user_login_history`;
  DROP TABLE IF EXISTS `tb_user_login_history`;
  CREATE TABLE `tb_user_login_history` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '로그인 아이디',
    `login_id` int(11) NOT NULL COMMENT '로그인 아이디',
    `login_time` datetime NOT NULL COMMENT '로그인 시간',
    `login_ip` varchar(15) DEFAULT NULL COMMENT '로그인 IP 주소',
    `access_status` varchar(32) NOT NULL COMMENT '접속상태',
    PRIMARY KEY (`id`),
    KEY `idx_tb_user_login_history_login_id` (`login_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='로그인 히스토리 테이블';
#------------------------------------------------------------
# tb_device : 디바이스(기기) 정보 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_device`;
  DROP TABLE IF EXISTS `tb_device`;
  CREATE TABLE `tb_device` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '로그인 아이디',
    `uuid` varchar(64) NOT NULL COMMENT '디바이스 고유 아이디',
    `login_id` int(11) NOT NULL COMMENT '로그인 아이디',
    `os` varchar(50) NULL COMMENT '접속디바이스 운영체제',
    `ip` varchar(15) DEFAULT NULL COMMENT '로그인 IP 주소',
    `mac_address` varchar(17) DEFAULT NULL COMMENT 'MAC 주소',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='디바이스정보 테이블';
#------------------------------------------------------------
# tb_whatchlist : 찜목록(관심목록) 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_whatchlist`;
  DROP TABLE IF EXISTS `tb_whatchlist`;
  CREATE TABLE `tb_whatchlist` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'tb_user 테이블의 아이디',
    `tb_place_id` bigint(20) unsigned DEFAULT NULL COMMENT 'tb_place 테이블의 아이디',
    `tb_bulletin_board_id` bigint(20) unsigned DEFAULT NULL COMMENT 'tb_bulletin_board_id 테이블의 아이디',
    `tb_pet_raboratory_id` bigint(20) unsigned DEFAULT NULL COMMENT 'tb_pet_raboratory_id 테이블의 아이디',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `index_tb_whatchlist_tb_user_id` (`tb_user_id`),
    UNIQUE KEY `index_tb_whatchlist_tb_place_id` (`tb_place_id`),
    UNIQUE KEY `index_tb_whatchlist_tb_bulletin_board_id` (`tb_bulletin_board_id`),
    UNIQUE KEY `index_tb_whatchlist_tb_pet_raboratory_id` (`tb_pet_raboratory_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='찜목록(관심목록) 테이블';
#------------------------------------------------------------
# tb_zipcode : 우체국 우편번호 테이블
#------------------------------------------------------------
  # show create table tb_zipcode;
  DROP TABLE IF EXISTS `tb_zipcode`;
  DROP TABLE IF EXISTS `tb_zipcode`;
  CREATE TABLE `tb_zipcode` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `zipcode`        varchar(5) NULL COMMENT '구역번호(우편번호) (예) 06315',
    `sido`           varchar(25) NULL COMMENT '시도(한글) (예) 서울특별시',
    `sido_en`        varchar(50) NULL COMMENT '시도(영문) (예) Seoul',
    `sigungu`        varchar(30) NULL COMMENT '시군구(한글) (예) 강남구',
    `sigungu_en`     varchar(60) NULL COMMENT '시군구(영문) (예) Gangnam-g',
    `eupmyeon`        varchar(20) NULL COMMENT '읍면(한글) (예) 감물면',
    `eupmyeon_en`     varchar(40) NULL COMMENT '읍면(영문) (예) Gammul-myeon',
    `doro_code`      varchar(12) NULL COMMENT '도로명 코드 (예) 116804166204',
    `doro`           varchar(80) NULL COMMENT '도로명(한글) (예) 논현로8길',
    `doro_en`        varchar(160) NULL COMMENT '도로명(영문) (예) Nonhyeon-ro 8-gil',
    `undergnd_yn`    varchar(1) NULL COMMENT '지하여부(0:지상,1:지하) (예) 0',
    `budg_no1`       varchar(5) NULL COMMENT '건물번호 본번 (예) 67',
    `budg_no2`       varchar(5) NULL COMMENT '건물번호 부번 (예) 0',
    `budg_mgmt_no`   varchar(25) NULL COMMENT '건물관리번호 (예) 1168010300111830010000001',
    `big_dlvy`       varchar(1) NULL COMMENT '다량배달처명(대형빌딩,기관,아파트) (예) NULL',
    `budg_name`      varchar(200) NULL COMMENT '시군구용 건물명 (예) Artespace',
    `dong_code`      varchar(10) NULL COMMENT '법정동코드 (예) 1168010300',
    `dong`           varchar(20) NULL COMMENT '법정동명 (예) 개포동',
    `ri`             varchar(20) NULL COMMENT '리명 (예) 광전리',
    `dong_hj`        varchar(40) NULL COMMENT '행정동명 (예) 개포4동',
    `mtn_yn`         varchar(1) NULL COMMENT '산여부(0:토지,1:산) (예) 0',
    `jibun_no1`      varchar(4) NULL COMMENT '지번 본번 (예) 1183',
    `eupmyeondong_sn` varchar(2) NULL COMMENT '읍면동 일련번호 (예) 01',
    `jibun_no2`      varchar(4) NULL COMMENT '지번 부번 (예) 10',
    `zipcode_old`    varchar(7) NULL COMMENT '구 우편번호 (예) NULL',
    `zipcode_sn`     varchar(3) NULL COMMENT '우편번호 일련번호 (예) NULL',
    PRIMARY KEY (`id`),
    KEY `tb_zipcode_zipcode_INDEX` (`zipcode`),
    KEY `tb_zipcode_sido_sigungu_eupmyeon_INDEX` (`sido`,`sigungu`,`eupmyeon`),
    KEY `tb_zipcode_doro_code_INDEX` (`doro_code`),
    KEY `tb_zipcode_doro_INDEX` (`doro`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='우편번호 테이블';

  #CREATE UNIQUE INDEX `tb_zipcode_zipcode_INDEX` ON `tb_zipcode` (`zipcode`);
  #CREATE INDEX `tb_zipcode_sido_sigungu_eupmyun_INDEX` ON `tb_zipcode` (`sido`, `sigungu`, `eupmyeon`);
  #CREATE INDEX `tb_zipcode_doro_code_INDEX` ON `tb_zipcode` (`doro_code`);
  #CREATE INDEX `tb_zipcode_doro_INDEX` ON `tb_zipcode` (`doro`);

#------------------------------------------------------------
# tb_medical_staff : 병원 의료진 정보 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_medical_staff`;
  DROP TABLE IF EXISTS `tb_medical_staff`;
  CREATE TABLE `tb_medical_staff` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_place_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `staff_name` varchar(256) NOT NULL COMMENT '의료진 사람이름',
    `position` varchar(128) NOT NULL COMMENT '의료진 직위 (예) 부사장 대표원장 부원장',
    `profile` varchar(1024) NOT NULL COMMENT '의료진 약력/경력/career',
    `input_order` smallint(6) NOT NULL COMMENT '정보 입력순서',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='병원 의료진 정보';
#------------------------------------------------------------
# tb_ranking_algorithm : 랭킹 알고리즘 계산 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_ranking_algorithm`;
  DROP TABLE IF EXISTS `tb_ranking_algorithm`;
  CREATE TABLE `tb_ranking_algorithm` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_place_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `ranking_date` datetime DEFAULT NULL COMMENT '랭킹일',
    `final_ranking` varchar(20) DEFAULT NULL COMMENT '장소에 대한 랭킹', 
    `reserved1` varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드1', 
    `reserved2` varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드2', 
    `reserved3` varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드3', 
    `reserved4` varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드4', 
    `reserved5` varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드5', 
    `reserved6` varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드6', 
    `reserved7` varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드7', 
    `reserved8` varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드8', 
    `reserved9` varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드9', 
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='랭킹 알고리즘 계산 테이블';
#------------------------------------------------------------
# tb_petme_qna : 펫미 Q&A(질의응답)/댓글 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_petme_qna`;
  DROP TABLE IF EXISTS `tb_petme_qna`;
  CREATE TABLE `tb_petme_qna` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `category` varchar(64) DEFAULT NULL COMMENT '카테고리',
    `title` varchar(512) NOT NULL COMMENT '게시글 제목',
    `content` text NOT NULL COMMENT '게시글 내용',
    `writer` varchar(256) DEFAULT NULL COMMENT '커뮤니티 게시판 게시글 작성자',
    `write_time` datetime DEFAULT NULL COMMENT '커뮤니티 게시판 게시글 작성자',
    `read_count` int(11) unsigned DEFAULT '0' COMMENT 'Q&A 조회수',
    `parent_id` bigint(20) unsigned NOT NULL COMMENT '부모 게시글 아이디',
    `order` tinyint(2) unsigned NOT NULL COMMENT '답변순서',
    `depth` tinyint(2) unsigned DEFAULT '0' COMMENT '댓글 레벨/깊이',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='펫미 Q&A 테이블';
#------------------------------------------------------------
# tb_petme_notice : 펫미 공지사항
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_petme_notice`;
  DROP TABLE IF EXISTS `tb_petme_notice`;
  CREATE TABLE `tb_petme_notice` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_admin_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '로그인 아이디',
    `title` varchar(512) NOT NULL COMMENT '제목',
    `writer` varchar(256) DEFAULT NULL COMMENT '공지 작성자',
    `content` text NOT NULL COMMENT '공지 내용',
    `read_count` int(11) unsigned DEFAULT '0' COMMENT '공지사항 조회수', 
    `notice_gubun` varchar(64) DEFAULT NULL COMMENT '공지사항 타입',
    `link_url` varchar(1024) NOT NULL COMMENT '링크 주소',
    `html_yn` varchar(1) DEFAULT NULL COMMENT 'HTML 사용여부',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='펫미 공지사항 테이블';
#************************************************************************************************/
# Web 운영을 위해서 Admin Page 등과 관련된 관련 테이블들
#************************************************************************************************/
#------------------------------------------------------------
# tb_common_code_category : 공통코드 카테고리 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_common_code_category`;
  DROP TABLE IF EXISTS `tb_common_code_category`;
  CREATE TABLE `tb_common_code_category` (
    `id` bigint(20) unsigned NOT NULL COMMENT '아이디',
    `name` varchar(45) NOT NULL COMMENT '카테고리명',
    `english_name` varchar(64) NOT NULL COMMENT '카테고리 영문명',
    `description` varchar(64) NOT NULL COMMENT '카테고리 설명',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='검색키워드 정보 테이블';
#------------------------------------------------------------
# tb_common_code : 공통코드 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_common_code`;
  DROP TABLE IF EXISTS `tb_common_code`;
  CREATE TABLE `tb_common_code` (
    `code` bigint(20) unsigned NOT NULL COMMENT '공통코드',
    `name` varchar(45) NOT NULL COMMENT '공통코드명',
    `english_name` varchar(64) NOT NULL COMMENT '공통코드 영문명',
    `description` varchar(64) NOT NULL COMMENT '공통코드 상세설명',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`code`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='공통코드 정보 테이블';
#------------------------------------------------------------
# tb_keyword_search : 검색 키워드 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_keyword_search`;
  DROP TABLE IF EXISTS `tb_keyword_search`;
  CREATE TABLE `tb_keyword_search` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `login_id` varchar(256) NOT NULL COMMENT '사용자(회원) 아이디',
    `search_keyword` varchar(64) NOT NULL COMMENT '검색 키워드',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='검색키워드 정보 테이블';
#------------------------------------------------------------
# tb_policy : 펫미 정책 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_policy`;
  DROP TABLE IF EXISTS `tb_policy`;
  CREATE TABLE `tb_policy` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `category` varchar(64) NOT NULL COMMENT '정책카테고리',
    `name` varchar(64) NOT NULL COMMENT '정책이름',
    `description` text DEFAULT NULL COMMENT '정책 설명',
    `mode` varchar(64) NOT NULL COMMENT '정책 모드',
    `rule_sql` varchar(1024) NOT NULL COMMENT 'SQL 쿼리 룰',
    `rule_regular_expression` varchar(1024) NOT NULL COMMENT '정규표현식 룰',
    `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='펫미 Q&A 테이블';
#------------------------------------------------------------
# tb_backup_history : 백업 테이블
#------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_backup_history`;
  DROP TABLE IF EXISTS `tb_backup_history`;
  CREATE TABLE `tb_backup_history` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `source_ip` varchar(15) NOT NULL COMMENT '서버IP',
    `backup_user_name` varchar(64) NOT NULL COMMENT '백업사용자명',
    `destination_ip` varchar(15) NOT NULL COMMENT '서버IP',
    `destination_ssl_port` varchar(5) NULL COMMENT 'ssl 포트',
    `destination_login_user` varchar(64) NULL COMMENT '로그인 아이디',
    `destination_login_pwd` varchar(45) NULL COMMENT '로그인 암호',
    `backup_file_name` varchar(1024) NOT NULL COMMENT '백업파일이름',
    `backup_location` varchar(2048) NOT NULL COMMENT '백업위치',
    `backup_type` varchar(64) DEFAULT NULL COMMENT '백업종류',
    `backup_comment` varchar(1024) DEFAULT NULL COMMENT '백업설명',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='펫미 Q&A 테이블';
#************************************************************************************************/
# n:m 관계를 위한 매핑 테이블 설계
#************************************************************************************************/
  #------------------------------------------------------------
  # tb_mapping_tb_user_tb_event : 이벤트-사용자 매핑테이블
  #------------------------------------------------------------
    DROP TABLE IF EXISTS `tb_mapping_tb_user_tb_event`;
    DROP TABLE IF EXISTS `tb_mapping_tb_user_tb_event`;
    CREATE TABLE `tb_mapping_tb_user_tb_event` (
      `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
      `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
      `tb_event_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
      `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',    
      `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
      `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
      PRIMARY KEY (`id`),
      UNIQUE KEY `index_tb_mapping_tb_user_tb_event_tb_user_id_tb_event_id` (`tb_user_id`, `tb_event_id`)      
    ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='이벤트-사용자 매핑테이블';
  #------------------------------------------------------------
  # tb_mapping_tb_user_tb_petme_notice : 공지사항-사용자 매핑테이블
  #------------------------------------------------------------
    DROP TABLE IF EXISTS `tb_mapping_tb_user_tb_petme_notice`;
    DROP TABLE IF EXISTS `tb_mapping_tb_user_tb_petme_notice`;
    CREATE TABLE `tb_mapping_tb_user_tb_petme_notice` (
      `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
      `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
      `tb_petme_notice_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
      `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',    
      `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
      `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
      PRIMARY KEY (`id`),
      UNIQUE KEY `unique_tb_mapping_tb_user_tb_petme_notice` (`tb_user_id`, `tb_petme_notice_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='이벤트-사용자 매핑테이블';
  #------------------------------------------------------------
  # tb_mapping_tb_server_tb_file : 서버-파일 매핑테이블
  #------------------------------------------------------------
    DROP TABLE IF EXISTS `tb_mapping_tb_server_tb_file`;
    DROP TABLE IF EXISTS `tb_mapping_tb_server_tb_file`;
    CREATE TABLE `tb_mapping_tb_server_tb_file` (
      `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
      `tb_server_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
      `tb_file_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
      `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',    
      `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
      `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
      PRIMARY KEY (`id`), 
      UNIQUE KEY `index_tb_mapping_tb_server_tb_file_tb_server_id_tb_file_id` (`tb_server_id`, `tb_file_id`)      
    ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='서버-파일 매핑테이블';
  #------------------------------------------------------------
  # tb_review_map_tb_image
  #------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_map_user_device`;
  DROP TABLE IF EXISTS `tb_map_user_device`;
  CREATE TABLE `tb_map_user_device` (
    `map_user_device_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '<한글 칼럼명> 아이디\n<설명> 자동증가값\n<예>',
    `user_id` bigint(20) unsigned NOT NULL COMMENT '<한글 칼럼명> 아이디\n<설명> 사용자 테이블 아이디\n<예>',
    `device_id` bigint(20) unsigned NOT NULL COMMENT '<한글 칼럼명> 아이디\n<설명> 사용자 테이블 아이디\n<예>',
    PRIMARY KEY (`map_user_device_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='<한글 디비명> UUID 테이블\n<설명>\n<예>';
#************************************************************************************************/
# 향후 추가 기획을 위해서 만들수도 있을 만한 테이블 설계
#************************************************************************************************/
  #------------------------------------------------------------
  # tb_member_rank : 우수 고객 통계를 위한 회원 랭킹 테이블
  #------------------------------------------------------------
#   빌링이 붙었을 때를 위해서
  DROP TABLE IF EXISTS `tb_member_rank`;
  DROP TABLE IF EXISTS `tb_member_rank`;
  CREATE TABLE `tb_member_rank` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `create_date` datetime NOT NULL,
    `ranking_month` tinyint(4) NOT NULL,
    `user_id` int(11) NOT NULL,
    `point` int(11) NOT NULL DEFAULT '0',
    `ranking` int(11) NOT NULL,
    PRIMARY KEY (`serial_number`),
    KEY `idx_tb_member_rank` (`user_id`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;

  #------------------------------------------------------------
  # tb_store_rank : 우수 상점 통계를 위한 랭킹 테이블
  #------------------------------------------------------------
#   가맹점으로 상점을 입점시켰을 때를 대비해서
  DROP TABLE IF EXISTS `tb_store_rank`;
  DROP TABLE IF EXISTS `tb_store_rank`;
  CREATE TABLE `tb_store_rank` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `ranking_month` tinyint(4) NOT NULL,
    `store_id` int(11) NOT NULL,
    `point` int(11) NOT NULL DEFAULT '0',
    `create_date` datetime NOT NULL,
    `ranking` int(11) NOT NULL,
    PRIMARY KEY (`serial_number`),
    KEY `idx_tb_store_rank` (`store_id`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;

  #------------------------------------------------------------
  # tb_sns_link : sns 서비스를 위한 테이블
  #------------------------------------------------------------
#   sns 전송 서비스를 할때를 위해서
  DROP TABLE IF EXISTS `tb_sns_link`;
  DROP TABLE IF EXISTS `tb_sns_link`;
  CREATE TABLE `tb_sns_link` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `sns_type` tinyint(4) NOT NULL,
    `sns_id` varchar(128) NOT NULL,
    `access_token` varchar(255) NOT NULL,
    `create_date` datetime NOT NULL,
    `delete_date` datetime DEFAULT NULL,
    `is_use` enum('Y','N') NOT NULL DEFAULT 'Y',
    PRIMARY KEY (`serial_number`),
    KEY `idx_tb_sns_link` (`user_id`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;

  DROP TABLE IF EXISTS `tb_sns_log`;
  DROP TABLE IF EXISTS `tb_sns_log`;
  CREATE TABLE `tb_sns_log` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `sns_type` tinyint(4) NOT NULL,
    `work_type` tinyint(4) NOT NULL,
    `create_date` datetime NOT NULL,
    `contents` text NOT NULL,
    `file_path` varchar(255) DEFAULT NULL,
    `file_name` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`serial_number`),
    KEY `idx_tb_sns_log` (`user_id`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;

  #------------------------------------------------------------
  # tb_order : 쇼핑몰 서비스를 위한 테이블
  #------------------------------------------------------------
#   대형종합몰, 브랜드몰, 오픈 마켓플레이스, 디지털 콘텐츠 유통, 티켓 예매 등 핵심 커머스 서비스를 대비해서
  DROP TABLE IF EXISTS `tb_order`;
  DROP TABLE IF EXISTS `tb_order`;
  CREATE TABLE `tb_order` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `order_time` datetime NOT NULL,
    `order` int(11) NOT NULL,
    `address` varchar(255) NOT NULL,
    `post_number` int(11) NOT NULL,
    `comment` text,
    `store_id` int(11) NOT NULL,
    `code` tinyint(4) NOT NULL,
    `status` tinyint(4) NOT NULL DEFAULT '1',
    `delivery_time` datetime DEFAULT NULL,
    `coupon` varchar(64) DEFAULT NULL,
    `total_price` int(11) NOT NULL,
    `decision_price` int(11) DEFAULT NULL,
    `cancel_cause` text,
    PRIMARY KEY (`serial_number`),
    KEY `idx_tb_order` (`order`),
    KEY `idx_tb_order_0` (`store_id`),
    KEY `idx_tb_order_1` (`coupon`),
    KEY `idx_tb_order_2` (`post_number`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;

  DROP TABLE IF EXISTS `tb_menu_postscript`;
  DROP TABLE IF EXISTS `tb_menu_postscript`;
  CREATE TABLE `tb_menu_postscript` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `menu_id` int(11) NOT NULL,
    `score` tinyint(4) NOT NULL DEFAULT '5',
    `contents` text NOT NULL,
    `image_path` varchar(255) DEFAULT NULL,
    `image_file` varchar(255) DEFAULT NULL,
    `writer` int(11) NOT NULL,
    `create_date` datetime NOT NULL,
    `answer_contents` text,
    `answer_id` int(11) DEFAULT NULL,
    `answer_date` datetime DEFAULT NULL,
    PRIMARY KEY (`serial_number`),
    KEY `idx_tb_menu_postscript_writer` (`writer`),
    KEY `idx_tb_menu_postscript_answer` (`answer_id`),
    KEY `idx_tb_menu_postscript` (`menu_id`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;

  DROP TABLE IF EXISTS `tb_store_postscript`;
  DROP TABLE IF EXISTS `tb_store_postscript`;
  CREATE TABLE `tb_store_postscript` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `score` tinyint(4) NOT NULL DEFAULT '5',
    `context` text NOT NULL,
    `image_path` varchar(255) DEFAULT NULL,
    `image_file` varchar(255) DEFAULT NULL,
    `writer` int(11) NOT NULL,
    `create_date` datetime NOT NULL,
    `answer_context` text,
    `answer_id` varchar(32) DEFAULT NULL,
    `answer_date` datetime DEFAULT NULL,
    `store_id` int(11) NOT NULL,
    PRIMARY KEY (`serial_number`),
    KEY `idx_tb_store_postscript_answer` (`answer_id`),
    KEY `idx_tb_store_postscript_writer` (`writer`),
    KEY `idx_tb_store_postscript` (`store_id`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;

  #------------------------------------------------------------
  # tb_order : 마일리지 적립 서비스를 위한 테이블
  #------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_milege`;
  DROP TABLE IF EXISTS `tb_milege`;
  CREATE TABLE `tb_milege` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `member_id` int(11) DEFAULT NULL,
    `use_date` datetime DEFAULT NULL,
    `billing_method` set('포인트뱅크','대한항공','아시아나','쇼핑몰','기타') CHARACTER SET utf8 NOT NULL DEFAULT '',
    `use_type` set('다운로드','마일리지전환','추천인등록','추천인최초결재','선물받음','클럽사용자에게분배') CHARACTER SET utf8 NOT NULL DEFAULT '',
    `gubun` enum('get','used') CHARACTER SET utf8 DEFAULT 'get',
    `use_milege` bigint(20) unsigned NOT NULL DEFAULT '0',
    `billing_status` set('결재대기','결재완료','결재취소','기타이유') CHARACTER SET utf8 NOT NULL DEFAULT '',
    `register_done_date` datetime DEFAULT NULL,
    PRIMARY KEY (`serial_number`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='마일리지 내역 테이블';

  #------------------------------------------------------------
  # 기타 향후 기획후 서비스에 필요할 수도 있는 테이블
  #------------------------------------------------------------
  DROP TABLE IF EXISTS ` tb_store_menu_type`;
  DROP TABLE IF EXISTS ` tb_store_menu_type`;
  CREATE TABLE ` tb_store_menu_type` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `store_id` int(11) NOT NULL,
    ` type_name` varchar(255) NOT NULL,
    PRIMARY KEY (`serial_number`),
    KEY ` tb_store_menu_type` (`store_id`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;

  DROP TABLE IF EXISTS `tb_auto_billing`;
  DROP TABLE IF EXISTS `tb_auto_billing`;
  CREATE TABLE `tb_auto_billing` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `member_id` int(11) NOT NULL,
    `use_date` datetime DEFAULT NULL,
    `billing_method` set('결제안함','핸드폰결제','ARS결제','전화결제','ISP_ID결제','무통장입금','카드결제','기타','취소') COLLATE utf8_bin NOT NULL DEFAULT '결제안함',
    `use_type` set('신청','해지') COLLATE utf8_bin NOT NULL DEFAULT '신청',
    `limit_date` set('무한','1달','3개월','6개월','1년') COLLATE utf8_bin NOT NULL DEFAULT '1달',
    `billing_amount` bigint(20) unsigned NOT NULL DEFAULT '0',
    `billing_status` set('결재대기','결재완료','결재취소','기타이유') COLLATE utf8_bin NOT NULL DEFAULT '결재대기',
    `register_done_date` datetime DEFAULT NULL,
    PRIMARY KEY (`serial_number`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='자동결제 내역테이블';

  DROP TABLE IF EXISTS `tb_billing`;
  DROP TABLE IF EXISTS `tb_billing`;
  CREATE TABLE `tb_billing` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `member_id` int(11) NOT NULL,
    `is_monthly` enum('Y','N') COLLATE utf8_bin DEFAULT 'Y',
    `cyber_money` int(11) NOT NULL DEFAULT '0',
    `points` int(11) NOT NULL DEFAULT '0',
    `is_auto_billing` enum('Y','N') COLLATE utf8_bin DEFAULT 'Y',
    `is_package` enum('Y','N') COLLATE utf8_bin DEFAULT 'Y',
    PRIMARY KEY (`serial_number`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='빌링 전체에 대한 정보 테이블';

  DROP TABLE IF EXISTS `tb_billing_gubun`;
  DROP TABLE IF EXISTS `tb_billing_gubun`;
  CREATE TABLE `tb_billing_gubun` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `gubun_name` varchar(128) COLLATE utf8_bin DEFAULT NULL,
    `amount_gubun_code` int(11) DEFAULT '0',
    `billing_money` int(11) DEFAULT '0',
    `is_used` enum('Y','N') COLLATE utf8_bin DEFAULT 'Y',
    PRIMARY KEY (`serial_number`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='결제 구분 테이블';

  DROP TABLE IF EXISTS `tb_billing_info`;
  DROP TABLE IF EXISTS `tb_billing_info`;
  CREATE TABLE `tb_billing_info` (
    `serial_number` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `member_id` int(11) NOT NULL,
    `club_id` int(11) NOT NULL,
    `gubun_code` int(11) NOT NULL,
    `gubun_name` varchar(128) COLLATE utf8_bin DEFAULT NULL,
    `tb_gubun_code` varchar(128) COLLATE utf8_bin DEFAULT NULL,
    `billing_method` set('결제안함','핸드폰결제','ARS결제','전화결제','ISP_ID결제','무통장입금','카드결제','기타','취소') CHARACTER SET utf8 NOT NULL DEFAULT '',
    `billing_money` bigint(20) unsigned NOT NULL DEFAULT '0',
    `register_date` datetime DEFAULT NULL,
    `billing_status` set('결제대기','결제완료','결제취소','기타') CHARACTER SET utf8 NOT NULL DEFAULT '',
    `register_done_date` datetime DEFAULT NULL,
    PRIMARY KEY (`serial_number`)
  ) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='결제 정보 테이블';

  DROP TABLE IF EXISTS `tb_cyber_money`;
  DROP TABLE IF EXISTS `tb_cyber_money`;
  CREATE TABLE `tb_cyber_money` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `member_id` int(11) DEFAULT NULL,
    `use_date` datetime DEFAULT NULL,
    `billing_method` set('결제안함','핸드폰결제','ARS결제','전화결제','ISP_ID결제','무통장입금','카드결제','기타','취소') CHARACTER SET utf8 NOT NULL DEFAULT '',
    `use_type` set('사이버머니충전','클럽','로그인','포인트에서변환','실시간재생') CHARACTER SET utf8 NOT NULL DEFAULT '',
    `gubun` enum('get','used') CHARACTER SET utf8 DEFAULT 'get',
    `use_cyber_money` bigint(20) unsigned NOT NULL DEFAULT '0',
    `billing_status` set('결재대기','결재완료','결재취소','기타이유') CHARACTER SET utf8 NOT NULL DEFAULT '',
    `register_done_date` datetime DEFAULT NULL,
    PRIMARY KEY (`serial_number`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='사이버머니 내역 테이블';


  DROP TABLE IF EXISTS `tb_familiar_shop`;
  DROP TABLE IF EXISTS `tb_familiar_shop`;
  CREATE TABLE `tb_familiar_shop` (
    `create_date` datetime NOT NULL,
    `member_id` int(11) NOT NULL,
    `store_id` int(11) NOT NULL,
    PRIMARY KEY (`member_id`,`store_id`),
    KEY `idx_tb_familiar_shop_0` (`store_id`),
    KEY `idx_tb_familiar_shop_1` (`member_id`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;

  DROP TABLE IF EXISTS `tb_recommand_rank`;
  DROP TABLE IF EXISTS `tb_recommand_rank`;
  CREATE TABLE `tb_recommand_rank` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `ranking` int(11) NOT NULL DEFAULT '0',
    `point` int(11) NOT NULL,
    `create_date` datetime NOT NULL,
    `ranking_month` int(11) NOT NULL,
    PRIMARY KEY (`serial_number`),
    KEY `idx_tb_recommand_rank` (`user_id`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;

  DROP TABLE IF EXISTS `tb_policy_code`;
  DROP TABLE IF EXISTS `tb_policy_code`;
  CREATE TABLE `tb_policy_code` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `code` varchar(512) NOT NULL,
    `name` varchar(512) DEFAULT NULL,
    `description` varchar(2048) DEFAULT NULL,
    `value` varchar(512) DEFAULT NULL,
    `registration_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci;

#   LOCK TABLES `tb_policy_code` WRITE;
#   INSERT INTO `tb_policy_code` VALUES (1,'SITE_CONNECT_BLOCKING',NULL,NULL,'ON','2017-10-18 17:16:19'),(2,'SITE_CONNECT_BLOCKING',NULL,NULL,'OFF','2017-10-18 17:16:19'),(3,'USB_CONNECT_BLOCKING',NULL,NULL,'ON','2018-02-12 23:09:08'),(4,'USB_CONNECT_BLOCKING',NULL,NULL,'OFF','2018-02-12 23:09:08'),(5,'MEMORY_LOAD_BLOCKING',NULL,NULL,'ON','2018-02-13 20:51:08'),(6,'MEMORY_LOAD_BLOCKING',NULL,NULL,'OFF','2018-02-13 20:51:08'),(7,'REALTIME_WATCHING',NULL,NULL,'ON','2018-02-14 10:26:55'),(8,'REALTIME_WATCHING',NULL,NULL,'OFF','2018-02-14 10:26:56'),(9,'REALTIME_WATCHING_THREATS_ACTION',NULL,NULL,'QUARANTINE','2018-02-21 19:54:07'),(10,'REALTIME_WATCHING_THREATS_ACTION',NULL,NULL,'JUST_REPORT','2018-02-21 19:54:07'),(11,'BACKGROUND_DNA_CHECK',NULL,NULL,'AUTO','2018-04-04 15:59:10'),(12,'BACKGROUND_DNA_CHECK',NULL,NULL,'MANUAL','2018-04-04 15:59:23'),(13,'MEMORY_WATCHER ',NULL,NULL,'ON','2018-05-14 15:24:52'),(16,'MEMORY_WATCHER ',NULL,NULL,'OFF','2018-05-14 15:24:57'),(17,'WINDOWS_UPDATE_CONTROL',NULL,NULL,'ON','2018-05-17 12:14:12'),(18,'WINDOWS_UPDATE_CONTROL',NULL,NULL,'OFF','2018-05-17 12:14:12');

  DROP TABLE IF EXISTS `tb_file_log`;
  DROP TABLE IF EXISTS `tb_file_log`;
  CREATE TABLE `tb_file_log` (
    `file_log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '<한글 칼럼명> 아이디\n<설명> 자동증가값\n<예>',
    `user_id` varchar(64) NULL COMMENT '<한글 칼럼명> 사용자 아이디\n<설명>\n<예>',
    `device_id` varchar(64) NULL COMMENT '<한글 칼럼명> 디바이스 아이디\n<설명>\n<예>',
    `uuid` varchar(64) NULL COMMENT '<한글 칼럼명> 로그인 GUID\n<설명>\n<예>',
    `file_name` varchar(4000) NULL COMMENT '<한글 칼럼명> 파일명\n<설명> 다운로드할 파일명\n<예>',
    `file_size` bigint(20) NULL COMMENT '<한글 칼럼명> 파일크기\n<설명> 다운로드할 파일 사이즈\n<예> 2014-10-30 11:18:27',
    `file_path` varchar(4000) NULL COMMENT '<한글 칼럼명> 파일경로\n<설명> 다운로드될 파일의 위치\n<예>',
    `create_time` datetime NULL COMMENT '<한글 칼럼명> 파일생성시간\n<설명> 파일생성 시간\n<예>',
    `delete_time` datetime NULL COMMENT '<한글 칼럼명> 파일삭제시간\n<설명> 파일 삭제 시간\n<예>',
    PRIMARY KEY (`file_log_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='<한글 디비명> 파일 로그 테이블\n<설명>\n<예>';

  DROP TABLE IF EXISTS `tb_view_file_log`;
  DROP TABLE IF EXISTS `tb_view_file_log`;
  CREATE TABLE `tb_view_file_log` (
    `view_file_log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '<한글 칼럼명> 아이디\n<설명> 자동증가값\n<예>',
    `user_id` varchar(64) NULL COMMENT '<한글 칼럼명> 사용자 아이디\n<설명>\n<예>',
    `device_id` varchar(64) NULL COMMENT '<한글 칼럼명> 디바이스 아이디\n<설명>\n<예>',
    `uuid` varchar(64) NULL COMMENT '<한글 칼럼명> 로그인 GUID\n<설명>\n<예>',
    `file_name` varchar(4000) NULL COMMENT '<한글 칼럼명> 파일명\n<설명> 조회할 파일명\n<예>',
    `file_size` bigint(20) NULL COMMENT '<한글 칼럼명> 파일크기\n<설명> 조회할 파일 사이즈\n<예> 2014-10-30 11:18:27',
    `file_path` varchar(4000) NULL COMMENT '<한글 칼럼명> 파일경로\n<설명> 조회할 파일의 위치\n<예>',
    `view_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '<한글 칼럼명> 파일 조회 시간\n<설명> 사용자가 조회한 시간을 나타낸다.\n<예> 2014-10-30 11:18:27',
    PRIMARY KEY (`view_file_log_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='<한글 디비명> 파일 조회 로그 테이블\n<설명>\n<예>';


  DROP TABLE IF EXISTS `tb_access_log`;
  DROP TABLE IF EXISTS `tb_access_log`;
  CREATE TABLE `tb_access_log` (
    `access_log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '<한글 칼럼명> 아이디\n<설명> 자동증가값\n<예>',
    `user_id` varchar(64) NULL COMMENT '<한글 칼럼명> 사용자 아이디\n<설명>\n<예>',
    `device_id` varchar(64) NULL COMMENT '<한글 칼럼명> 디바이스 아이디\n<설명>\n<예>',
    `uuid` varchar(64) NULL COMMENT '<한글 칼럼명> 로그인 GUID\n<설명>\n<예>',
    `access_ip` varchar(15) NULL COMMENT '<한글 칼럼명> 접근아이피\n<설명> 사용자가 접속한 IP 주소\n<예>',
    `access_user_browser` varchar(50) NULL COMMENT '<한글 칼럼명> 사용자 브라우저\n<설명> 사용자가 접속한 브라우저 종류\n<예>',
    `access_user_os` varchar(50) NULL COMMENT '<한글 칼럼명> 사용자 OS\n<설명> 접속 사용자의 OS\n<예>',
    `access_user_referer` varchar(200) NULL COMMENT '<한글 칼럼명> 접속전 주소\n<설명> 사용자가 접속하기 전 링크 주소\n<예>',
    `access_url` varchar(200) NULL COMMENT '<한글 칼럼명> 사이트 접속 주소\n<설명> 사용자가 접속한 사이트 접속 주소를 나타낸다.\n<예> 2014-10-30 11:18:27',
    `access_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '<한글 칼럼명> 접속 시간\n<설명> 사용자가 접속한 시간을 나타낸다.\n<예> 2014-10-30 11:18:27',
    PRIMARY KEY (`access_log_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='<한글 디비명> 사용자 접속로그 테이블\n<설명>\n<예>';

  DROP TABLE IF EXISTS `tb_credential`;
  DROP TABLE IF EXISTS `tb_credential`;
  CREATE TABLE `tb_credential` (
    `credential_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '<한글 칼럼명> 아이디\n<설명> 자동증가값\n<예>',
    `user_id` bigint(20) unsigned NOT NULL COMMENT '<한글 칼럼명> 아이디\n<설명> 사용자 테이블 아이디\n<예>',
    `auth_credential` varchar(1024) NOT NULL COMMENT '<한글 칼럼명> 인증 크리덴셜\n<설명>\n<예>',
    `device_credential` varchar(1024) NOT NULL COMMENT '<한글 칼럼명> 디바이스 크리덴셜\n<설명>\n<예>',
    `registration_time` datetime NOT NULL COMMENT '<한글 칼럼명> 최초 등록 시간\n<설명> 최초 등록된 시간을 나타낸다.\n<예> 2014-10-30 11:18:27',
    `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '<한글 칼럼명> 마지막 갱신시각\n<설명>\n<예>',
    PRIMARY KEY (`credential_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='<한글 디비명> 크리덴셜 테이블\n<설명>\n<예>';