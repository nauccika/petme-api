SET
foreign_key_checks = 0;

DROP TABLE IF EXISTS `tb_place_business_hours`;
CREATE TABLE `tb_place_business_hours`
(
    `id`                         bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_place_id`                bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `content`                    text                        NOT NULL COMMENT '영업시간 전체정보',
    `all_year_round_yn`          varchar(1)    DEFAULT NULL COMMENT '연중무휴 여부',
    `closed_days`                varchar(2048) DEFAULT NULL COMMENT '특정 휴무일',
    `regular_holiday`            varchar(8)    DEFAULT NULL COMMENT '정기 휴무일',
    `weekly_regular_holiday_yn`  varchar(1)    DEFAULT NULL COMMENT '매주 정기휴무일 여부',
    `monthly_regular_holiday_yn` varchar(1)    DEFAULT NULL COMMENT '매월 정기휴무일 여부',
    `monday_hours`               varchar(32)   DEFAULT NULL COMMENT '월요일 영업시간',
    `tuesday_hours`              varchar(32)   DEFAULT NULL COMMENT '화요일 영업시간',
    `wednesday_hours`            varchar(32)   DEFAULT NULL COMMENT '수요일 영업시간',
    `thursday_hours`             varchar(32)   DEFAULT NULL COMMENT '목요일 영업시간',
    `friday_hours`               varchar(32)   DEFAULT NULL COMMENT '금요일 영업시간',
    `saturday_hours`             varchar(32)   DEFAULT NULL COMMENT '토요일 영업시간',
    `sunday_hours`               varchar(32)   DEFAULT NULL COMMENT '일요일 영업시간',
    `monday_break_time`          varchar(32)   DEFAULT NULL COMMENT '월요일 휴게시간',
    `tuesday_break_time`         varchar(32)   DEFAULT NULL COMMENT '화요일 휴게시간',
    `wednesday_break_time`       varchar(32)   DEFAULT NULL COMMENT '수요일 휴게시간',
    `thursday_break_time`        varchar(32)   DEFAULT NULL COMMENT '목요일 휴게시간',
    `friday_break_time`          varchar(32)   DEFAULT NULL COMMENT '금요일 휴게시간',
    `saturday_break_time`        varchar(32)   DEFAULT NULL COMMENT '토요일 휴게시간',
    `sunday_break_time`          varchar(32)   DEFAULT NULL COMMENT '일요일 휴게시간',
    `modify_time`                datetime      DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`              datetime      DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_tb_place_business_hours_tb_place_id` (`tb_place_id`)
    -- FOREIGN KEY (`tb_place_id`) REFERENCES `tb_place_id` (`id`),
    -- FULLTEXT `idx_tb_place_id_content` (`content`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='영업시간 테이블';

DROP TABLE IF EXISTS `tb_server`;
CREATE TABLE `tb_server`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `hostname`        varchar(64)               NOT NULL COMMENT '서버 호스트명',
    `nickname`        varchar(64)               NOT NULL COMMENT '서버 닉네임(별명)',
    `model`           varchar(64)               NOT NULL COMMENT '서버 모델명',
    `ip1`             varchar(15) DEFAULT NULL COMMENT '서버 ip 주소1',
    `ip2`             varchar(15) DEFAULT NULL COMMENT '서버 ip 주소2',
    `status`          varchar(32) DEFAULT NULL COMMENT '서버 상태',
    `load_average`    tinyint(8) DEFAULT '0' COMMENT '서버 로드평균(로드 애버리지)',
    `concurrent_user` int(11) unsigned DEFAULT '0' COMMENT '서버 동접자수',
    `use_yn`          varchar(1)  DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`     datetime    DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`   datetime    DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_tb_server_nickname` (`nickname`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='서버 정보 테이블';

DROP TABLE IF EXISTS `tb_file`;
CREATE TABLE `tb_file`
(
    `id`                   bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    -- `tb_server_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_user_id`           bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_place_id`          bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_blog_id`           bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_bulletin_board_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_pet_raboratory_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_petme_notice_id`   bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_event_id`          bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `original_name`        varchar(512)              NOT NULL COMMENT '원본 파일명',
    `save_name`            varchar(512)              NOT NULL COMMENT '저장 파일명',
    `full_path`            varchar(1024)             NOT NULL COMMENT '파일 저장 전체경로명',
    `size`                 int(11) NOT NULL COMMENT '파일크기(Byte)',
    `hash_type`            varchar(32)               NOT NULL COMMENT '해시종류',
    `hash`                 varchar(512)              NOT NULL COMMENT '파일해시',
    `mimetype`             varchar(32) DEFAULT NULL COMMENT '파일 마인타입',
    `gubun`                varchar(64) DEFAULT NULL COMMENT '파일 구분',
    `source`               varchar(32) DEFAULT NULL COMMENT '파일 source',
    `main_image_yn`        varchar(1)  DEFAULT NULL COMMENT '대표이미지여부',
    `exposure_order`       smallint(6) unsigned DEFAULT NULL COMMENT '노출순서',
    `encoding`             varchar(32) DEFAULT NULL COMMENT '파일 엔코딩',
    `use_yn`               varchar(1)  DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`          datetime    DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`        datetime    DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_tb_file_save_name` (`save_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='파일 정보 테이블';

DROP TABLE IF EXISTS `tb_review`;
CREATE TABLE `tb_review`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id`    bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_place_id`   bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_blog_id`    bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `writer`        varchar(256) DEFAULT NULL COMMENT '리뷰 작성자',
    `content`       text                       NOT NULL COMMENT '리뷰 내용',
    `grade`         varchar(10)  DEFAULT NULL COMMENT '평점',
    `keyword`       varchar(20)  DEFAULT NULL COMMENT '리뷰 키워드',
    `read_count`    int(11) unsigned DEFAULT '0' COMMENT '리뷰 조회수',
    `use_yn`        varchar(1)   DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`   datetime     DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime     DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='후기 정보 테이블';

DROP TABLE IF EXISTS `tb_blog`;
CREATE TABLE `tb_blog`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id`    bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_place_id`   bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `url`           varchar(1024)               NOT NULL COMMENT '블로그 주소',
    `title`         varchar(512)  DEFAULT NULL COMMENT '블로그 제목',
    `content`       text                        NOT NULL COMMENT '블로그 내용',
    `writer`        varchar(256)  DEFAULT NULL COMMENT '블로그 작성자',
    `hashtag`       varchar(1024) DEFAULT NULL COMMENT '블로그 해시태그',
    `modify_time`   datetime      DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime      DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    KEY             `idx_tb_blog_title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='블로그 정보 테이블';

DROP TABLE IF EXISTS `tb_crawling_naver_map`;
CREATE TABLE `tb_crawling_naver_map`
(
    `id`                   bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `name`                 varchar(1024)               NOT NULL COMMENT '장소이름',
    `ranking`              varchar(10)   DEFAULT NULL COMMENT '랭킹(순위)',
    `blog_review_count`    int(11) unsigned DEFAULT '0' COMMENT '블로그 리뷰수',
    `visitor_review_count` int(11) unsigned DEFAULT '0' COMMENT '방문자 리뷰수',
    `street_name_address`  varchar(1024) DEFAULT NULL COMMENT '도로명 주소',
    `lot_number_address`   varchar(1024) DEFAULT NULL COMMENT '지번 주소',
    `zipcode`              varchar(20)   DEFAULT NULL COMMENT '우편번호',
    `phone`                varchar(20)   DEFAULT NULL COMMENT '전화번호(대표)',
    `payment_method`       varchar(80)   DEFAULT NULL COMMENT '결제 수단',
    `content`              text          DEFAULT NULL COMMENT '장소 소개/설명',
    `information_use`      text          DEFAULT NULL COMMENT '이용안내/정보(부가서비스포함)',
    `homepage_url`         varchar(1024) DEFAULT NULL COMMENT '홈페이지 주소',
    `blog_url`             varchar(1024) DEFAULT NULL COMMENT '블로그 주소',
    `instagram_url`        varchar(1024) DEFAULT NULL COMMENT '인스타그램 주소',
    `facebook_url`         varchar(1024) DEFAULT NULL COMMENT '페이스북 주소',
    `youtube_url`          varchar(1024) DEFAULT NULL COMMENT '유튜브 주소',
    `hashtag`              varchar(1024)               NOT NULL COMMENT '해시태그',
    `business_gubun`       varchar(32)   DEFAULT 'bt00' COMMENT '장소 구분',
    `latitude`             double        DEFAULT NULL COMMENT '위도좌표(y좌표)',
    `longitude`            double        DEFAULT NULL COMMENT '경도좌표(x좌표)',
    `summary`              varchar(1024) DEFAULT NULL COMMENT '장소 요약',
    `use_yn`               varchar(1)    DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`          datetime      DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`        datetime      DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    KEY                    `idx_tb_crawling_naver_map_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='네이버맵 정보 크롤링 테이블';

DROP TABLE IF EXISTS `tb_crawling_dogpalza`;
CREATE TABLE `tb_crawling_dogpalza`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `category`      varchar(64)  DEFAULT NULL COMMENT '카테고리',
    `title`         varchar(512)               NOT NULL COMMENT '게시글 제목',
    `content`       text                       NOT NULL COMMENT '게시글 내용',
    `writer`        varchar(256) DEFAULT NULL COMMENT '커뮤니티 게시판 게시글 작성자',
    `write_time`    datetime     DEFAULT NULL COMMENT '커뮤니티 게시판 게시글 작성자',
    `read_count`    int(11) unsigned DEFAULT '0' COMMENT 'Q&A 조회수',
    `parent_id`     bigint(20) unsigned DEFAULT NULL COMMENT '부모 게시글 아이디',
    `order`         tinyint(2) unsigned NOT NULL COMMENT '답변순서',
    `depth`         tinyint(2) unsigned DEFAULT '0' COMMENT '댓글 레벨/깊이',
    `use_yn`        varchar(1)   DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`   datetime     DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime     DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='강사모 크롤링 정보 테이블';

DROP TABLE IF EXISTS `tb_bulletin_board`;
CREATE TABLE `tb_bulletin_board`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id`    bigint(20) unsigned DEFAULT NULL COMMENT 'tb_user.id',
    `category`      varchar(64)  DEFAULT NULL COMMENT '카테고리',
    `title`         varchar(512)               NOT NULL COMMENT '게시글 제목',
    `content`       text                       NOT NULL COMMENT '게시글 내용',
    `writer`        varchar(256) DEFAULT NULL COMMENT '커뮤니티 게시판 게시글 작성자',
    `write_time`    datetime     DEFAULT NULL COMMENT '커뮤니티 게시판 게시글 작성자',
    `read_count`    int(11) unsigned DEFAULT '0' COMMENT 'Q&A 조회수',
    `parent_id`     bigint(20) unsigned DEFAULT NULL COMMENT '부모 게시글 아이디',
    `order`         tinyint(2) unsigned NOT NULL COMMENT '답변순서',
    `depth`         tinyint(2) unsigned DEFAULT '0' COMMENT '댓글 레벨/깊이',
    `use_yn`        varchar(1)   DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`   datetime     DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime     DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='강사모 크롤링 정보 테이블';

DROP TABLE IF EXISTS `tb_place`;
CREATE TABLE `tb_place`
(
    `id`                   bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `name`                 varchar(1024)               NOT NULL COMMENT '장소이름',
    `ranking`              varchar(10)   DEFAULT NULL COMMENT '랭킹(순위)',
    `blog_review_count`    int(11) unsigned DEFAULT '0' COMMENT '블로그 리뷰수',
    `visitor_review_count` int(11) unsigned DEFAULT '0' COMMENT '방문자 리뷰수',
    `street_name_address`  varchar(1024) DEFAULT NULL COMMENT '도로명 주소',
    `lot_number_address`   varchar(1024) DEFAULT NULL COMMENT '지번 주소',
    `zipcode`              varchar(20)   DEFAULT NULL COMMENT '우편번호',
    `phone`                varchar(20)   DEFAULT NULL COMMENT '전화번호(대표)',
    `payment_method`       varchar(80)   DEFAULT NULL COMMENT '결제 수단',
    `content`              text          DEFAULT NULL COMMENT '장소 소개/설명',
    `information_use`      text          DEFAULT NULL COMMENT '이용안내/정보(부가서비스포함)',
    `homepage_url`         varchar(1024) DEFAULT NULL COMMENT '홈페이지 주소',
    `blog_url`             varchar(1024) DEFAULT NULL COMMENT '블로그 주소',
    `instagram_url`        varchar(1024) DEFAULT NULL COMMENT '인스타그램 주소',
    `facebook_url`         varchar(1024) DEFAULT NULL COMMENT '페이스북 주소',
    `youtube_url`          varchar(1024) DEFAULT NULL COMMENT '유튜브 주소',
    `hashtag`              varchar(1024)               NOT NULL COMMENT '해시태그',
    `business_gubun`       varchar(64)   DEFAULT NULL COMMENT '장소 구분',
    `latitude`             double        DEFAULT NULL COMMENT '위도좌표(y좌표)',
    `longitude`            double        DEFAULT NULL COMMENT '경도좌표(x좌표)',
    `place_summary`        varchar(1024) DEFAULT NULL COMMENT '장소 요약',
    `use_yn`               varchar(1)    DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`          datetime      DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`        datetime      DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    KEY                    `idx_tb_place_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='장소 정보 테이블';

DROP TABLE IF EXISTS `tb_pet_raboratory`;
CREATE TABLE `tb_pet_raboratory`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `category`      varchar(64)                 NOT NULL COMMENT '펫연구소 콘텐츠 카테고리',
    `title`         varchar(512)                NOT NULL COMMENT '펫연구소 콘텐츠 제목',
    `hashtag`       varchar(1024) DEFAULT NULL COMMENT '펫연구소 콘텐츠 해시태그',
    `modify_time`   datetime      DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime      DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    KEY             `idx_tb_pet_raboratory_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='애견 컨텐츠 정보 테이블';

DROP TABLE IF EXISTS `tb_event`;
CREATE TABLE `tb_event`
(
    `id`               bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `title`            varchar(512)               NOT NULL COMMENT '이벤트 제목',
    `writer`           varchar(256) DEFAULT NULL COMMENT '이벤트 작성자',
    `content`          text                       NOT NULL COMMENT '이벤트 내용',
    `content1`         text         DEFAULT NULL COMMENT '이벤트 내용1',
    `content2`         text         DEFAULT NULL COMMENT '이벤트 내용2',
    `read_count`       int(11) unsigned NOT NULL DEFAULT '0' COMMENT '이벤트 읽음 조회수',
    `applicant_limit`  int(11) unsigned NOT NULL DEFAULT '0' COMMENT '응모자수 제한',
    `applicant_number` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '응모자 인원수',
    `link_url`         varchar(1024)              NOT NULL COMMENT '링크 주소',
    `html_yn`          varchar(1)   DEFAULT NULL COMMENT 'HTML 사용여부',
    `event_start_date` datetime     DEFAULT NULL COMMENT '이벤트 시작일',
    `event_end_date`   datetime     DEFAULT NULL COMMENT '이벤트 종료일',
    `use_yn`           varchar(4)   DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`      datetime     DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`    datetime     DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='이벤트 정보 테이블';

DROP TABLE IF EXISTS `tb_point_history`;
CREATE TABLE `tb_point_history`
(
    `id`             bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id`     bigint(20) unsigned DEFAULT NULL COMMENT '로그인 아이디',
    `login_id`       int(11) NOT NULL COMMENT '로그인 아이디',
    `point_gubun`    varchar(64)  DEFAULT NULL COMMENT '포인트 타입',
    `billing_method` varchar(128) DEFAULT NULL COMMENT '빌링 형태',
    `billing_status` varchar(64)  DEFAULT NULL COMMENT '빌링 상태',
    `use_type`       varchar(128) DEFAULT NULL COMMENT '포인트 이용 형태',
    `used_point`     bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '이용 포인트',
    `modify_time`    datetime     DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`  datetime     DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    KEY              `idx_tb_point_history_login_id` (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='로그인 히스토리 테이블';

DROP TABLE IF EXISTS `tb_gifticon_history`;
CREATE TABLE `tb_gifticon_history`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id`    bigint(20) unsigned DEFAULT NULL COMMENT '로그인 아이디',
    `login_id`      int(11) NOT NULL COMMENT '로그인 아이디',
    `gifticon_code` varchar(256) NOT NULL COMMENT '기프티콘 코드',
    `get_date`      datetime     DEFAULT NULL COMMENT '기프티콘 취득일',
    `used_point`    bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '이용 포인트',
    `used_date`     datetime     DEFAULT NULL COMMENT '기프티콘 사용일',
    `use_type`      varchar(128) DEFAULT NULL COMMENT '기프티콘 이용 형태',
    PRIMARY KEY (`id`),
    KEY             `idx_ttb_gifticon_history_login_id` (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='기프티콘 히스토리 테이블';

DROP TABLE IF EXISTS `tb_coupon_history`;
CREATE TABLE `tb_coupon_history`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id`  bigint(20) unsigned DEFAULT NULL COMMENT '로그인 아이디',
    `login_id`    int(11) NOT NULL COMMENT '로그인 아이디',
    `coupon_code` varchar(256) NOT NULL COMMENT '쿠폰 코드',
    `used_point`  bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '이용 포인트',
    `get_date`    datetime     DEFAULT NULL COMMENT '쿠폰 취득일',
    `used_date`   datetime     DEFAULT NULL COMMENT '쿠폰 사용일',
    `use_type`    varchar(128) DEFAULT NULL COMMENT '쿠폰 이용 형태',
    PRIMARY KEY (`id`),
    KEY           `idx_tb_coupon_history_login_id` (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='쿠폰 이력 테이블';

DROP TABLE IF EXISTS `tb_admin_user`;
CREATE TABLE `tb_admin_user`
(
    `id`                           bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `login_id`                     varchar(256)                NOT NULL COMMENT '관리자 아이디',
    `user_name`                    varchar(256)  DEFAULT NULL COMMENT '관리자명',
    `password`                     varchar(64)   DEFAULT NULL COMMENT '로그인 패스워드',
    `email`                        varchar(512)  DEFAULT NULL COMMENT '사용자 이메일',
    `phone`                        varchar(20)   DEFAULT NULL COMMENT '전화번호',
    `resident_registration_number` varchar(18)   DEFAULT NULL COMMENT '주민등록번호',
    `street_name_address`          varchar(1024) DEFAULT NULL COMMENT '도로명 주소',
    `lot_number_address`           varchar(1024) DEFAULT NULL COMMENT '지번 주소',
    `gender`                       varchar(16)   DEFAULT NULL COMMENT '성별',
    `department`                   varchar(128)  DEFAULT NULL COMMENT '부서명',
    `position`                     varchar(128)  DEFAULT NULL COMMENT '직위',
    `last_login`                   datetime      DEFAULT NULL COMMENT '최근 로그인 시간',
    `login_times`                  int(11) NOT NULL DEFAULT '0' COMMENT '로그인 횟수',
    `use_yn`                       varchar(1)    DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`                  datetime      DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`                datetime      DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_tb_admin_user_login_id` (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='관리자정보';

DROP TABLE IF EXISTS `tb_user`;
DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user`
(
    `id`                           bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `login_id`                     varchar(256)                NOT NULL COMMENT '사용자(회원) 아이디',
    `user_name`                    varchar(256)  DEFAULT NULL COMMENT '사용자(회원) 이름',
    `password`                     varchar(64)   DEFAULT NULL COMMENT '로그인 패스워드',
    `email`                        varchar(512)  DEFAULT NULL COMMENT '사용자 이메일',
    `phone`                        varchar(20)   DEFAULT NULL COMMENT '전화번호',
    `birthday`                     varchar(16)   DEFAULT NULL COMMENT '생일',
    `age_range`                    varchar(16)   DEFAULT NULL COMMENT '연령대',
    `resident_registration_number` varchar(18)   DEFAULT NULL COMMENT '주민등록번호',
    `street_name_address`          varchar(1024) DEFAULT NULL COMMENT '도로명 주소',
    `lot_number_address`           varchar(1024) DEFAULT NULL COMMENT '지번 주소',
    `gender`                       varchar(16)   DEFAULT NULL COMMENT '성별',
    `receive_information_yn`       varchar(1)    DEFAULT "0" COMMENT '정보수신여부',
    `receive_event_yn`             varchar(1)    DEFAULT "0" COMMENT '이벤트수신여부',
    `access_token`                 varchar(4)    DEFAULT "0" COMMENT '2차 oAuth 엑세스 토큰',
    `oauth_type`                   varchar(16)   DEFAULT NULL COMMENT '2차 인증 타입',
    `pet_type`                     varchar(32)   DEFAULT NULL COMMENT '애완동물 타입',
    `current_point`                int(11) NOT NULL DEFAULT '0' COMMENT '현재 포인트',
    `last_login`                   datetime      DEFAULT NULL COMMENT '최근 로그인 시간',
    `login_times`                  int(11) NOT NULL DEFAULT '0' COMMENT '로그인 횟수',
    `withdrawal_date`              datetime      DEFAULT NULL COMMENT '탈퇴일',
    `withdrawal_cause`             varchar(512)  DEFAULT NULL COMMENT '탈퇴이유',
    `use_yn`                       varchar(1)    DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`                  datetime      DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`                datetime      DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_tb_user_login_id` (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='회원정보';

DROP TABLE IF EXISTS `tb_user_login_history`;
CREATE TABLE `tb_user_login_history`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id`    bigint(20) unsigned DEFAULT NULL COMMENT '로그인 아이디',
    `login_id`      int(11) NOT NULL COMMENT '로그인 아이디',
    `login_time`    datetime    NOT NULL COMMENT '로그인 시간',
    `login_ip`      varchar(15) DEFAULT NULL COMMENT '로그인 IP 주소',
    `access_status` varchar(32) NOT NULL COMMENT '접속상태',
    PRIMARY KEY (`id`),
    KEY             `idx_tb_user_login_history_login_id` (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='로그인 히스토리 테이블';

DROP TABLE IF EXISTS `tb_device`;
CREATE TABLE `tb_device`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id`    bigint(20) unsigned DEFAULT NULL COMMENT '로그인 아이디',
    `uuid`          varchar(64)               NOT NULL COMMENT '디바이스 고유 아이디',
    `login_id`      int(11) NOT NULL COMMENT '로그인 아이디',
    `os`            varchar(50) NULL COMMENT '접속디바이스 운영체제',
    `ip`            varchar(15) DEFAULT NULL COMMENT '로그인 IP 주소',
    `mac_address`   varchar(17) DEFAULT NULL COMMENT 'MAC 주소',
    `modify_time`   datetime    DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime    DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='디바이스정보 테이블';

DROP TABLE IF EXISTS `tb_watchlist`;
CREATE TABLE `tb_watchlist`
(
    `id`                   bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id`           bigint(20) unsigned DEFAULT NULL COMMENT 'tb_user 테이블의 아이디',
    `tb_place_id`          bigint(20) unsigned DEFAULT NULL COMMENT 'tb_place 테이블의 아이디',
    `tb_bulletin_board_id` bigint(20) unsigned DEFAULT NULL COMMENT 'tb_bulletin_board_id 테이블의 아이디',
    `tb_pet_raboratory_id` bigint(20) unsigned DEFAULT NULL COMMENT 'tb_pet_raboratory_id 테이블의 아이디',
    `modify_time`          datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`        datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_tb_watchlist_tb_user_id` (`tb_user_id`),
    UNIQUE KEY `idx_tb_watchlist_tb_place_id` (`tb_place_id`),
    UNIQUE KEY `idx_tb_watchlist_tb_bulletin_board_id` (`tb_bulletin_board_id`),
    UNIQUE KEY `idx_tb_watchlist_tb_pet_raboratory_id` (`tb_pet_raboratory_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='찜목록(관심목록) 테이블';

DROP TABLE IF EXISTS `tb_zipcode`;
CREATE TABLE `tb_zipcode`
(
    `id`              bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `zipcode`         varchar(5) NULL COMMENT '구역번호(우편번호) (예) 06315',
    `sido`            varchar(25) NULL COMMENT '시도(한글) (예) 서울특별시',
    `sido_en`         varchar(50) NULL COMMENT '시도(영문) (예) Seoul',
    `sigungu`         varchar(30) NULL COMMENT '시군구(한글) (예) 강남구',
    `sigungu_en`      varchar(60) NULL COMMENT '시군구(영문) (예) Gangnam-g',
    `eupmyeon`        varchar(20) NULL COMMENT '읍면(한글) (예) 감물면',
    `eupmyeon_en`     varchar(40) NULL COMMENT '읍면(영문) (예) Gammul-myeon',
    `doro_code`       varchar(12) NULL COMMENT '도로명 코드 (예) 116804166204',
    `doro`            varchar(80) NULL COMMENT '도로명(한글) (예) 논현로8길',
    `doro_en`         varchar(160) NULL COMMENT '도로명(영문) (예) Nonhyeon-ro 8-gil',
    `undergnd_yn`     varchar(1) NULL COMMENT '지하여부(0:지상,1:지하) (예) 0',
    `budg_no1`        varchar(5) NULL COMMENT '건물번호 본번 (예) 67',
    `budg_no2`        varchar(5) NULL COMMENT '건물번호 부번 (예) 0',
    `budg_mgmt_no`    varchar(25) NULL COMMENT '건물관리번호 (예) 1168010300111830010000001',
    `big_dlvy`        varchar(1) NULL COMMENT '다량배달처명(대형빌딩,기관,아파트) (예) NULL',
    `budg_name`       varchar(200) NULL COMMENT '시군구용 건물명 (예) Artespace',
    `dong_code`       varchar(10) NULL COMMENT '법정동코드 (예) 1168010300',
    `dong`            varchar(20) NULL COMMENT '법정동명 (예) 개포동',
    `ri`              varchar(20) NULL COMMENT '리명 (예) 광전리',
    `dong_hj`         varchar(40) NULL COMMENT '행정동명 (예) 개포4동',
    `mtn_yn`          varchar(1) NULL COMMENT '산여부(0:토지,1:산) (예) 0',
    `jibun_no1`       varchar(4) NULL COMMENT '지번 본번 (예) 1183',
    `eupmyeondong_sn` varchar(2) NULL COMMENT '읍면동 일련번호 (예) 01',
    `jibun_no2`       varchar(4) NULL COMMENT '지번 부번 (예) 10',
    `zipcode_old`     varchar(7) NULL COMMENT '구 우편번호 (예) NULL',
    `zipcode_sn`      varchar(3) NULL COMMENT '우편번호 일련번호 (예) NULL',
    PRIMARY KEY (`id`),
    KEY               `tb_zipcode_zipcode_INDEX` (`zipcode`),
    KEY               `tb_zipcode_sido_sigungu_eupmyeon_INDEX` (`sido`,`sigungu`,`eupmyeon`),
    KEY               `tb_zipcode_doro_code_INDEX` (`doro_code`),
    KEY               `tb_zipcode_doro_INDEX` (`doro`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='우편번호 테이블';

DROP TABLE IF EXISTS `tb_medical_staff`;
CREATE TABLE `tb_medical_staff`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_place_id`   bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `staff_name`    varchar(256)           NOT NULL COMMENT '의료진 사람이름',
    `position`      varchar(128)           NOT NULL COMMENT '의료진 직위 (예) 부사장 대표원장 부원장',
    `profile`       varchar(1024)          NOT NULL COMMENT '의료진 약력/경력/career',
    `input_order`   smallint(6) NOT NULL COMMENT '정보 입력순서',
    `modify_time`   datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='병원 의료진 정보';

DROP TABLE IF EXISTS `tb_ranking_algorithm`;
CREATE TABLE `tb_ranking_algorithm`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_place_id`   bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `ranking_date`  datetime    DEFAULT NULL COMMENT '랭킹일',
    `final_ranking` varchar(20) DEFAULT NULL COMMENT '장소에 대한 랭킹',
    `reserved1`     varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드1',
    `reserved2`     varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드2',
    `reserved3`     varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드3',
    `reserved4`     varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드4',
    `reserved5`     varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드5',
    `reserved6`     varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드6',
    `reserved7`     varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드7',
    `reserved8`     varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드8',
    `reserved9`     varchar(20) DEFAULT NULL COMMENT '알고리즘을 위한 예약필드9',
    `modify_time`   datetime    DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime    DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='랭킹 알고리즘 계산 테이블';

DROP TABLE IF EXISTS `tb_petme_qna`;
CREATE TABLE `tb_petme_qna`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id`    bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `category`      varchar(64)  DEFAULT NULL COMMENT '카테고리',
    `title`         varchar(512)               NOT NULL COMMENT '게시글 제목',
    `content`       text                       NOT NULL COMMENT '게시글 내용',
    `writer`        varchar(256) DEFAULT NULL COMMENT '커뮤니티 게시판 게시글 작성자',
    `write_time`    datetime     DEFAULT NULL COMMENT '커뮤니티 게시판 게시글 작성자',
    `read_count`    int(11) unsigned DEFAULT '0' COMMENT 'Q&A 조회수',
    `parent_id`     bigint(20) unsigned NOT NULL COMMENT '부모 게시글 아이디',
    `order`         tinyint(2) unsigned NOT NULL COMMENT '답변순서',
    `depth`         tinyint(2) unsigned DEFAULT '0' COMMENT '댓글 레벨/깊이',
    `use_yn`        varchar(1)   DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`   datetime     DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime     DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='펫미 Q&A 테이블';

DROP TABLE IF EXISTS `tb_petme_notice`;
CREATE TABLE `tb_petme_notice`
(
    `id`               bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_admin_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '로그인 아이디',
    `title`            varchar(512)               NOT NULL COMMENT '제목',
    `writer`           varchar(256) DEFAULT NULL COMMENT '공지 작성자',
    `content`          text                       NOT NULL COMMENT '공지 내용',
    `read_count`       int(11) unsigned DEFAULT '0' COMMENT '공지사항 조회수',
    `notice_gubun`     varchar(64)  DEFAULT NULL COMMENT '공지사항 타입',
    `link_url`         varchar(1024)              NOT NULL COMMENT '링크 주소',
    `html_yn`          varchar(1)   DEFAULT NULL COMMENT 'HTML 사용여부',
    `use_yn`           varchar(1)   DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`      datetime     DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`    datetime     DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='펫미 공지사항 테이블';

DROP TABLE IF EXISTS `tb_common_code_category`;
CREATE TABLE `tb_common_code_category`
(
    `id`            bigint(20) unsigned NOT NULL COMMENT '아이디',
    `name`          varchar(45)              NOT NULL COMMENT '카테고리명',
    `english_name`  varchar(64)              NOT NULL COMMENT '카테고리 영문명',
    `description`   varchar(64)              NOT NULL COMMENT '카테고리 설명',
    `use_yn`        varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`   datetime   DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime   DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='검색키워드 정보 테이블';

DROP TABLE IF EXISTS `tb_common_code`;
CREATE TABLE `tb_common_code`
(
    `code`          bigint(20) unsigned NOT NULL COMMENT '공통코드',
    `name`          varchar(45)              NOT NULL COMMENT '공통코드명',
    `english_name`  varchar(64)              NOT NULL COMMENT '공통코드 영문명',
    `description`   varchar(64)              NOT NULL COMMENT '공통코드 상세설명',
    `use_yn`        varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`   datetime   DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime   DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='공통코드 정보 테이블';

DROP TABLE IF EXISTS `tb_keyword_search`;
CREATE TABLE `tb_keyword_search`
(
    `id`             bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `login_id`       varchar(256)             NOT NULL COMMENT '사용자(회원) 아이디',
    `search_keyword` varchar(64)              NOT NULL COMMENT '검색 키워드',
    `use_yn`         varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`    datetime   DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`  datetime   DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='검색키워드 정보 테이블';

DROP TABLE IF EXISTS `tb_policy`;
CREATE TABLE `tb_policy`
(
    `id`                      bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `category`                varchar(64)              NOT NULL COMMENT '정책카테고리',
    `name`                    varchar(64)              NOT NULL COMMENT '정책이름',
    `description`             text       DEFAULT NULL COMMENT '정책 설명',
    `mode`                    varchar(64)              NOT NULL COMMENT '정책 모드',
    `rule_sql`                varchar(1024)            NOT NULL COMMENT 'SQL 쿼리 룰',
    `rule_regular_expression` varchar(1024)            NOT NULL COMMENT '정규표현식 룰',
    `use_yn`                  varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`             datetime   DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`           datetime   DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='펫미 Q&A 테이블';

DROP TABLE IF EXISTS `tb_backup_history`;
CREATE TABLE `tb_backup_history`
(
    `id`                     bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `source_ip`              varchar(15)                 NOT NULL COMMENT '서버IP',
    `backup_user_name`       varchar(64)                 NOT NULL COMMENT '백업사용자명',
    `destination_ip`         varchar(15)                 NOT NULL COMMENT '서버IP',
    `destination_ssl_port`   varchar(5) NULL COMMENT 'ssl 포트',
    `destination_login_user` varchar(64) NULL COMMENT '로그인 아이디',
    `destination_login_pwd`  varchar(45) NULL COMMENT '로그인 암호',
    `backup_file_name`       varchar(1024)               NOT NULL COMMENT '백업파일이름',
    `backup_location`        varchar(2048)               NOT NULL COMMENT '백업위치',
    `backup_type`            varchar(64)   DEFAULT NULL COMMENT '백업종류',
    `backup_comment`         varchar(1024) DEFAULT NULL COMMENT '백업설명',
    `modify_time`            datetime      DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`          datetime      DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='펫미 Q&A 테이블';

DROP TABLE IF EXISTS `tb_mapping_tb_user_tb_event`;
CREATE TABLE `tb_mapping_tb_user_tb_event`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id`    bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_event_id`   bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `use_yn`        varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`   datetime   DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime   DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_tb_mapping_tb_user_tb_event_tb_user_id_tb_event_id` (`tb_user_id`, `tb_event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='이벤트-사용자 매핑테이블';

DROP TABLE IF EXISTS `tb_mapping_tb_user_tb_petme_notice`;
CREATE TABLE `tb_mapping_tb_user_tb_petme_notice`
(
    `id`                 bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id`         bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_petme_notice_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `use_yn`             varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`        datetime   DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time`      datetime   DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_mapping_tb_user_petme_notice_user_id_petme_notice_id` (`tb_user_id`, `tb_petme_notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='이벤트-사용자 매핑테이블';

DROP TABLE IF EXISTS `tb_mapping_tb_server_tb_file`;
CREATE TABLE `tb_mapping_tb_server_tb_file`
(
    `id`            bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_server_id`  bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `tb_file_id`    bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
    `use_yn`        varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',
    `modify_time`   datetime   DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime   DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_tb_mapping_tb_server_tb_file_tb_server_id_tb_file_id` (`tb_server_id`, `tb_file_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='서버-파일 매핑테이블';

DROP TABLE IF EXISTS `tb_map_user_device`;
CREATE TABLE `tb_map_user_device`
(
    `map_user_device_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `user_id`            bigint(20) unsigned NOT NULL COMMENT '사용자 아이디',
    `device_id`          bigint(20) unsigned NOT NULL COMMENT '디바이스 아이디',
    PRIMARY KEY (`map_user_device_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='사용자 디바이스 매핑테이블';

-- 약관 (강희동 추가)
DROP TABLE IF EXISTS `tb_terms`;
CREATE TABLE `tb_terms`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `title`       varchar(1024)          NOT NULL COMMENT '약관제목',
    `contents`    text                   NOT NULL COMMENT '약관내용',
    `required_yn` varchar(1) DEFAULT 'y' NOT NULL COMMENT '필수여부',
    `version`     tinyint(8) NOT NULL COMMENT '버전(가장 높은 버전을 사용한다)',
    `order`       tinyint(8) NOT NULL COMMENT '정렬순서',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='약관';

-- 사용자 약관 동의 (강희동 추가)
DROP TABLE IF EXISTS `tb_terms_consent`;
CREATE TABLE `tb_terms_consent`
(
    `terms_id`      bigint(20) unsigned NOT NULL COMMENT '약관아이디',
    `user_id`       bigint(20) unsigned NOT NULL COMMENT '사용자아이디',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`terms_id`, `user_id`),
    FOREIGN KEY (`terms_id`) REFERENCES `tb_terms` (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `tb_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='약관동의';



SET
foreign_key_checks = 1;