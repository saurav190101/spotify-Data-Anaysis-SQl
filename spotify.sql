CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--EDA
select count(distinct(album)) from spotify;

select count(distinct(artist)) from spotify;

select distinct(album_type) from spotify;

select max(duration_min) from spotify

select min(duration_min) from spotify

select * from spotify where duration_min =0

delete  from spotify where duration_min=0

select distinct(channel) from spotify

select distinct(most_played_on) from spotify

-- Business question

-- Easy level

-- Retrieve the names of all tracks that have more than 1 billion streams.

select  distinct(track),stream from spotify
		where stream>=1000000000



--List all albums along with their respective artists.
select distinct(album) ,artist from spotify
order by 1

--Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) from spotify where licensed='true'


--Find all tracks that belong to the album type single.

select track ,album_type from spotify where album_type =('single')

--Count the total number of tracks by each artist.
select artist,count(track) as count_track  from spotify
group by 1
order by count_track 

--Medium Level

--Calculate the average danceability of tracks in each album.
select album,avg(danceability) as avg_danceability
	from spotify 
	group by 1
	order by 2 desc

--Find the top 10 artist which make most energetic music
select 	artist,count(*) energetic_tracks from spotify
where energy>0.8 and loudness>-5 and tempo>120
group by 1
order by energetic_tracks desc limit 10 

--top 5 tracks  energetic
select artist, track,energy,loudness,tempo from spotify
where energy>0.8 and loudness>-5 and tempo>120
order by energy desc,loudness desc,tempo desc
limit 5
	

--List all tracks along with their views and likes where official_video = TRUE.
select * from spotify

select distinct(track),views,likes from spotify
		where official_video ='true'

--For each album, calculate the total views of all associated tracks.
select distinct(album) ,track,sum(views) total_views
	from spotify
	group by 1,2
    order by 3 desc

--Retrieve the track names that have been streamed on Spotify more than YouTube.
select * from spotify

select * from(
select track ,coalesce(sum(case 
				when most_played_on='Youtube' then stream  end),0)
				as stream_on_youtube,
				coalesce(sum(case when most_played_on='Spotify' then stream end),0) as stream_on_spotify
				from spotify
				group by 1)
				where stream_on_spotify>stream_on_youtube





--Advanced Level

--Find the top 3 most-viewed tracks for each artist using window functions.
select * from (
select artist,track,sum(views) total_views
,dense_rank()over(partition by artist order by sum(views)desc ) as drn 
from spotify 
group by 1,2
) where drn between 1 and 3

-- Write a query to find tracks where the liveness score is above the average

select *   from spotify
where liveness>(select avg(liveness)from spotify)

--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
with diffrence as(
select album, max(energy) highest_energy,min(energy)as 
lowest_energy from spotify
group by 1)

select album, highest_energy-lowest_energy as diffrences
from diffrence
order by 2 desc






--Extra Analysis

-- Youtube vs Spotify stream
select coalesce(sum(case 
				when most_played_on='Youtube' then stream  end),0)
				as stream_on_youtube,
				coalesce(sum(case when most_played_on='Spotify' then stream end),0) as stream_on_spotify
				from spotify

-- top 10 tracks Youtube vs Spotify in Views 
SELECT
	TRACK,
	SUM(
		CASE
			WHEN MOST_PLAYED_ON = 'Spotify' THEN VIEWS
			ELSE 0
		END
	) AS SPOTIFY_VIEWS,
	SUM(
		CASE
			WHEN MOST_PLAYED_ON = 'Youtube' THEN VIEWS
			ELSE 0
		END
	) AS YOUTUBE_VIEWS
FROM
	SPOTIFY
GROUP BY
	1
HAVING
	SUM(
		CASE
			WHEN MOST_PLAYED_ON = 'Spotify' THEN VIEWS
			ELSE 0
		END
	) > 0
	AND SUM(
		CASE
			WHEN MOST_PLAYED_ON = 'Youtube' THEN VIEWS
			ELSE 0
		END
	) > 0
ORDER BY
	SPOTIFY_VIEWS DESC,
	YOUTUBE_VIEWS DESC
LIMIT
	10

--youtube vs spotify views
SELECT
	SUM(
		CASE
			WHEN MOST_PLAYED_ON = 'Spotify' THEN VIEWS
			ELSE 0
		END
	) AS SPOTIFY_VIEWS,
	SUM(
		CASE
			WHEN MOST_PLAYED_ON = 'Youtube' THEN VIEWS
			ELSE 0
		END
	) AS YOUTUBE_VIEWS
FROM
	SPOTIFY
