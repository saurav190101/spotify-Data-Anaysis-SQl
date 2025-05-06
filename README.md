# spotify-Data-Anaysis-SQl

# 🎧 Spotify vs YouTube Music Dashboard

**Project Type:** Data Analysis & Dashboard  
**Tech Stack:** SQL, Power BI  
**Tools Used:** SQL (for analysis), Power BI (for interactive dashboard)

---

## 📌 Project Overview

This project presents a anaysis of **Spotify**  using streaming data. The goal is to derive insights into the **top-performing tracks and artists**, **energy/tempo-based performance**, and **platform-specific trends**.

---

## 🔍 Key Insights

- Top 10 streamed tracks on both platforms
- Most popular artists with total views
- Energetic tracks filtered by energy, tempo, and loudness
- Tracks that performed better on Spotify than YouTube
- Artist-wise slicers and platform toggles for dynamic filtering

---

## 📊 Power BI Dashboard Features

- **KPI cards**: Highlighting top artist and track
- **Toggle buttons**: Switch between Spotify and YouTube views
- **Custom visuals**: Icons, bookmarks, images for each artist
- **Searchable slicers**: Filter by artist or platform
- **Interactive charts**: Line + clustered column chart for dual comparison

## Dashbord look like
preview![dashbord preview](https://github.com/saurav190101/spotify-Data-Anaysis-SQl/blob/main/Dashboard.png)


## Heighlight sql querry

```
select artist, track,energy,loudness,tempo from spotify
where energy>0.8 and loudness>-5 and tempo>120
order by energy desc,loudness desc,tempo desc
limit 5
```

```
select * from(
select track ,coalesce(sum(case 
				when most_played_on='Youtube' then stream  end),0)
				as stream_on_youtube,
				coalesce(sum(case when most_played_on='Spotify' then stream end),0) as stream_on_spotify
				from spotify
				group by 1)
				where stream_on_spotify>stream_on_youtube
```

```
SELECT
	TRACK,SUM(CASE
			WHEN MOST_PLAYED_ON = 'Spotify' THEN VIEWS
			ELSE 0
		END) AS SPOTIFY_VIEWS,
	SUM(CASEWHEN MOST_PLAYED_ON = 'Youtube' THEN VIEWS
			ELSE 0
		END) AS YOUTUBE_VIEWS
FROM SPOTIFY
GROUP BY 1
HAVING
	SUM(
		CASE WHEN MOST_PLAYED_ON = 'Spotify' THEN VIEWS
			ELSE 0 END) > 0
	AND SUM(
		CASE WHEN MOST_PLAYED_ON = 'Youtube' THEN VIEWS
			ELSE 0 END) > 0
ORDER BY
	SPOTIFY_VIEWS DESC, YOUTUBE_VIEWS DESC
LIMIT 10
```

---

## 📂 Project Files

- SQL queries for analysis
- Cleaned datasets (Spotify & YouTube)
- Power BI `.pbix` file with final dashboard
- Screenshots of visuals

---





Crafted by **Saurav Kumar**  
*SQL + Power BI Analyst | Freelancer | Dashboard Designer*
