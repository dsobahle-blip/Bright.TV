--- Removing the none rows from user profiles
SELECT  *,
    COALESCE(TRIM(Name), "") AS Name,
    COALESCE(TRIM(Surname), "") AS Surname,
    COALESCE(NULLIF(REPLACE(TRIM(Email), ' ', ''), ''), "") AS Email,
    COALESCE(TRIM(Gender), "") AS Gender,
    COALESCE(TRIM(Race), "") AS Race,
    COALESCE(CAST(Age AS STRING), "") AS Age,
    COALESCE(CAST(UserID AS STRING), "") AS UserID,
    COALESCE(TRIM(Province), "") AS Province,
    COALESCE(TRIM(`Social Media Handle`), "") AS `Social Media Handle`
FROM `workspace`.`brighttv`.`user_profiles`;

--- RETRIEVING 5000 rows from Viewership Table.
select * from `workspace`.`brighttv`.`viewership` limit 5000--- RETRIEVING 5000 rows from User_prifiles Table.
select * from `workspace`.`brighttv`.`user_profiles` limit 5000;

---Removing the NONE
SELECT (*)
FROM `workspace`.`default`.`user_profiles`
WHERE Name != 'None' 
  AND Name IS NOT NULL 
  AND TRIM(Name) != ''
  AND Province != 'None';

---
SELECT Province,
    SUM(A.RecordDate2) AS total_watch_time
FROM `workspace`.`brighttv`.`viewership` AS A
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS B
ON A.`UserID0` = B.`UserID`
GROUP BY Province
ORDER BY total_watch_time DESC
LIMIT 3;

--- Average Age
SELECT  AVG(CASE 
            WHEN B.Age BETWEEN 20 and 60 THEN B.Age 
            ELSE NULL 
        END) AS avg_age_long_watch
FROM `workspace`.`brighttv`.`viewership` AS A
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS B
ON A.`UserID0` = B.`UserID`;

--- Most Viewed channel
select SUM(`userid4`) , Channel2 AS Most_watched_Channel
from `workspace`.`brighttv`.`viewership` 
group by Channel2
order by Most_watched_Channel DESC
limit 10;

--- Channel watched the most
SELECT 
    A.Channel2,
    COUNT(A.Channel2) AS total_views
FROM `workspace`.`brighttv`.`viewership` AS A
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS B
ON A.`UserID0` = B.`UserID`
GROUP BY A.Channel2
ORDER BY total_views DESC
LIMIT 1;

---Gender that watches the most
SELECT 
    B.Gender,
    COUNT(*) AS total_views
FROM `workspace`.`brighttv`.`viewership` AS A
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS B
ON A.`UserID0` = B.`UserID`
GROUP BY B.Gender
ORDER BY total_views DESC
LIMIT 1;

--- Number of Race
SELECT 
    Race,
    COUNT(*) AS total_count
FROM `workspace`.`brighttv`.`user_profiles`
GROUP BY Race;

--- Least Viewed channel
SELECT SUM(`userid4`) AS view_count, Channel2 AS Least_watched_Channel
FROM`workspace`.`brighttv`.`viewership` 
GROUP BY Channel2
ORDER BY view_count ASC
LIMIT 10;

--- Total number of Channels
SELECT DISTINCT Channel2
FROM `workspace`.`brighttv`.`viewership`
ORDER BY Channel2;



--- Most viewed Channels per Province
select B.`Province`, COUNT(A.`userid4`) AS sum_of_views, A.Channel2
from `workspace`.`brighttv`.`viewership` AS A
inner join `workspace`.`brighttv`.`user_profiles` AS B
on A.`UserID0` = B.`UserID`
group by B.`Province`, A.Channel2
order by  sum_of_views DESC;

--- Channels with the most duration 
SELECT 
    Channel2,
    COUNT(`Duration 2`) AS total_watch_time
FROM `workspace`.`brighttv`.`viewership`
GROUP BY Channel2
ORDER BY total_watch_time DESC
LIMIT 5;

--- Time Converting from UCT to CAT
select 
  RecordDate2,
  from_utc_timestamp(RecordDate2, '+00:00') as utc_time,
  from_utc_timestamp(RecordDate2, '+02:00') as local_time
from `workspace`.`brighttv`.`viewership`
order by local_time;

--- Average views on per Province
SELECT A.Channel2, COUNT(A.`duration 2`) AS daily_viewed
FROM `workspace`.`brighttv`.`viewership` AS A
GROUP BY A.Channel2
ORDER BY daily_viewed;

--- When, Where and Who watches the channels
SELECT B.Age, B.Name, B.Surname, B.Province, A.RecordDate2, A.Channel2, COUNT(*) AS total_views
FROM `workspace`.`brighttv`.`viewership` AS A
JOIN `workspace`.`brighttv`.`user_profiles` AS B
ON A.UserID0 = B.UserID
GROUP BY B.Age, B.Name, B.Surname, B.Province, A.RecordDate2, A.Channel2;

---
SELECT 
    A.Channel2,
    A.RecordDate2,
    B.Name,
    B.Email
FROM `workspace`.`brighttv`.`viewership` AS A
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS B
ON A.UserID0 = B.UserID;

--- How many watch the Channel 
SELECT 
    A.Channel2,
    B.Gender,
    COUNT(*) AS total_views
FROM `workspace`.`brighttv`.`viewership` AS A
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS B
ON A.UserID0 = B.UserID
GROUP BY A.Channel2, B.Gender;

--- Who watches the most
SELECT 
    B.Name,
    COUNT(A.`Duration 2`) AS total_watch_time
FROM `workspace`.`brighttv`.`viewership` AS A
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS B
ON A.UserID0 = B.UserID
GROUP BY B.Name
ORDER BY total_watch_time DESC
LIMIT 10;

--- Viewers per day
SELECT  A.RecordDate2,
    SUM(DISTINCT A.UserID0) AS daily_viewers
FROM `workspace`.`brighttv`.`viewership` AS A
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS B
ON A.UserID0 = B.UserID
GROUP BY A.RecordDate2
ORDER BY A.RecordDate2;

--- Viewers during the month of February 
SELECT  B.Province,
    A.Channel2,
    DATE(A.RecordDate2) AS view_month,
    COUNT(DISTINCT A.UserID0) AS daily_viewers
    FROM A.RecordDate2 '2016-01-01' BETWEEN A.RecordDate2 '2016-02-28'
FROM `workspace`.`brighttv`.`viewership` AS A
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS B
ON A.UserID0 = B.UserID
GROUP BY DATE(A.RecordDate2), A.Channel2, B.Province
ORDER BY daily_viewers DESC,B.Province, A.Channel2 DESC;

--- Viewers during the school holidays
SELECT 
    B.Province,
    A.Channel2,
    DATE(A.RecordDate2) AS view_month,
    COUNT(DISTINCT A.UserID0) AS daily_viewers
FROM `workspace`.`brighttv`.`viewership` AS A
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS B
ON A.UserID0 = B.UserID
WHERE A.RecordDate2 BETWEEN '2016-01-03' AND '2016-01-13'
GROUP BY DATE(A.RecordDate2), A.Channel2, B.Province
ORDER BY daily_viewers DESC,B.Province, A.Channel2 DESC;

--- Retrieving all the Rows of the JOIN tables
SELECT *
FROM `workspace`.`brighttv`.`viewership` AS V
JOIN `workspace`.`brighttv`.`user_profiles` AS U
  ON U.UserID = V.UserID0;

--- Checking if theres no Duplicates
SELECT DISTINCT UserID0, Channel2, `Duration 2`
FROM `workspace`.`brighttv`.`viewership`;

--- Removing Null values
SELECT *
FROM `workspace`.`brighttv`.`viewership` AS V
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS U
  ON U.UserID = V.UserID0
WHERE V.UserID0 IS NULL 
   OR V.Channel2 IS NULL 
   OR V.RecordDate2 IS NULL 
   OR V.`Duration 2` IS NULL 
   OR V.UserID4 IS NULL
   OR U.Province IS NULL
   OR U.Race IS NULL
   OR U.Email IS NULL
   OR U.Gender IS NULL;

--- Removing IS NOT None values
SELECT *
FROM `workspace`.`brighttv`.`viewership` AS V
JOIN `workspace`.`brighttv`.`user_profiles` AS U
  ON U.UserID = V.UserID0
WHERE UserID0 IS NOT NULL 
   OR V.Channel2 IS NOT NULL 
   OR V.RecordDate2 IS NOT NULL 
   OR V.`Duration 2` IS NOT NULL 
   OR V.Userid4 IS NOT NULL
   OR U.Province IS NOT NULL
   OR U.Race IS NOT NULL
   OR U.Email IS NOT NULL
   OR U.Gender IS NOT NULL;

--- Time Buckets
SELECT 
      V.RecordDate2,
      Dayname(V.RecordDate2) AS Day_name,
      Monthname(V.RecordDate2) AS Month_name
FROM `workspace`.`brighttv`.`viewership` AS V
JOIN `workspace`.`brighttv`.`user_profiles` AS U
  ON U.UserID = V.UserID0;

--- Clean user profiles
SELECT 
  CASE 
   WHEN LOWER(TRIM(Province)) = 'kwazulu natal' THEN 'KwaZulu Natal'
   WHEN Province IS NULL OR TRIM(Province) = '' THEN 'Unknown'
   ELSE TRIM(Province)
   END AS Province
FROM `workspace`.`brighttv`.`user_profiles`;
     
SELECT
      UserID,
      INITCAP(TRIM(Province)) AS clean_Province,
      REPLACE(Email, 'gmial.com', 'gmail.com') AS clean_email, 
     CASE
       WHEN Age < 0 THEN NULL
       ELSE Age
       END AS clean_age
FROM `workspace`.`brighttv`.`user_profiles`;

--- TIME BUCKETS with DAY CLASSIFICATION
SELECT 
      V.RecordDate2 AS purchase_date,
      Dayname(V.RecordDate2) AS Day_name,
      Monthname(V.RecordDate2) AS Month_name,
      Dayofmonth(V.RecordDate2) AS day_of_month,

      CASE 
            WHEN Dayname(V.RecordDate2) IN ('Sun','Sat') THEN 'Weekend'
            ELSE 'Weekday'
      END AS day_classifiction,

      --date_format(V.RecordDate2, 'HH:mm:ss') AS purchase_time,
      CASE
            WHEN date_format(V.RecordDate2, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning'
            WHEN date_format(V.RecordDate2, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '02. Afternoon'
            WHEN date_format(V.RecordDate2, 'HH:mm:ss') BETWEEN '17:00:00' AND '23:59:59' THEN '03. Evening'
      END AS time_buckets
      FROM `workspace`.`brighttv`.`viewership` AS V
JOIN `workspace`.`brighttv`.`user_profiles` AS U
  ON U.UserID = V.UserID0
GROUP BY V.RecordDate2,
         Dayname(V.RecordDate2),
         Monthname(V.RecordDate2),
         Dayofmonth(V.RecordDate2);

--- Number of Subscribers per Channel
SELECT 
  V.Channel2,
  COUNT(DISTINCT V.UserID0) AS unique_Subscribers,
  COUNT(*) AS total_views
FROM `workspace`.`brighttv`.`viewership` AS V
JOIN `workspace`.`brighttv`.`user_profiles` AS U
  ON U.UserID = V.UserID0
GROUP BY V.Channel2;

--- Performance of Channels per Province
SELECT 
  V.Channel2,
  COUNT(DISTINCT V.UserID0) AS unique_Subscribers,
  COUNT(*) AS total_views,
  LOWER(TRIM(U.Province)) AS Province
FROM `workspace`.`brighttv`.`viewership` AS V
JOIN `workspace`.`brighttv`.`user_profiles` AS U
  ON U.UserID = V.UserID0
GROUP BY V.Channel2, U.Province;

--- Time Converting from UCT to CAT
SELECT
  RecordDate2,
  FROM_utc_timestamp(RecordDate2, '+00:00') as utc_time,
  FROM_utc_timestamp(RecordDate2, '+02:00') as local_time
FROM `workspace`.`brighttv`.`viewership`
ORDER BY local_time;

--- Age average that watches which channel
SELECT 
    V.Channel2,
    AVG(U.Age) AS avg_age
FROM `workspace`.`brighttv`.`viewership` AS V
JOIN `workspace`.`brighttv`.`user_profiles` AS U
  ON U.UserID = V.UserID0
GROUP BY V.Channel2;

--- How many watch the Channel 
SELECT 
    V.Channel2,
    U.Gender,
    COUNT(*) AS total_views
FROM `workspace`.`brighttv`.`viewership` AS V
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS U
ON V.UserID0 = U.UserID
GROUP BY V.Channel2, U.Gender;

--- Viewers per day
SELECT V.UserID0,
       V.Channel2,
       V.RecordDate2,
       COUNT(DISTINCT V.UserID0) AS daily_viewers
FROM `workspace`.`brighttv`.`viewership` AS V
LEFT JOIN `workspace`.`brighttv`.`user_profiles` AS U
ON V.UserID0 = U.UserID
GROUP BY V.Channel2, V.RecordDate2, V.UserID0 
ORDER BY V.RecordDate2;

SELECT
  V.Channel2,
  V.RecordDate2,
  FROM_utc_timestamp(V.RecordDate2, '+00:00') AS utc_time,
  FROM_utc_timestamp(V.RecordDate2, '+02:00') AS local_time,
  V.RecordDate2 AS view_date,
  dayname(V.RecordDate2) AS Day_name,
  date_format(V.RecordDate2, 'MMMM') AS Month_name,
  dayofmonth(V.RecordDate2) AS day_of_month,
  CASE 
    WHEN dayname(V.RecordDate2) IN ('Sun','Sat') THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_classification,
  U.Age,
  CASE
    WHEN U.Age < 3 THEN 'Child'

CREATE OR REPLACE TABLE brighttv_analysis_long AS SELECT
v.UserID,
p.Name, 
p.Surname, 
p.Email, 
p.Gender, 
p.Race, 
p.Age, 
p.Age_Group, 
p.Province,
p.Social_Media_Handle,

v.Channel, 
v.RecordDate_UTC, 
v.RecordDate_CAT,
v.View_Date, 
v.View_Time, 
v.Duration_Seconds, 
v.Duration_Minutes, 
v.ID_Match_Flag,
DATE_FORMAT(v.View_Date, 'EEEE') AS Day_Name, 
  CASE
WHEN DATE_FORMAT(v.View_Date, 'u') IN ('6', '7') THEN 'Weekend'
ELSE 'Weekday' 
  END AS Day_Type,

CASE
   WHEN HOUR(v.RecordDate_CAT) BETWEEN 5 AND 11 THEN 'Morning' 
   WHEN HOUR(v.RecordDate_CAT) BETWEEN 12 AND 16 THEN 'Afternoon' 
   WHEN HOUR(v.RecordDate_CAT) BETWEEN 17 AND 21 THEN 'Evening' 
  ELSE 'Late Night'
END AS Time_Period

FROM tv_viewer_analysis_ready v 
LEFT JOIN tv_profile_clean p
ON v.UserID = p.UserID;
