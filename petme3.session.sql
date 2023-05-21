-- 메인:랭킹목록
SELECT 
   COUNT(*) OVER() AS total_count, 
   X.place_id,
   X.ranking, 
   X.total_review_count, 
   X.distance, 
   X.place_name, 
   X.image_url 
FROM
(
   SELECT       
   	  a.id AS place_id,
      (TRIM(a.ranking) + 0) AS ranking,
      (IFNULL(a.blog_review_count, 0) + IFNULL(a.visitor_review_count, 0)) AS total_review_count,
      @rest_meter := ROUND(ST_Distance_Sphere(POINT(a.longitude, a.latitude), POINT(@input_longitude, @input_latitude))) '',
      IF (@rest_meter > 1000, CONCAT(CONVERT(ROUND(@rest_meter/1000, 1), CHAR), 'km'), CONCAT(CONVERT(@rest_meter, CHAR), 'm')) AS distance,
      TRIM(a.NAME) AS place_name, 
      if (a.id NOT IN(SELECT bb.id FROM tb_file aa, tb_place bb WHERE bb.id = aa.tb_place_id), '',
         (SELECT 
            CONCAT('http://', (SELECT z.ip1 FROM tb_server z, tb_file y WHERE z.id = y.tb_server_id AND y.tb_place_id = a.id), full_path, '/', save_name) 
         FROM tb_file WHERE tb_place_id = a.id)) AS image_url
   FROM 
      tb_place AS a,
      (SELECT @rownum := 0) AS b,
      (SELECT @rest_meter := 0) AS c,
      (SELECT @input_longitude := 127.027528) AS d, -- longitude 
      (SELECT @input_latitude := 37.497637) AS e, -- latitude
      (SELECT MIN(zipcode) AS from_zipcode, MAX(zipcode) AS to_zipcode
           FROM tb_zipcode
          WHERE sido = '서울특별시' AND sigungu = '강남구') AS f -- sido, sigungu
  WHERE
      a.zipcode BETWEEN f.from_zipcode AND f.to_zipcode
      AND a.business_gubun = '동물병원' -- business_gubun
   ORDER BY ranking DESC
) X LIMIT 4 OFFSET 0;

-- 메인:베스트리뷰 목록
SELECT
    X.place_id,
    X.grade,
    X.writer,
    X.register_time,
    X.place_name,
    X.content,
    X.image_url
FROM
(
    SELECT
    	c.id AS place_id,
        d.grade,
        d.writer,
        d.register_time,
        d.content,
        TRIM(c.name) AS place_name,
        CONCAT('http://', a.ip1, b.full_path, '/', b.save_name) AS image_url, b.size, b.width, b.height
    FROM
        tb_server AS a, 
        tb_file AS b, 
        tb_place AS c, 
        tb_review AS d,
        (SELECT MIN(zipcode) AS from_zipcode, MAX(zipcode) AS to_zipcode
           FROM tb_zipcode
          WHERE sido = '서울특별시' AND sigungu = '강남구') AS e -- sido, sigungu
    WHERE c.id = b.tb_place_id
      AND a.id = b.tb_server_id
      AND b.main_image_yn = 'y'
      AND b.gubun = 'image|장소-메인'
      AND c.zipcode BETWEEN e.from_zipcode AND e.to_zipcode
      AND c.business_gubun = '동물병원' -- business_gubun
      AND c.id = d.tb_place_id
    GROUP BY d.id
    ORDER BY d.grade DESC
    LIMIT 0, 4 -- page, size
) X;

-- 메인:추천목록
SELECT
    X.place_id,
    X.ranking,
    X.total_review_count,
    X.distance,
    X.rest_meter,
    X.place_name,
    X.sido,
    X.sigungu,
    X.image_url
FROM
(
    SELECT
    	d.id AS place_id,
        (TRIM(d.ranking) + 0) AS ranking,
        SUM(IFNULL(d.blog_review_count, 0) + IFNULL(d.visitor_review_count, 0)) AS total_review_count,
        @rest_meter := ROUND(ST_Distance_Sphere(POINT(d.longitude, d.latitude), POINT(@input_longitude, @input_latitude))) AS rest_meter,
        IF (@rest_meter > 1000, CONCAT(CONVERT(ROUND(@rest_meter/1000, 1), CHAR), 'km'),
            CONCAT(CONVERT(@rest_meter, CHAR), 'm')) AS distance,
        TRIM(d.NAME) AS place_name,
        CONCAT('http://', a.ip1, b.full_path, '/', b.save_name) AS image_url, b.size, b.width, b.height,
        i.sido,
        i.sigungu
    FROM
        tb_server AS a, 
        tb_file AS b, 
        tb_place AS c, 
        tb_place AS d,
        (SELECT @rownum := 0) AS e,
        (SELECT @rest_meter := 0) AS f,
        (SELECT @input_longitude := 127.027528) AS g, -- longitude, latitude
        (SELECT @input_latitude := 37.497637) AS h,
        (SELECT 
           MIN(zipcode) AS from_zipcode, 
           MAX(zipcode) AS to_zipcode,
           sido,
           sigungu
           FROM tb_zipcode
          WHERE sido = '서울특별시' AND sigungu = '강남구') AS i -- sido, sigungu
    WHERE c.id = b.tb_place_id
      AND a.id = b.tb_server_id
      AND b.main_image_yn = 'y'
      AND b.gubun = 'image|장소-메인'
      AND c.zipcode BETWEEN i.from_zipcode AND i.to_zipcode
      AND c.business_gubun = '동물병원' -- business_gubun
    GROUP BY d.id
    ORDER BY rest_meter ASC, ranking DESC
    LIMIT 0, 4 -- page, size
) X;

-- 메인: 팻연구소 콘텐츠 목록
SELECT 
	a.id AS content_id, 
	a.category,
	a.title,
	a.hashtag,
	CONCAT('http://', b.ip1, c.full_path, '/', c.save_name) AS image_url
  FROM tb_pet_raboratory a, tb_server b, tb_file c
 WHERE c.tb_pet_raboratory_id = a.id
 ORDER BY a.register_time DESC
 LIMIT 0, 4;
 
-- 메인:랭킹목록
