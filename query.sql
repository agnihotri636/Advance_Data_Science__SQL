
1. Write a query that lists the theaters and the districts which are showing the movie
with the title ‘Beautiful’.

SELECT DISTINCT t.Name AS TheaterName, d.Name AS DistrictName
FROM movies m
JOIN movies2theaters m2t ON m.MovieCode = m2t.MovieCode
JOIN theaters t ON m2t.TheaterCode = t.TheaterCode
JOIN theaters2districts t2d ON t.TheaterCode = t2d.TheaterCode
JOIN districts d ON t2d.DistrictCode = d.DistrictCode
WHERE m.Title = 'Beautiful';
+-------------------------+----------------+
| TheaterName | DistrictName |
+-------------------------+----------------+
| Cineplex Odeon Meridian | CAPITOL HILL |
| Cineplex Odeon Meridian | THE U DISTRICT |
| Cineplex Odeon Meridian | DOWNTOWN |
+-------------------------+----------------+
3 rows in set (0.00 sec)

2. Write a Relational Algebra expression for the query in the previous question.

π TheaterName, DistrictName (σ Title='Beautiful' (movies ⨝ movies2theaters ⨝ theaters ⨝
theaters2districts ⨝ district))

3. Write a query that lists the name and address of theatres playing movies with length
greater than 100.

SELECT DISTINCT t.Name, t.Address
FROM theaters t
JOIN movies2theaters m2t ON t.TheaterCode = m2t.TheaterCode
JOIN movies m ON m2t.MovieCode = m.MovieCode
WHERE m.Length > 100;

+----------------------------------+---------------------------------------------------+
| Name | Address |
+----------------------------------+---------------------------------------------------+
| Cineplex Odeon Northgate | 10 Northgate Plaza | Seattle, WA 98125 |
| Cineplex Odeon Uptown | 511 Queen Anne Avenue North | Seattle, WA 98109 |
| Landmark Varsity Theatre | 4329 University Way, NE | Seattle, WA 98105 |
| Landmark Seven Gables Theatre | 911 NE 50th | Seattle, WA 98105 |
| Landmark Metro Cinemas | 4500 9th Avenue NE, Suite 200 | Seattle, WA 98105 |
| Landmark Harvard Exit Theatre | 807 E.Roy | Seattle, WA 98102 |
| Landmark Guild 45th | 2115 N. 45th | Seattle, WA 98103 |
| Landmark Broadway Market Cinemas | 425 Broadway East | Seattle, WA 98102 |
| Cineplex Odeon Meridian | 1501 7th Avenue | Seattle, WA 98101 |
| General Cinema Pacific Place 11 | 600 Pine St. #406 | Seattle, WA 98101 |
| General Cinema Cinerama | 2100 4th Avenue | Seattle, WA 98121 |
+----------------------------------+---------------------------------------------------+
11 rows in set (0.01 sec)

4. Write a Relational Algebra expression for the query in the previous question.

π Name, Address (theaters ⨝ movies2theaters ⨝ (σ Length > 100 (movies)))

5. Write a query that lists the movie name, movie length and district name of the longest
movie played in each district.

SELECT m.Title AS movie_name, m.Length AS movie_length, d.Name AS district_name
FROM districts d
JOIN theaters2districts t2d ON d.DistrictCode = t2d.DistrictCode
JOIN theaters t ON t2d.TheaterCode = t.TheaterCode
JOIN movies2theaters m2t ON t.TheaterCode = m2t.TheaterCode
JOIN movies m ON m2t.MovieCode = m.MovieCode
WHERE m.Length = (
 SELECT MAX(m2.Length)
 FROM movies m2
 JOIN movies2theaters m2t2 ON m2.MovieCode = m2t2.MovieCode
 JOIN theaters t2 ON m2t2.TheaterCode = t2.TheaterCode
 JOIN theaters2districts t2d2 ON t2.TheaterCode = t2d2.TheaterCode
 WHERE t2d2.DistrictCode = d.DistrictCode
)
GROUP BY d.Name, m.Title, m.Length
ORDER BY d.Name ASC;

+------------+--------+----------------+
| movie_name | Length | district_name |
+------------+--------+----------------+
| Get Carter | 147 | CAPITOL HILL |
| Get Carter | 147 | DOWNTOWN |
| Get Carter | 147 | THE U DISTRICT |
+------------+--------+----------------+
3 rows in set (1.52 sec) 3 rows in set (0.01 sec)

6. Write a Relational Algebra expression for the query in the previous question.

π Title, Length, districts.Name (σ Length = MAX(Length) (movies ⨝ movies2theaters ⨝ (theaters
⨝ theaters2districts ⨝ districts))) ÷ MAX(Length) (π Length (movies ⨝ movies2theaters ⨝
(theaters ⨝ theaters2districts ⨝ districts)))

7. Draw the query plan/tree for the Relational Algebra expression from the previous question.

 π
 Title
 Length
 Name
 |
 ⨝
 movies
 movies2theaters
 theaters
 theaters2districts
 district
 |
 ⨝
 movies
 |
 σ
 Length = MAX(Length)
 |
 π
 MAX(Length)
 |
 Movies
 
8. Write a query that lists the theater name, phone and the number of movies played by the
theaters in ‘The U District’ district, where each theater plays less than 3 movies. The
theatres must be sorted in descending order by the number of movies shown by each
theater. Each of them should play at least 1 movie.

SELECT DISTINCT t.Name AS TheaterName, t.Phone, COUNT(m2t.MovieCode) AS NumMovies
FROM theaters t
JOIN theaters2districts t2d ON t.TheaterCode = t2d.TheaterCode
JOIN districts d ON t2d.DistrictCode = d.DistrictCode
JOIN movies2theaters m2t ON t.TheaterCode = m2t.TheaterCode
WHERE d.Name = 'The U District' AND t.TheaterCode IN (
 SELECT TheaterCode FROM movies2theaters
 GROUP BY TheaterCode
 HAVING COUNT(DISTINCT MovieCode) < 3 AND COUNT(DISTINCT MovieCode) > 0)
GROUP BY t.Name, t.Phone
ORDER BY COUNT(m2t.MovieCode) DESC;

+----------------------------------+----------------+-----------+
| TheaterName | Phone | NumMovies |
+----------------------------------+----------------+-----------+
| Landmark Broadway Market Cinemas | (206) 323-0231 | 14 |
| Cineplex Odeon City Centre | (206) 622-6465 | 6 |
| Landmark Guild 45th | (206) 633-3353 | 6 |
| Landmark Harvard Exit Theatre | (206) 323-8986 | 6 |
| Cineplex Odeon Northgate | (206) 363-5800 | 3 |
| Landmark Neptune Theatre | (206) 633-5545 | 3 |
| Landmark Seven Gables Theatre | (206) 632-8820 | 2 |
| Landmark Varsity Theatre | (206) 632-3131 | 2 |
+----------------------------------+----------------+-----------+
8 rows in set (0.01 sec)

9. Write a query that lists the theater name, phone, address, and district name of theaters
playing ‘Meet the Parents’ or any ‘NR’-rated movie.
SELECT DISTINCT t.Name AS TheaterName, t.Phone, t.Address, d.Name AS DistrictName
FROM theaters t
JOIN theaters2districts t2d ON t.TheaterCode = t2d.TheaterCode
JOIN districts d ON t2d.DistrictCode = d.DistrictCode
JOIN movies2theaters m2t ON t.TheaterCode = m2t.TheaterCode
JOIN movies m ON m2t.MovieCode = m.MovieCode
WHERE m.Title = 'Meet the Parents' OR m.Rating = 'NR';

+---------------------------------+----------------+-------------------------------------------------+----------------+
| TheaterName | Phone | Address | DistrictName |
+---------------------------------+----------------+-------------------------------------------------+----------------+
| Cineplex Odeon Uptown | (206) 285-1022 | 511 Queen Anne Avenue North | Seattle, WA
98109 | CAPITOL HILL |
| Cineplex Odeon Uptown | (206) 285-1022 | 511 Queen Anne Avenue North | Seattle, WA
98109 | THE U DISTRICT |
| Cineplex Odeon Uptown | (206) 285-1022 | 511 Queen Anne Avenue North | Seattle, WA
98109 | DOWNTOWN |
| Landmark Varsity Theatre | (206) 632-3131 | 4329 University Way, NE | Seattle, WA 98105
| CAPITOL HILL |
| Landmark Varsity Theatre | (206) 632-3131 | 4329 University Way, NE | Seattle, WA 98105
| THE U DISTRICT |
| Landmark Varsity Theatre | (206) 632-3131 | 4329 University Way, NE | Seattle, WA 98105
| DOWNTOWN |
| Landmark Guild 45th | (206) 633-3353 | 2115 N. 45th | Seattle, WA 98103 |
CAPITOL HILL |
| Landmark Guild 45th | (206) 633-3353 | 2115 N. 45th | Seattle, WA 98103 | THE
U DISTRICT |
| Landmark Guild 45th | (206) 633-3353 | 2115 N. 45th | Seattle, WA 98103 |
DOWNTOWN |
| General Cinema Pacific Place 11 | (206) 652-2404 | 600 Pine St. #406 | Seattle, WA 98101 |
CAPITOL HILL |
| General Cinema Pacific Place 11 | (206) 652-2404 | 600 Pine St. #406 | Seattle, WA 98101 |
THE U DISTRICT |
| General Cinema Pacific Place 11 | (206) 652-2404 | 600 Pine St. #406 | Seattle, WA 98101 |
DOWNTOWN |
+---------------------------------+----------------+-------------------------------------------------+----------------+
12 rows in set (0.01 sec)

10. Write a query that lists all theaters name, movie name, movie rating, movie length, and
phones numbers sorted in ascending order in ‘DOWNTOWN’ district that play the longest
‘PG-13’-rated movie or the shortest ‘R-rated’-movie.

SELECT DISTINCT t.Name AS TheaterName, m.Title AS MovieName, m.Rating AS MovieRating,
m.Length AS MovieLength, t.Phone
FROM theaters t
JOIN theaters2districts t2d ON t.TheaterCode = t2d.TheaterCode
JOIN districts d ON t2d.DistrictCode = d.DistrictCode
JOIN movies2theaters m2t ON t.TheaterCode = m2t.TheaterCode
JOIN movies m ON m2t.MovieCode = m.MovieCode
WHERE d.Name = 'DOWNTOWN' AND (
 m.Rating = 'PG-13' AND m.Length = (SELECT MAX(Length) FROM movies WHERE Rating = 'PG13')
 OR m.Rating = 'R' AND m.Length = (SELECT MIN(Length) FROM movies WHERE Rating = 'R')
)
ORDER BY t.Name ASC;

+-------------------------+----------------+-------------+-------------+----------------+
| TheaterName | MovieName | MovieRating | MovieLength | Phone |
+-------------------------+----------------+-------------+-------------+----------------+
| Cineplex Odeon Meridian | Beautiful | PG-13 | 112 | (206) 223-9600 |
| Cineplex Odeon Meridian | The Ladies Man | R | 84 | (206) 223-9600 |
+-------------------------+----------------+-------------+-------------+----------------+
2 rows in set (0.00 sec)

11. Write a query that lists the average length of movies played in ‘Boeing Imax Theater’.
SELECT AVG(m.Length) AS avg_length
FROM movies m
JOIN movies2theaters m2t ON m.MovieCode = m2t.MovieCode
JOIN theaters t ON m2t.TheaterCode = t.TheaterCode
WHERE t.Name = 'Boeing Imax Theater';

12. Write a query that lists the district names that the theater "General Cinema Pacific Place
11" belongs to. Note that a theater may belong to multiple districts.
SELECT DISTINCT d.Name AS DistrictName
FROM theaters t
JOIN theaters2districts t2d ON t.TheaterCode = t2d.TheaterCode
JOIN districts d ON t2d.DistrictCode = d.DistrictCode
WHERE t.Name = 'General Cinema Pacific Place 11';
+----------------+
| DistrictName |
+----------------+
| CAPITOL HILL |
| THE U DISTRICT |
| DOWNTOWN |
+----------------+
3 rows in set (0.00 sec)

13. Write a query that lists the name(s) of the theater(s) that belong(s) to at least two
districts and play(s) any "R"-Rated Movie.
SELECT DISTINCT t.Name AS TheaterName
FROM theaters t
JOIN theaters2districts t2d ON t.TheaterCode = t2d.TheaterCode
JOIN movies2theaters m2t ON t.TheaterCode = m2t.TheaterCode
JOIN movies m ON m2t.MovieCode = m.MovieCode
WHERE m.Rating = 'R'
GROUP BY t.TheaterCode
HAVING COUNT(DISTINCT t2d.DistrictCode) >= 2;

+----------------------------------+
| TheaterName |
+----------------------------------+
| Cineplex Odeon City Centre |
| Landmark Varsity Theatre |
| Landmark Seven Gables Theatre |
| Landmark Metro Cinemas |
| Landmark Harvard Exit Theatre |
| Landmark Guild 45th |
| Landmark Broadway Market Cinemas |
| Cineplex Odeon Meridian |
| General Cinema Pacific Place 11 |
| General Cinema Cinerama |
+----------------------------------+
10 rows in set (0.01 sec)

14. Write a query that lists the movie and theater name(s) in ‘Downtown’ District, showing
movies starting with the letter ‘N’ and sort the results by the theater name in ascending
order.

SELECT DISTINCT m.Title AS MovieTitle, t.Name AS TheaterName
FROM movies m
JOIN movies2theaters m2t ON m.MovieCode = m2t.MovieCode
JOIN theaters t ON m2t.TheaterCode = t.TheaterCode
JOIN theaters2districts t2d ON t.TheaterCode = t2d.TheaterCode
JOIN districts d ON t2d.DistrictCode = d.DistrictCode
WHERE d.Name = 'Downtown' AND m.Title LIKE 'N%'
ORDER BY t.Name ASC;

+----------------------------------+-------------------------+
| MovieTitle | TheaterName |
+----------------------------------+-------------------------+
| Nutty Professor 2: with captions | Cineplex Odeon Meridian |
| Nurse Betty | Cineplex Odeon Meridian |
| Nurse Betty | Landmark Metro Cinemas |
+----------------------------------+-------------------------+
3 rows in set (0.00 sec)

15. Write a query that lists the theater name, movie name, movie rating, movie length, and
the movie showings count per each theater playing the shortest ‘R’-rated movie in each
district. The count should display how many times the movie is played in a theater.

SELECT d.Name AS district_name, t.Name AS theater_name, m.Title AS movie_name, m.Rating
AS movie_rating, m.Length AS movie_length, COUNT(*) AS showings_count
FROM districts d
JOIN theaters2districts td ON d.DistrictCode = td.DistrictCode
JOIN theaters t ON td.TheaterCode = t.TheaterCode
JOIN movies2theaters mt ON t.TheaterCode = mt.TheaterCode
JOIN movies m ON mt.MovieCode = m.MovieCode
WHERE m.Rating = 'R' AND m.Length = (
 SELECT MIN(m2.Length)
 FROM movies m2
 JOIN movies2theaters m2t2 ON m2.MovieCode = m2t2.MovieCode
 JOIN theaters t2 ON m2t2.TheaterCode = t2.TheaterCode
 JOIN theaters2districts t2d2 ON t2.TheaterCode = t2d2.TheaterCode
 WHERE t2d2.DistrictCode = d.DistrictCode AND m2.Rating = 'R'
)
GROUP BY d.Name, t.Name, m.Title, m.Rating, m.Length;

+-------------------------+----------------+-------------+-------------+---------------+
| TheaterName | MovieTitle | MovieRating | MovieLength | ShowingsCount |
+-------------------------+----------------+-------------+-------------+---------------+
| Cineplex Odeon Meridian | The Ladies Man | R | 84 | 30 |
+-------------------------+----------------+-------------+-------------+---------------+
1 row in set (0.01 sec)

16. Write a query that lists the district name, theater name, and movie count, where each
district has all theaters named starting with the letter ‘C’ and the theaters are sorted in
descending order based on their movies count. The movie count is the number of movies
played by a theater.

SELECT DISTINCT d.Name AS DistrictName, t.Name AS TheaterName, COUNT(m2t.MovieCode)
AS MovieCount
FROM theaters t
JOIN movies2theaters m2t ON t.TheaterCode = m2t.TheaterCode
JOIN theaters2districts t2d ON t.TheaterCode = t2d.TheaterCode
JOIN districts d ON t2d.DistrictCode = d.DistrictCode
WHERE t.Name LIKE 'C%'
AND NOT EXISTS (
 SELECT *
 FROM theaters tx
 WHERE tx.Name NOT LIKE 'C%' AND tx.TheaterCode = t.TheaterCode
)
GROUP BY d.Name, t.Name
HAVING COUNT(m2t.MovieCode) > 0
ORDER BY MovieCount DESC;

+----------------+----------------------------+------------+
| DistrictName | TheaterName | MovieCount |
+----------------+----------------------------+------------+
| CAPITOL HILL | Cineplex Odeon Meridian | 73 |
| DOWNTOWN | Cineplex Odeon Meridian | 73 |
| THE U DISTRICT | Cineplex Odeon Meridian | 73 |
| CAPITOL HILL | Cineplex Odeon Uptown | 12 |
| DOWNTOWN | Cineplex Odeon Uptown | 12 |
| THE U DISTRICT | Cineplex Odeon Uptown | 12 |
| THE U DISTRICT | Cineplex Odeon City Centre | 6 |
| CAPITOL HILL | Cineplex Odeon City Centre | 6 |
| DOWNTOWN | Cineplex Odeon City Centre | 6 |
| THE U DISTRICT | Cineplex Odeon Northgate | 3 |
+----------------+----------------------------+------------+
10 rows in set (0.01 sec)

17. Write a query that lists the movie name, theater name and district name of theaters
showing the shortest movie in each district.

SELECT m.Title AS movie_name, t.Name AS theater_name, d.Name AS district_name
FROM movies m
JOIN movies2theaters m2t ON m.MovieCode = m2t.MovieCode
JOIN theaters t ON m2t.TheaterCode = t.TheaterCode
JOIN theaters2districts t2d ON t.TheaterCode = t2d.TheaterCode
JOIN districts d ON t2d.DistrictCode = d.DistrictCode
WHERE m.Length = (
 SELECT MIN(m2.Length)
 FROM movies m2
 JOIN movies2theaters m2t2 ON m2.MovieCode = m2t2.MovieCode
 JOIN theaters t2 ON m2t2.TheaterCode = t2.TheaterCode
 JOIN theaters2districts t2d2 ON t2.TheaterCode = t2d2.TheaterCode
 WHERE t2d2.DistrictCode = d.DistrictCode
)
GROUP BY d.Name;
+------------+--------------------------+----------------+
| movie_name | theater_name | district_name |
+------------+--------------------------+----------------+
| Dark Days | Landmark Varsity Theatre | CAPITOL HILL |
| Dark Days | Landmark Varsity Theatre | DOWNTOWN |
| Dark Days | Landmark Varsity Theatre | THE U DISTRICT |
+------------+--------------------------+----------------+
3 rows in set (0.01 sec)

18. Write a query that lists the movie rating, movie count and district name played by
Landmark Broadway Market Cinemas” in each district. For example if there are 5 “R”
rated movies played by the “Landmark Broadway Market Cinemas” in one district then
the result set should include:

SELECT m.Rating AS movie_rating, COUNT(*) AS movie_count, d.Name AS district_name
FROM movies m
JOIN movies2theaters m2t ON m.MovieCode = m2t.MovieCode
JOIN theaters t ON m2t.TheaterCode = t.TheaterCode
JOIN theaters2districts t2d ON t.TheaterCode = t2d.TheaterCode
JOIN districts d ON t2d.DistrictCode = d.DistrictCode
WHERE t.Name = 'Landmark Broadway Market Cinemas'
GROUP BY m.Rating, d.Name;
+--------------+-------------+----------------+
| movie_rating | movie_count | district_name |
+--------------+-------------+----------------+
| PG-13 | 10 | CAPITOL HILL |
| PG-13 | 10 | DOWNTOWN |
| PG-13 | 10 | THE U DISTRICT |
| R | 4 | CAPITOL HILL |
| R | 4 | DOWNTOWN |
| R | 4 | THE U DISTRICT |
+--------------+-------------+----------------+
6 rows in set (0.00 sec)

19. Write a query that lists the theater name and the average length of movies shown in each
theater, sorted by the average length of movies in ascending order.

SELECT t.Name AS theater_name, AVG(m.Length) AS avg_length
FROM movies m
JOIN movies2theaters m2t ON m.MovieCode = m2t.MovieCode
JOIN theaters t ON m2t.TheaterCode = t.TheaterCode
GROUP BY t.Name
ORDER BY avg_length ASC;

+----------------------------------+------------+
| theater_name | avg_length |
+----------------------------------+------------+
| Landmark Neptune Theatre | 90.0000 |
| Landmark Varsity Theatre | 93.0000 |
| Cineplex Odeon City Centre | 93.6667 |
| Landmark Broadway Market Cinemas | 93.7143 |
| Cineplex Odeon Uptown | 96.6667 |
| Cineplex Odeon Meridian | 110.1507 |
| General Cinema Pacific Place 11 | 112.9756 |
| Cineplex Odeon Northgate | 113.0000 |
| Landmark Guild 45th | 113.5000 |
| Landmark Harvard Exit Theatre | 117.0000 |
| Landmark Metro Cinemas | 117.2059 |
| General Cinema Cinerama | 132.0000 |
| Landmark Seven Gables Theatre | 140.0000 |
+----------------------------------+------------+
13 rows in set (0.00 sec)

20. Write a query that lists the theaters that play any movies shorter than 90 minutes and the
number of times these movies were played in each theater.

SELECT t.Name AS theater_name, COUNT(*) AS movie_count
FROM theaters t
JOIN movies2theaters m2t ON t.TheaterCode = m2t.TheaterCode
JOIN movies m ON m2t.MovieCode = m.MovieCode
WHERE m.Length < 90
GROUP BY t.Name;

+--------------------------+-------------+
| theater_name | movie_count |
+--------------------------+-------------+
| Cineplex Odeon Meridian | 10 |
| Cineplex Odeon Uptown | 4 |
| Landmark Metro Cinemas | 4 |
| Landmark Varsity Theatre | 1 |
+--------------------------+-------------+
4 rows in set (0.00 sec)
