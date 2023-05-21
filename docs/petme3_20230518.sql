//------------------------------------------------------------
// DB Convention/Naming Convention 명명 규칙
//------------------------------------------------------------
{
  * DB 테이블명은 가독성을 위해서 축약하지 않는다.
  * 단, 우편번호 테이블인 tb_zipcode DB 테이블안의 칼럼명은 축약한다.(성능을 위해서)
  * NoSQL도 고려해 볼만하다.
  * 테이블 생성 스크립트에서 MySQL은 INDEX와 KEY가 동일하게 쓰이므로 모두 KEY로 통일한다.
  * MySQL set type 은 사용하지 않는다. 굉장히 구리다.
  * 공통코드 테이블은 생성만 하고 쓰지 않는다. join이 굉장히 비효율적이다.
    즉, 참조만 하도록 하자.
  * Auto Increment 결론 :
    단일 DB를 쓰면 AUTO_INCREMENT를 키로 쓰자. (성능, 메모리 측면에서 더 낫다.)
    다중 DB를 사용하는 분산형 환경이면 데이터 일관성을 위해 UUID를 키로 쓰는 걸 고려하자.
    MySQL 5.7, MariaDB 10.1.12 버전은 데이터를 삭제하고, DB를 재시작 할 경우 초기화 된 정보가
    나오게 되며, MySQL 8.0, MariaDB 10.3.8 버전은 데이터를 삭제하고, DB를 재 시작 한다고 해도 
    초기화 되지 않고 계속 증가하게 된다. 
    자동증가값 관련 참조 사이트 : https://insanelysimple.tistory.com/410
  * charset과 collate는 이모지, 이모티콘을 지원하기 위해서,
    각각 utf8mb4와 utf8mb4_general_ci를 사용한다.
  * index=key 생성 규칙 :
    insert, update, delete 가 많은 컬럼에는 성능때문에 index를 걸지 않는다.
    where 또는 join 절에 자주 사용하는 컬럼에 사용한다.
    order by 에 사용되는 컬럼에는 클러스터형 인덱스(id와 같은)가 유리하다.
    중복되는 값이 들어가는 컬럼(NULL값 허용)에는 index를 건다.
    즉, 
      KEY 'index_테이블명_컬럼명' (컬럼명)   
    과 같이 사용한다.
    중복값 허용되지 않는 컬럼(NULL값 허용)에는 unique index를 건다.
    즉, UNIQUE KEY 'index_테이블명_컬럼명' (컬럼명)   과 같이 사용한다.
    foreign key(NULL값 허용) 도 인덱스이다.
    인덱스의 속도는 
      clustered index(primary key) > secondary index(unique index) > foreign key
    의 순으로 빠르다.
    다중 컬럼 인덱스도 활용하도록 하자.
    즉, key idx_name(name, address) 와 같이 사용한다.
  * Foreign Key : 
    개발시 편리성
    대용량 데이터 로딩시 성능문제
    테이블 구조 변경시 고려사항이 많음
    테스트 데이터(canned data:통조림 데이타,미리 준비된 데이터) 만들기에 불편함
    등의 문제검 때문에 사용하지 않는것을 원칙으로 한다.
    향후는 고려해 볼만 한다.
}
//------------------------------------------------------------
// 공통 컬럼 설명
//------------------------------------------------------------
{
  id :
  (테이블명 설명) 
    자동증가/기본키이다.
    MySQL은 항상 id를 두는 것이 좋다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  modify_time :
  (테이블명 설명) 
    정보 수정일시
  (데이터 타입 설명) 
    datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP
    위와 같이 하면 record insert시에 자동으로 MySQL에 현재시간에 대한 타임스탬프가 입력된다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  use_yn :
  (필드명 설명)
    서버 사용 여부
  (데이터 타입 설명) 
    varchar(1) DEFAULT NULL
    'y' 'n' 데이타만 들어감으로 4바이트면 충분하다.
    소문자로 입력하자.
    enum('Y','N') DEFAULT 'Y' 로 설계하지 마라.
    MySQL에서 enum 타입은 되도록 안 쓰는 것이 좋다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "y" "n"

  register_time :
  (테이블명 설명) 
    정보 등록일시
  (데이터 타입 설명) 
    datetime DEFAULT now() NOT NULL
    위와 같이 하면 record insert시에 자동으로 MySQL에 현재시간에 대한 타임스탬프가 입력된다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 
  //----- reserved field ---------------------------------------
    없음
}


//************************************************************************************************/
// Web Crawling 데이터 관련 테이블들
//************************************************************************************************/
//------------------------------------------------------------
// tb_place_business_hours : 해당 장소(가게)의 영업시간 데이타가 저장되는 테이블
//------------------------------------------------------------
{
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
}

{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_place_business_hours : 
  (테이블명 설명) 
    네이버 맵(지도)에서 크롤링한 데이터가 저장되는 테이블이다.
    해당 장소의 영업시간을 저장하는 테이블이다.
    비정형 데이타가 많아서 향후 처리하기 위한 reserved 필드도 많이 설계해 놓았다.
    향후, 다듬도록 하자.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  tb_place_id :
  (테이블명 설명) 
    tb_place 테이블의 id를 나타낸다.
    tb_place 테이블의 내용은 tb_crawling_naver_map 테이블에서 끌고가는 것으로 하며,
    내용은 동일하다고 본다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  content :
  (필드명 설명)
    영업시간 전체정보
    해당 장소의 영업시간에 대한 전체 데이타가 입력되는 필드이다.
    하나씩 디비에 저장한 것을 끌고와서 보여줄려면 힘들기 때문에,
    이렇게 전체 데이타를 모두 저장해 놓는 필드가 필요하다.
    그대로 DB에서 끌고와서 보여준다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "월 10:00 - 18:30 \n
        13:00 - 14:00 휴게시간 \n
    화 10:00 - 18:30 \n
        13:00 - 14:00 휴게시간 \n
    수 10:00 - 21:00 \n
    목 10:00 - 21:00 \n
    금 10:00 - 21:00 \n
    토 10:00 - 21:00 \n
    일 10:00 - 18:30 \n
        13:00 - 14:00 휴게시간 \n
    04/10 휴무 \n
    - 일, 월, 화요일 오전접수마감은 12시입니다"
    "매일 00:00 - 24:00 \n
          13:00 - 14:00 휴게시간"
    "매일 00:00 - 24:00 \n
    - 응급 진료: 20:00~9:00"

  all_year_round_yn :
  (필드명 설명)
    연중무휴 여부
  (데이터 타입 설명) 
    varchar(4) DEFAULT NULL
    'y' 'n' 데이타만 들어감으로 4바이트면 충분하다.
    소문자로 입력하자.
    enum('Y','N') DEFAULT 'Y' 로 설계하지 마라.
    MySQL에서 enum 타입은 되도록 안 쓰는 것이 좋다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "y" "n"

  closed_days :
  (필드명 설명)
    휴무일
    쉬는 날은 무작위이기 때문에, 여러레코드를 두지 않고 문자열을 계속 이어붙이도록 한다.  
  (데이터 타입 설명) 
    varchar(2048) DEFAULT NULL 
    04/10 과 같은 형태의 문자열을 계속 이어붙인다. 구분자는 | 로 한다.
    한가지 우려는 휴무일이 아주 많은 영업장은 4096바이트보다 더 필요할 수도 있지 않을까?
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "04/10"
    "04/10|05/13"
    "04/10|05/13|06/27"

  regular_holiday :
  (필드명 설명)
    정기휴무일
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "일" "월" "화" "수" "목" "금" "토"

  weekly_regular_holiday_yn :
  (필드명 설명)
    매주 정기휴무일
  (데이터 타입 설명) 
    varchar(4) DEFAULT NULL
    'y' 'n' 데이타만 들어감으로 4바이트면 충분하다.
    소문자로 입력하자.
    enum('Y','N') DEFAULT 'Y' 로 설계하지 마라.
    MySQL에서 enum 타입은 되도록 안 쓰는 것이 좋다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "y" "n"

  monthly_regular_holiday_yn :
  (필드명 설명)
    매월 정기휴무일
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "y" "n"

  monday_hours
  tuesday_hours
  wednesday_hours
  thursday_hours
  friday_hours
  saturday_hours
  sunday_hours :
  (필드명 설명)
    각 요일별 영업시간을 저장하고 있는 필드이다.
    영업시작시간 - 영업종료시간   으로 입력되어 있다. 구분 문자열   -   로 파싱하여 보여주도록 한다.
    웹페이지에서 "휴게시간 13:00에 영업 시작" "영업중" "연중무휴" 등을 표현해 주기 위해서 필요한 필드이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "10:00 - 18:30"
    "10:00 - 21:00"

  monday_break_time
  tuesday_break_time
  wednesday_break_time
  thursday_break_time
  friday_break_time
  saturday_break_time
  sunday_break_time :
  (필드명 설명)
    각 요일별 휴게시간을 나타내고 있는 필드이다.
    웹페이지에서 "휴게시간 13:00에 영업 시작" "영업중" "연중무휴" 등을 표현해 주기 위해서 필요한 필드이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "13:00 - 14:00"

  modify_time : 공통설명 참조
  register_time : 공통설명 참조

  //----- 향후 설계해야 될지도 모르는 필드 ---------------------
  `business_hours_sub_description` text DEFAULT NULL COMMENT '영업시간 부가정보',

  `weekday_operating_time` varchar(64) DEFAULT NULL COMMENT '평일운영시간',
  `weekend_operating_time` varchar(64) DEFAULT NULL COMMENT '주말운영시간',
  `saturday_operating_time` varchar(64) DEFAULT NULL COMMENT '토요일운영시간',
  `sunday_operating_time` varchar(64) NOT NULL COMMENT '일요일운영시간',
  `holiday_operating_time` varchar(64) NOT NULL COMMENT '공휴일운영시간',

  `monday_hospital_morning_reception_deadline` varchar(64) DEFAULT NULL COMMENT '월요일 오전접수마감시간',
  `tuesday_hospital_morning_reception_deadline` varchar(64) DEFAULT NULL COMMENT '화요일 오전접수마감시간',
  `wednesday_hospital_morning_reception_deadline` varchar(64) DEFAULT NULL COMMENT '수요일 오전접수마감시간',
  `thursday_hospital_morning_reception_deadline` varchar(64) DEFAULT NULL COMMENT '목요일 오전접수마감시간',
  `friday_hospital_morning_reception_deadline` varchar(64) DEFAULT NULL COMMENT '금요일 오전접수마감시간',
  `saturday_hospital_morning_reception_deadline` varchar(64) DEFAULT NULL COMMENT '토요일 오전접수마감시간',
  `sunday_hospital_morning_reception_deadline` varchar(64) DEFAULT NULL COMMENT '일요일 오전접수마감시간',

  `monday_hospital_afternoon_reception_deadline` varchar(64) DEFAULT NULL COMMENT '월요일 오후접수마감시간',
  `tuesday_hospital_afternoon_reception_deadline` varchar(64) DEFAULT NULL COMMENT '화요일 오후접수마감시간',
  `wednesday_hospital_afternoon_reception_deadline` varchar(64) DEFAULT NULL COMMENT '수요일 오후접수마감시간',
  `thursday_hospital_afternoon_reception_deadline` varchar(64) DEFAULT NULL COMMENT '목요일 오후접수마감시간',
  `friday_hospital_afternoon_reception_deadline` varchar(64) DEFAULT NULL COMMENT '금요일 오후접수마감시간',
  `saturday_hospital_afternoon_reception_deadline` varchar(64) DEFAULT NULL COMMENT '토요일 오후접수마감시간',
  `sunday_hospital_afternoon_reception_deadline` varchar(64) DEFAULT NULL COMMENT '일요일 오후접수마감시간',

  business_hours_sub_information :
  (필드명 설명)
    영업시간 부가정보
    영업시간에 대한 부가적인 정보를 저장한다.
    현재는 필요없는 reserved 필드이다.
  (데이터 타입 설명) 
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "일,월,화요일 오전접수마감은 12시입니다 ^"
    "일요일/공휴일 휴무 ^"
}
//------------------------------------------------------------
// tb_server : 서버에 대한 정보가 저장되는 테이블
//------------------------------------------------------------
{
  DROP TABLE IF EXISTS `tb_server`;
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_server : 
  (테이블명 설명) 
    petme3 서비스를 제공하는 서버에 대한 각종 정보를 저장하는 테이블이다.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  hostname : 
  (테이블명 설명) 
    서버 호스트명
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "petme-dev" "ip-172-31-43-247"

  nickname : 
  (테이블명 설명) 
    서버 닉네임(별명)
    관리를 위한 목적으로 사용한다. 
    주로 admin 페이지에서 관리하기 위해서 서버에 대한 별명을 붙인다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "petme_웹서버" "petme_이미지서버" "petme_개발서버"

  model : 
  (테이블명 설명) 
    서버 모델
    서버의 물리적인 모델을 표시한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "ibm3650"

  ip1 :
  ip2 : 
  (테이블명 설명) 
    서버 ip 주소1 
    서버 ip 주소2
    서버의 ip 주소를 나타낸다. 
    서버는 보통 랜카드가 2개 있는 경우가 많다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "172.31.43.247" "192.168.0.37"

  status : 
  (테이블명 설명) 
    서버 상태
    로드 밸런싱을 하기위해서 서버의 상태를 표시한다.
    normal : 정상 상태
    bad : 로그 밸런싱해야 할 필요가 있다.
    diskfull : 디스크 풀남
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "normal" "bad" "diskfull"

  load_average : 
  (테이블명 설명) 
    서버 로드평균(로드 애버리지)
    로드 밸런싱을 하기위해서 서버의 상태를 표시한다.
    리눅스 top 상태를 저장한다.
    정기적인 배치페이지에서 로드상태를 check해서 DB에 입력한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "10.68" "12.26" "57.45"

  concurrent_user : 
  (테이블명 설명) 
    서버 동접자수
    로드 밸런싱을 하기위해서 서버의 상태를 표시한다.
    해당 서버에 현재 접속한 동접자 수를 저장하는 필드이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    736 4003

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_file : 파일에 대한 정보가 저장되는 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_file : 
  (테이블명 설명) 
    파일에 대한 정보를 저장하는 테이블이다.
    크롤링한 이미지 및 사이트에서 직접 사용자가 upload한 이미지 등 모든 이미지가 같은 테이블에 저장된다.
    이미지의 출처에 대한 것은 image_from 필드로 구분하도록 하자.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  tb_user_id :
  (테이블명 설명) 
    tb_user 테이블의 id를 나타낸다.
    tb_user_id 는 값이 NULL 일 수도 있다. 
    즉 파일의 소유자가 반드시 기입될 필요는 없다.
    왜냐하면, 네이버의 병원 약국 이미지는 소유주가 없기 때문이다.
    크롤링 id 일수 있기 때문에, NULL 일 수도 있다.
    image_gubun 필드값이 "image|사용자-프로필" 일때 tb_user_id 를 찾아서 검색하면 된다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  tb_place_id :
  (테이블명 설명) 
    tb_place 테이블의 id를 나타낸다.
    image_gubun 필드값이 "image|장소-시간표" "image|장소-방문자" "image|장소-메인" 일때 tb_place_id 를 찾아서 검색하면 된다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  tb_blog_id :
  (테이블명 설명) 
    tb_blog 테이블의 id를 나타낸다.
    image_gubun 필드값이 "image|블로그-메인" "image|블로그-썸네일" 일때 tb_blog_id 를 찾아서 검색하면 된다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  tb_bulletin_board_id :
  (테이블명 설명) 
    tb_bulletin_board 테이블의 id를 나타낸다.
    tb_bulletin_board 테이블의 내용은 tb_crawling_dogpalza 테이블에서 끌고가는 것으로 하며,
    내용은 동일하다고 본다.
    image_gubun 필드값이 "image|강사모-메인" 일때 tb_bulletin_board_id 를 찾아서 검색하면 된다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.
    18 2045 398 40056 

  tb_pet_raboratory_id :
  (테이블명 설명) 
    tb_pet_raboratory 테이블의 id를 나타낸다.
    tb_pet_raboratory 테이블의 내용은 tb_crawling_dogpalza 테이블에서 끌고가는 것으로 하며,
    내용은 동일하다고 본다.
    image_gubun 필드값이 "image|펫연구소-메인" "image|펫연구소-썸네일" 일때 tb_pet_raboratory_id 를 찾아서 검색하면 된다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.
    18 2045 398 40056 

  tb_petme_notice_id :
  (테이블명 설명) 
    tb_petme_notice 테이블의 id를 나타낸다.
    tb_petme_notice 테이블의 내용은 tb_crawling_dogpalza 테이블에서 끌고가는 것으로 하며,
    내용은 동일하다고 본다.
    file_gubun 필드값이 "file|공지사항" 일때 tb_petme_noticeid 를 찾아서 검색하면 된다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.
    18 2045 398 40056 

  tb_event_id :
  (테이블명 설명) 
    tb_event 테이블의 id를 나타낸다.
    file_gubun 필드값이 "file|이벤트" 일때 tb_event 를 찾아서 검색하면 된다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.
    18 2045 398 40056 

  original_name : 
  (테이블명 설명) 
    원본파일명 = 네이버에서 긁어온 원본파일명
    파일명만 저장한다. 즉, 파일의 path(경로)는 저장하지 않는다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "%B0%C7%B0%AD%B0%CB%C1%F8_%C3%D6%BD%C5.jpg"

  save_name : 
  (테이블명 설명) 
    저장할때의 이름 = 네이버에서 긁어온 원본파일명을 바꿔서 저장할 수도 있다.
    파일명만 저장한다. 즉, 파일의 path(경로)는 저장하지 않는다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "%B0%C7%B0%AD%B0%CB%C1%F8_%C3%D6%BD%C5.jpg"

  full_path : 
  (테이블명 설명) 
    파일의 전체경로만 저장한다. 즉, 파일명은 저장되지 않는다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "/data/images/"

  size :
  (테이블명 설명) 
    이미지 크기/사이즈
    byte(바이트) 단위이다.
  (데이터 타입 설명) 
    int(11) DEFAULT NULL
    이 타입으로 설계하면 Tera Byte 까지 저장가능하다. 그 이상은 필요치 않을 것이다.
  (DB 입력데이터 예제) 
    정수형 숫자이다.  
    901922 2739662663

  hash_type : 
  (테이블명 설명) 
    hash의 형태를 저장하는 필드이다.
    주로 md5 해쉬값을 쓰도록 하자.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "md5" "sha256"

  hash : 
  (테이블명 설명) 
    파일의 hash를 저장한다.
    향후, 중복파일들이 존재할 때, 
    용량을 줄이기 위해서 hash 값만 저장하기 위해서 사용하는 필드이다.
    주로 md5 해쉬값을 쓰도록 하자.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "5bdf74912a51c34815f11e9a3d20b609"

  mimetype : 
  (테이블명 설명) 
    이미지의 mimetype을 나타낸다. 즉, 이미지 타입을 나타낸다.
    이 필드가 왜 필요하냐면, 리눅스에서는 이미지가 저장될 때 반드시 확장자를 지정해서 저장되지 않을 수도 있기 때문이다.
    가령, dog_jindo.jpg 를 dog_jindo203840 등과 같이 저장될 때는 확장자를 알 수 없기 때문이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "image/jpeg" "file/xls" "file/text" "file/avi"

  gubun :
  (테이블명 설명) 
    파일의 형태에 대한 구분
    파일 및 이미지가 어떤 종류의 것인지를 표시해 준다.
    사용자-프로필 : 사용자의 프로필 이지미이다 = tb_user_id
    장소-시간표 : 동물병원 가격표와 검사항목 등에 대한 이미지을 말한다, 복수가 되나? = tb_place_id
    장소-방문자 : 동물병원에 방문해서 찍은 사진들에 대한 이미지들 = tb_place_id
    장소-메인 : 사이트 자체에 대한 이미지들 = tb_place_id

    블로그-메인 : 사이트에 대한 블로그 이미지들 = tb_blog_id
    블로그-썸네일 : 블로그에 대한 썸네일 이미지, 복수가 되나? = tb_blog_id
    
    강사모-메인 : 강사모에 대한 썸네일 이미지 = tb_bulletin_board_id
    
    펫연구소-메인 : 펫연구소에 대한 컨텐츠이고 통 이미지로 되어 있다 = tb_pet_raboratory_id
    펫연구소-썸네일 : 펫연구소에 대한 썸네일 이미지 = tb_pet_raboratory_id
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제)  
    문자열 형태의 텍스트이다.
    mimetype 필드가 있는데도 불구하고 앞에 file| image| 를 붙이는 이유는 가독성을 위해서이다.
    "file|공지사항" 
    "file|이벤트"

    "image|사용자-프로필"

    "image|장소-시간표" 
    "image|장소-방문자" 
    "image|장소-메인" 
    
    "image|블로그-메인" 
    "image|블로그-썸네일" 
    "image|강사모-메인" 
    "image|펫연구소-메인" 
    "image|펫연구소-썸네일"        

  source : 
  (테이블명 설명) 
    이미지 source
    이미지의 원본 출처가 어디인지를 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "naver crawling"
    "petme upload"

  main_image_yn :
  (필드명 설명)
    파일 형식이 이미지일 때 대표 이미지인지 아닌지의 여부를 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "y" "n"

  exposure_order :
  (테이블명 설명) 
    이미지 노출 순서
    한 사이트에 대한 이미지가 여러장일때 노출 순서를 나타낸다.
    1이 제일 먼저 노출된다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    1 3 8  

  encoding : 
  (테이블명 설명) 
    파일 엔코딩
    텍스트 파일인 경우 파일의 인코딩이 다를 수 있다.
    대부분 utf-8이지만 특정 인코딩을 그대로 사용할 수도 있다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "UTF-8" "EUC-KR" "CP949"

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조

  //----- 향후 설계해야 될지도 모르는 필드 ---------------------
    `file_url` varchar(1024) NOT NULL COMMENT '파일 접근 URL',
    `image_encoding_method` varchar(64) NOT NULL COMMENT '파일 인코딩(엔코딩)',
    `image_encoding_yn` varchar(1) NOT NULL COMMENT '이미지 인코딩 여부',

  image_encoding_method : 
    파일 인코딩 방법
    이미지 인코딩으로 사이즈를 줄여야 할 필요가 있다.
    ffmpeg 으로 인코딩한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "ffmpeg"
}
//------------------------------------------------------------
// tb_review : 후기 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_review : 
  (테이블명 설명) 
    해당 장소에 대한 후기(리뷰)를 저장하는 테이블이다.
    향후, 다듬도록 하자.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  tb_user_id :
  (테이블명 설명) 
    tb_user 테이블의 id를 나타낸다.
    크롤링 id 일수 있기 때문에, NULL 일 수도 있다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  tb_place_id :
  (테이블명 설명) 
    tb_place 테이블의 id를 나타낸다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  tb_blog_id :
  (테이블명 설명) 
    tb_blog 테이블의 id를 나타낸다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  writer :
  (필드명 설명)
    리뷰 작성자
    이 필드를 두는 이유는 tb_user_id 로 join 하지 않고, 바로 writer만 가지고 사용하기 위함이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "꼬마돌507" "lo****" "빵빠레바닐라" "태지11"

  content :
  (필드명 설명)
    리뷰 내용
    petme3 서비스의 모든 글쓰기 내용들은 400자 제한을 두었다.
    왜냐하면, app이기 때문에 너무 길면 안되기 때문이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "너무 친절하고 자세하게 알려주셔서 항상 감사드립니다. 진료뿐만 아니라 집에서도 아이들 건강 관리방법 및 재활등 여러가지들도 자\n
    세하게 알려주시고 특정 문제점이 생기면 그 원인들도 잘 찾아주셔서 항상 믿음이 갑니다! 감사합니다^^"

  grade : 
  (필드명 설명)
    사용자가 해당장소에 대한 리뷰 작성시에 매기는 평점을 나타낸다.
    참조 사이트로 "반려생활" "화해" 등의 App에서 랭킹을 참조하면 된다.
  (데이터 타입 설명) 
    원래는, 실수형 데이터 타입으로 설계해야 하지만,
    코딩의 번거로움을 피하기 위해서 varchar로 표현한다.
    성능이 떨어지면, 다시 실수형으로 바꿀 필요가 있다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "4.58"  "6.97"  "3. 53" 

  keyword :
  (필드명 설명)
    리뷰 키워드
    리뷰에 대한 키워드를 표현한다.
    리뷰 작성할 때 미리 정의한 키워드를 불러와서 보여준다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "친절해요" "상담이 자세해요" "복약지도를 잘해줘요"
    "조제약 포장이 세심해요" "제품 종류가 다양해요" "매장이 청결해요"
    "가격이 합리적이에요" "매장이 넓어요"

  read_count :
  (필드명 설명)
    읽은 조회수
    사용자가 클릭하면 조회수가 1개씩 올라간다.
  (DB 입력데이터 예제) 
    정수형 숫자이다.
    349

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_blog : 블로그 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_blog : 
  (테이블명 설명) 
    해당 장소에 대한 네이버 블로그를 저장하는 테이블이다.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  tb_user_id :
  (테이블명 설명) 
    tb_user 테이블의 id를 나타낸다.
    크롤링 id 일수 있기 때문에, NULL 일 수도 있다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  tb_place_id :
  (테이블명 설명) 
    tb_place 테이블의 id를 나타낸다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  url :
  (필드명 설명)
    장소에 대한 블로그 주소를 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "https://blog.naver.com/byejoon22" 
    "https://blog.naver.com/smart7582" 

  title :
  (필드명 설명)
    장소에 대한 블로그 제목을 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "[병원일기] 리찌는 강남 예은동물병원에서 십자인대질환 수술 없이..." 
    "소형견 말티푸 슬개골탈구 예은동물병원 진료 후기" 

  content :
  (필드명 설명)
    장소에 대한 블로그 내용을 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "21년 12월에 리찌의 우측 십자인대가 아예 끊어져 버려서 정말 22년도 한 해는 어떻게든 수술을 시키지 않고 보행에\n
    문제없는 다릴 만들기 위해서 리찌와 내가 진짜 많이 노력했다. 솔직히 십자인대 수술 비용이 적지 않기..." 
    "소형견 말티푸 슬개골탈구 예은동물병원 진료 후기 한 4달 전쯤 애기가 산책하다 낑낑거리면서 다리를 절었어요ㅠ\n
    그때 집 앞 동물병원을 가보긴 했지만 슬개골탈구 수술이 가능한 전문 병원이 아니라서 유명하기도 하고..." 

  writer :
  (필드명 설명)
    블로그 작성자
    이 필드를 두는 이유는 
     로 join 하지 않고, 바로 writer만 가지고 사용하기 위함이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "러브러블리" "datesugar" "재로몬" "별이언니"

  hashtag :
  (필드명 설명)
    블로그 해시태그
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "#리찌 #말티즈 #강남예은동물변원 #예은동물병원 #십자인대파열 #강아지십자인대\n
    #강아지십자인대수술 #십자인대 #퇴행성관절염 #조인트벡스 #pdrn 주사"

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_crawling_naver_map : 네이버 맵(지도)에서 크롤링한 데이터가 저장되는 테이블 = tb_place
//------------------------------------------------------------
{
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
    PRIMARY KEY (`id`),
    KEY `index_tb_crawling_naver_map_name` (`name`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='네이버맵 정보 크롤링 테이블';
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_crawling_naver_map : 
  (테이블명 설명) 
    네이버 맵에서 크롤링한 데이터가 저장되는 테이블이다.
    다음 두 테이블은 같은 구조이다.(tb_crawling_naver_map = tb_place)
    크롤링 업체 "앨코컴패니"에 외주 용역을(약 1,000만원 정도) 줘서 끌고오는 엑셀데이타가 입력되는 테이블이다.
    한달에 4번, 1주일에 한번 정도 크롤링해서 DB에 엑셀로 입력하도록 한다.
    네이버 지도 >> 동물병원 검색   을 참조해서 설계했다.
    place(장소) 정보를 위해서는 반려생활이란 앱을 참조로 하면 된다.
    place는 "병원" "약국" "미용" "용품매장" "산책" "카페" "호텔" 등 다양하다.
    더 늘어날 수도 있다.
    우체국 우편번호를 끌고온 tb_zipcode 테이블에 넣으면 큰일난다.
    왜냐하면, 공원이나 산은 우편 배달하는 주소가 없고, 
    네이버나 반려생활 앱에 표현된 것은 해당 위치에서 가장 가까운 곳의 
    주소로 표현되는 가짜 주소이기 때문이다.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  name :
  (필드명 설명)
    해당 장소명/장소이름을 나타낸다.
    인코딩에 따라서, utf = 3바이트, utf8mb4 = 4바이트가 한 문자이므로
  (데이터 타입 설명) 
    이 필드는 varchar(1024) NOT NULL 이다.
    이 테이블의 나머지 필드들은 네이버에서 크롤링한 데이터이기 때문에 장소에 따라서 없는 데이타가 있기 때문에, 모두 DEFAULT NULL 로 되어야 한다. 단, 장소명은 무조건 있어야 하므로, NULL이 되면 안된다. 즉, location_name 필드는 NOT NULL 이어야 한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "봉은공원" "독립문동물병원" "우리동물병원"

  ranking : 
  (필드명 설명)
    순위/등급/서열/평점 등을 나타낸다.
    참조 사이트로 "반려생활" "화해" 등의 App에서 랭킹을 참조하면 된다.
    < 알고리즘 >
    1. 랭킹 디비 입력시간 :
    금일 24시 59분 59초를 넘어서, 다음날 0시 0초에 랭킹이 입력되게 된다.
    전주/전달/전일 기준으로 랭킹으로 소팅한다.
    예를 들어, 2023-03-22 의 월간 랭킹은 2023-02-01 ~ 2023-02-28 까지의 합의 평균이다.
    따라서 2023년 1월 이전의 랭킹 데이타는 필요가 없지만, 일단 삭제하지 말고 보관하도록 하자.
    왜냐하면 나중에 필요에 의해서 그래프 같은 것을 그릴수도 있기 때문이다.
    단 조회 속도를 원활히 하도록 하기 위해서, backup 테이블로 옮기는 것이 좋을 듯 하다.
    2. 랭킹 표현방법 :
    웹에서 별로 표시된다. 별아이콘에 노랗게 표시되고, 반쪽만 칠해지게 되면 1점이다.
    네이버는 5점 만점에 3가지로 표시한다. 즉, 4.38/5 와 같이 표현한다.
    평점은 0도 있는가? 0은 없다. 
    기본으로 2점은 준다. 
    2 ~ 10 점까지 랭킹을 매긴다.
    2점이 디폴트이고 5랭킹이 있는데 2씩 더한다. 
    내부적으로는 3자리 이상으로 랭킹을 매기고, 웹에서 보여줄때는 2자리로 보여주도록 하자.
  (데이터 타입 설명) 
    원래는, 실수형 데이터 타입으로 설계해야 하지만,
    코딩의 번거로움을 피하기 위해서 varchar로 표현한다.
    성능이 떨어지면, 다시 실수형으로 바꿀 필요가 있다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "4.58"  "6.97"  "3. 53" 

  blog_review_count :   
  (필드명 설명)
    블로그 리뷰수
    자료형은 int(11) DEFAULT '0' 으로 표현한다.
    리뷰수는 아무리 많아도 10억단위가 넘지 않을 것으로 예상되기 때문에(단, 유튜브나 아마존같은 대형 서비스로 가면 넘을 것이다) int 형으로 설계한다.
    또, int unsigned일 경우에 0 ~ 4294967295까지 표시할 수 있다.
    바이트를 절약하기 위해서, varchar로 설계하지 않았다.
  (DB 입력데이터 예제) 
    정수형 숫자이다.
    349

  visitor_review_count :
  (필드명 설명)
    방문자 리뷰수
    자료형은 int(11) DEFAULT '0' 으로 표현한다.
    리뷰수는 아무리 많아도 10억단위가 넘지 않을 것으로 예상되기 때문에(단, 유튜브나 아마존같은 대형 서비스로 가면 넘을 것이다) int 형으로 설계한다.
    또, int unsigned일 경우에 0 ~ 4294967295까지 표시할 수 있다.
    바이트를 절약하기 위해서, varchar로 설계하지 않았다.
  (DB 입력데이터 예제) 
    정수형 숫자이다.  
    159
    
  street_name_address :
  (필드명 설명)
    도로명 주소
    자료형은 varchar(1024) DEFAULT NULL 으로 표현한다. 즉, name 필드와 넉넉하게 잡았다.
  (DB 입력데이터 예제) 
    가짜 주소가 들어갈 수도 있다.
    산, 공원 등은 주소가 없다.
    즉, 네이버에서는 특정 장소에(산이나 바다, 하천, 공원 등)는 주소가 존재하지 않으면, 인접한 다른 유명한 장소로(파출소나 건물 등) 대신 주소가 들어가는 경우도 있다.
    아래는 예는 봉은공원에 대한 주소이다. 
    원래 봉은공원에 대한 우체국 주소는 존재하지 않는다???
    웹상에서 주소는 도로명과 지번을 두줄로 표현하도록 한다. 
    문자열 형태의 텍스트이다.
    "서울 강남구 봉은사로81길 16" "서울 마포구 마포대로11길 35"
    "서울 강남구 삼성동 74-13 건너편"

  lot_number_address :
  (필드명 설명)
    지번 주소
    자료형은 varchar(1024) DEFAULT NULL 으로 표현한다. 즉, name 필드와 넉넉하게 잡았다.
  (DB 입력데이터 예제) 
    가짜 주소가 들어갈 수도 있다.
    즉, 네이버에서는 특정 장소에(산이나 바다, 하천, 공원 등)는 주소가 존재하지 않으면, 인접한 다른 유명한 장소로(파출소나 건물 등) 대신 주소가 들어가는 경우도 있다.
    아래는 예는 봉은공원에 대한 주소이다. 
    원래 봉은공원에 대한 우체국 주소는 존재하지 않는다???
    웹상에서 주소는 도로명과 지번을 두줄로 표현하도록 한다. 
    문자열 형태의 텍스트이다.
    "서울 강남구 삼성동 74-13 건너편" "공덕동 222-2"

  zipcode :
  (필드명 설명)
    우편번호
    자료형은 varchar(20) DEFAULT NULL 으로 표현한다. 
    고정 5자리 형태이다. 하지만, utf8mb4를 고려해서 혹시모르기 때문에 곱하기 4해서 20자리로 잡았다.
    향후 쿼리 속도를 살펴봐서 다시 5자리로 조정될 수 있다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "04501" "04558" "06086"

  phone :
  (필드명 설명)
    전화번호(대표)
    자료형은 varchar(20) DEFAULT NULL 으로 표현한다. 
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "02-735-7530" "010-5813-2657"

  payment_method :
  (필드명 설명)
    결제 수단
    카드 등 일반적인 결제 수단을 제외하고 특수하게 통용되는 결제 수단을 나타내는 필드이다.
  (데이터 타입 설명) 
    varchar(80) DEFAULT NULL
    한글 20자리면 충분하다. utfmb4고려해서 20 * 4 = 80자리로 한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "지역화폐(모바일)" "제로페이" "네이버페이" "지역화폐(카드), 제로페이"

  content :
  (필드명 설명)
    장소 소개/설명
  (데이터 타입 설명) 
    text DEFAULT NULL
    설명필드라서 길기 때문에 text 타입으로 설계한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "세상을 봄처럼 늘 희망 있게 가꾸고 싶은 마음을 담은 이름입니다" 
    "32년을 한결같이 연구하며 성실히 진료하는 남산동물병원입니다. 최신기기도입으로 더욱 더 공부하고 발전하여 반려동물에 가까이 다가가도록 하겠습니다. \n
    진료시간: 평일 오전9시30분~오후7시30분 \n
    토요일 오전9시30분~오후6시00분 \n
    일요일,공휴일은 휴진합니다. ^"
    "봉은사가 위치하고 있어 불교 관련 체험행사가 풍부하며 대방광불화엄경(大方廣佛華嚴經) 수소연의 초판," \n
    "秋史 金正喜가 만년에 쓴 "板殿" 현판과 선불당이 문화재로 지정되어 있는 사적공원이다."

  information_use :
  (필드명 설명)
    부가 이용정보
  (데이터 타입 설명) 
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "주차,발렛파킹,예약,무선 인터넷,반려동물 동반" 
    "주차,예약,무선 인터넷,반려동물 동반,남/녀 화장실 구분" 
    "모든견종·애견동반·고양이"
    "펫티켓을 꼭 지켜주세요!" \n
    "" \n
    "업소의 사정으로 반려동물 동반 여부, 가격, 시설물의 정보가 예고없이 변경될 수 있습니다." \n
    "방문 전에 전화문의 해주세요."

  homepage_url :
  (필드명 설명)
    장소에 대한 홈페이지 주소를 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "http://24onamc.com" 
    "http://www.pet7582.co.kr/" 

  blog_url :
  (필드명 설명)
    장소에 대한 홈페이지 주소를 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "https://blog.naver.com/byejoon22" 
    "https://blog.naver.com/smart7582" 

  instagram_url :
  (필드명 설명)
    장소에 대한 인스타그램 주소를 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "https://www.instagram.com/5417515wr/" 
    "https://www.instagram.com/central_a.m.c/" 

  facebook_url :
  (필드명 설명)
    장소에 대한 페이스북 주소를 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "https://www.facebook.com/cwamc" 

  youtube_url :
  (필드명 설명)
    장소에 대한 유튜브 주소
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "https://www.youtube.com/c/예은동물병원" 

  hashtag :
  (필드명 설명)
    장소에 대한 해시태그
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "#슬개골탈구 #수술전문동물병원 #강아지건강검진 #강아지십자인대" 
    "#강아지아토피 #강아지피부과 #피부전문동물병원 #피부동물병원 #강아지알러지" 

  business_gubun :
  (필드명 설명)
    장소 구분
    장소가 어떤 장소인가에 대한 구분을 나타낸다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "병원" "약국" "미용" "용품매장" "산책" "카페" "호텔"

  latitude :
  (필드명 설명)
    위도
  (DB 입력데이터 예제)     
    double 형태의 숫자값이다.
    37.420125 37.51060190000046 37.49238799999997

  longitude :
  (필드명 설명)
    경도
  (DB 입력데이터 예제)     
    double 형태의 숫자값이다.
    127.126665 126.97432350097529 126.99013100097879

  //----- reserved field ---------------------------------------
  summary :
  (필드명 설명)
    장소 요약
    장소 상세 페이지를 위해서 관리자에서 직접 입력하도록 한다.
    크롤링 데이타에는 없는 필드이다.
    기획서 "펫미 v3.0_Front_APP_v0.3.8_20230322.pptx"의 61 페이지를 참조하라.
    따라서, 이 필드는 tb_crawling_naver_map테이블에는 필요없는 reserved 필드이다.
    즉, tb_place 테이블에만 필요한 필드이다.
  (DB 입력데이터 예제)     
    문자열 형태의 텍스트이다.
    "24시간 야간응급실 운영\n
     반려동물 건강검진 클리닉\n
     안과/치과 클리닉\n
     정형외과 클리닉\n
     한방 운동 재활 치료 클리닉"

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_crawling_dogpalza : 네이버 카페 강사모에서 크롤링한 데이터가 저장되는 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_crawling_dogpalza :
  (테이블명 설명) 
    네이버 카페 강사모에서 크롤링한 데이터가 저장되는 테이블
    URL은 다음과 같다. 
    https://cafe.naver.com/dogpalza  >> 좌측 메뉴 >> 정모/번개 단체사진 밑에 >> [질문방]종합 Q&A
    위의 게시판안의 글들을 참조하여 그 내용을 모두 끌어온다.

    < 크롤링하는 데이타들 >
    말머리 제목 회원명 글쓴날짜 사진 글 댓글 대댓글 댓글 이미지 까지 크롤링한다.
    < 특이사항 >
    아래처럼 대댓글은 앞에 댓글 쓴 사람을 붙이고 내용을 적는다.
    (댓글 depth1)
    베코벤 <<-- "댓글 작성자"
      여자라면 더 쉽지 않을거 같네요
      (댓글 depth2) 
      SRN <<-- "댓글 작성자"
        댓글 감사합니다.
        (댓글 depth3)       
        베코벤  <<-- "댓글 작성자"
          SRN <<-- "댓글 작성자를 나타내는 키워드를 붙인다." 크게 효과 없을거 같아요
          (댓글 depth4) 
          SRN <<-- "댓글 작성자"
            베코벤 <<-- "댓글 작성자를 나타내는 키워드를 붙인다." 산책을 다녀야 싶더라구요
    계층형 게시판의 구조에 대해서는 
      https://gangnam-americano.tistory.com/25
    를 참조하라.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  category :
  (필드명 설명)
    글머리/말머리
    미리 정해진 키워드 카테고리이다. 
    글머리/말머리(bullet_point)로 사용될 수도 있다.
    "[일반 문의] 곰팡이성 피부병인데 산책모임 나가시는 분들 계신가요?"
    와 같이 웹페이지에서 표시한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "훈련|교정" "의료|치료" "사료|간식" "미용|코디" "상품|용품"
    "유기|분식" "장례|추모" "애견스포츠" "일반 문의"

  title :
  (필드명 설명)
    글제목
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "토모조 사료를 쓰시는 분들 보관 어떻게 하시나요?" 
    "강아지설사유산균 다 똑같나요?" 
    "벚꽃길 산책 괜찮나요??"

  content :
  (필드명 설명)
    커뮤니티 게시판의 게시글에 대한 내용을 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "강아지가 오리젠 제일 잘 먹길래 시켜주려고 찾아보니 6키로 삼만원대 판매하는 제품이 있네요...? 유통기한이 9월까지\n
    라 해도 가격이 너~무 싸서 뭔가 의심(?)스러운데 정품 맞겠죠???" 

  writer :
  (필드명 설명)
    커뮤니티 게시판 게시글 작성자
    글쓴이를 말한다.
    이 필드를 두는 이유는 tb_user_id 로 join 하지 않고, 바로 writer만 가지고 사용하기 위함이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "디로딩" "유월이동생레오" "모에모에뀽" "삐쑝구름"

  write_time :
  (테이블명 설명) 
    글쓴 시간
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  read_count :
  (필드명 설명)
    읽은 조회수
    Q&A를 사용자가 클릭하면 조회수가 1개씩 올라간다.
  (DB 입력데이터 예제) 
    정수형 숫자이다.
    349

  parent_id :
  (필드명 설명)
    부모 게시글 아이디
    답변형 게시판의 부모글 아이디이다.
    그런데, parent_id = id 와 같으면 최상단의 글이라는 것이다.
    즉, 댓글이 아닌것이다.
    그리고, parent_id != id 이면 댓글이라는 얘기이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  order :
  (필드명 설명)
    댓글 순서이다.
    1이면 첫번째 댓글, 2면 두번째 댓글 이런순이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  0 과 1만 있다.
    0 1 

  depth :
  (필드명 설명)
    댓글 레벨/깊이
    답변형 게시판의 부모글 아이디이다.
    즉, 부모글에 대한 댓글이라는 얘기이다.
  (데이터 타입 설명) 
    tinyint(2) unsigned DEFAULT '0'
    성능을 위해서 depth는 1 단계로만 제한하도록 한다.
    네이버도 1단계까지만 한다.
    즉, 0, 1 값만 있는 것이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  0 과 1만 있다.
    0 1 

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_bulletin_board : tb_crawling_dogpalza 테이블의 clone 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_bulletin_board :
  (테이블명 설명) 
    펫연구소 Q&A 게시판을 표현하는 테이블이다.
    tb_crawling_dogpalza 테이블과 구조가 같다.
    네이버 카페 강사모에서 크롤링한 데이터가 저장되는 테이블인 tb_crawling_dogpalza 테이블에서
    데이터를 그대로 가져온다. 
    이렇게 하는 이중으로 테이블을 설계한 이유는, 강사모데이터는 크롤링업체에서 받아서 배치로 붓는 것이고, 여기에서 clone해서 가져가는 것이 더 효율적인 구조라서 이렇게 만들었다.
    이렇게 가져온 데이터는 펫연구소 Q&A에서 보여준다.
    계층형 게시판의 구조에 대해서는 
      https://gangnam-americano.tistory.com/25
    를 참조하라.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  tb_user_id :
  (테이블명 설명) 
    tb_user 테이블의 id를 나타낸다.
    크롤링 id 일수 있기 때문에, NULL 일 수도 있다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  category :
  (필드명 설명)
    글머리/말머리
    미리 정해진 키워드 카테고리이다. 
    글머리/말머리(bullet_point)로 사용될 수도 있다.
    "[일반 문의] 곰팡이성 피부병인데 산책모임 나가시는 분들 계신가요?"
    와 같이 웹페이지에서 표시한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "훈련|교정" "의료|치료" "사료|간식" "미용|코디" "상품|용품"
    "유기|분식" "장례|추모" "애견스포츠" "일반 문의"

  title :
  (필드명 설명)
    글제목
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "토모조 사료를 쓰시는 분들 보관 어떻게 하시나요?" 
    "강아지설사유산균 다 똑같나요?" 
    "벚꽃길 산책 괜찮나요??"

  content :
  (필드명 설명)
    커뮤니티 게시판의 게시글에 대한 내용을 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "강아지가 오리젠 제일 잘 먹길래 시켜주려고 찾아보니 6키로 삼만원대 판매하는 제품이 있네요...? 유통기한이 9월까지\n
    라 해도 가격이 너~무 싸서 뭔가 의심(?)스러운데 정품 맞겠죠???" 

  writer :
  (필드명 설명)
    커뮤니티 게시판 게시글 작성자
    글쓴이를 말한다.
    이 필드를 두는 이유는 tb_user_id 로 join 하지 않고, 바로 writer만 가지고 사용하기 위함이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "디로딩" "유월이동생레오" "모에모에뀽" "삐쑝구름"

  write_time :
  (테이블명 설명) 
    글쓴 시간
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  read_count :
  (필드명 설명)
    읽은 조회수
    Q&A를 사용자가 클릭하면 조회수가 1개씩 올라간다.
  (DB 입력데이터 예제) 
    정수형 숫자이다.
    349

  parent_id :
  (필드명 설명)
    부모 게시글 아이디
    답변형 게시판의 부모글 아이디이다.
    그런데, parent_id = id 와 같으면 최상단의 글이라는 것이다.
    즉, 댓글이 아닌것이다.
    그리고, parent_id != id 이면 댓글이라는 얘기이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  order :
  (필드명 설명)
    댓글 순서이다.
    1이면 첫번째 댓글, 2면 두번째 댓글 이런순이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  0 과 1만 있다.
    0 1 

  depth :
  (필드명 설명)
    댓글 레벨/깊이
    답변형 게시판의 부모글 아이디이다.
    즉, 부모글에 대한 댓글이라는 얘기이다.
  (데이터 타입 설명) 
    tinyint(2) unsigned DEFAULT '0'
    성능을 위해서 depth는 1 단계로만 제한하도록 한다.
    네이버도 1단계까지만 한다.
    즉, 0, 1 값만 있는 것이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  0 과 1만 있다.
    0 1 

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_place : 장소 상세 정보 테이블
//------------------------------------------------------------
{
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
    PRIMARY KEY (`id`),
    KEY `index_tb_place_name` (`name`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='장소 정보 테이블';
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_place : 
  (테이블명 설명) 
    장소 상세 정보 테이블를 나타내는 테이블이다.
    tb_crawling_naver_map 과 동일한 구조를 갖는다.
    이렇게 하는 이유는 tb_crawling_naver_map 테이블은 크롤링 데이타(엑셀)을 배치로 입력받는 테이블이다.
    크롤링 데이터 insert 배치 job이 끝난 후 tb_place로 데이타를 다시 끌고온다.
    즉, 레이버를 하나 더 두어서 데이터의 무결성과 운영의 편리성을 도모하고자 한다.
    향후, 필요하지 않을 수도 있다.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  name :
  (필드명 설명)
    해당 장소명/장소이름을 나타낸다.
    인코딩에 따라서, utf = 3바이트, utf8mb4 = 4바이트가 한 문자이다.
  (데이터 타입 설명) 
    이 필드는 varchar(1024) NOT NULL 이다.
    이 테이블의 나머지 필드들은 네이버에서 크롤링한 데이터이기 때문에 장소에 따라서 없는 데이타가 있기 때문에, 모두 DEFAULT NULL 로 되어야 한다. 단, 장소명은 무조건 있어야 하므로, NULL이 되면 안된다. 즉, name 필드는 NOT NULL 이어야 한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "봉은공원" "독립문동물병원" "우리동물병원"

  ranking : 
  (필드명 설명)
    순위/등급/서열/평점 등을 나타낸다.
    참조 사이트로 "반려생활" "화해" 등의 App에서 랭킹을 참조하면 된다.
    < 알고리즘 >
    1. 랭킹 디비 입력시간 :
    금일 24시 59분 59초를 넘어서, 다음날 0시 0초에 랭킹이 입력되게 된다.
    전주/전달/전일 기준으로 랭킹으로 소팅한다.
    예를 들어, 2023-03-22 의 월간 랭킹은 2023-02-01 ~ 2023-02-28 까지의 합의 평균이다.
    따라서 2023년 1월 이전의 랭킹 데이타는 필요가 없지만, 일단 삭제하지 말고 보관하도록 하자.
    왜냐하면 나중에 필요에 의해서 그래프 같은 것을 그릴수도 있기 때문이다.
    단 조회 속도를 원활히 하도록 하기 위해서, backup 테이블로 옮기는 것이 좋을 듯 하다.
    2. 랭킹 표현방법 :
    웹에서 별로 표시된다. 별아이콘에 노랗게 표시되고, 반쪽만 칠해지게 되면 1점이다.
    네이버는 5점 만점에 3가지로 표시한다. 즉, 4.38/5 와 같이 표현한다.
    평점은 0도 있는가? 0은 없다. 
    기본으로 2점은 준다. 
    2 ~ 10 점까지 랭킹을 매긴다.
    2점이 디폴트이고 5랭킹이 있는데 2씩 더한다. 
    내부적으로는 3자리 이상으로 랭킹을 매기고, 웹에서 보여줄때는 2자리로 보여주도록 하자.
  (데이터 타입 설명) 
    원래는, 실수형 데이터 타입으로 설계해야 하지만,
    코딩의 번거로움을 피하기 위해서 varchar로 표현한다.
    성능이 떨어지면, 다시 실수형으로 바꿀 필요가 있다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "4.58"  "6.97"  "3. 53" 

  blog_review_count :   
  (필드명 설명)
    블로그 리뷰수
    자료형은 int(11) DEFAULT '0' 으로 표현한다.
    리뷰수는 아무리 많아도 10억단위가 넘지 않을 것으로 예상되기 때문에(단, 유튜브나 아마존같은 대형 서비스로 가면 넘을 것이다) int 형으로 설계한다.
    또, int unsigned일 경우에 0 ~ 4294967295까지 표시할 수 있다.
    바이트를 절약하기 위해서, varchar로 설계하지 않았다.
  (DB 입력데이터 예제) 
    정수형 숫자이다.
    349

  visitor_review_count :
  (필드명 설명)
    방문자 리뷰수
    자료형은 int(11) DEFAULT '0' 으로 표현한다.
    리뷰수는 아무리 많아도 10억단위가 넘지 않을 것으로 예상되기 때문에(단, 유튜브나 아마존같은 대형 서비스로 가면 넘을 것이다) int 형으로 설계한다.
    또, int unsigned일 경우에 0 ~ 4294967295까지 표시할 수 있다.
    바이트를 절약하기 위해서, varchar로 설계하지 않았다.
  (DB 입력데이터 예제) 
    정수형 숫자이다.  
    159
    
  street_name_address :
  (필드명 설명)
    도로명 주소
    자료형은 varchar(1024) DEFAULT NULL 으로 표현한다. 즉, name 필드와 같이 넉넉하게 잡았다.
  (DB 입력데이터 예제) 
    가짜 주소가 들어갈 수도 있다.
    산, 공원 등은 주소가 없다.
    즉, 네이버에서는 특정 장소에(산이나 바다, 하천, 공원 등)는 주소가 존재하지 않으면, 인접한 다른 유명한 장소로(파출소나 건물 등) 대신 주소가 들어가는 경우도 있다.
    아래는 예는 봉은공원에 대한 주소이다. 
    원래 봉은공원에 대한 우체국 주소는 존재하지 않는다???
    웹상에서 주소는 도로명과 지번을 두줄로 표현하도록 한다. 
    문자열 형태의 텍스트이다.
    "서울 강남구 봉은사로81길 16" "서울 마포구 마포대로11길 35"
    "서울 강남구 삼성동 74-13 건너편"

  lot_number_address :
  (필드명 설명)
    지번 주소
    자료형은 varchar(1024) DEFAULT NULL 으로 표현한다. 즉, name 필드와 같이 넉넉하게 잡았다.
  (DB 입력데이터 예제) 
    가짜 주소가 들어갈 수도 있다.
    즉, 네이버에서는 특정 장소에(산이나 바다, 하천, 공원 등)는 주소가 존재하지 않으면, 인접한 다른 유명한 장소로(파출소나 건물 등) 대신 주소가 들어가는 경우도 있다.
    아래는 예는 봉은공원에 대한 주소이다. 
    원래 봉은공원에 대한 우체국 주소는 존재하지 않는다???
    웹상에서 주소는 도로명과 지번을 두줄로 표현하도록 한다. 
    문자열 형태의 텍스트이다.
    "서울 강남구 삼성동 74-13 건너편" "공덕동 222-2"

  zipcode :
  (필드명 설명)
    우편번호
    자료형은 varchar(20) DEFAULT NULL 으로 표현한다. 
    고정 5자리 형태이다. 하지만, utf8mb4를 고려해서 혹시모르기 때문에 곱하기 4해서 20자리로 잡았다.
    향후 쿼리 속도를 살펴봐서 다시 5자리로 조정될 수 있다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "04501" "04558" "06086"

  phone :
  (필드명 설명)
    전화번호(대표)
    자료형은 varchar(20) DEFAULT NULL 으로 표현한다. 
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "02-735-7530" "010-5813-2657"

  payment_method :
  (필드명 설명)
    결제 수단
    카드 등 일반적인 결제 수단을 제외하고 특수하게 통용되는 결제 수단을 나타내는 필드이다.
    common_code로 만들어야 하는 부분이다.
  (데이터 타입 설명) 
    varchar(80) DEFAULT NULL
    한글 20자리면 충분하다. utfmb4고려해서 20 * 4 = 80자리로 한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "지역화폐(모바일)" "제로페이" "네이버페이" "지역화폐(카드), 제로페이"

  content :
  (필드명 설명)
    장소 소개/설명
  (데이터 타입 설명) 
    text DEFAULT NULL
    설명필드라서 길기 때문에 text 타입으로 설계한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "세상을 봄처럼 늘 희망 있게 가꾸고 싶은 마음을 담은 이름입니다" 
    "32년을 한결같이 연구하며 성실히 진료하는 남산동물병원입니다. 최신기기도입으로 더욱 더 공부하고 발전하여 반려동물에 가까이 다가가도록 하겠습니다. \n
    진료시간: 평일 오전9시30분~오후7시30분 \n
    토요일 오전9시30분~오후6시00분 \n
    일요일,공휴일은 휴진합니다. ^"
    "봉은사가 위치하고 있어 불교 관련 체험행사가 풍부하며 대방광불화엄경(大方廣佛華嚴經) 수소연의 초판," \n
    "秋史 金正喜가 만년에 쓴 "板殿" 현판과 선불당이 문화재로 지정되어 있는 사적공원이다."

  information_use :
  (필드명 설명)
    부가 이용정보
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "주차,발렛파킹,예약,무선 인터넷,반려동물 동반" 
    "주차,예약,무선 인터넷,반려동물 동반,남/녀 화장실 구분" 
    "모든견종·애견동반·고양이"
    "펫티켓을 꼭 지켜주세요!" \n
    "" \n
    "업소의 사정으로 반려동물 동반 여부, 가격, 시설물의 정보가 예고없이 변경될 수 있습니다." \n
    "방문 전에 전화문의 해주세요."

  homepage_url :
  (필드명 설명)
    장소에 대한 홈페이지 주소를 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "http://24onamc.com" 
    "http://www.pet7582.co.kr/" 

  blog_url :
  (필드명 설명)
    장소에 대한 홈페이지 주소를 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "https://blog.naver.com/byejoon22" 
    "https://blog.naver.com/smart7582" 

  instagram_url :
  (필드명 설명)
    장소에 대한 인스타그램 주소를 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "https://www.instagram.com/5417515wr/" 
    "https://www.instagram.com/central_a.m.c/" 

  facebook_url :
  (필드명 설명)
    장소에 대한 페이스북 주소를 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "https://www.facebook.com/cwamc" 

  youtube_url :
  (필드명 설명)
    장소에 대한 유튜브 주소
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "https://www.youtube.com/c/예은동물병원" 

  hashtag :
  (필드명 설명)
    장소에 대한 해시태그
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "#슬개골탈구 #수술전문동물병원 #강아지건강검진 #강아지십자인대" 
    "#강아지아토피 #강아지피부과 #피부전문동물병원 #피부동물병원 #강아지알러지" 

  business_gubun :
  (필드명 설명)
    장소 구분
    장소가 어떤 장소인가에 대한 구분을 나타낸다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "병원" "약국" "미용" "용품매장" "산책" "카페" "호텔" "기타"

  latitude :
  (필드명 설명)
    위도
  (DB 입력데이터 예제)     
    double 형태의 숫자값이다.
    37.420125 37.51060190000046 37.49238799999997

  longitude :
  (필드명 설명)
    경도
  (DB 입력데이터 예제)     
    double 형태의 숫자값이다.
    127.126665 126.97432350097529 126.99013100097879

  place_summary :
  (필드명 설명)
    장소 요약
    장소 상세 페이지를 위해서 관리자에서 직접 입력하도록 한다.
    크롤링 데이타에는 없는 필드이다.
    기획서 "펫미 v3.0_Front_APP_v0.3.8_20230322.pptx"의 61 페이지를 참조하라.
  (DB 입력데이터 예제)     
    문자열 형태의 텍스트이다.
    "24시간 야간응급실 운영\n
     반려동물 건강검진 클리닉\n
     안과/치과 클리닉\n
     정형외과 클리닉\n
     한방 운동 재활 치료 클리닉"

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조

  //----- 향후 설계해야 될지도 모르는 필드 ---------------------
  `place_status` varchar(20) DEFAULT 'ss00' COMMENT '장소 상태',
  `ceo_name` varchar(20) DEFAULT NULL COMMENT '대표자이름',
  `company_registration_number` varchar(20) NOT NULL COMMENT '사업자등록번호',
  `bank_name` varchar(20) DEFAULT NULL COMMENT '거래계좌 은행이름',
  `bank_acct_no` varchar(50) DEFAULT NULL COMMENT '거래계좌번호',
  `tb_sub_phone_info_id` varchar(20) DEFAULT NULL COMMENT '부전화번호 아이디(reserved)',
  `premium` enum('N','Y') DEFAULT 'N',
  `biz_asset_id` text,
  `approved_dt` timestamp NULL DEFAULT NULL,
  `alliance` varchar(1) DEFAULT NULL COMMENT '가맹점 여부',
  `holder` varchar(100) DEFAULT NULL,

  company_registration_number : 
    Company Registration Number 사업자등록번호
    향후, 예약이 들어가면 사용될 수 있다.

  tb_sub_phone_info_id : 
    향후를 위한 예약필드이다.
    종합병원인 경우 전화번호가 여러개 비정형으로 있을 수가 있을 것이다.
    따라서, tb_sub_phone_info 테이블을 만들어서 비정형 전화번호 정보를 입력하고 이 테이블의 id와 연결되는 필드이다.

}
//------------------------------------------------------------
// tb_pet_raboratory : 애견에 관한 컨텐츠 정보 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_pet_raboratory : 
  (테이블명 설명) 
    애견에 관한 컨텐츠 정보 테이블
    어바웃펫(어펫) app을 참조하면 된다.
    어펫은 애견에 대한 유튜브 같은 영상과 블로그도 만들 수 있는 기능을 가지고 있다.
    하지만, petme 서비스는 그렇게 할 여력이 없어서,
    마케팅 팀에서 애견에 대한 통이미지 컨텐츠만 제작해서 첫 서비스를 시작하려고 한다.
    마케팅 팀에서 자체적으로 만드는 컨텐트에는
    컨텐츠 썸네일
    제목
    해시태그
    컨텐츠 이미지 (전체가 하나의 통 이미지)
    로 이루어져 있다.
    켄텐츠의 제작자 정보는 필드로 구현할 필요가 없다.
    왜냐하면, 어펫도 자체로 제작해서 올리기 때문이다. 즉, 고객은 유튜브처럼 영상을 올릴 수 없다.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  category :
  (필드명 설명)
    펫연구소 콘텐츠 카테고리
    계속 추가된다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "초보생활" "반려생활" "펫미케어" "행동교정"

  title :
  (필드명 설명)
    펫연구소 콘텐츠 제목
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "강아지와의 첫 만남, 반려견 입양의 모든 것"

  hashtag :
  (필드명 설명)
    펫연구소 콘텐츠 해시태그
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "#리찌 #말티즈 #강남예은동물변원 #예은동물병원 #십자인대파열 #강아지십자인대\n
    #강아지십자인대수술 #십자인대 #퇴행성관절염 #조인트벡스 #pdrn 주사"

  modify_time
  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_event : 이벤트 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_event : 
  (테이블명 설명) 
    이벤트 테이블
    petme3 자체 서비스를 위한 이벤트 정보를 기록하는 테이블이다.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  title :
  (필드명 설명)
    이벤트 제목
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "펫미 웰컴혜택 최대 10,000 포인트 증정"

  writer :
  (필드명 설명)
    이벤트 작성자
    이 필드를 두는 이유는 tb_user_id 로 join 하지 않고, 바로 writer만 가지고 사용하기 위함이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "administrator" "신운정" "재로몬" "별이언니"

  content :
  (필드명 설명)
    이벤트에 대한 상세 내용
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "가입하시면 무조건 포인트를 드립니다." 

  content1 :
  content2 :
  (필드명 설명)
    이벤트에 대한 상세 내용
    여러가지 내용이 있을 수 있기 때문에 reserved 필드이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "가입하시면 무조건 포인트를 드립니다." 

  read_count :
  (필드명 설명)
    이벤트 읽음 조회수
    이벤트를 사용자가 클릭하면 조회수가 1개씩 올라간다.
  (DB 입력데이터 예제) 
    정수형 숫자이다.
    349

  applicant_limit :
  (필드명 설명)
    이벤트 응모자의 최대 수
    응모자 수를 제한한다.
    unlimited 도 가능함
  (DB 입력데이터 예제) 
    정수형 숫자이다.
    349

  applicant_number :
  (필드명 설명)
    현재까지 이벤트에 응모한 인원수
    이벤트 내용에서 응모 신청을 했을 때, 갯수가 1개씩 올라간다.
  (DB 입력데이터 예제) 
    정수형 숫자이다.
    349

  link_url :
  (필드명 설명)
    이벤트 연결된 out link(외부링크)에 대한 URL을 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "https://blog.naver.com/byejoon22" 
    "https://blog.naver.com/smart7582" 

  html_yn :
  (필드명 설명)
    html 사용 여부
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "y" "n"

  event_start_date :
  (테이블명 설명)
    이벤트 시작일
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  event_end_date :
  (테이블명 설명)
    이벤트 종료일
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_point_use_history : 포인트 정보 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_point_history : 
  (테이블명 설명) 
    포인트 정보 테이블
    포인트를 현금 + 가상사이버머니 라고 생각하면 된다.
    따라서, 변환 비율은 1:1이 아니다.
    또한, 포인트 정책은 반드시 고객 이용약관에 알기 쉽게 명시해야 한다.
    < 기본 개념 >
    빌링=캐쉬=유료충전수단 현금취급. 
    <온라인머니>
    사이버머니(콩/코인)
    <마케팅>
    포인트=무료충전수단, 할인혜택 
    마일리지=적립개념
      이벤트 상품 및 세일, 행사제품은 마일리지에서 제외
      하부에 스탬프/코인 등이 자리하고 있다.
    쿠폰/기프티콘(모바일선물쿠폰)=할인혜택 적용
    <전환>
    마일리지 > 포인트
    포인트 > 사이버머니
    유료충전 > 사이버머니
  -- -----------------------------------------------------------

  id : 공통설명 참조

  login_id :
  (필드명 설명)
    사용자(회원) 아이디
    자동증가값 id가 아닌 사이트 로그인 아이디를 의미한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "supercob" "i48korea" "geoTest" 

  point_gubun :
  (필드명 설명)
    포인트 구분 형태
    get : 포인트를 취득함
    use : 포인트를 사용함
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "get" "used"

  billing_method : 
  (테이블명 설명) 
    빌링형태
    전자결제 빌링(사용자의 결제에 의해서 이루어짐)에 사용된 수단을 의미한다.
    즉, 온라인 상에서 발생해서 얻어진 가상의 사이버머니(포인트, 쿠폰) 등의 결재수단이 아닌 것이다. 
    set('결제안함','핸드폰결제','ARS결제','전화결제','ISP_ID결제','무통장입금','카드결제','기타','취소') 
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "결제안함" "핸드폰결제" "ARS결제" "전화결제" 
    "ISP_ID결제" "무통장입금" "카드결제" "기타" "취소"

  billing_status : 
  (테이블명 설명) 
    오프라인 결제시 빌링의 현재 상태를 나타냄
    set('결재대기','결재완료','결재취소','기타이유')
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "결재대기" "결재완료" "결재취소" "기타이유"

  use_type : 
  (테이블명 설명) 
    포인트 이용 형태
    온라인에서 포인트를 취득하거나 사용한 형태를 나타낸다.
    set('사이버머니전환','포인트충전','GS샵전환','추천인등록에의해서','추천인최초결재','선물받음','클럽사용자에게분배')
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "사이버머니전환" "포인트충전" "GS샵전환" "추천인등록에의해서" 
    "추천인최초결재" "선물받음" "클럽사용자에게분배"

  used_point : 
  (테이블명 설명) 
    이용된 포인트
    온라인에서 포인트를 취득하거나 사용한 양을 나타낸다.
    단위는 원이 아니고, 적절한 비율로 변환된 양이니 주의하기 바람
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    1800 4700 28000 

  modify_time
  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_gifticon_history : 기프티콘 정보 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_gifticon_history : 
  (테이블명 설명) 
    기프티콘 정보 테이블
    기프티콘은 제휴사 api 연동을 통해서 이루어진다.
    기프티콘 petme3 1차 기획에는 사용하지 않는다. 
  -- -----------------------------------------------------------

  id : 공통설명 참조

  login_id :
  (필드명 설명)
    사용자(회원) 아이디
    자동증가값 id가 아닌 사이트 로그인 아이디를 의미한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "supercob" "i48korea" "geoTest" 

  gifticon_code :
  (필드명 설명)
    기프티콘 구분 형태
    기프티콘은 제휴사 api 연동을 통해서 이루어진다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "sTHq-3AVg-4g00-0004"

  used_point : 
  (테이블명 설명) 
    기프티콘에 이용된 포인트
    온라인에서 포인트를 취득하거나 사용한 양을 나타낸다.
    단위는 원이 아니고, 적절한 비율로 변환된 양이니 주의하기 바람
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    1800 4700 28000 

  get_date :
  (테이블명 설명)
    기프티콘 취득일
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  used_date :
  (테이블명 설명) 
    기프티콘 사용일
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  use_type : 
  (테이블명 설명) 
    기프티콘 이용 형태
    온라인에서 포인트를 취득하거나 사용한 형태를 나타낸다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "used-제휴상품할인" "used-리뷰작성" "used-펫연구소Q&A" 
}
//------------------------------------------------------------
// tb_coupon_history : 쿠폰 정보 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_coupon_history : 
  (테이블명 설명) 
    쿠폰 정보 테이블
    petme3 서비스 자체적으로 발행하는 쿠폰이다.
    쿠폰은 petme3 1차 기획에는 사용하지 않는다. 
  -- -----------------------------------------------------------

  id : 공통설명 참조

  login_id :
  (필드명 설명)
    사용자(회원) 아이디
    자동증가값 id가 아닌 사이트 로그인 아이디를 의미한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "supercob" "i48korea" "geoTest" 

  coupon_code :
  (필드명 설명)
    쿠폰 구분 형태
    https://github.com/jiyoon1156/Coupon
    위를 참조해서 쿠폰코드를 발생시키자.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "sTHq-3AVg-4g00-0004"

  used_point : 
  (테이블명 설명) 
    이용된 포인트
    온라인에서 포인트를 취득하거나 사용한 양을 나타낸다.
    단위는 원이 아니고, 적절한 비율로 변환된 양이니 주의하기 바람
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    1800 4700 28000 

  get_date :
  (테이블명 설명)
    쿠폰 취득일
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  used_date :
  (테이블명 설명) 
    쿠폰 사용일
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  use_type : 
  (테이블명 설명) 
    쿠폰 이용 형태
    온라인에서 포인트를 취득하거나 사용한 형태를 나타낸다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "used-제휴상품할인" "used-리뷰작성" "used-펫연구소Q&A" 
}
//------------------------------------------------------------
// tb_admin_user : 관리자 정보 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_admin_user : 
  (테이블명 설명) 
    관리자 정보 테이블
  -- -----------------------------------------------------------

  id : 공통설명 참조

  login_id :
  (필드명 설명)
    관리자 접속 아이디
    자동증가값 id가 아닌 사이트 로그인 아이디를 의미한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "supercob" "i48korea" "geoTest" 

  user_name :
  (필드명 설명)
    관리자명
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "홍길도" "이순신" "박찬호" 

  password :
  (필드명 설명)
    로그인 패스워드
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "qwer@1234" "k2017!@" 

  email :
  (필드명 설명)
    사용자 이메일 주소
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "allsam49@gmail.com" "k2017@naver.com" 

  phone :
  (필드명 설명)
    전화번호(대표)
    자료형은 varchar(20) DEFAULT NULL 으로 표현한다. 
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "02-735-7530" "010-5813-2657"

  resident_registration_number :
  (필드명 설명)
    주민등록번호
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "820701-2409184" "7810231451578" 

  street_name_address :
  (필드명 설명)
    회원 도로명 주소
  (DB 입력데이터 예제) 
    "서울 강남구 봉은사로81길 16" "서울 마포구 마포대로11길 35"
    "서울 강남구 삼성동 74-13 건너편"

  lot_number_address :
  (필드명 설명)
    회원 지번 주소
  (DB 입력데이터 예제) 
    "서울 강남구 삼성동 74-13 건너편" "공덕동 222-2"

  gender :
  (필드명 설명)
    회원 성별
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    "남" "여" "M" "F" "남자" "여자"

  department :
  (필드명 설명)
    부서명
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    "개발본부" "디자인본부" "마케팅팀" "경영지원실"

  position :
  (필드명 설명)
    직위
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    "대표" "이사" "이사대우" "매니저"

  last_login :
  (테이블명 설명) 
    최근 로그인 시간
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  login_times :
  (테이블명 설명) 
    로그인 횟수
    총 몇번을 지금까지 로그인 했는지를 센다.
    통계를 위해서 만든 필드인데 사용하지 않을 수도 있다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    3 547 2809

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조

  //----- 향후 설계해야 될지도 모르는 필드 ---------------------
  `cloud_service_car_number` varchar(20) DEFAULT NULL COMMENT '차량번호',
  `active` tinyint DEFAULT 1 COMMENT '상태',
  `department` varchar(128) DEFAULT NULL COMMENT '부서명',
  `position` varchar(128) DEFAULT NULL COMMENT '직위',

  쇼핑몰 찜 또는 장바구니 기능 처럼 DB로 안 만들고, 
  세션으로 만들거나
  임시 테이블을 만들고 일정시간(일주일 등)이 지나면 자동 삭제되게 하는 방법도 있을 것 같다.

}  
//------------------------------------------------------------
// tb_user : 사용자 정보 테이블
//------------------------------------------------------------
{
  DROP TABLE IF EXISTS `tb_user`;
  CREATE TABLE `tb_user` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `login_id` varchar(256) NOT NULL COMMENT '사용자(회원) 아이디',
    `user_name` varchar(256) DEFAULT NULL COMMENT '사용자(회원) 이름',
    `password` varchar(64) DEFAULT NULL COMMENT '로그인 패스워드',
    `email` varchar(512) DEFAULT NULL COMMENT '사용자 이메일',
    `phone` varchar(20) DEFAULT NULL COMMENT '전화번호',
    `birthday` varchar(16) DEFAULT NULL COMMENT '생일',
    `age_range` varchar(16) DEFAULT NULL COMMENT '연령대',
    `resident_registration_number` varchar(18) DEFAULT NULL COMMENT '주민등록번호',
    `street_name_address` varchar(1024) DEFAULT NULL COMMENT '도로명 주소',
    `lot_number_address` varchar(1024) DEFAULT NULL COMMENT '지번 주소',
    `gender` varchar(16) DEFAULT NULL COMMENT '성별',
    `receive_information_yn` varchar(1) DEFAULT "0" COMMENT '정보수신여부',
    `receive_event_yn` varchar(1) DEFAULT "0" COMMENT '이벤트수신여부',
    `access_token` varchar(4) DEFAULT "0" COMMENT '2차 oAuth 엑세스 토큰',
    `oauth_type` varchar(16) DEFAULT NULL COMMENT '2차 인증 타입',
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_user : 
  (테이블명 설명) 
    사용자 정보 테이블
  -- -----------------------------------------------------------

  id : 공통설명 참조

  login_id :
  (필드명 설명)
    사용자(회원) 아이디
    자동증가값 id가 아닌 사이트 로그인 아이디를 의미한다.
    < 카카오 2차인증 >
      카카오 2차 인증인 경우 id만 필수로 넘어오고, 
      사용자 email 정보는 선택적이기 때문에 없을 수도 있다.
      따라서, id값을 이 login_id 필드에 입력해야 하는 데 다음과 같이 하도록 한다.
      id는 10자리 숫자 2745303667와 같이 되어있다.
      id앞에 kakao_를 붙여서 즉, kakao_2745303667 와 같이 만들어서 login_id 필드에 저장하고 login_id를 사용하도록 한다.    

  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "supercob" "i48korea" "geoTest" 

  user_name :
  (필드명 설명)
    사용자(회원) 이름
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "홍길도" "이순신" "박찬호" 

  password :
  (필드명 설명)
    로그인 패스워드
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "qwer@1234" "k2017!@" 

  email :
  (필드명 설명)
    사용자 이메일 주소
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "allsam49@gmail.com" "k2017@naver.com" 

  phone :
  (필드명 설명)
    전화번호(대표)
    자료형은 varchar(20) DEFAULT NULL 으로 표현한다. 
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "02-735-7530" "010-5813-2657"

  birthday :
  (필드명 설명)
    사용자 생일
    다양한 형태로 저장가능하다.
    < 카카오 2차인증 >
      카카오 개인정보는 월일만 존재한다. 
      따라서 1207과 같은 형태로 이 필드에 저장된다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "1127" "681127" "2009-09-04" "2001년 4월 18일" "1975/02/23"

  age_range :
  (필드명 설명)
    사용자 연령대
    다양한 형태로 저장가능하다.
    < 카카오 2차인증 >
      카카오 개인정보는 "50~59" 와 같이 넘어와서 이 필드에 저장된다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "50~59" "50대" "오십대초반" "50대초반" "30대 중반"

  resident_registration_number :
  (필드명 설명)
    주민등록번호
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "820701-2409184" "7810231451578" 

  street_name_address :
  (필드명 설명)
    회원 도로명 주소
  (DB 입력데이터 예제) 
    "서울 강남구 봉은사로81길 16" "서울 마포구 마포대로11길 35"
    "서울 강남구 삼성동 74-13 건너편"

  lot_number_address :
  (필드명 설명)
    회원 지번 주소
  (DB 입력데이터 예제) 
    "서울 강남구 삼성동 74-13 건너편" "공덕동 222-2"

  gender :
  (필드명 설명)
    회원 성별
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    "남" "여" "M" "F" "남자" "여자"

  receive_information_yn :
  receive_event_yn :
  (필드명 설명)
    정보수신여부
    이벤트수신여부
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "y" "n"

  access_token :
  (필드명 설명)
    2차 oAuth 엑세스 토큰
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "AQA8EgaNIWAGZjyb4eJP0kQEZSnkaXElkUPcHz7gosO54nynKI7VGi3L0ji1EcfFy_MvTKw-n1uithNcHIuEak9lD43wJ9-m87Vf5JH1y6BmO2NIKgrPZdcFhD_DQs6V0DjWW_1fSP3jcOnh6Zxwwg19mnM1VmJxi_FSWFHhuhdAwvbDWOpwOspFFBOmr6dbsinkQJOncfENq3z5-F2xEP4eVoQzkb1leA43BgCFAvNG64t90sQMQtIxOM__2QdeFEzUmnHsUuXcZ0apCL-VikxF0RbZvjdnDEkJAL60OcWnUf8NIhAbbIUzFGOB3ZvsgqCz0XAyolWlaD0v0zPGMoGZ#_=_"

  oauth_type :
  (필드명 설명)
    2차 인증 타입
    간편로그인, 간편인증, OAuth 인증, 2차 인증을 위해서 존재하는 필드이다.
    구글(안드로이드)==페이스북, 네이버, 카카오 == 애플, 기타 : twitter naver daum
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "google" "facebook" "naver" "kakao" "twitter"

  pet_type :
  (필드명 설명)
    애완동물 타입
    처음 app을 깔고 app에 대한 튜터리얼 설명의 맨끝 부분에서 기르는 애완동물 형태를 입력받게 할 예정이다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "개" "고양이"

  current_point :
  (테이블명 설명) 
    현재 포인트
    join을 줄이기 위해서 중복이 되더라도 포인트를 보관한다.
    단위는 실제 돈 단위의 1.5배 정도 등의 배율을 가지고 있다.
    petme 사이트 운영 정책에 의해서 달라진다. 
    관리자에서 셋팅할 수 있도록 한다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    5400 6900 17800

  last_login :
  (테이블명 설명) 
    최근 로그인 시간
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  login_times :
  (테이블명 설명) 
    로그인 횟수
    총 몇번을 지금까지 로그인 했는지를 센다.
    통계를 위해서 만든 필드인데 사용하지 않을 수도 있다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    3 547 2809

  withdrawal_date :
  (테이블명 설명) 
    탈퇴일
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  withdrawal_cause :
  (테이블명 설명) 
    탈퇴이유
    회원이 탈퇴한 이유를 나타낸다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "휴면계정" "사이트 유지보수"

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조

  //----- 향후 설계해야 될지도 모르는 필드 ---------------------
  `cloud_service_car_number` varchar(20) DEFAULT NULL COMMENT '차량번호',
  `active` tinyint DEFAULT 1 COMMENT '상태',
  `department` varchar(128) DEFAULT NULL COMMENT '부서명',
  `position` varchar(128) DEFAULT NULL COMMENT '직위',

  쇼핑몰 찜 또는 장바구니 기능 처럼 DB로 안 만들고, 
  세션으로 만들거나
  임시 테이블을 만들고 일정시간(일주일 등)이 지나면 자동 삭제되게 하는 방법도 있을 것 같다.

  //----- 카카오 kakao 2차인증 ---------------------
  카카오 로그인에서 선택적 동의를 받을 수 있는 사항은 6가지이다.
  닉네임, 프로필 사진, 카카오계정(이메일), 성별, 연령대, 생일
  다음은 넘어오는 실제 json 값이다.
  {
    "id": 2775303665,
    "connected_at": "2023-05-09T02:04:59Z",
    "properties": {
      "nickname": "박형순",
      "profile_image": "http://k.kakaocdn.net/dn/bVjL70/btrYRjOSVqW/Kqv6XzBCUDeNPM35NQD2ik/img_640x640.jpg",
      "thumbnail_image": "http://k.kakaocdn.net/dn/bVjL70/btrYRjOSVqW/Kqv6XzBCUDeNPM35NQD2ik/img_110x110.jpg"
    },
    "kakao_account": {
      "profile_nickname_needs_agreement": false,
      "profile_image_needs_agreement": false,
      "profile": {
        "nickname": "박형순",
        "thumbnail_image_url": "http://k.kakaocdn.net/dn/bVjL70/btrYRjOSVqW/Kqv6XzBCUDeNPM35NQD2ik/img_110x110.jpg",
        "profile_image_url": "http://k.kakaocdn.net/dn/bVjL70/btrYRjOSVqW/Kqv6XzBCUDeNPM35NQD2ik/img_640x640.jpg",
        "is_default_image": false
      },
      "has_email": true,
      "email_needs_agreement": false,
      "is_email_valid": true,
      "is_email_verified": true,
      "email": "hyeongsoonpark@gmail.com",
      "has_age_range": true,
      "age_range_needs_agreement": false,
      "age_range": "50~59",
      "has_birthday": true,
      "birthday_needs_agreement": false,
      "birthday": "1127",
      "birthday_type": "SOLAR",
      "has_gender": true,
      "gender_needs_agreement": false,
      "gender": "male"
    }
  }  

  < kakao 로그인관련 개발자용 참조문서 >
    https://developers.kakao.com/docs/latest/ko/kakaologin/rest-api#request-code
    
  < kakao 연결 끊기용 curl 명령 >
  Bearer 다음에 오는 것은 엑세스토큰이다.
  curl -v -X POST "https://kapi.kakao.com/v1/user/unlink" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Bearer 21NZBTP3hGrIZHvTNDmueCql96yPR7EdV7WmmOQDCj1zGAAAAYf-NlBB"
}  
//------------------------------------------------------------
// tb_user_login_history : 로그인 히스토리 정보 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_user : 
  (테이블명 설명) 
    사용자 정보 테이블
    감사(audit)를 위해서 고객 로그인 정보를 기록한다.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  login_id :
  (필드명 설명)
    사용자(회원) 아이디
    자동증가값 id가 아닌 사이트 로그인 아이디를 의미한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "supercob" "i48korea" "geoTest" 

  login_time :
  (필드명 설명)
    로그인 시간
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  login_ip : 
  (테이블명 설명) 
    로그인 ip 주소
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "172.31.43.247" "192.168.0.37"

  access_status :
  (필드명 설명)
    접속상태
    향후 쓰임을 위해서 만들었다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "접속중" "로그아웃" 
}
//------------------------------------------------------------
// tb_device : 디바이스(기기) 정보 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_device : 
  (테이블명 설명) 
    찜목록(관심목록) 테이블
    사용자가 관심을 갖고 있는 항목들을 찜 아이콘을 눌러서 저장해 놓을 수 있다.
    찜목록은 아래 페이지들에서 선택할 수 있다.
      - 상세 장소
      - 펫연구소 Q&A (강사모)
      - 펫연구소 컨텐츠
  -- -----------------------------------------------------------

  id : 공통설명 참조

  uuid :
  (필드명 설명)
    디바이스 고유 아이디
    petme3 서버에서 최초에 할당해 주는 device uuid 이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "280a8a4d-a27f-4d01-b031-2a003cc4c039"

  login_id :
  (필드명 설명)
    디바이스의 사용자 아이디
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "supercob" "i48korea" "geoTest" 

  os :
  (필드명 설명)
    접속디바이스 운영체제
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "Android-kitkat" "iOS" "Windows" "Linux" "Mac OS"

  ip : 
  (테이블명 설명) 
    로그인 ip 주소
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "172.31.43.247" "192.168.0.37"

  mac_address : 
  (테이블명 설명) 
    디바이스의 MAC 주소
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "12:34:56:78:90:AB"

  modify_time
  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_watchlist : 찜목록(관심목록) 테이블
//------------------------------------------------------------
{
  
  DROP TABLE IF EXISTS `tb_watchlist`;
  CREATE TABLE `tb_watchlist` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'tb_user 테이블의 아이디',
    `tb_place_id` bigint(20) unsigned DEFAULT NULL COMMENT 'tb_place 테이블의 아이디',
    `tb_bulletin_board_id` bigint(20) unsigned DEFAULT NULL COMMENT 'tb_bulletin_board_id 테이블의 아이디',
    `tb_pet_raboratory_id` bigint(20) unsigned DEFAULT NULL COMMENT 'tb_pet_raboratory_id 테이블의 아이디',
    `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
    `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `index_tb_watchlist_tb_user_id` (`tb_user_id`),
    UNIQUE KEY `index_tb_watchlist_tb_place_id` (`tb_place_id`),
    UNIQUE KEY `index_tb_watchlist_tb_bulletin_board_id` (`tb_bulletin_board_id`),
    UNIQUE KEY `index_tb_watchlist_tb_pet_raboratory_id` (`tb_pet_raboratory_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='찜목록(관심목록) 테이블';
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_watchlist : 
  (테이블명 설명) 
    찜목록(관심목록) 테이블
    사용자가 관심을 갖고 있는 항목들을 찜 아이콘을 눌러서 저장해 놓을 수 있다.
    찜목록은 아래 페이지들에서 선택할 수 있다.
      - 상세 장소
      - 펫연구소 Q&A (강사모)
      - 펫연구소 컨텐츠
  -- -----------------------------------------------------------

  id : 공통설명 참조

  tb_user_id :
  (테이블명 설명) 
    기본키이다.
    MySQL은 항상 id를 두는 것이 좋다.
    찜된 tb_user 테이블의 id를 찾는다. 즉, 찜한 사람이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  tb_place_id :
  (테이블명 설명) 
    기본키이다.
    MySQL은 항상 id를 두는 것이 좋다.
    찜된 tb_place 테이블의 id를 찾는다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  tb_bulletin_board_id :
  (테이블명 설명) 
    기본키이다.
    MySQL은 항상 id를 두는 것이 좋다.
    찜된 tb_bulletin_board 테이블의 id를 찾는다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  tb_pet_raboratory_id :
  (테이블명 설명) 
    기본키이다.
    MySQL은 항상 id를 두는 것이 좋다.
    찜된 tb_pet_raboratory 테이블의 id를 찾는다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  modify_time
  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_zipcode : 우체국 우편번호 테이블
//------------------------------------------------------------
{
  # show create table tb_zipcode;
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

}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_zipcode : 
  (테이블명 설명) 
    우체국 우편번호 테이블
  -- -----------------------------------------------------------

  id : 공통설명 참조

  sido :
  (필드명 설명)
    시도
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "서울특별시" "경기도" "대구광역시" "세종특별자치시"

  sido_en :
  sigungu :      
  sigungu_en :
  eupmyeon :   
  eupmyeon_en :   
  doro_code :  
  doro :    
  doro_en :       
  undergnd_yn :   
  budg_no1 :  
  budg_no2 :     
  budg_mgmt_no :
  big_dlvy : 
  budg_name :     
  dong_code :    
  dong :    
  ri :         
  dong_hj :       
  mtn_yn :      
  jibun_no1 :     
  eupmyeondong_sn :
  jibun_no2 :
  zipcode_old :   
  zipcode_sn :
  (테이블명 설명)
    테이블 스크립트만 참조해도 충분할 것이다.

  // 예제
 우편번호|시도|시도영문|시군구|시군구영문|읍면|읍면영문|도로명코드|도로명|도로명영문|지하여부|건물번호본번|건물번호부번|건물관리번호|다량배달처명|시군구용건물명|법정동코드|법정동명|리명|행정동명|산여부|지번본번|읍면동일련번호|지번부번|구우편번호|우편번호일련번호
 06315|서울특별시|Seoul|강남구|Gangnam-gu|||116804166204|논현로8길|Nonhyeon-ro 8-gil|0|67|0|1168010300111830010000001||Artespace|1168010300|개포동||개포4동|0|1183|01|10||
 06325|서울특별시|Seoul|강남구|Gangnam-gu|||116804166443|선릉로10길|Seolleung-ro 10-gil|0|16|0|1168010300101640009019445||9COZYVILLE|1168010300|개포동||개포2동|0|164|01|9||

  // 약어/축어 의미
  big_dlvy : large quantity delivery 다량배달처(대형빌딩,기관,아파트)
  budg : building 빌딩
  budg_mgmt_no : building management number 건물관리번호
  dlvy : delivery 배달
  dong_hj : hj는 행정의 한글발음대로의 약어임. 
    행정은 원래 영어로는(Administration 약어는 admin) 이지만, 좀더 직관적으로 알기 쉽게 연상되도록 한글발음 그대로 약어로 만들어 사용한다.
  en : english name 영어 이름
  mgmt : management 관리
  mtn : mountain 산
  no : number 번호
  sn : serial number 일련번호
  undergnd : underground 지하
  yn : yes no 여부

  //----- reserved field ---------------------------------------
    없음

  //----- 향후 설계해야 될지도 모르는 필드 ---------------------
  DROP TABLE IF EXISTS `tb_zipcode_old`;
  CREATE TABLE `tb_zipcode` (
    `zipcode` char(7) NOT NULL,
    `sido` varchar(30) NOT NULL,
    `gugun` varchar(30) NOT NULL,
    `dong` varchar(30) NOT NULL,
    `ri` varchar(30) DEFAULT NULL,
    `bldg` varchar(50) DEFAULT NULL,
    `st_bunji` varchar(10) DEFAULT NULL,
    `ed_bunji` varchar(10) DEFAULT NULL,
    `seq` int(11) NOT NULL,
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`serial_number`),
    UNIQUE KEY `serial_number_UNIQUE` (`serial_number`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci;
}
{
  //------------------------------------------------------------
  // 유용한 스크립트
  //------------------------------------------------------------
  # 
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/강원도.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/경기도.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/경상남도.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/경상북도.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/광주광역시.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/대구광역시.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/대전광역시.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/부산광역시.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/서울특별시.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/세종특별자치시.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/울산광역시.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/인천광역시.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/전라남도.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/전라북도.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/제주특별자치도.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/충청남도.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;
  LOAD DATA LOCAL INFILE '/var/lib/mysql/zipcode_DB/충청북도.txt' INTO TABLE petme3.tb_zipcode CHARACTER SET 'utf8' FIELDS TERMINATED BY '|' IGNORE 1 LINES;


  # iconv -c -f cp949 -t utf-8 강원도.txt > 강원도1.txt
  # iconv -c -f cp1252 -t utf-8 강원도.txt > 강원도1.txt
}
//------------------------------------------------------------
// tb_medical_staff : 병원 의료진 정보 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_medical_staff : 
  (테이블명 설명) 
    병원 의료진 정보 테이블
    의료진 정보는 각 병원의 홈페이지나 블로그에서 끌어온다.
    크롤링은 petme3 서비스 운영시에 운영자가 수작업으로 관리자 페이지에서 입력하게 한다.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  tb_place_id :
  (테이블명 설명) 
    tb_place 테이블의 id를 나타낸다.
    tb_place 테이블의 내용은 tb_crawling_naver_map 테이블에서 끌고가는 것으로 하며,
    내용은 동일하다고 본다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  staff_name :
  (필드명 설명)
    의료진 사람이름
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "원장" "김종일" "이태호" "정상호"

  position :
  (필드명 설명)
    의료진 직위 
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "대표 원장" "외과 원장" "내과 원장"

  profile :
  (필드명 설명)
    의료진 약력/경력/career 
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2015년 육군 수의장교 대위 전역" "2015~2017년 서울대학교 수의과대학 동물병원 내과 수련의"
    "2018년 청담동 I will 24시동물병원 진료수의사" "2019년 상도동 GN동물병원 내과과장"

  input_order :
  (필드명 설명)
    의료진 직위 
    관리자 페이지에서 의료진의 약력이 입력되는 순서를 의미한다.
    1 : "2015년 육군 수의장교 대위 전역" 
    2 : "2015~2017년 서울대학교 수의과대학 동물병원 내과 수련의"
    3 : "2018년 청담동 I will 24시동물병원 진료수의사" 
    4 : "2019년 상도동 GN동물병원 내과과장"
    위와 같이 입력된다면, 4번이 제일 최근의 이력이 되는 것이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    1 3 8  

  modify_time
  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_ranking_algorithm : 랭킹 알고리즘 계산 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_ranking_algorithm : 
  (테이블명 설명) 
    랭킹 알고리즘을 계산할 수 있는 정보를 저장하고 있는 테이블이다.
    관리자에서 기초 정보를 입력받아서 DB에 쿼리한 후, 이 테이블에 정보를 저장하게 된다.
    그후, 배치 프로세스로 tb_place 테이블의 ranking 필드에 해당 랭킹이 갱신되게 하도록 하자.
    < 배치 프로세스 >
    금일 24시 59분 59초를 넘어서, 다음날 0시 0초에 랭킹이 입력되게 된다.
    전주/전달/전일 기준으로 랭킹으로 소팅한다.
    예를 들어, 2023-03-22 의 월간 랭킹은 2023-02-01 ~ 2023-02-28 까지의 합의 평균이다.
    따라서 2023년 1월 이전의 랭킹 데이타는 필요가 없지만, 일단 삭제하지 말고 보관하도록 하자.
    왜냐하면 나중에 필요에 의해서 그래프 같은 것을 그릴수도 있기 때문이다.
    단 조회 속도를 원활히 하도록 하기 위해서, backup 테이블로 옮기는 것이 좋을 듯 하다.
  < a 동물병원 >  
  전주/전달/전일 랭킹으로 기준
  2023-03-1 9.1
  ...
  2023-03-22 10.0
  2023-03-23 9.1
  2023-03-24 9.1
  2023-03-25 9.1
  2023-03-26 9.1
  2023-03-27 9.1
  2023-03-28 9.1
  2023-03-29 9.1
  2023-03-30 9.1
  2023-03-31 9.1
  2023-04-1 9.1
  -- -----------------------------------------------------------

  id : 공통설명 참조

  tb_place_id :
  (테이블명 설명) 
    기본키이다.
    MySQL은 항상 id를 두는 것이 좋다.
    찜된 tb_place 테이블의 id를 찾는다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  ranking_date :
  (테이블명 설명)
    랭킹이 계산된 날짜
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  final_ranking :
  (테이블명 설명)
    최종적으로 계산된 랭킹이 들어가게 되는 필드이다.
    이 필드에서 배치프로세스로 tb_place 테이블의 ranking 필드에 해당 랭킹이 갱신되게 하도록 하자.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "4.58"  "6.97"  "3. 53" 

  reserved1
  reserved2
  reserved3
  reserved4
  reserved5
  reserved6
  reserved7
  reserved8
  reserved9 :
  (테이블명 설명)
    알고리즘을 위한 예약필드를 10개 정도 만들어 놓았다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    아직 fix 되지 않은 reserved 필드이다.
    어떤 문자도 들어갈 수 있다.

  modify_time
  register_time : 공통설명 참조

  //----- 향후 설계해야 될지도 모르는 필드 ---------------------
  `place_scale` varchar(20) DEFAULT NULL COMMENT '장소의 규모', 
  `final_ranking` varchar(20) DEFAULT NULL COMMENT '부정적 리뷰', 

  ## 랭킹 알고리즘 (전국 단위의 랭킹) 필요
  1. 평점:
  2. 리뷰 기본 척도:
  3. 규모:
  4. 지역:
      - 서울시 강남구, 활성화 정도에 따라 가산점 부여
  5. 부정적 리뷰의 경우
      - 긍정적 리뷰와의 비율에 따라 감점을 부여
  6. 최신 리뷰
      - 네이버 기준 3개월 간 최신리뷰 건수
      - 지역별 최신리뷰의 차이가 랭킹이 전환될 수 있음
  7. 의료진 수
      - 예) 6명인 경우와 1명인 경우를 구분
          - +점수를 부여할 수 있음
  8. 포토 리뷰많은 순

  ## 리뷰 알고리즘
  1. 랭킹 1위~30위까지의 랭킹을 랜덤 돌린다 
  - 일간 / 주간 / 월간
  2. 리뷰 많은순 랭킹 1  

  리뷰는 랭킹은 없다
  단, 알고리즘 10개 이상의 
}
//------------------------------------------------------------
// tb_petme_qna : 펫미 Q&A(질의응답)/댓글 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_petme_qna : 
  (테이블명 설명) 
    펫미 Q&A(질의응답)/댓글 테이블
    petme3 서비스에서 펫연구소에서 고객이 작성하는 Q&A 를 저장하는 테이블이다.
    크롤링 데이타가 들어가는 tb_bulletin_board 테이블과 완전히 동일한 구조이지만, 
    펫미 자체에서 올린 것과 구분하기 위해서 생성하는 테이블이다.
    향후 크롤링 관련 테이블은 전부 삭제처리하는 것이 좋을 듯 하다.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  tb_user_id :
  (테이블명 설명) 
    tb_user 테이블의 id를 나타낸다.
    크롤링 id 일수 있기 때문에, NULL 일 수도 있다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  category :
  (필드명 설명)
    Q&A 카테고리
    Q&A 글쓰기 버튼을 눌러서 작성시 카테고리를 선택할 수 있도록 한다.
    개별 컨텐츠에 대한 Q&A 글쓰기는 없다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "초보생활" "반려생활" "펫미케어" "행동교정"

  title :
  (필드명 설명)
    펫연구소 콘텐츠 제목
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "강아지와의 첫 만남, 반려견 입양의 모든 것"

  content :
  (필드명 설명)
    커뮤니티 게시판의 게시글에 대한 내용을 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "강아지가 오리젠 제일 잘 먹길래 시켜주려고 찾아보니 6키로 삼만원대 판매하는 제품이 있네요...? 유통기한이 9월까지\n
    라 해도 가격이 너~무 싸서 뭔가 의심(?)스러운데 정품 맞겠죠???" 

  writer :
  (필드명 설명)
    Q&A를 작성한 사용자(회원) 아이디
    이 필드를 두는 이유는 tb_user_id 로 join 하지 않고, 바로 writer만 가지고 사용하기 위함이다.
    자동증가값 id가 아닌 사이트 로그인 아이디를 의미한다.
    즉, writer = tb_user.id 이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "supercob" "i48korea" "geoTest" 

  write_time :
  (테이블명 설명) 
    글쓴 시간
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "2023-03-28 06:53:14" 

  read_count :
  (필드명 설명)
    읽은 조회수
    Q&A를 사용자가 클릭하면 조회수가 1개씩 올라간다.
  (DB 입력데이터 예제) 
    정수형 숫자이다.
    349

  parent_id :
  (필드명 설명)
    부모 게시글 아이디
    답변형 게시판의 부모글 아이디이다.
    그런데, parent_id = id 와 같으면 최상단의 글이라는 것이다.
    즉, 댓글이 아닌것이다.
    그리고, parent_id != id 이면 댓글이라는 얘기이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  order :
  (필드명 설명)
    댓글 순서이다.
    1이면 첫번째 댓글, 2면 두번째 댓글 이런순이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  0 과 1만 있다.
    0 1 

  depth :
  (필드명 설명)
    댓글 레벨/깊이
    답변형 게시판의 부모글 아이디이다.
    즉, 부모글에 대한 댓글이라는 얘기이다.
  (데이터 타입 설명) 
    tinyint(2) unsigned DEFAULT '0'
    성능을 위해서 depth는 1 단계로만 제한하도록 한다.
    네이버도 1단계까지만 한다.
    즉, 0, 1 값만 있는 것이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  0 과 1만 있다.
    0 1 

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_petme_notice : 펫미 공지사항
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_petme_notice : 
  (테이블명 설명) 
    petme3 서비스에서 자체적으로 제공하는 공지 및 소식(이벤트 등)을 저장하는 테이블이다.
    관리자에서 기초 정보를 입력받아서 DB에 쿼리한 후, 이 테이블에 정보를 저장하게 된다.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  tb_user_id :
  (테이블명 설명) 
    tb_user 테이블의 id를 나타낸다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  tb_admin_user_id :
  (테이블명 설명) 
    tb_admin_user 테이블의 id를 나타낸다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  title :
  (필드명 설명)
    펫연구소 콘텐츠 제목
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "강아지와의 첫 만남, 반려견 입양의 모든 것"

  writer :
  (필드명 설명)
    공지/소식 작성자
    이 필드를 두는 이유는 tb_user_id 로 join 하지 않고, 바로 writer만 가지고 사용하기 위함이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "administrator" "신운정" "재로몬" "별이언니"

  content :
  (필드명 설명)
    커뮤니티 게시판의 게시글에 대한 내용을 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "강아지가 오리젠 제일 잘 먹길래 시켜주려고 찾아보니 6키로 삼만원대 판매하는 제품이 있네요...? 유통기한이 9월까지\n
    라 해도 가격이 너~무 싸서 뭔가 의심(?)스러운데 정품 맞겠죠???" 

  read_count :
  (필드명 설명)
    공지사항 조회수
    공지를 사용자가 클릭하면 조회수가 1개씩 올라간다.
  (DB 입력데이터 예제) 
    정수형 숫자이다.
    349

  notice_gubun :
  (필드명 설명)
    공지사항 타입
    공지사항 형식에 대한 구분을 의미한다.    
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "소식" "공지" "이벤트"

  link_url :
  (필드명 설명)
    공지사항에서 연결된 링크에 대한 URL을 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "https://blog.naver.com/byejoon22" 
    "https://blog.naver.com/smart7582" 

  html_yn :
  (필드명 설명)
    html 사용 여부
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "y" "n"

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//************************************************************************************************/
// Web 운영을 위해서 Admin Page 등과 관련된 관련 테이블들
//************************************************************************************************/
//------------------------------------------------------------
// tb_common_code_category : 공통코드 카테고리 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_common_code_category :
  (테이블명 설명) 
    공통코드 카테고리 테이블
    사용자가 검색한 키워드를 보관하는 테이블이다.
    공통코드 테이블 설계에 대해서는 
      https://blog.b2en.com/366
    를 참조하라.
  -- -----------------------------------------------------------

  id :
  (테이블명 설명) 
    기본키이다.
    공통코드 아이디이기 때문에 자동증가값이 아니다. 
    AUTO_INCREMENT=1 과 같이 선언하면 절대 안된다.
    100 부터 시작하도록 한다.
    100 200 300 이렇게 증가시키도록 하자.    
    tb_common_code_category.id = tb_common_code.code
    위와 같이 값이 같게 설계했다. 
    이렇게 설계한 이유는 코딩 생산성이 높고, 코드 값만 보고도 코드 유형을 알 수 있기 때문이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    100 200 300 ...

  name :
  (필드명 설명)
    공통코드 카테고리명을 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "장소종류" "서버상태"

  english_name :
  (필드명 설명)
    공통코드 카테고리 영문명을 나타낸다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "PLACE_TYPE" "SERVER_STATUS"

  description :
  (필드명 설명)
    공통코드 카테고리에 대한 설명 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "장소에 대한 종류를 나타낸다. 병원/약국/미용/용품매장/산책/카페/호텔 등이 존재한다." 

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_common_code : 공통코드 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_common_code :
  (테이블명 설명) 
    공통코드 카테고리 테이블
    사용자가 검색한 키워드를 보관하는 테이블이다.
    공통코드 테이블 설계에 대해서는 
      https://blog.b2en.com/366
    를 참조하라.
  -- -----------------------------------------------------------

  code :
  (테이블명 설명) 
    공통코드를 나타낸다.
    AUTO_INCREMENT=1 과 같이 선언하면 절대 안된다.
    10001 부터 시작하도록 한다.
    10001 10002 10003 이렇게 증가시키도록 하자.
    tb_common_code_category.id = tb_common_code.code
    위와 같이 값이 같게 설계했다. 
    이렇게 설계한 이유는 코딩 생산성이 높고, 코드 값만 보고도 코드 유형을 알 수 있기 때문이다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    10001 10002 10003 ...

  name :
  (필드명 설명)
    공통코드명을 나타낸다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "일반" "나쁨" "디스크꽉참"

  english_name :
  (필드명 설명)
    공통코드 카테고리 영문명을 나타낸다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "normal" "bad" "diskfull"

  description :
  (필드명 설명)
    공통코드 카테고리에 대한 설명 나타낸다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "일반적인 정상 서버 상태이다." "서버상태가 굉장히 나쁨. 부하가 많이 걸린 상태이다." 
    "디스크가 꽉차서 더이상 공간이 없다"

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_keyword_search : 검색 키워드 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_keyword_search
   : 
  (테이블명 설명) 
    검색키워드 정보 테이블
    사용자가 검색한 키워드를 보관하는 테이블이다.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  login_id :
  (필드명 설명)
    검색하는 사용자 아이디
    자동증가값 id가 아닌 사이트 로그인 아이디를 의미한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "supercob" "i48korea" "geoTest" 

  search_keyword :
  (필드명 설명)
    검색 키워드
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "동물병원" "사료" "산책"

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_policy : 펫미 정책 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_policy : 
  (테이블명 설명) 
    펫미 정책 테이블
    petme3 서비스 운영상의 다양한 정책을 관리하기 위한 테이블이다.
    정책은 비정형이기 때문에 어떠한 형태도 담을 수 있도록 설계했다.
  -- -----------------------------------------------------------

  id : 공통설명 참조

  category :
  (필드명 설명)
    정책카테고리
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "Integrity Management" "Point Management" "Review Management" "Ranking Management"
    "Alliance(제휴) Management" "Withdrawal(탈퇴) Management" 

  name :
  (필드명 설명)
    정책이름
    프로그램에 의해서 전달되어서 파싱될 수 있는 정책명이다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "BLOCK_DEVICE" "POINT_MANAGEMENT" "REVIEW_MANAGEMENT" "RANKING_MANAGEMENT"
    "디바이스 접속 차단 정책" "포인트 정책" "리뷰정책" "랭킹 정책"

  description :
  (필드명 설명)
    정책에 대한 설명
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "단말의 무결성을 실시간으로 감시한다"
    "탈퇴한 회원을 DB에서 삭제하고, history 정보를 백업테이블로 저장한다."

  mode :
  (필드명 설명)
    정책에 대한 모드
    프로그램에서 제어 가능한 값들이 들어간다.
    주로 "ON" "OFF" 로 제어한다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "ON" "OFF"

  rule_sql :
  (필드명 설명)
    SQL 쿼리 룰
    관리자에서 SQL을 입력하면 실행되도록 한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "DELETE FROM tb_user WHERE id = '99' AND user_name = '김회계';"

  rule_regular_expression :
  (필드명 설명)
    정규표현식 룰
    관리자에서 client나 back-end 프로그램으로 전달해서 파싱해서 쓸 수 있는 정규표현식 룰이 들어간다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "/\d{3}-\d{4}-\d{4}/"

  use_yn : 공통설명 참조

  modify_time : 공통설명 참조

  register_time : 공통설명 참조
}
//------------------------------------------------------------
// tb_backup_history : 백업 테이블
//------------------------------------------------------------
{
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
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_backup_history : 
  (테이블명 설명) 
    펫미 DB 백업 히스토리 테이블
    petme3 서비스 운영중 오래된 DB 백업,
    성능을 위해서 백업후 삭제 등을 기록하는 테이블이다.
    보통은 디비테이블의 스키마와 데이타를 dump 해서 .sql 파일에 저장해서 백업하도록 하자.
    단, 서버 to 서버 백업은 위해서는 원본 DB테이블 스키마를 그대로 구성한 테이블이나 MariaDB가 존재해야 한다.
    예) 원본 테이블 : tb_place   백업 테이블 : tb_place_backup_20230718
  -- -----------------------------------------------------------

  id : 공통설명 참조

  backup_user_name :
  (필드명 설명)
    백업을 주도하는 사용자 이름
    tb_admin_user의 사용자이거나 펫미 회사 직원이나 펫미 사이트 운영자가 될 수 있다.
    아니면, 시스템 자동백업으로 시스템호스트명이 들어갈 수도 있다.
    나중에 누가 백업했는지를 알려면, 무조건 NOT NULL 이어야 한다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "supercob" "i48korea" "geoTest" 

  source_ip : 
  (테이블명 설명) 
    백업할 원본 DB테이블이 있는 서버 ip 주소
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "172.31.43.247" "192.168.0.37"

  destination_ip : 
  (테이블명 설명) 
    백업을 보관할 서버 ip 주소
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "172.31.43.247" "192.168.0.37"

  destination_ssl_port :
  (필드명 설명)
    백업 사본이 저장될 서버의 ssl 포트번호
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "48702" 

  destination_login_user :
  (필드명 설명)
    백업 사본이 저장될 서버의 로그인 아이디
    백업 프로그램이 사용할 인증용 로그인 아이디이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "root" "jongwh"

  destination_login_password :
  (필드명 설명)
    백업 사본이 저장될 서버의 로그인 암호
    백업 프로그램이 사용할 인증용 로그인 암호이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "qwer@1234" "k2017!@" 

  backup_file_name :
  (필드명 설명)
    백업시킨 덤프 파일명
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "tb_place_backup_20230718.sql"

  backup_location :
  (필드명 설명)
    백업하는 서버의 디렉토리 풀패스
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "/data/petme3/backup/20230917"

  backup_type :
  (필드명 설명)
    백업의 성격을 설명한다.
    common_code로 만들어야 하는 부분이다.
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "일일정규백업" "월백업" 

  backup_comment :
  (필드명 설명)
    백업하는 서버의 디렉토리 풀패스
  (DB 입력데이터 예제) 
    문자열 형태의 텍스트이다.
    "디비죽어서급하게백업"

  modify_time
  register_time : 공통설명 참조
}
//************************************************************************************************/
// n:m 관계를 위한 매핑 테이블 설계
//************************************************************************************************/
{
  //------------------------------------------------------------
  // tb_mapping_tb_user_tb_event : 이벤트-사용자 매핑테이블
  //------------------------------------------------------------
  {
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
  }
  {
    //------------------------------------------------------------
    // 테이블 및 컬럼 설명
    //------------------------------------------------------------
    tb_mapping_tb_user_tb_event : 
    (테이블명 설명) 
      이벤트 테이블
      petme3 자체 서비스를 위한 이벤트 정보를 기록하는 테이블이다.
    -- -----------------------------------------------------------

    id : 공통설명 참조

    tb_user_id :
    (테이블명 설명) 
      tb_user 테이블의 id를 나타낸다.
    (DB 입력데이터 예제) 
      unsigned 정수형 숫자이다.  
      18 2045 398 40056 

    tb_event_id :
    (테이블명 설명) 
      tb_event 테이블의 id를 나타낸다.
    (DB 입력데이터 예제) 
      unsigned 정수형 숫자이다.  
      18 2045 398 40056 

    modify_time : 공통설명 참조

    register_time : 공통설명 참조
  }

  //------------------------------------------------------------
  // tb_mapping_tb_user_tb_petme_notice : 공지사항-사용자 매핑테이블
  //------------------------------------------------------------
  {
    DROP TABLE IF EXISTS `tb_mapping_tb_user_tb_petme_notice`;
    CREATE TABLE `tb_mapping_tb_user_tb_petme_notice` (
      `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
      `tb_user_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
      `tb_petme_notice_id` bigint(20) unsigned DEFAULT NULL COMMENT '아이디',
      `use_yn` varchar(1) DEFAULT 'y' COMMENT '사용여부/노출여부',    
      `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
      `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
      PRIMARY KEY (`id`),
      UNIQUE KEY `index_tb_mapping_tb_user_tb_petme_notice_tb_user_id_tb_petme_notice_id` (`tb_user_id`, `tb_petme_notice_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='이벤트-사용자 매핑테이블';
  }
  {
    //------------------------------------------------------------
    // 테이블 및 컬럼 설명
    //------------------------------------------------------------
    tb_mapping_tb_user_tb_petme_notice : 
    (테이블명 설명) 
      공지사항-사용자 매핑테이블
      petme3 자체 공지사항을 읽은 사용자를 처리하기 위한 매핑 테이블이다.
    -- -----------------------------------------------------------

    id : 공통설명 참조

    tb_user_id :
    (테이블명 설명) 
      tb_user 테이블의 id를 나타낸다.
    (DB 입력데이터 예제) 
      unsigned 정수형 숫자이다.  
      18 2045 398 40056 

    tb_petme_notice_id :
    (테이블명 설명) 
      tb_event 테이블의 id를 나타낸다.
    (DB 입력데이터 예제) 
      unsigned 정수형 숫자이다.  
      18 2045 398 40056 

    modify_time : 공통설명 참조

    register_time : 공통설명 참조
  }

  //------------------------------------------------------------
  // tb_mapping_tb_server_tb_file : 서버-파일 매핑테이블
  //------------------------------------------------------------
  {
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
  }
  {
    //------------------------------------------------------------
    // 테이블 및 컬럼 설명
    //------------------------------------------------------------
    tb_mapping_tb_server_tb_file : 
    (테이블명 설명) 
      서버-파일 매핑 테이블
      로드밸런싱을 위해서 한파일이 여러 서버에 있을 수 있으므로(n:m관계) 매핑테이블이 필요하다.
    -- -----------------------------------------------------------

    id : 공통설명 참조

    tb_server_id :
    (테이블명 설명) 
      tb_user 테이블의 id를 나타낸다.
    (DB 입력데이터 예제) 
      unsigned 정수형 숫자이다.  
      18 2045 398 40056 

    tb_file_id :
    (테이블명 설명) 
      tb_event 테이블의 id를 나타낸다.
    (DB 입력데이터 예제) 
      unsigned 정수형 숫자이다.  
      18 2045 398 40056 

    modify_time : 공통설명 참조

    register_time : 공통설명 참조
  }


  //------------------------------------------------------------
  // tb_review_map_tb_image
  //------------------------------------------------------------
  DROP TABLE IF EXISTS `tb_map_user_device`;
  CREATE TABLE `tb_map_user_device` (
    `map_user_device_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '<한글 칼럼명> 아이디\n<설명> 자동증가값\n<예>',
    `user_id` bigint(20) unsigned NOT NULL COMMENT '<한글 칼럼명> 아이디\n<설명> 사용자 테이블 아이디\n<예>',
    `device_id` bigint(20) unsigned NOT NULL COMMENT '<한글 칼럼명> 아이디\n<설명> 사용자 테이블 아이디\n<예>',
    PRIMARY KEY (`map_user_device_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='<한글 디비명> UUID 테이블\n<설명>\n<예>';
  ...
  ...
  ...
}
//************************************************************************************************/
// 향후 추가 기획을 위해서 만들수도 있을 만한 테이블 설계
//************************************************************************************************/
{
  //------------------------------------------------------------
  // tb_member_rank : 우수 고객 통계를 위한 회원 랭킹 테이블
  //------------------------------------------------------------
  빌링이 붙었을 때를 위해서
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

  //------------------------------------------------------------
  // tb_store_rank : 우수 상점 통계를 위한 랭킹 테이블
  //------------------------------------------------------------
  가맹점으로 상점을 입점시켰을 때를 대비해서
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

  //------------------------------------------------------------
  // tb_sns_link : sns 서비스를 위한 테이블
  //------------------------------------------------------------
  sns 전송 서비스를 할때를 위해서
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

  //------------------------------------------------------------
  // tb_order : 쇼핑몰 서비스를 위한 테이블
  //------------------------------------------------------------
  대형종합몰, 브랜드몰, 오픈 마켓플레이스, 디지털 콘텐츠 유통, 티켓 예매 등 핵심 커머스 서비스를 대비해서
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

  //------------------------------------------------------------
  // tb_order : 마일리지 적립 서비스를 위한 테이블
  //------------------------------------------------------------
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

  //------------------------------------------------------------
  // 기타 향후 기획후 서비스에 필요할 수도 있는 테이블
  //------------------------------------------------------------
  DROP TABLE IF EXISTS ` tb_store_menu_type`;
  CREATE TABLE ` tb_store_menu_type` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `store_id` int(11) NOT NULL,
    ` type_name` varchar(255) NOT NULL,
    PRIMARY KEY (`serial_number`),
    KEY ` tb_store_menu_type` (`store_id`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;

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
  CREATE TABLE `tb_billing_gubun` (
    `serial_number` int(11) NOT NULL AUTO_INCREMENT,
    `gubun_name` varchar(128) COLLATE utf8_bin DEFAULT NULL,
    `amount_gubun_code` int(11) DEFAULT '0',
    `billing_money` int(11) DEFAULT '0',
    `is_used` enum('Y','N') COLLATE utf8_bin DEFAULT 'Y',
    PRIMARY KEY (`serial_number`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='결제 구분 테이블';

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
  CREATE TABLE `tb_familiar_shop` (
    `create_date` datetime NOT NULL,
    `member_id` int(11) NOT NULL,
    `store_id` int(11) NOT NULL,
    PRIMARY KEY (`member_id`,`store_id`),
    KEY `idx_tb_familiar_shop_0` (`store_id`),
    KEY `idx_tb_familiar_shop_1` (`member_id`)
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;

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
  CREATE TABLE `tb_policy_code` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    `code` varchar(512) NOT NULL,
    `name` varchar(512) DEFAULT NULL,
    `description` varchar(2048) DEFAULT NULL,
    `value` varchar(512) DEFAULT NULL,
    `registration_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci;

  LOCK TABLES `tb_policy_code` WRITE;
  INSERT INTO `tb_policy_code` VALUES (1,'SITE_CONNECT_BLOCKING',NULL,NULL,'ON','2017-10-18 17:16:19'),(2,'SITE_CONNECT_BLOCKING',NULL,NULL,'OFF','2017-10-18 17:16:19'),(3,'USB_CONNECT_BLOCKING',NULL,NULL,'ON','2018-02-12 23:09:08'),(4,'USB_CONNECT_BLOCKING',NULL,NULL,'OFF','2018-02-12 23:09:08'),(5,'MEMORY_LOAD_BLOCKING',NULL,NULL,'ON','2018-02-13 20:51:08'),(6,'MEMORY_LOAD_BLOCKING',NULL,NULL,'OFF','2018-02-13 20:51:08'),(7,'REALTIME_WATCHING',NULL,NULL,'ON','2018-02-14 10:26:55'),(8,'REALTIME_WATCHING',NULL,NULL,'OFF','2018-02-14 10:26:56'),(9,'REALTIME_WATCHING_THREATS_ACTION',NULL,NULL,'QUARANTINE','2018-02-21 19:54:07'),(10,'REALTIME_WATCHING_THREATS_ACTION',NULL,NULL,'JUST_REPORT','2018-02-21 19:54:07'),(11,'BACKGROUND_DNA_CHECK',NULL,NULL,'AUTO','2018-04-04 15:59:10'),(12,'BACKGROUND_DNA_CHECK',NULL,NULL,'MANUAL','2018-04-04 15:59:23'),(13,'MEMORY_WATCHER ',NULL,NULL,'ON','2018-05-14 15:24:52'),(16,'MEMORY_WATCHER ',NULL,NULL,'OFF','2018-05-14 15:24:57'),(17,'WINDOWS_UPDATE_CONTROL',NULL,NULL,'ON','2018-05-17 12:14:12'),(18,'WINDOWS_UPDATE_CONTROL',NULL,NULL,'OFF','2018-05-17 12:14:12');

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
  CREATE TABLE `tb_credential` (
    `credential_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '<한글 칼럼명> 아이디\n<설명> 자동증가값\n<예>',
    `user_id` bigint(20) unsigned NOT NULL COMMENT '<한글 칼럼명> 아이디\n<설명> 사용자 테이블 아이디\n<예>',
    `auth_credential` varchar(1024) NOT NULL COMMENT '<한글 칼럼명> 인증 크리덴셜\n<설명>\n<예>',
    `device_credential` varchar(1024) NOT NULL COMMENT '<한글 칼럼명> 디바이스 크리덴셜\n<설명>\n<예>',
    `registration_time` datetime NOT NULL COMMENT '<한글 칼럼명> 최초 등록 시간\n<설명> 최초 등록된 시간을 나타낸다.\n<예> 2014-10-30 11:18:27',
    `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '<한글 칼럼명> 마지막 갱신시각\n<설명>\n<예>',
    PRIMARY KEY (`credential_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='<한글 디비명> 크리덴셜 테이블\n<설명>\n<예>';

}
//************************************************************************************************/
// 기타
//************************************************************************************************/
//------------------------------------------------------------
// Template
//------------------------------------------------------------
{
  `modify_time` datetime DEFAULT now() NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 수정일시',
  `register_time` datetime DEFAULT now() NOT NULL COMMENT '정보 등록일시',
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디(자동증가/기본키)',
  PRIMARY KEY (`id`),

  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 DEFAULT COLLATE=utf8mb4_general_ci COMMENT='테이블';


  (테이블명 설명) 

  (필드명 설명)
  (데이터 타입 설명) 
  (DB 입력데이터 예제) 
}
//------------------------------------------------------------
// 이미 처리된 테이블 설계
//------------------------------------------------------------
{
  * 카카오알리미 연동 관련 테이블 : 1차에는 빠진다. 향후 고려
  * 결재 테이블 : 1차에는 빠진다. 향후 고려
  //------------------------------------------------------------
  //  petme 자체 운영을 위한 관련 테이블들
  //------------------------------------------------------------
  * 디바이스 정보 테이블 : tb_device
  * 서버/파일 관리 테이블 : tb_server tb_file
  * 정책 테이블 : tb_policy
  * 공지사항/Q&A/댓글 테이블 : tb_petme_notice tb_petme_qna 
  * 약관 테이블 :  
      HTML 페이지로 대체한다.
      이용약관
      위치기반 서비스 이용약관
      마케팅 수신 동의 정보 : 서비스 정책에 포함되어야 함
  //------------------------------------------------------------
  //  크롤링 및 서비스 주컨텐츠 관련  테이블들
  //------------------------------------------------------------
  * 크롤링 테이블 : tb_crawling_dogpalza tb_crawling_naver_map
  * 리뷰/블로그 관리 테이블 : 
      tb_review tb_blog
  * 운영시간 테이블 : tb_place_business_hours
  * 병원 의료진 테이블 : tb_medical_staff
  * 랭킹 테이블 : tb_ranking_algorithm
  * 장소(병원,약국 등) 테이블 : tb_place
      가게의 요약정보 : 관리자에서 입력하게 처리해야
      부가혜택 

      지역화폐 
      진료비
      소식 : 네이버에서 긁어온다.
        블로그와 알림이 있다.
      만족/보통/불만족 처리 :
        2 ~ 3 불만족
        4 ~ 6 보통
        7 ~ 10 만족
  * 펫연구소 테이블(애견 컨텐츠 관리) : tb_pet_raboratory
  * 찜 테이블 : 
      최근 본 장소
      tb_watchlist
  //------------------------------------------------------------
  //  마케팅/프로모션/이벤트 관련  테이블들
  //------------------------------------------------------------
  * 이벤트(프로모션) 테이블 : tb_event
  * 기프티콘 테이블 : tb_gifticon_history
  * 포인트 테이블 : tb_point_use_history
  //------------------------------------------------------------
  //  로그인/인증 관련  테이블들
  //------------------------------------------------------------
  * 사용자 테이블/로그인 테이블/2차인증 : tb_admin_user tb_user tb_user_login_history
  //------------------------------------------------------------
  //  기타  테이블들
  //------------------------------------------------------------
  * 지도 테이블 : tb_zipcode  
}
//------------------------------------------------------------
// 크롤링 업체 질문사항 
//------------------------------------------------------------
{
  1. 이미지는 어떻게 줄 것인가?
  2. 장소에 대한 위/경도 도 끌고오는가?
  3. 강사모 답변형 게시판의 계층은 어떻게 처리해서 끌고 왔는가?
    댓글과 대댓글의 구분이 되는가?  
}
//------------------------------------------------------------
// 개발 관련 고려사항들
//------------------------------------------------------------
{
  1. ERD 작성 :
    Draw.io 온라인 erd 툴을 사용한다.
    https://app.diagrams.net/
  2. 푸시 테이블 : 고려 ( 안드로이드 FCM 또는 custom push를 쓸건지? )
  3. 공유에 대한 네이티브 기능도 필요함
  4. 통합검색을 어떻게 해야 하나? 고민해 보자
    - full text 검색의 시간이 얼마나 걸리나 고민해 봐야 함
    - 너무 오래걸린다 싶으면, 제목만 디비화시켜서 검색하는 방법을 시도해 보자....
  5. 영업시간에 대한 비정형 데이타를 저장하거나 파싱하기 위한 좋은 방법은 없을까?
  6. 휴대폰인증 테이블 : 
    강다솜님에게 물어보자. 계약이 만료되었으면 재 계약해야 한다.
    본인인증은 안하고, 단순 sms 발송만 하는 것 같다. 카카오 알림도 여기서 한다고 한다.
  7. 기타 :
    추천 검색어
    q&a 검색 카테고리
    강사모 Q&A 는 리스트를 3~4만개나 되서 제한시켜야 한다.
    스크롤시에 update 되는 형태로 해야 한다.
    스크롤바와 top 키도 구현해야 한다. >> 성능 이슈를 해결해야 함

    카메라 촬영은 flutter native로 구현해야 함 :
      댓글은 한개 이미지만 upload 할 수 있음
      리뷰는 10개 이미지만 upload 할 수 있음
      Q&A는 3개의 이미지만 upload 할 수 있음

    공유하기는 추후 공통정의 예정
    제3자 로그인 앱등록 심사시 문제가 발생하는 지 확인해야 함
}
//------------------------------------------------------------
// 의문사항 
//------------------------------------------------------------
{
  1. 향후 pet store 말고 일반 상점으로 변경될 수도 있는가? 반려동물 범위에서 벗어나지는 않을 것이다.
  2. 연락처가 여러개 있는 경우도 있는가? 가변적인 부 전화번호가 있을 수 있으므로 다른 테이블을 설계해서 이것과 연결하도록 한다.
  3. 각 상점에 대한 관리자(영업자/운영자)가 배정될 수도 있는가? 향후 있을 수도 있다.
  4. 상점에 대한 설명이 따로 존재하는가? 아무리 봐도 추천하는 설명만 있는 것으로 보인다.
  5. 이미지에 동영상은 없는가? 없다.
  6. 이미지가 어디서 왔는지 구분할 필요가 있는가? 즉, 크롤링 업체가 긁어온데로 네이버인가? 자체로 업로드한 이미지인가?
  앨범
  7. 평점은 0도 있는가? 0은 없다. 2점이 디폴트이고 5랭킹이 있는데 2씩 더한다. 반점도 있다.
  8. 의료진 프로필에서 순서가 있는가? 의료진의 병원이 겹치는 경우도 있는가?
  한 의사는 한 병원에만 있다.
  9. 해시태그는 어디어디에 있는가? 이미지 게시물마다 해시태그가 따로 있는가?
  같은 리뷰의 해시태그는 동일하다
}
//------------------------------------------------------------
// 당장 오픈할 때 필요한 것 
//------------------------------------------------------------
{
  - 랭킹 알고리즘 확립 필요
  - 우선순위에 대한 확립 필요 : 
    의사 프로필에 표시하기 위한 순서
    리뷰를 표시하기 위한 순서
  - 공유하기 확정 필요함
  - 설정창에 해당하는 것들
}
//------------------------------------------------------------
< 추후 필요한 것 >
//------------------------------------------------------------
{
  - 랭킹 알고리즘
  - 쇼핑몰
  - 제휴  
}
//------------------------------------------------------------
// 레퍼런스
//------------------------------------------------------------
{
  타입	설명	일반적인 서브타입 예시
  text	텍스트를 포함하는 모든 문서를 나타내며 이론상으로는 인간이 읽을 수 있어야 합니다	text/plain, text/html, text/css, text/javascript
  image	모든 종류의 이미지를 나타냅니다. (animated gif처럼) 애니메이션되는 이미지가 이미지 타입에 포함되긴 하지만, 비디오는 포함되지 않습니다.	image/gif, image/png, image/jpeg, image/bmp, image/webp
  audio	모든 종류의 오디오 파일들을 나타냅니다.	audio/midi, audio/mpeg, audio/webm, audio/ogg, audio/wav
  video	모든 종류의 비디오 파일들을 나타냅니다.	video/webm, video/ogg
  application	모든 종류의 이진 데이터를 나타냅니다.	application/octet-stream, application/pkcs12, application/vnd.mspowerpoint, application/xhtml+xml, application/xml, application/pdf


  Mime Type 분류
  타입	설명	타입 예시
  text	텍스트를 포함하는 모든 문서를 나타냄	text/plane
  text/html
  text/css
  text/javascript
  text/*
  image	모든 종류의 이미지를 나타냄	image/gif
  image/png
  image/jpeg
  image/bmp
  image/webp
  image/*
  audio	모든 종류의 오디오를 나타냄	audio/midi
  audio/mpeg
  audio/webm
  audio/ogg
  audio/wav
  audio/*
  video	모든 종류의 비디오 파일을 나타냄	video/webm
  video/ogg
  video/*
  application	모든 종류의 이진 데이터를 나타냄	application/octet_stream
  application/pkcs12
  application/vnd.mspowerpoint
  application/xhtml+xml
  application/xml
  application/pdf

  //----- 기타
  mod : modification 수정 변경
  이미지 엔코딩 ffmpeg 사용한다.

  타입	설명	일반적인 서브타입 예시
  text	텍스트를 포함하는 모든 문서를 나타내며 이론상으로는 인간이 읽을 수 있어야 합니다	text/plain, text/html, text/css, text/javascript
  image	모든 종류의 이미지를 나타냅니다. (animated gif처럼) 애니메이션되는 이미지가 이미지 타입에 포함되긴 하지만, 비디오는 포함되지 않습니다.	image/gif, image/png, image/jpeg, image/bmp, image/webp
  audio	모든 종류의 오디오 파일들을 나타냅니다.	audio/midi, audio/mpeg, audio/webm, audio/ogg, audio/wav
  video	모든 종류의 비디오 파일들을 나타냅니다.	video/webm, video/ogg
  application	모든 종류의 이진 데이터를 나타냅니다.	application/octet-stream, application/pkcs12, application/vnd.mspowerpoint, application/xhtml+xml, application/xml, application/pdf


  Mime Type 분류
  타입	설명	타입 예시
  text	텍스트를 포함하는 모든 문서를 나타냄	text/plane
  text/html
  text/css
  text/javascript
  text/*
  image	모든 종류의 이미지를 나타냄	image/gif
  image/png
  image/jpeg
  image/bmp
  image/webp
  image/*
  audio	모든 종류의 오디오를 나타냄	audio/midi
  audio/mpeg
  audio/webm
  audio/ogg
  audio/wav
  audio/*
  video	모든 종류의 비디오 파일을 나타냄	video/webm
  video/ogg
  video/*
  application	모든 종류의 이진 데이터를 나타냄	application/octet_stream
  application/pkcs12
  application/vnd.mspowerpoint
  application/xhtml+xml
  application/xml
  application/pdf



  < comment >
  ranking : 
    순위/등급/서열/평점 등을 나타낸다.
    원래는, 아래와 같이 설계해야 하지만,
    -- 아래 --
    자료형은 smallint(6) unsigned NOT NULL 으로 표현한다.
    랭킹을 만자리(5자리) 단위로 표시할 수도 있기 때문에 6으로 표시한다. 즉, smallint(6) 이다.
    또, smallint unsigned일 경우에 0 ~ 65535까지 표시할 수 있다.
    바이트를 절약하기 위해서, varchar로 설계하지 않았다.
    ----------
    코딩의 번거로움을 피하기 위해서 varchar로 표현한다.
    성능이 떨어지면, 위와 같이 다시 정수형이나 실수형으로 바꿀 필요가 있다.


  http://192.168.0.37:8008/api/main/ranking
  get
  http://192.168.0.37:8008/ranking

  {
    "ranking": [
      {
        "title": "예은동물병원",
        "ranking": "10.0",
        "review_count": "188",
        "latitude": "37.51060190000046",
        "longitude": "126.97432350097529"
      },
      {
        "title": "위너스동물병원",
        "ranking": "10.0",
        "review_count": "399",
        "latitude": "37.488039500000006",
        "longitude": "127.02394300097735"
      },
      {
        "title": "24시 SNC 동물메디컬센터",
        "ranking": "10.0",
        "review_count": "122",
        "latitude": "37.488039500000006",
        "longitude": "127.02394300097735"
      },
      {
        "title": "드림 동물병원",
        "ranking": "10.0",
        "review_count": "72",
        "latitude": "37.488039500000006",
        "longitude": "127.02394300097735"
      },
      {
        "title": "고양이 병원 백산동물병원",
        "ranking": "10.0",
        "review_count": "221",
        "latitude": "37.55875799999908",
        "longitude": "126.98384720097702"
      },
      {
        "title": "츄츄동물병원",
        "ranking": "10.0",
        "review_count": "523",
        "latitude": "37.49238799999997",
        "longitude": "126.99013100097879"
      },
      {
        "title": "닥터박동물병원",
        "ranking": "10.0",
        "review_count": "268",
        "latitude": "37.49238799999997",
        "longitude": "126.99013100097879"
      },
      {
        "title": "동물병원 다온",
        "ranking": "10.0",
        "review_count": "377",
        "latitude": "37.49238799999997",
        "longitude": "126.99013100097879"
      }
    ]
  }
}

//************************************************************************************************/
// 전체 스키마 스크립트
//************************************************************************************************/
//------------------------------------------------------------
// tb_otp : OTP를 위한 테이블
//------------------------------------------------------------
{
  create table `tb_otp`
  (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '아이디',
    `phone` varchar(20) NOT NULL COMMENT '전화번호',
    `otp` varchar(6) NOT NULL COMMENT 'otp',
    `register_time` datetime DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '생성일시',
	  `expiration_time` datetime DEFAULT (CURRENT_TIMESTAMP + INTERVAL 3 MINUTE) NOT NULL COMMENT '만료일시',
    PRIMARY KEY (`id`),
    UNIQUE KEY `index_tb_otp_phone` (`phone`)    
  );
}
{
  //------------------------------------------------------------
  // 테이블 및 컬럼 설명
  //------------------------------------------------------------
  tb_otp : 
  (테이블명 설명) 
    SMS로 otp를 발송하여 본인 확인을 하기 위한 테이블이다.
  --------------------------------------------------------------

  id : 공통설명 참조

  tb_user_id :
  (테이블명 설명) 
    tb_user 테이블의 id를 나타낸다.
  (DB 입력데이터 예제) 
    unsigned 정수형 숫자이다.  
    18 2045 398 40056 

  phone : 전화번호

  otp : 일회성 패스워드

  expiration_time : 패스워드 만료일시

  register_time : 공통설명 참조
}