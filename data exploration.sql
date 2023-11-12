--viewing the data
select * from netfl

--checking if there are any nulls
select *
from netfl
where null in (show_id, type, title, director, country, date_added, release_year, rating, duration, listed_in);

--
select count(type) as totalrows from netfl

--checking the number of movies and tv shows 
select count(type) as tvshowcount from netfl where type like '%tv show%'
select count(type) as moviescout from netfl where type like '%movie%' 

--performing simliar as above using stored procedures 
declare @movcount int;
select @movcount=count(type) from netfl where type like '%tv show%'
print @movcount 
declare @tvcount int;
select @tvcount=count(type) from netfl where type like '%movie%'
print @tvcount
print @movcount+@tvcount

--checking for false values 
select count(director) as null_valuesdirector from netfl where director like'%not given%'
select count(country) as null_valuescountry from netfl where country like'%not%'
----looking at no of releases by year
select release_year, count(*) as year_count
from netfl
group by release_year
order by release_year;
--
select * from netfl where release_year=1925
--looking at no of releases of directors 
select director, count(*) as dir_count
from netfl
group by director
order by dir_count desc;
--looking at the releases by country
select country, count(*) as country_count
from netfl
group by country
order by country_count desc;
--looking at the releases by ratings
select rating, count(*) as rating_count
from netfl
group by rating
order by rating_count ;
--looking at the no of seasons and time duration in separated columns
select
    case
        when duration like '% min' and isnumeric(substring(duration, 1, charindex(' min', duration) - 1)) = 1
        then cast(substring(duration, 1, charindex(' min', duration) - 1) as int)
        else null
    end as time_duration,
    case
        when duration like '% season%' then
            case
                when isnumeric(substring(duration, 1, charindex(' season', duration) - 1)) = 1
                then cast(substring(duration, 1, charindex(' season', duration) - 1) as int)
                else null
            end
        when duration like '% seasons%' then
            case
                when isnumeric(substring(duration, 1, charindex(' seasons', duration) - 1)) = 1
                then cast(substring(duration, 1, charindex(' seasons', duration) - 1) as int)
                else null
            end
        else null
    end as seasons
from netfl
order by seasons desc;
--percentage of content
select
    type,
    count(*) as content_count,
    (count(*) * 100.0 / (select count(*) from netfl)) as percentage_of_content
from netfl
group by [type];
--percentage of releases by contries
select
    country,
    count(*) as total_releases,
    (count(*) * 100.0 / (select count(*) from netfl)) as percentage_by_country
from
    netfl
group by 
	country
order by 
	percentage_by_country desc
--release of content by years
select
    release_year,
    count(*) as total_releases_byyear,
    (count(*) * 100.0 / (select count(*) from netfl)) as percentage_by_year
from
    netfl
group by
    release_year
order by
    percentage_by_year DESC;
