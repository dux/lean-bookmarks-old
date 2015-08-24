--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: buckets; Type: TABLE; Schema: public; Owner: sbprod; Tablespace: 
--

CREATE TABLE buckets (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    created_by integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by integer NOT NULL,
    active boolean DEFAULT true,
    tags character varying(255)[] DEFAULT '{}'::character varying[],
    child_buckets integer[] DEFAULT '{}'::integer[],
    template character varying(255),
    image character varying(255)
);


ALTER TABLE public.buckets OWNER TO sbprod;

--
-- Name: buckets_id_seq; Type: SEQUENCE; Schema: public; Owner: sbprod
--

CREATE SEQUENCE buckets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.buckets_id_seq OWNER TO sbprod;

--
-- Name: buckets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sbprod
--

ALTER SEQUENCE buckets_id_seq OWNED BY buckets.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: sbprod; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by integer NOT NULL,
    data text NOT NULL,
    grp_id integer NOT NULL,
    grp_type character varying(255) NOT NULL
);


ALTER TABLE public.comments OWNER TO sbprod;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: sbprod
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO sbprod;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sbprod
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: domains; Type: TABLE; Schema: public; Owner: sbprod; Tablespace: 
--

CREATE TABLE domains (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    created_by integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text,
    is_article boolean
);


ALTER TABLE public.domains OWNER TO sbprod;

--
-- Name: domains_id_seq; Type: SEQUENCE; Schema: public; Owner: sbprod
--

CREATE SEQUENCE domains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domains_id_seq OWNER TO sbprod;

--
-- Name: domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sbprod
--

ALTER SEQUENCE domains_id_seq OWNED BY domains.id;


--
-- Name: links; Type: TABLE; Schema: public; Owner: sbprod; Tablespace: 
--

CREATE TABLE links (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    url character varying(255) NOT NULL,
    domain character varying(255) NOT NULL,
    tags character varying(255)[] DEFAULT '{}'::character varying[],
    kind character varying(255),
    description character varying(255),
    created_by integer,
    updated_by integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    active boolean DEFAULT true,
    is_article boolean DEFAULT false,
    bucket_id integer NOT NULL
);


ALTER TABLE public.links OWNER TO sbprod;

--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: sbprod
--

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.links_id_seq OWNER TO sbprod;

--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sbprod
--

ALTER SEQUENCE links_id_seq OWNED BY links.id;


--
-- Name: logs; Type: TABLE; Schema: public; Owner: sbprod; Tablespace: 
--

CREATE TABLE logs (
    id integer NOT NULL,
    kind character varying(255),
    name character varying(255),
    created_by integer,
    created_at timestamp without time zone,
    grp_id integer,
    grp_type character varying(255)
);


ALTER TABLE public.logs OWNER TO sbprod;

--
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: sbprod
--

CREATE SEQUENCE logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logs_id_seq OWNER TO sbprod;

--
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sbprod
--

ALTER SEQUENCE logs_id_seq OWNED BY logs.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: sbprod; Tablespace: 
--

CREATE TABLE notes (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    data text,
    created_at timestamp without time zone NOT NULL,
    created_by integer NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    updated_by integer NOT NULL,
    bucket_id integer NOT NULL,
    active boolean DEFAULT true,
    tags character varying(255)[] DEFAULT '{}'::character varying[]
);


ALTER TABLE public.notes OWNER TO sbprod;

--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: sbprod
--

CREATE SEQUENCE notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notes_id_seq OWNER TO sbprod;

--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sbprod
--

ALTER SEQUENCE notes_id_seq OWNED BY notes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: sbprod; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(140),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying(255),
    avatar character varying(255),
    active boolean,
    pass character varying(255),
    connect_via character varying(255),
    description character varying(255)
);


ALTER TABLE public.users OWNER TO sbprod;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: sbprod
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO sbprod;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sbprod
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: sbprod
--

ALTER TABLE ONLY buckets ALTER COLUMN id SET DEFAULT nextval('buckets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: sbprod
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: sbprod
--

ALTER TABLE ONLY domains ALTER COLUMN id SET DEFAULT nextval('domains_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: sbprod
--

ALTER TABLE ONLY links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: sbprod
--

ALTER TABLE ONLY logs ALTER COLUMN id SET DEFAULT nextval('logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: sbprod
--

ALTER TABLE ONLY notes ALTER COLUMN id SET DEFAULT nextval('notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: sbprod
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: public; Owner: sbprod
--

COPY buckets (id, name, description, created_at, created_by, updated_at, updated_by, active, tags, child_buckets, template, image) FROM stdin;
4	Motor	\N	2015-07-25 18:38:23.56807	1	2015-07-25 18:38:23.568184	1	t	{}	{}	\N	\N
5	VC	\N	2015-07-26 00:25:54.163502	1	2015-07-26 00:25:54.163592	1	t	{}	{}	\N	\N
8	Design	\N	2015-07-26 01:08:08.229439	1	2015-07-26 01:08:08.229549	1	t	{}	{}	\N	\N
9	House search	\N	2015-07-26 01:13:15.786075	1	2015-07-26 01:13:15.786248	1	t	{}	{}	\N	\N
10	Dev company	\N	2015-07-26 01:15:11.461571	1	2015-07-26 01:15:11.461656	1	t	{}	{}	\N	\N
11	CSS	\N	2015-07-28 21:52:05.717256	1	2015-07-28 21:52:05.717339	1	t	{}	{}	\N	\N
12	Haevy mashinery	\N	2015-07-29 09:59:14.935304	1	2015-07-29 09:59:14.935448	1	t	{}	{}	\N	\N
13	Various	\N	2015-07-31 00:26:35.225554	2	2015-07-31 00:26:35.225706	2	t	{}	{}	\N	\N
27	Various	\N	2015-08-20 18:34:22.07375	3	2015-08-21 20:01:24.795283	3	t	{}	{}	\N	\N
2	Stash buckets		2015-07-24 00:50:45.944953	1	2015-08-04 15:28:27.740682	1	t	{project}	{}	\N	\N
17	Jakov	\N	2015-08-05 09:41:56.585943	1	2015-08-05 09:47:24.281258	1	t	{}	{}	\N	\N
15	node	\N	2015-08-04 09:31:26.601929	1	2015-08-05 09:47:24.295466	1	t	{}	{}	\N	\N
24	Lists (Movies, Music)	\N	2015-08-18 09:57:41.066759	1	2015-08-18 11:53:24.135586	1	t	{}	{}	\N	\N
25	Membership Management	ideja od Nikolasa	2015-08-19 14:49:44.583494	1	2015-08-24 12:20:30.307317	1	t	{}	{}	\N	http://i.imgur.com/Jlx0EUk.png
20	Img resize and thumbnails	\N	2015-08-07 08:43:12.921551	1	2015-08-07 09:17:20.433341	1	t	{}	{}	\N	\N
19	German	just a place to put all resources found helpful in learning german	2015-08-07 08:33:52.628018	1	2015-08-07 13:45:42.373684	1	t	{}	{}	\N	\N
21	job	\N	2015-08-10 07:32:50.23858	1	2015-08-10 07:32:56.643674	1	f	{}	{}	\N	\N
6	Jobs	\N	2015-07-26 00:26:35.036538	1	2015-08-10 10:47:56.094527	1	t	{}	{}	\N	\N
29	Deals APP	ivanina ideja, malo razrade\n	2015-08-22 10:45:42.239171	1	2015-08-24 12:20:30.321975	1	t	{}	{}	\N	
26	CRM	\N	2015-08-20 08:11:30.004098	1	2015-08-20 12:32:51.08996	1	t	{}	{}	\N	\N
7	Jobs APP	\N	2015-07-26 00:26:47.980385	1	2015-08-24 14:29:01.446161	1	t	{idea}	{}	\N	\N
1	Various	\N	2015-07-24 00:45:01.721697	1	2015-08-24 14:29:34.119333	1	t	{}	{}	\N	\N
30	Site SASS support apps	\N	2015-08-24 14:30:25.826008	1	2015-08-24 14:30:31.649231	1	t	{}	{}	\N	\N
18	Networking		2015-08-06 10:49:53.96074	1	2015-08-20 12:56:40.381257	1	t	{}	{}	\N	http://i.imgur.com/remKXlnm.jpg
16	ClubWeb	\N	2015-08-04 15:27:08.588288	1	2015-08-20 12:59:09.419791	1	f	{idea}	{}	\N	\N
3	Games		2015-07-24 00:52:02.958331	1	2015-08-20 15:05:18.226914	1	t	{}	{}	\N	http://i.imgur.com/fENkykfm.jpg
23	CupoNation CN		2015-08-18 09:13:35.043676	1	2015-08-20 18:21:05.721802	1	t	{}	{}	\N	http://c93fea60bb98e121740fc38ff31162a8.s3.amazonaws.com/wp-content/uploads/2012/12/cn.png
14	Ruby		2015-08-01 13:09:54.410788	1	2015-08-20 18:22:28.08415	1	t	{}	{}	\N	http://www.unixstickers.com/image/cache/data/stickers/ruby/ruby.sh-600x600.png
22	Rent heavy machinery		2015-08-11 20:44:10.545176	1	2015-08-20 18:23:20.198733	1	t	{}	{}	\N	http://i.imgur.com/v2SkXAgm.jpg
28	JavaScript	\N	2015-08-20 18:49:38.047474	1	2015-08-20 21:09:18.320155	1	t	{}	{}	\N	\N
\.


--
-- Name: buckets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sbprod
--

SELECT pg_catalog.setval('buckets_id_seq', 30, true);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: sbprod
--

COPY comments (id, created_at, created_by, updated_at, updated_by, data, grp_id, grp_type) FROM stdin;
\.


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sbprod
--

SELECT pg_catalog.setval('comments_id_seq', 1, false);


--
-- Data for Name: domains; Type: TABLE DATA; Schema: public; Owner: sbprod
--

COPY domains (id, name, created_at, created_by, updated_at, description, is_article) FROM stdin;
\.


--
-- Name: domains_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sbprod
--

SELECT pg_catalog.setval('domains_id_seq', 1, false);


--
-- Data for Name: links; Type: TABLE DATA; Schema: public; Owner: sbprod
--

COPY links (id, name, url, domain, tags, kind, description, created_by, updated_by, created_at, updated_at, active, is_article, bucket_id) FROM stdin;
14	Artoo - Ruby framework for robotics, physical computing, and the Internet of Things	http://artoo.io/	artoo.io	{}		Artoo is a framework for robotics, physical computing, and the Internet of Things written in the Ruby programming language. It provides a simple, yet powerful way to create solutions that incorporate multiple, different hardware devices at the same time	1	1	2015-07-24 00:54:34.9947	2015-07-24 01:02:18.456897	t	f	1
16	Cylon.js - JavaScript framework for robotics, physical computing, and the Internet of Things using Node.js	http://cylonjs.com/	cylonjs.com	{}		Cylon.js is a JavaScript framework for robotics, physical computing, and the Internet of Things using Node.js. It provides a simple, yet powerful way to create JavaScript robots that incorporate multiple, different hardware devices at the same time.	1	1	2015-07-24 00:54:48.023871	2015-07-24 00:54:58.023918	t	f	1
15	Particle (formerly Spark) | Build your connected product	https://www.spark.io/	spark.io	{}		Particle offers a suite of hardware and software tools to help you prototype, scale, and manage your Internet of Things products.	1	1	2015-07-24 00:54:42.17965	2015-07-24 00:54:58.026616	t	f	1
24	Kakav 'švaler': Ulijetao mladim majkama, broj mu dale i udane - 24sata	http://www.24sata.hr/fun-video/kakav-svaler-ulijetao-mladim-majkama-broj-mu-dale-i-udane-411299	24sata.hr	{}	\N	 Vitaly Zdorovetskiy je jedan od superstarova YouTube generacije, a u svojem je novom videu pokazao kako mladima mamama 'prodati spiku' i dobiti broj mobitela	1	1	2015-07-25 11:34:38.859912	2015-07-25 11:34:38.859996	t	t	1
13	Noir Deco - Future To Fantasy [Full Album] - YouTube	https://www.youtube.com/watch?v=Ew4SLiKbzPk	youtube.com	{}	vid	http://www.cdbaby.com/cd/noirdeco Tracklist: 1. Future Noir 00:00 2. Charged And Ready 04:45 3. Journeys (feat. MPM Soundtracks) 08:39 4. Silence And Echoes ...	1	1	2015-07-24 00:54:28.528252	2015-07-24 00:54:58.03247	t	t	1
12	blog.twocanoes.com	http://blog.twocanoes.com/post/68861362715/10-awesome-things-you-can-do-today-with-ibeacons	blog.twocanoes.com	{}		\N	1	1	2015-07-24 00:54:21.921786	2015-07-24 00:54:58.035401	t	t	1
11	Using iBeacon to Hack an Open Door Policy - ArcTouch	http://arctouch.com/2015/02/hacking-open-door-policy-ibeacon/	arctouch.com	{}		In one of the ArcTouch Hackathon projects, a team used iBeacon proximity technology to make the office door unlock automatically as employees approach.	1	1	2015-07-24 00:54:15.394492	2015-07-24 00:54:58.038243	t	t	1
10	garagebeacon.com	http://www.garagebeacon.com/	garagebeacon.com	{}		\N	1	1	2015-07-24 00:54:08.334331	2015-07-24 00:54:58.040256	t	f	1
9	August Smart Lock	http://august.com/	august.com	{}		The August Smart Lock is a new lock and access system that allows you to send a virtual key to anyone you choose to have access to your home.	1	1	2015-07-24 00:53:59.426733	2015-07-24 00:54:58.042096	t	f	1
8	Kaufmich.com - Kostenlose Community für Escorts, Hobby-Huren, Dominas, Bordelle und Freier	http://www.kaufmich.com/	kaufmich.com	{}		Erfülle Deine Träume, lass Deine Fantasien Wirklichkeit werden. Sexy Escorts warten auf Dein Angebot. Die neue 100% kostenlose Community!	1	1	2015-07-24 00:53:53.556149	2015-07-24 00:54:58.043956	t	f	1
7	bcoe/thumbd · GitHub	https://github.com/bcoe/thumbd	github.com	{}		thumbd - Node.js/AWS/ImageMagick-based image thumbnailing service.	1	1	2015-07-24 00:53:44.198848	2015-07-24 00:54:58.045885	t	f	1
6	The Escapists on Steam	http://store.steampowered.com/app/298630/?snr=1_5_9__300	store.steampowered.com	{}		The Escapists provides players the opportunity of experiencing a light-hearted insight into everyday prison life with the main objective being that of escaping!	1	1	2015-07-24 00:51:28.310876	2015-07-24 00:54:58.047804	t	t	3
5	GitBook · Write & Publish Books	https://www.gitbook.com/	gitbook.com	{}		Modern Publishing, Simply taking your books from ideas to finished, polished books.	1	1	2015-07-24 00:51:18.599156	2015-07-24 00:54:58.049893	t	f	1
4	hackpad	https://hackpad.com/	hackpad.com	{}	doc	Real-time collaborative wiki	1	1	2015-07-24 00:50:50.406723	2015-07-24 00:54:58.051765	t	f	1
3	Adminer - Database management in a single PHP file	http://www.adminer.org/	adminer.org	{}		Adminer (formerly phpMinAdmin) is a full-featured database management tool written in PHP. Conversely to phpMyAdmin, it consist of a single file ready to deploy to the target server. Adminer is available for MySQL, PostgreSQL, SQLite, MS SQL, Oracle, Fire	1	1	2015-07-24 00:50:40.231555	2015-07-24 00:54:58.054014	t	f	1
2	GitHub · Build software better, together.	https://github.com/	github.com	{}		Build software better, together.	1	1	2015-07-24 00:50:32.843873	2015-07-24 00:54:58.056334	t	f	1
1	Strike Search - Torrent Search Engine	http://getstrike.net/torrents/	getstrike.net	{}		A modern approach to BitTorrent searching, download music, movies, games and software. Right at your fingertips	1	1	2015-07-24 00:46:20.15411	2015-07-24 00:54:58.058506	t	f	1
17	Make Money Online: Documenting 10 Years of Failure	http://johnathanward.com/make-money-online-failure/	johnathanward.com	{}	\N	My history of attempting to make money online. Here's what worked and what didn't over the last ten years.	1	1	2015-07-25 11:33:48.407571	2015-07-25 11:33:48.407675	t	t	1
18	Finding apartments in Munich - Mr. Lodge	https://www.mrlodge.com/search/	mrlodge.com	{}	\N	Looking for an apartment in Munich? A wide offer of furnished apartments and houses in Munich by Mr. Lodge, Munich's biggest agency for temporary accommodation.	1	1	2015-07-25 11:33:56.895366	2015-07-25 11:33:56.895444	t	f	1
19	Object details - Home For Rent - Your Search Engine for furnished short-term accommodation!	http://www.homeforrent.de/objektdetails/hfr_hcid/36/hfr_oid/AG874399/hfr_page/7	homeforrent.de	{}	\N	Discover our offers for furnished short-term accommodation 	1	1	2015-07-25 11:34:05.127234	2015-07-25 11:34:05.127357	t	t	1
20	Fenomeni: Prepis spaljene knjige (Croatian Edition): Svetislav Basara: 9788673190273: Amazon.com: Books	http://www.amazon.com/Fenomeni-Prepis-spaljene-Croatian-Edition/dp/8673190274	amazon.com	{}	\N	Fenomeni: Prepis spaljene knjige (Croatian Edition) [Svetislav Basara] on Amazon.com. *FREE* shipping on qualifying offers.	1	1	2015-07-25 11:34:11.125865	2015-07-25 11:34:11.125971	t	t	1
21	holywar.org	http://holywar.org/txt/LibriInCroato/Nilus%20-%20Protokoli%20sionskih%20mudraca.pdf	holywar.org	{}	\N	\N	1	1	2015-07-25 11:34:18.754406	2015-07-25 11:34:18.75449	t	t	1
22	Chrome Web Store	https://chrome.google.com/webstore/developer/dashboard	chrome.google.com	{}	\N	Discover great apps, games, extensions and themes for Chrome.	1	1	2015-07-25 11:34:23.799148	2015-07-25 11:34:23.799217	t	f	1
23	console.developers.google.com	https://console.developers.google.com/project	console.developers.google.com	{}	\N	\N	1	1	2015-07-25 11:34:30.123019	2015-07-25 11:34:30.123092	t	f	1
25	Derren Brown - Miracles for Sale - YouTube	https://www.youtube.com/watch?v=bouAp1pGBwk	youtube.com	{}	\N	A scuba diver instructor becomes a successful Christian faith healer with 6 months of training. Unfortunately there is nothing miraculous that takes place in...	1	1	2015-07-25 11:34:44.113241	2015-07-25 11:34:44.113323	t	t	1
26	BBC Two - Louis Theroux, By Reason of Insanity, Part 1	http://www.bbc.co.uk/programmes/b05nyysy	bbc.co.uk	{}	\N	  Louis immerses himself in the world of Ohio's state psychiatric hospitals.  	1	1	2015-07-25 11:34:54.563723	2015-07-25 11:34:54.563847	t	t	1
27	Home	http://evolveskateboards.de/	evolveskateboards.de	{}	\N	Evolve Elektro Skateboards. Das Evolve ist ein Premium Longboard das mit einem sehr effizienten Elektroantrieb und Lithium Akku ausgestattet ist. Durch die komplette Eigenentwicklung in Australien ist es einzigartig und erreicht durch die Profi Komponente	1	1	2015-07-25 11:35:02.519446	2015-07-25 11:35:02.519523	t	f	1
28	VIM Adventures	http://vim-adventures.com/	vim-adventures.com	{}	\N	VIM Adventures is an online game based on VIM's keyboard shortcuts. It's the "Zelda meets text editing" game. So come have some fun and learn some VIM!	1	1	2015-07-25 11:35:11.371057	2015-07-25 11:35:11.371145	t	f	1
29	Web Console — Web-based SSH in your browser	http://www.web-console.org/	web-console.org	{}	\N	Web Console is a web-based application that allows to execute shell commands on a server directly from a browser (web-based SSH). The application is very light, does not require any database and can be installed in about 3 minutes.	1	1	2015-07-25 11:35:13.419837	2015-07-25 11:35:13.419946	t	f	1
30	gosugamers.net	http://www.gosugamers.net/lol	gosugamers.net	{}	\N	\N	1	1	2015-07-25 11:35:18.693052	2015-07-25 11:35:18.693161	t	f	1
31	property database - HomeCompany Munich - Agency for temporary furnished accommodation	http://muenchen.homecompany.de/en/suchergebnis/noreset/1	muenchen.homecompany.de	{}	\N	You can search for your suitable accommodation or property you desire the Agency Munich, or simply browsein our offers. 	1	1	2015-07-25 11:35:26.885361	2015-07-25 11:35:26.885442	t	t	1
32	2wunder.slack.com	https://2wunder.slack.com/home	2wunder.slack.com	{}	\N	\N	1	1	2015-07-25 11:35:31.16459	2015-07-25 11:35:31.164665	t	f	1
33	Vertabelo - Design Your Database Online	https://www.vertabelo.com	vertabelo.com	{}	\N	Fully-featured online tool for database design – simple but powerful. Create a database model, share it with your team, and finally generate SQL scripts instead of writing them manually.	1	1	2015-07-25 11:35:37.025418	2015-07-25 11:35:37.025524	t	f	1
34	wg-gesucht.de	http://www.wg-gesucht.de/en/wg-zimmer-in-Muenchen.90.0.0.0.html	wg-gesucht.de	{}	\N	\N	1	1	2015-07-25 11:35:44.054553	2015-07-25 11:35:44.054636	t	t	1
35	amazon.com	http://www.amazon.com/Cartoon-History-Universe-Volumes-1-7/dp/0385265204/ref=sr_1_1?ie=UTF8&qid=1427398587&sr=8-1&keywords=cartoon history of the universe	amazon.com	{}	\N	\N	1	1	2015-07-25 11:36:01.037734	2015-07-25 11:36:01.0378	t	t	1
36	COUCHMASTER® Pro - Black Edition: Amazon.de: Computer & Zubehör	http://www.amazon.de/COUCHMASTER%C2%AE-Pro-PC-Gaming-integriertes-Kabelmanagement/dp/B00CCHRJ2Q	amazon.de	{}	\N	COUCHMASTER® Pro - Black Edition: Amazon.de: Computer & Zubehör	1	1	2015-07-25 11:36:07.970231	2015-07-25 11:36:07.970335	t	t	1
37	Python vs Ruby - The Workshape Smackdown	http://blog.workshape.io/python-vs-ruby-the-workshape-smackdown/	blog.workshape.io	{}	\N		1	1	2015-07-25 11:36:14.150247	2015-07-25 11:36:14.150328	t	t	1
38	railsjobs.de	http://railsjobs.de/rubyonrails/11616-freelance-senior-ruby-on-rails-developer-m-f-berlin-wimdu-gmbh	railsjobs.de	{}	\N	\N	1	1	2015-07-25 11:36:20.54209	2015-07-25 11:36:20.542192	t	t	1
39	TechCrunch Disrupt Returns To London December 5-8  |  TechCrunch	http://techcrunch.com/2015/03/30/techcrunch-disrupt-returns-to-london-from-december-5th-to-8th/	techcrunch.com	{}	\N	Last year European startups raised more money in the first quarter than they had during the "dot-com boom". Much of that money and startup activity was coming..	1	1	2015-07-25 11:36:27.829765	2015-07-25 11:36:27.829844	t	t	1
40	Pretty, short urls for every route in your Rails app - Arkency Blog	http://blog.arkency.com/2014/01/short-urls-for-every-route-in-your-rails-app/	blog.arkency.com	{}	\N	Photo remix available thanks to the courtesy of Moyan Brenn. CC BY 2.0 One of our recent project had the requirement so that admins are able to generate short top level urls (like /cool) for every page in our system. Basically a url shortening service ins	1	1	2015-07-25 11:36:33.200896	2015-07-25 11:36:33.200974	t	t	1
41	Disqus – The Web’s Community of Communities	https://disqus.com/	disqus.com	{}	\N	The web's community of communities now has one central hub.	1	1	2015-07-25 11:36:38.421759	2015-07-25 11:36:38.421847	t	f	1
42	rubymonk.com	https://rubymonk.com/	rubymonk.com	{}	\N	\N	1	1	2015-07-25 11:36:45.139273	2015-07-25 11:36:45.139352	t	f	1
43	mobile.nytimes.com	http://mobile.nytimes.com/2013/07/02/magazine/evermans-war.html?_r=0&referrer&utm_content=buffera2a48&utm_medium=social&utm_source=facebook.com&utm_campaign=buffer	mobile.nytimes.com	{}	\N	\N	1	1	2015-07-25 11:36:52.438774	2015-07-25 11:36:52.438858	t	t	1
44	Free Live Chat Software for Websites | Pure Chat	https://www.purechat.com/	purechat.com	{}	\N		1	1	2015-07-25 11:36:58.426785	2015-07-25 11:36:58.426887	t	f	1
45	Bidsketch: Proposal Software & Proposal Templates	https://www.bidsketch.com/	bidsketch.com	{}	\N	Create professional looking client proposals in half the time. Win more projects with online proposal software, Bidsketch.	1	1	2015-07-25 11:37:05.882927	2015-07-25 11:37:05.883003	t	f	1
46	Motley Crew: The incredible story of the Dirty Dozen Rowing Club | FOX Sports	http://www.foxsports.com/olympics/story/features-dirty-dozen-rowing-club-011315	foxsports.com	{}	\N	In 1983, a group of overage, hard-drinking, rugby-playing badasses from the Bay Area set out to turn the stuffy world of competitive rowing upside down. The ultimate goal? Olympic gold.\n	1	1	2015-07-25 11:37:12.407032	2015-07-25 11:37:12.407134	t	t	1
47	The Perfect Game Of Thrones Video Game Already Exists	http://kotaku.com/the-perfect-game-of-thrones-video-game-already-exists-5913709	kotaku.com	{}	\N	Forget RPGs, action games or even the promise of a decent adventure title. The perfect Game of Thrones video game already exists, as a mod for a PC game that's not too shabby itself. Finally, A Game of Thrones Video Game That Looks Worthy Of The Name Fina	1	1	2015-07-25 11:37:18.868474	2015-07-25 11:37:18.868553	t	t	1
48	Forge Solid KILO: Denser than solid uranium by Jaime Raijman — Kickstarter	https://www.kickstarter.com/projects/1014603694/forge-solid-denser-than-solid-uranium?ref=jellop	kickstarter.com	{}	\N	Jaime Raijman is raising funds for Forge Solid KILO: Denser than solid uranium on Kickstarter! \n\n Introducing the KILO CUBE by Forge Solid.  Geometrically perfect, it's crafted from 1 kg of aerospace grade Tungsten (W).	1	1	2015-07-25 11:37:24.983364	2015-07-25 11:37:24.98345	t	t	1
49	How to do a ghetto tubeless conversion using Gorilla tape 26er 650b\\27.5er and 29er - YouTube	https://www.youtube.com/watch?v=YbJDPgdZxMY	youtube.com	{}	\N	This video shows you how to convert a bicycle rim that is not tubeless ready to one that is. The how to uses 1" (25mm) Gorilla tape to form a seal around the...	1	1	2015-07-25 11:37:30.216131	2015-07-25 11:37:30.216213	t	t	1
50	Cellagon – From the abundance of nature	http://www.cellagon.de/en/	cellagon.de	{}	\N		1	1	2015-07-25 11:37:36.84599	2015-07-25 11:37:36.846069	t	f	1
51	[500DISTRO] Do You Speak Growth? Examining the Language Behind What Users Want - YouTube	https://www.youtube.com/watch?v=FI52Z-fDM5c	youtube.com	{}	\N	James Currier, Co-Founder @ Ooga Labs & Growth Advisor, PayPal	1	1	2015-07-25 11:37:45.694643	2015-07-25 11:37:45.694724	t	t	1
52	Porch: Designs, remodel ideas, and costs for home projects	https://porch.com	porch.com	{}	\N	Find design ideas for your home and professionals for all projects including maintenance, repair and remodels.	1	1	2015-07-25 11:37:51.136046	2015-07-25 11:37:51.136123	t	f	1
53	Getting High with a Hallucinogenic Toad Prophet - YouTube	https://www.youtube.com/watch?t=1260&v=cOFSX6nezEY	youtube.com	{}	\N	Our Vice Mexico team went to the Sonora desert in search of the Bufo Alvarius, an endemic toad species that contains a very high dosage of 5-MEO-DMT in it´s ...	1	1	2015-07-25 11:37:59.275737	2015-07-25 11:37:59.275812	t	t	1
54	tacit	http://yegor256.github.io/tacit/	yegor256.github.io	{}	\N	CSS Framework for Dummies	1	1	2015-07-25 11:38:06.892397	2015-07-25 11:38:06.892521	t	f	1
55	Immobilien, Wohnungen und Häuser bei ImmobilienScout24	http://www.immobilienscout24.de/	immobilienscout24.de	{}	\N	Das größte Angebot an Immobilien finden Sie bei ImmobilienScout24. Jetzt einfach, effizient und stressfrei Wohnungen und Häuser mieten, kaufen oder anbieten	1	1	2015-07-25 11:38:13.879898	2015-07-25 11:38:13.879976	t	f	1
56	Book Things To Do, Attractions, and Tours | GetYourGuide	http://www.getyourguide.com/	getyourguide.com	{}	\N	Find, compare, and book sightseeing tours, attractions, excursions, things to do and fun activities from around the world. Save money and book directly from local suppliers.	1	1	2015-07-25 11:38:20.243036	2015-07-25 11:38:20.243126	t	f	1
57	Comics archive - Stuart McMillen cartoons	http://www.stuartmcmillen.com/comics/	stuartmcmillen.com	{}	\N	Archive gallery of Stuart McMillen's comics and cartoons on science, society and ecological sustainability.	1	1	2015-07-25 11:38:25.86653	2015-07-25 11:38:25.866606	t	f	1
58	JS NICE: Statistical renaming, Type inference and Deobfuscation	http://www.jsnice.org/	jsnice.org	{}	\N	JS NICE | Software Reliability Lab in ETH	1	1	2015-07-25 11:38:39.170318	2015-07-25 11:38:39.170409	t	f	1
59	lolnexus.com	http://www.lolnexus.com/EUNE/search?name=crodux76&region=EUNE	lolnexus.com	{}	\N	\N	1	1	2015-07-25 11:38:45.857057	2015-07-25 11:38:45.857142	t	t	1
60	Anime Movies to watch - Album on Imgur	http://imgur.com/a/9UGCL	imgur.com	{}	\N	Non Ghibli, hopefully lesser known anime flicks to check out for those who are interested!	1	1	2015-07-25 11:38:50.966376	2015-07-25 11:38:50.966459	t	t	1
61	UX Crash Course: 31 Fundamentals | The Hipper Element	http://thehipperelement.com/post/75476711614/ux-crash-course-31-fundamentals	thehipperelement.com	{}	\N	Using, abusing, & designing human behaviour.	1	1	2015-07-25 11:38:57.884707	2015-07-25 11:38:57.884787	t	t	1
62	tenderi.hgk.hr Login	http://tenderi.hgk.hr/login.php	tenderi.hgk.hr	{}	\N	Xenon Boostrap Admin Panel	1	1	2015-07-25 11:39:04.244854	2015-07-25 11:39:04.244942	t	f	1
63	cloudsurfing.com	http://www.cloudsurfing.com/browse/	cloudsurfing.com	{}	\N	\N	1	1	2015-07-25 11:39:10.147689	2015-07-25 11:39:10.147769	t	f	1
64	Markets - AngelList	https://angel.co/markets	angel.co	{}	\N	AngelList is a platform for startups	1	1	2015-07-25 11:39:16.047694	2015-07-25 11:39:16.047763	t	f	1
65	appappeal.com	http://www.appappeal.com/	appappeal.com	{}	\N	\N	1	1	2015-07-25 11:39:20.858772	2015-07-25 11:39:20.858851	t	f	1
75	Why I am no longer a Christian by Evid3nc3 - YouTube	https://www.youtube.com/watch?v=dsAZSz2Yb_8	youtube.com	{god}	vid	A brilliant mini series that I have put together as one whole video. Made by http://www.youtube.com/user/Evid3nc3 Enjoy and please subscribe to his channel.	1	1	2015-07-25 11:40:18.353925	2015-07-26 01:44:11.107971	t	t	1
79	LAUNCH FESTIVAL: Product Hunt AMA with Roy Bahat, Head, Bloomberg Beta - YouTube	https://www.youtube.com/watch?v=Q6M6ixc7OZ0	youtube.com	{}	vid	At the 2015 LAUNCH Festival, Product Hunt's Ryan Hoover sits down with Roy Bahat, Head, Bloomberg Beta	1	1	2015-07-25 11:40:51.91291	2015-07-25 12:15:06.111664	t	t	1
78	Jedan matematičar tvrdi da je zlatni rez obična prevara stara 150 godina i upravo mi je srušio cijeli svijet - Telegram	http://www.telegram.hr/kultura/jedan-matematicar-tvrdi-da-je-zlatni-rez-obicna-prevara-i-upravo-mi-je-srusio-cijeli-svijet/	telegram.hr	{}		Sjedio sam na klupici Louvre muzeja u Parizu. Možda sam imao 12 godina, nisam siguran, ali znam da sam bio potpuno fasciniran. Stari mi je objašnjavao što	1	1	2015-07-25 11:40:43.587829	2015-07-25 12:15:06.114054	t	t	1
81	Kingpin - free quailty online games and gaming!	http://www.kingpin.com/	kingpin.com	{}		Kingpin, quality free online games.	1	1	2015-07-25 11:41:22.3037	2015-07-26 01:07:44.023737	t	f	3
76	How the Bible Led Me to Islam: The Story of a Former Christian Youth Minister - Joshua Evans - YouTube	https://www.youtube.com/watch?v=IYMKQKSV0bY	youtube.com	{god}	vid	Like us on Facebook: http://wwww.facebook.com/themimbar Follow us on Twitter: http://www.twitter.com/digitalmimbar How the Bible Led Me to Islam: The Story o...	1	1	2015-07-25 11:40:23.140216	2015-07-26 01:44:18.225187	t	t	1
74	ebay.com	http://www.ebay.com/sch/i.html?_from=R40&_trksid=p2050601.m570.l1313.TR0.TRC0.H0.Xarnette glory daze.TRS0&_nkw=arnette glory daze&_sacat=0	ebay.com	{}		\N	1	1	2015-07-25 11:40:12.523046	2015-07-25 12:15:06.127033	t	t	1
73	Richard Dawkins & Brian Greene - 2014 Religious Conversation - YouTube	https://www.youtube.com/watch?v=O8LbBqc31a0	youtube.com	{}	vid	For more celebrity videos from the world of movies, sports, politics, science, comedy and music, please subscribe to my channel Celebrity Universe https://ww...	1	1	2015-07-25 11:40:06.460525	2015-07-25 12:15:06.131404	t	t	1
72	Unlawful Killing - Full Movie - Documentary - YouTube	https://www.youtube.com/watch?v=n1vdw633QkM	youtube.com	{}	vid	The "establishment" assassination of Diana and Dodi	1	1	2015-07-25 11:40:01.231422	2015-07-25 12:15:06.136501	t	t	1
71	wg-gesucht.de	http://www.wg-gesucht.de/	wg-gesucht.de	{}		\N	1	1	2015-07-25 11:39:54.952078	2015-07-25 12:15:06.141737	t	f	1
70	Circular - an open source Buffer app	http://circular.io/	circular.io	{}		Circular is an open source Buffer app. Stock up some great tweets and have them automatically shared throughout the day.	1	1	2015-07-25 11:39:50.131977	2015-07-25 12:15:06.147398	t	f	1
69	pointninecap.com	http://www.pointninecap.com/portfolio	pointninecap.com	{}		\N	1	1	2015-07-25 11:39:45.603794	2015-07-25 12:15:06.151568	t	f	1
77	HackerOne: Vulnerability Coordination and Bug Bounty Platform	https://hackerone.com/	hackerone.com	{saas}		HackerOne provides a platform designed to streamline vulnerability coordination and bug bounty program by enlisting hackers to improve your security.	1	1	2015-07-25 11:40:30.636125	2015-07-26 01:07:06.929496	t	f	1
66	Browse All Business Software Directories at Capterra	http://www.capterra.com/categories	capterra.com	{db}		If you need business software, Capterra is the place for you. With over 300 software categories, you are sure to find the solution you need.	1	1	2015-07-25 11:39:26.869203	2015-07-26 00:25:38.246318	t	f	1
68	kimaventures.com	http://www.kimaventures.com/	kimaventures.com	{}		\N	1	1	2015-07-25 11:39:40.111286	2015-07-26 00:26:06.561975	t	f	5
67	Business Software Reviews, SaaS & Cloud Applications Directory | GetApp	http://www.getapp.com/	getapp.com	{db}		Review, Compare and Evaluate small business software. GetApp has software offers, SaaS and Cloud Apps, independent evaluations and reviews	1	1	2015-07-25 11:39:32.891581	2015-07-26 00:24:26.825888	t	f	1
83	Avernum: Escape From the Pit HD - iPad 2 - HD Gameplay Trailer - YouTube	https://www.youtube.com/watch?v=Lhf-FO6CVq8	youtube.com	{}	vid	Avernum: Escape From the Pit HD by Spiderweb Software Avernum: Escape From the Pit HD is an epic, indie fantasy role-playing adventure. It is optimized for t...	1	1	2015-07-25 11:41:34.468943	2015-07-26 01:17:00.808167	t	t	3
109	pouchdb.com	http://pouchdb.com/	pouchdb.com	{db}		\N	1	1	2015-07-25 11:44:40.512313	2015-07-26 01:11:10.008528	t	f	1
99	Dezinr - Portfolio	http://www.dezinr.com/	dezinr.com	{}		Portfolio 	1	1	2015-07-25 11:43:37.531466	2015-07-26 01:19:40.601761	f	f	8
107	Curvytron	http://www.curvytron.com/#/	curvytron.com	{}		The ultimate addictive multiplayer game, come and play with friends or fellow workers !	1	1	2015-07-25 11:44:29.773188	2015-07-26 01:19:04.594456	t	f	3
106	dapulse - Lead your team with the big picture	https://dapulse.com/	dapulse.com	{saas}		Become a better manager, lead your team with dapulse's big picture - management is better when it's visual.	1	1	2015-07-25 11:44:21.834985	2015-07-26 01:18:50.741363	t	f	1
104	Kong - Open-Source API and Microservice Management Layer	http://getkong.org	getkong.org	{}		Secure, Manage & Extend your APIs or Microservices with plugins for authentication, logging, rate-limiting, transformations and more.	1	1	2015-07-25 11:44:04.841643	2015-07-25 12:15:06.054893	t	f	1
103	Manifold JS	http://www.manifoldjs.com/	manifoldjs.com	{}			1	1	2015-07-25 11:43:59.289182	2015-07-25 12:15:06.056802	t	f	1
101	‘Rent-a-Foreigner in China’ - The New York Times	http://www.nytimes.com/2015/04/28/opinion/rent-a-foreigner-in-china.html	nytimes.com	{}		In this short documentary, housing developers in China hire ordinary foreigners to pose as celebrities to raise flagging property sales.	1	1	2015-07-25 11:43:49.141098	2015-07-25 12:15:06.060608	t	t	1
102	Slides – Create and share presentations online	http://slides.com/	slides.com	{tool}		Slides is a place for creating, presenting and sharing presentations. The Slides editor is available right in your browser. Unlike traditional presentation software, like PowerPoint, there's no need to download anything.	1	1	2015-07-25 11:43:54.007898	2015-07-26 01:09:16.204241	t	f	1
100	Portfolio of Maciej Mach	http://maciejmach.pl/	maciejmach.pl	{}		web design, mobile apps, branding	1	1	2015-07-25 11:43:41.473796	2015-07-26 01:08:34.083321	t	f	8
98	markoprljic.com	http://www.markoprljic.com/	markoprljic.com	{}		\N	1	1	2015-07-25 11:43:30.303782	2015-07-25 12:15:06.066196	t	f	1
108	Patchmania for iOS	http://www.getpatchmania.com/	getpatchmania.com	{}		A delightful puzzle about bunny revenge!	1	1	2015-07-25 11:44:34.861555	2015-08-20 15:05:18.222697	f	f	3
96	foodora | Top Restaurant Lieferservice | Essen online	https://www.volo.de/	volo.de	{}		Online bestellen in Ihren Lieblingsrestaurants | Blitzschneller Lieferservice ✔ Frische Mahlzeiten in 32min ✔ Die beste Alternative zu FastFood ✔	1	1	2015-07-25 11:43:20.351317	2015-07-25 12:15:06.069978	t	f	1
95	The Limits of Discourse : As Demonstrated by Sam Harris and Noam Chomsky :Sam Harris	http://www.samharris.org/blog/item/the-limits-of-discourse	samharris.org	{}		Sam Harris and Noam Chomsky attempt to have a conversation about the ethics of war, terrorism, state surveillance, and related topics--and fail.	1	1	2015-07-25 11:43:13.893382	2015-07-25 12:15:06.072067	t	t	1
94	World of Warcraft: Looking for Group Documentary - YouTube	https://www.youtube.com/watch?v=xyPzTywUBsQ	youtube.com	{}	vid	An all-new documentary celebrating 10 years of adventure, camaraderie, and /dancing on mailboxes all around Azeroth. Explore the history of WoW with its crea...	1	1	2015-07-25 11:42:54.087395	2015-07-25 12:15:06.073908	t	t	1
93	A light-hearted moment from a children's bible : WTF	http://www.reddit.com/r/WTF/comments/2v31f1/a_lighthearted_moment_from_a_childrens_bible/	reddit.com	{}		reddit: the front page of the internet	1	1	2015-07-25 11:42:43.234222	2015-07-25 12:15:06.07579	t	t	1
97	Zopim Pricing | Free Live Chat Trial | Affordable Pricing	https://www.zopim.com/pricing	zopim.com	{saas}		Award-winning live chat software solution. Chat with visitors in real-time and increase conversions. Sales and support made easy for businesses. Free 14-day trial.	1	1	2015-07-25 11:43:25.364817	2015-07-26 01:19:50.595956	t	f	1
91	Zappos CEO Tony Hsieh: Adopt Holacracy Or Leave  | Fast Company | Business + Innovation	http://www.fastcompany.com/3044417/zappos-ceo-tony-hsieh-adopt-holacracy-or-leave	fastcompany.com	{}		An internal memo provided to Fast Company by Zappos.	1	1	2015-07-25 11:42:27.967035	2015-07-25 12:15:06.079668	t	t	1
90	When Going Online Will Send You To Prison - Digg	http://digg.com/2015/when-going-online-will-send-you-to-prison	digg.com	{}		What happens when a former hacker becomes legally forbidden from using the Internet as a condition of his parole.	1	1	2015-07-25 11:42:20.828396	2015-07-25 12:15:06.081713	t	t	1
89	Living small and cozy - Album on Imgur	http://imgur.com/a/Ikrmb	imgur.com	{}		And yes, its winter	1	1	2015-07-25 11:42:14.339848	2015-07-25 12:15:06.084043	t	f	1
88	firstround.com	http://firstround.com/openapp	firstround.com	{}		\N	1	1	2015-07-25 11:42:06.143661	2015-07-25 12:15:06.086084	t	f	1
87	b92.net	http://www.b92.net/zivot/pop.php?yyyy=2015&mm=04&dd=22&nav_id=983667	b92.net	{}		\N	1	1	2015-07-25 11:41:59.951473	2015-07-25 12:15:06.088193	t	t	1
86	Building Gallipoli Episode 5 - YouTube	https://www.youtube.com/watch?t=245&v=P5atPpq-rxc	youtube.com	{}	vid	The big reveal! Finally Gallipoli: The scale of our war is open and we can show you the process used by Weta Workshop to create our larger than life figures ...	1	1	2015-07-25 11:41:52.624409	2015-07-25 12:15:06.08997	t	t	1
85	MINDBODY: Online Business Management Software	https://www.mindbodyonline.com/	mindbodyonline.com	{}		A world of possibilities, from the world leader in software for class- and appointment-based businesses. See why over 42,000 of them rely on MINDBODY.	1	1	2015-07-25 11:41:48.764912	2015-07-25 12:15:06.092004	t	f	1
84	This French tech school has no teachers, no books, no tuition -- and it could change everything | VentureBeat | Dev | by Dylan Tweney	http://venturebeat.com/2014/06/13/this-french-tech-school-has-no-teachers-no-books-no-tuition-and-it-could-change-everything/?hn=true	venturebeat.com	{}		PARIS — École 42 might be one of the most ambitious experiments in engineering education.	1	1	2015-07-25 11:41:41.85338	2015-07-25 12:15:06.095618	t	t	1
105	Hyperactive | Creative solutions for web and mobile	http://www.thehyperactive.com/	thehyperactive.com	{}		Hyperactive is a software design & development agency that creates awesome looking web and mobile applications.	1	1	2015-07-25 11:44:10.57529	2015-07-26 01:18:42.662228	t	f	10
92	Documentation - Materialize	http://materializecss.com/	materializecss.com	{}		Materialize is a modern responsive CSS framework based on Material Design by Google. 	1	1	2015-07-25 11:42:33.173863	2015-07-26 01:08:18.487966	t	f	8
141	Enterprise Sales Guide	http://www.enterprisesales.nyc/	enterprisesales.nyc	{}		Work-Bench is an enterprise technology growth accelerator in NYC. We scale companies through our community, workspace, business development, and venture fund.	1	1	2015-07-25 11:48:19.463739	2015-07-25 12:15:02.510807	t	f	1
140	Amazingly Simple Graphic Design Software – Canva	https://www.canva.com/	canva.com	{}		Canva makes design simple for everyone. Create designs for Web or print: blog graphics, presentations, Facebook covers, flyers, posters, invitations and so much more.	1	1	2015-07-25 11:48:13.96022	2015-07-25 12:15:02.513123	t	f	1
139	push.cx	https://push.cx/2015/railsconf	push.cx	{}		\N	1	1	2015-07-25 11:48:10.263475	2015-07-25 12:15:02.515373	t	t	1
138	Viadeo.com - United States: where professionals meet	http://us.viadeo.com/en/	us.viadeo.com	{}		 65 million members | 2 700 000 companies | 30 000 groups | Jobs | 5 alumni | Professional network - United States.	1	1	2015-07-25 11:48:03.700188	2015-07-25 12:15:02.517978	t	f	1
137	StockSnap.io - Beautiful Free Stock Photos (CC0)	https://stocksnap.io/	stocksnap.io	{}		The #1 source for beautiful free stock photos. High quality and high resolution images free from all copyright restrictions (CC0) - no attribution required.	1	1	2015-07-25 11:47:58.382376	2015-07-25 12:15:02.520079	t	f	1
136	Drag out files like Gmail  |  The CSS Ninja - Web tech, front-end performance & silly ideas	http://www.thecssninja.com/javascript/gmail-dragout	thecssninja.com	{}		How Gmail does their drag to desktop attachment saving using the Drag and Drop API.	1	1	2015-07-25 11:47:53.09081	2015-07-25 12:15:02.522118	t	t	1
135	blog.rebil.co	http://blog.rebil.co/	blog.rebil.co	{}		\N	1	1	2015-07-25 11:47:46.025232	2015-07-25 12:15:02.524454	t	f	1
134	lollyrock.com	http://lollyrock.com/articles/nodejs-encryption/	lollyrock.com	{}		\N	1	1	2015-07-25 11:47:40.380004	2015-07-25 12:15:02.526612	t	t	1
133	youtube.com	https://www.youtube.com/results?search_query=parov stelar	youtube.com	{}		\N	1	1	2015-07-25 11:47:33.362659	2015-07-25 12:15:02.52858	t	t	1
132	alt j - YouTube	https://www.youtube.com/results?search_query=alt%20j	youtube.com	{}		Share your videos with friends, family, and the world	1	1	2015-07-25 11:47:24.237836	2015-07-25 12:15:02.530517	t	t	1
131	Coursera - Specializations	https://www.coursera.org/specialization/jhudatascience/1	coursera.org	{}		Take free online classes from 120+ top universities and educational organizations. We partner with schools like Stanford, Yale, Princeton, and others to offer courses in dozens of topics, from computer science to teaching and beyond. Whether you are pursu	1	1	2015-07-25 11:47:14.134136	2015-07-25 12:15:02.532519	t	t	1
130	music.musicofthemoon.com	http://music.musicofthemoon.com	music.musicofthemoon.com	{}		\N	1	1	2015-07-25 11:47:08.528217	2015-07-25 12:15:02.534705	t	f	1
129	carpenterbrut.bandcamp.com	https://carpenterbrut.bandcamp.com/	carpenterbrut.bandcamp.com	{}		\N	1	1	2015-07-25 11:47:02.098139	2015-07-25 12:15:02.536829	t	f	1
128	JavaScript Graphing Library Comparison	http://www.jsgraphs.com/	jsgraphs.com	{}		Comparing all the different javascript graphing libraries.	1	1	2015-07-25 11:46:53.551934	2015-07-25 12:15:02.538782	t	f	1
126	BBC Three - Reggie Yates' Extreme Russia	http://www.bbc.co.uk/programmes/b05rbyhq	bbc.co.uk	{}		  Reggie Yates gets up close and personal with three very different communities in Russia.  	1	1	2015-07-25 11:46:41.533635	2015-07-25 12:15:02.543181	t	t	1
127	coinado.io	https://coinado.io/	coinado.io	{}		\N	1	1	2015-07-25 11:46:48.659456	2015-07-26 01:19:17.234708	f	f	1
125	boz.	http://boz.com/	boz.com	{}			1	1	2015-07-25 11:46:23.544405	2015-07-26 01:16:20.626199	t	f	8
124	Codemancers - Craftsmen of Web & Mobile applications	http://www.codemancers.com/	codemancers.com	{}		We are craftsmen and tinkerers of Web & Mobile applications. We are a small team with deep passion for creating wonderful web & Mobile applications.	1	1	2015-07-25 11:46:18.440333	2015-07-26 01:15:21.632787	t	f	10
122	World War II in Cologne: Delusion - SPIEGEL ONLINE	http://www.spiegel.de/international/europe/world-war-ii-in-cologne-delusion-a-1032115.html	spiegel.de	{}		Daily news, analysis and opinion from Europe's leading newsmagazine and Germany's top news Web site.	1	1	2015-07-25 11:46:03.117011	2015-07-25 12:15:02.55271	t	t	1
123	Business Software and Services Reviews | G2 Crowd	https://www.g2crowd.com/	g2crowd.com	{db}		Compare the best business software and services based on user ratings and social data. Reviews for CRM, ERP, CAD, PDM, HR, and Marketing software.	1	1	2015-07-25 11:46:09.777745	2015-07-26 01:13:41.297216	t	f	1
120	Imagoid - Supercharged Reddit galleries	http://www.imagoid.com	imagoid.com	{}		Imagoid is the best way to browse Reddit and Imgur images, showing them as galleries and slideshows	1	1	2015-07-25 11:45:51.625798	2015-07-25 12:15:02.55732	t	f	1
119	keiththompsonart.com	http://www.keiththompsonart.com/colour.html	keiththompsonart.com	{}		\N	1	1	2015-07-25 11:45:46.24598	2015-07-25 12:15:02.559327	t	f	1
118	society6.com	http://society6.com/smafo	society6.com	{}		\N	1	1	2015-07-25 11:45:40.556687	2015-07-25 12:15:02.561714	t	f	1
117	The Best Site For Recipes, Recommendations, Food And Cooking | Yummly	http://www.yummly.com/	yummly.com	{}		Search for recipes by ingredient, diet, allergy, nutrition, taste, calories, fat, price, cuisine, time, course and source.	1	1	2015-07-25 11:45:34.106532	2015-07-25 12:15:02.563932	t	f	1
121	Immobilien schnell und einfach finden bei immowelt.de	http://www.immowelt.de/	immowelt.de	{}		Aktuelle Immobilien, schöne Wohnungen und Häuser zum Kaufen oder Mieten in ganz Deutschland. Jetzt schnell und einfach finden bei immowelt.de	1	1	2015-07-25 11:45:57.657866	2015-07-26 01:13:23.287151	t	f	9
115	We Don’t Sell Saddles Here — Medium	https://medium.com/@stewart/we-dont-sell-saddles-here-4c59524d650d	medium.com	{}		The memo below was sent to the team at Tiny Speck, the makers of Slack, on July 31st, 2013. It had been a little under s…	1	1	2015-07-25 11:45:22.860251	2015-07-25 12:15:06.031243	t	t	1
116	Simplora.de - Alle Online-Supermärkte und -Drogerien auf einer Seite	https://www.simplora.de/	simplora.de	{}		cudo servis od Vincentovog frenda	1	1	2015-07-25 11:45:30.762197	2015-07-26 01:12:18.669597	t	f	1
113	The Greatest Story NEVER Told - The Untold Story of Adolf Hitler	http://tgsnt.tv/	tgsnt.tv	{}		Watch The Greatest Story Never Told, Adolf Hitler and learn the real story about the most reviled man in history. A 6 hour Documentary by TruthWillOut Films	1	1	2015-07-25 11:45:09.593126	2015-07-25 12:15:06.036009	t	f	1
114	hamljs	https://www.npmjs.com/package/hamljs	npmjs.com	{}		Faster / Express compliant Haml implementation	1	1	2015-07-25 11:45:16.573162	2015-07-26 01:10:40.132682	f	f	1
168	Software: Business & Nonprofit | Reviews and Top Software at Capterra	http://www.capterra.com/	capterra.com	{}		Capterra helps millions of people find the best business software. With software reviews, ratings, infographics, and the most comprehensive list of the top business software products available, you're sure to find what you need at Capterra.	1	1	2015-07-25 11:51:58.671038	2015-07-25 12:14:47.871929	t	f	1
167	jqueryscript.net	http://www.jqueryscript.net/demo/Easy-Drag-and-Drop-Plugin-For-jQuery-dad-js/	jqueryscript.net	{}		\N	1	1	2015-07-25 11:51:52.795441	2015-07-25 12:14:47.873953	t	t	1
166	100+ jQuery Drag & Drop Plugins Tutorials with example	http://www.jqueryrain.com/example/jquery-drag-drop/	jqueryrain.com	{}		jQuery drag and drop list of plugins and tutorial with examples.jQuery draggable plugin	1	1	2015-07-25 11:51:47.620093	2015-07-25 12:14:47.875946	t	t	1
165	Aecore	http://asm-aecore-dev.herokuapp.com/projects/create	asm-aecore-dev.herokuapp.com	{}		Project management for construction.	1	1	2015-07-25 11:51:39.576322	2015-07-25 12:15:02.457036	t	f	1
164	emby.media	http://emby.media/	emby.media	{}		\N	1	1	2015-07-25 11:51:15.674694	2015-07-25 12:15:02.459979	t	f	1
155	Beirut Discography (download torrent) - TPB	https://thepiratebay.vg/torrent/4846280/Beirut_Discography	thepiratebay.vg	{music}		Download Beirut Discography torrent or any other torrent from the Audio Music. Direct download via magnet link.	1	1	2015-07-25 11:50:21.588039	2015-07-26 01:21:15.8275	t	t	1
163	markt.motorradonline.de	http://markt.motorradonline.de/gebrauchtes-motorrad-1346659-suzuki-bandit-1250s?pos=62	markt.motorradonline.de	{}		\N	1	1	2015-07-25 11:51:11.017218	2015-07-26 01:20:30.026713	t	t	4
162	Gebrauchte Ducati Monster 695 von DUCATI Stuttgart, Baujahr: 2007, 17500 km, Preis: 4.489,00 EUR. aus Baden-Württemberg - MOTORRAD online	http://markt.motorradonline.de/gebrauchtes-motorrad-1346736-ducati-monster-695?pos=49	markt.motorradonline.de	{}		Daten zum gebrauchten Motorrad: Hubraum 695 ccm, Leistung 71 PS, BJ 2007, 17.500 km, Farbe SCHWARZ, 4.489,00 EUR, aus Baden-Württemberg	1	1	2015-07-25 11:51:07.14833	2015-07-26 01:20:25.122576	t	t	4
161	markt.motorradonline.de	http://markt.motorradonline.de/gebrauchtes-motorrad-1346734-bmw-f-800-r?pos=47	markt.motorradonline.de	{}		\N	1	1	2015-07-25 11:50:59.169125	2015-07-26 01:20:20.660951	t	t	4
159	Delightful lessons for dedicated programmers - Practicing Ruby	https://practicingruby.com/	practicingruby.com	{}			1	1	2015-07-25 11:50:44.896484	2015-07-25 12:15:02.471137	t	f	1
158	Dobro došli na portal znanja - Toni Milun	http://www.tonimilun.com/	tonimilun.com	{}		Ovaj obrazovni portal namijenjen je svim učenicima osnovnih i srednjih škola te studentima koji slušaju predmet statistika i matematika. Profesor Toni Milun	1	1	2015-07-25 11:50:38.652032	2015-07-25 12:15:02.473491	t	f	1
157	PgTune	http://pgtune.leopard.in.ua/	pgtune.leopard.in.ua	{}		PgTune - Tuning PostgreSQL config by your hardware	1	1	2015-07-25 11:50:32.330849	2015-07-25 12:15:02.47553	t	f	1
156	stackoverflow.com	http://stackoverflow.com/questions/4768748/requireing-a-coffeescript-file-from-a-javascript-file-or-repl	stackoverflow.com	{}		\N	1	1	2015-07-25 11:50:26.243288	2015-07-25 12:15:02.477901	t	t	1
154	Making Rack::Reloader work with Sinatra | The Devver Blog	https://devver.wordpress.com/2009/12/21/making-rackreloader-work-with-sinatra/	devver.wordpress.com	{}		According to the Sinatra FAQ, source reloading was taken out of Sinatra in version 0.9.2 due to "excess complexity" (in my opinion, that's a great idea, because it's not a feature that needs to be in minimal a web framework like Sinatra). Also, according 	1	1	2015-07-25 11:50:14.188606	2015-07-25 12:15:02.482194	t	t	1
153	$LOADED_FEATURES and require, load, require_dependency | BigBinary Blog	http://blog.bigbinary.com/2010/05/12/require-load-loaded_features.html	blog.bigbinary.com	{}		 This blog discusses LOADED_FEATURES, require, load and require_dependency in ruby. 	1	1	2015-07-25 11:50:07.530004	2015-07-25 12:15:02.484192	t	t	1
152	scontent.xx.fbcdn.net	https://scontent.xx.fbcdn.net/hphotos-xat1/v/t1.0-9/11168125_468077070027287_7843071713999662457_n.jpg?oh=e270d7add0fb16c1dd851c0a2ec3fcaa&oe=5634E1DF	scontent.xx.fbcdn.net	{}		\N	1	1	2015-07-25 11:49:59.612329	2015-07-25 12:15:02.486138	t	t	1
151	VMware | Careers	https://www.themuse.com/companies/vmware	themuse.com	{}		Explore VMware careers, find out what it's like to work at the Silicon Valley, CA office, in addition to jobs that the company is hiring for.	1	1	2015-07-25 11:49:52.016005	2015-07-25 12:15:02.488227	t	f	1
150	lorempixel - placeholder images for every case	http://lorempixel.com/	lorempixel.com	{}		Placeholder Images for every case. Webdesign or Print. Just put a custom url in your html and you receive a proper placeholder picture	1	1	2015-07-25 11:49:46.747377	2015-07-25 12:15:02.490448	t	f	1
149	simonsmith.io	http://simonsmith.io/	simonsmith.io	{}		\N	1	1	2015-07-25 11:49:41.04717	2015-07-25 12:15:02.492787	t	f	1
148	GeoMetric	http://webflow.com/template/GeoMetric	webflow.com	{}		GeoMetric is a modern and colorful responsive Webflow template. It consists of 7 page templates and multiple useful page sections which you can edit to fit your own images, icons and textual content.	1	1	2015-07-25 11:49:35.283498	2015-07-25 12:15:02.494826	t	f	1
147	Button Concept	http://codepen.io/chrisdothtml/pen/xbmddV	codepen.io	{}		A cool little CSS button...	1	1	2015-07-25 11:49:29.99415	2015-07-25 12:15:02.496832	t	f	1
146	phusionpassenger.com	https://www.phusionpassenger.com/documentation/ServerOptimizationGuide.html	phusionpassenger.com	{}		\N	1	1	2015-07-25 11:49:22.940476	2015-07-25 12:15:02.498753	t	f	1
145	Hire Freelance Software Developers from the Top 3%	http://www.toptal.com/	toptal.com	{}		Toptal connects start-ups, businesses, and organizations to a growing network of the best custom software developers in the world. Our engineers are available full-time, part-time, or hourly and are able to seamlessly integrate into your team.	1	1	2015-07-25 11:49:17.591173	2015-07-25 12:15:02.500924	t	f	1
144	buildyourownsinatra.com	http://buildyourownsinatra.com/	buildyourownsinatra.com	{}		\N	1	1	2015-07-25 11:49:06.345963	2015-07-25 12:15:02.503487	t	f	1
143	2015 Internet Trends Report	http://www.slideshare.net/kleinerperkins/internet-trends-v1?ref=https://www.linkedin.com/pulse/25b-opp-mobile-ads-mary-meekers-2015-internet-trends-report-wong	slideshare.net	{}		KPCB’s Mary Meeker presents the 2015 Internet Trends report, 20 years after the inaugural “The Internet Report” was first published in 1995. Since then, the nu…	1	1	2015-07-25 11:48:58.795151	2015-07-25 12:15:02.50618	t	t	1
160	markt.motorradonline.de	http://markt.motorradonline.de/gebrauchtes-motorrad-1326067-aprilia-pegaso-650-strada	markt.motorradonline.de	{}		\N	1	1	2015-07-25 11:50:51.854943	2015-07-26 01:20:15.565436	t	t	4
204	stackoverflow.com	http://stackoverflow.com/questions/14824453/rails-raw-sql-example	stackoverflow.com	{}		\N	1	1	2015-07-25 11:58:24.328485	2015-07-25 12:14:47.798599	t	t	1
202	psychologytoday.com	https://www.psychologytoday.com/	psychologytoday.com	{}		\N	1	1	2015-07-25 11:58:12.991182	2015-07-25 12:14:47.803017	t	f	1
201	marvl.infotech.monash.edu	http://marvl.infotech.monash.edu/webcola/	marvl.infotech.monash.edu	{}		\N	1	1	2015-07-25 11:58:08.875473	2015-07-25 12:14:47.805104	t	f	1
200	zuti-titl.com	http://zuti-titl.com/specijal/takashi-miike/	zuti-titl.com	{}		\N	1	1	2015-07-25 11:57:58.641593	2015-07-25 12:14:47.807234	t	t	1
199	quora.com	http://www.quora.com/What-are-the-best-ways-to-make-1000 -per-month-with-little-to-no-capital-without-getting-a-job/answer/Tony-Briggs	quora.com	{}		\N	1	1	2015-07-25 11:57:50.734434	2015-07-25 12:14:47.809268	t	t	1
198	matt.might.net	http://matt.might.net/articles/how-to-native-iphone-ipad-apps-in-javascript/	matt.might.net	{}		\N	1	1	2015-07-25 11:57:41.243562	2015-07-25 12:14:47.811255	t	t	1
197	Babel · The compiler for writing next generation JavaScript	https://babeljs.io/	babeljs.io	{}		The compiler for writing next generation JavaScript	1	1	2015-07-25 11:57:36.097118	2015-07-25 12:14:47.813532	t	f	1
196	airbnb/javascript · GitHub	https://github.com/airbnb/javascript	github.com	{}		javascript - JavaScript Style Guide	1	1	2015-07-25 11:57:30.80742	2015-07-25 12:14:47.815532	t	f	1
195	Everything Is Yours, Everything Is Not Yours — Matter — Medium	https://medium.com/matter/everything-is-yours-everything-is-not-yours-d6f66bd9c6f9	medium.com	{}		At age six, I ran away with my sister to escape the Rwandan massacre. We spent seven years as refugees. What do you want…	1	1	2015-07-25 11:57:24.481287	2015-07-25 12:14:47.817368	t	t	1
194	bold-hotels.2wunder.de	http://bold-hotels.2wunder.de/gmap?lat=48.1350767&lng=11.6203115	bold-hotels.2wunder.de	{}		\N	1	1	2015-07-25 11:57:18.097183	2015-07-25 12:14:47.819202	t	t	1
193	gettingovergod.com	http://www.gettingovergod.com/?p=121	gettingovergod.com	{}		\N	1	1	2015-07-25 11:57:09.524876	2015-07-25 12:14:47.821023	t	t	1
192	Mike Adams – Developing developers	http://www.mgadams.com/	mgadams.com	{}		Developing developers	1	1	2015-07-25 11:57:03.490771	2015-07-25 12:14:47.82282	t	f	1
191	Impossible Mission. Commodore 64 remake.	http://impossible-mission.krissz.hu/	impossible-mission.krissz.hu	{}		Impossible Mission. Commodore 64 remake.	1	1	2015-07-25 11:56:56.578038	2015-07-25 12:14:47.824721	t	f	1
190	thepugautomatic.com	http://thepugautomatic.com/2012/07/sinatra-with-rack-cache-on-heroku/	thepugautomatic.com	{}		\N	1	1	2015-07-25 11:56:49.471347	2015-07-25 12:14:47.826991	t	t	1
189	Business Process Management Tool & Workflow Software | Automate Workflows	https://kissflow.com/	kissflow.com	{}		KiSSFLOW is a workflow tool & business process workflow management software to automate your workflow process. Rated #1 cloud workflow software in Google Apps Marketplace.	1	1	2015-07-25 11:56:39.450746	2015-07-25 12:14:47.829214	t	f	1
188	en.wikipedia.org	https://en.wikipedia.org/wiki/Synthwave	en.wikipedia.org	{}		\N	1	1	2015-07-25 11:56:34.065948	2015-07-25 12:14:47.831207	t	f	1
187	The 100% FREE live chat application for your website!	https://www.tawk.to/	tawk.to	{saas}		tawk.to is a free live chat app that lets you monitor and chat with visitors on your website or from a free customizable page	1	1	2015-07-25 11:56:23.534312	2015-08-24 14:30:31.646624	t	f	30
186	Business Process Management Tool & Workflow Software | Automate Workflows	https://kissflow.com/#home	kissflow.com	{}		KiSSFLOW is a workflow tool & business process workflow management software to automate your workflow process. Rated #1 cloud workflow software in Google Apps Marketplace.	1	1	2015-07-25 11:56:18.343628	2015-07-25 12:14:47.83549	t	f	1
185	Dino Reic (dinoreic) | Pearltrees	http://www.pearltrees.com/dinoreic	pearltrees.com	{}		Unnamed pearl. Stash buckets	1	1	2015-07-25 11:56:13.092611	2015-07-25 12:14:47.837437	t	f	1
184	deveiate.org	http://deveiate.org/code/linguistics/Linguistics/EN.html	deveiate.org	{}		\N	1	1	2015-07-25 11:56:07.206251	2015-07-25 12:14:47.839147	t	f	1
183	High Performance and Cheap Cloud Servers Deployment - Vultr.com	https://www.vultr.com/pricing/	vultr.com	{}		View details and pricing information for the most popular VULTR plans.	1	1	2015-07-25 11:53:36.974614	2015-07-25 12:14:47.84107	t	f	1
182	dev.af83.com	http://dev.af83.com/2013/02/28/load-testing-with-siege.html	dev.af83.com	{}		\N	1	1	2015-07-25 11:53:31.663494	2015-07-25 12:14:47.842952	t	t	1
181	trevorsomething.bandcamp.com	http://trevorsomething.bandcamp.com/	trevorsomething.bandcamp.com	{}		\N	1	1	2015-07-25 11:53:25.655557	2015-07-25 12:14:47.844847	t	f	1
180	JScreenFix - Pixel Repair	http://www.jscreenfix.com/	jscreenfix.com	{}		Repair stuck pixels using the JScreenFix algorithm.	1	1	2015-07-25 11:53:18.687963	2015-07-25 12:14:47.846958	t	f	1
179	DeltaWalker: Advanced file and folder comparison and synchronization	http://www.deltawalker.com/	deltawalker.com	{}		DeltaWalker - world's most advanced and intuitive\r\n two- and three-way visual file and folder comparison for Mac OS X, Windows and Linux.\r\n Use DeltaWalker to compare (diff) and merge files, compare and synchronize folders.	1	1	2015-07-25 11:53:13.201739	2015-07-25 12:14:47.848998	t	f	1
178	Getting Started\r - Mithril	https://lhorie.github.io/mithril/getting-started.html	lhorie.github.io	{}		\N	1	1	2015-07-25 11:53:08.064047	2015-07-25 12:14:47.850992	t	t	1
177	Learning the Tarot - An On-Line Course	http://www.learntarot.com/	learntarot.com	{}		Online Course for Learning the Tarot	1	1	2015-07-25 11:53:01.362808	2015-07-25 12:14:47.853152	t	f	1
176	THE BIGGEST LIES EVER TOLD IN THE WORLD - YouTube	https://www.youtube.com/watch?v=F-6x4e8mA5I	youtube.com	{}	vid	THE POWER OF PROPAGANDA . WARNING ! STRONG CONTENT. NOT FOR KIDS. (15+) PLEASE SHARE . North Korea released a film titled "Propaganda". We are brainwashed by...	1	1	2015-07-25 11:52:53.482926	2015-07-25 12:14:47.855089	t	t	1
175	careers.stackoverflow.com	http://careers.stackoverflow.com/jobs/90356/ruby-on-rails-developer-full-stack-shore-gmbh?utm_source=stackoverflow.com&utm_medium=ad&utm_campaign=large-sidebar-orange-nearyou	careers.stackoverflow.com	{}		\N	1	1	2015-07-25 11:52:47.201065	2015-07-25 12:14:47.856994	t	t	1
174	Welcome to Shore - The software for local businesses	http://www.shore.com/en/	shore.com	{}		Shore ist die führende Softwarelösung für lokale Unternehmen zur Verwaltung von Terminen, Kunden und Automatisierung des Marketings - jetzt kostenlos testen	1	1	2015-07-25 11:52:40.969592	2015-07-25 12:14:47.859424	t	f	1
173	Bootcards - Cards-based UI built with Bootstrap	http://bootcards.org/index.html	bootcards.org	{}		Bootcards - A cards-based UI for mobile and desktop apps, built on top of Bootstrap	1	1	2015-07-25 11:52:34.681347	2015-07-25 12:14:47.861573	t	f	1
172	dynamicsjs.com	http://dynamicsjs.com/	dynamicsjs.com	{}		\N	1	1	2015-07-25 11:52:29.421019	2015-07-25 12:14:47.863602	t	f	1
215	Nouvelle Vague - Nouvelle Vague - YouTube	https://www.youtube.com/watch?v=cfvIMTlM4sY	youtube.com	{}	vid	00:00 "Love Will Tear Us Apart" Joy Division 03:18 "Just Can't Get Enough" Depeche Mode 06:26 "In a Manner of Speaking" Tuxedomoon 10:23 "Guns of Brixton" Th...	1	1	2015-07-25 11:59:33.995012	2015-07-25 12:14:47.77354	t	t	1
214	Discover and get early access to tomorrow's startups - BetaList	http://betalist.com/	betalist.com	{}		BetaList provides an overview of upcoming internet startups. Discover and get early access to the future.	1	1	2015-07-25 11:59:27.433179	2015-07-25 12:14:47.777377	t	f	1
213	bevacqua.github.io	http://bevacqua.github.io/dragula/	bevacqua.github.io	{}		\N	1	1	2015-07-25 11:59:22.29618	2015-07-25 12:14:47.779296	t	f	1
212	Construction Equipment Rental | EquipmentShare	https://equipmentshare.com/	equipmentshare.com	{}		EquipmentShare offers high quality equipment rental at a guaranteed lowest price. Rent construction equipment, heavy equipment and lifts from contractors.	1	1	2015-07-25 11:59:16.74313	2015-07-25 12:14:47.781262	t	f	1
211	gettingovergod.com	http://www.gettingovergod.com/?p=262	gettingovergod.com	{}		\N	1	1	2015-07-25 11:59:11.189683	2015-07-25 12:14:47.783135	t	t	1
210	Want a Better Pitch? Watch This. — Firm Narrative — Medium	https://medium.com/firm-narrative/want-a-better-pitch-watch-this-328b95c2fd0b	medium.com	{}		When leaders ask me to help them tell better stories, I always start by sending them this video.	1	1	2015-07-25 11:59:05.786957	2015-07-25 12:14:47.785083	t	t	1
209	Terence Mckenna - DMT, Mathematical Dimensions, Syntax and Death - YouTube	https://www.youtube.com/watch?v=VuEXBBaFAbw	youtube.com	{}	vid	Our facebook community, check it out https://www.facebook.com/EtherealExposition	1	1	2015-07-25 11:58:58.745877	2015-07-25 12:14:47.787222	t	t	1
208	DMT: You Cannot Imagine a Stranger Drug or a Stranger Experience | VICE | United States	http://www.vice.com/read/dmt-you-cannot-imagine-a-stranger-drug-or-a-stranger-experience-365	vice.com	{}		"Why this is not four-inch headlines on every newspaper on the planet I cannot understand, because I don't know what news you were waiting for, but this is the news that <i>I</i> was waiting for." —Terence McKenna on DMT	1	1	2015-07-25 11:58:52.170224	2015-07-25 12:14:47.78934	t	t	1
207	jQuery plugin for FileAPI	http://rubaxa.github.io/jquery.fileapi/	rubaxa.github.io	{}		jQuery.fn.fileapi — the best plugin for jQuery (it is true)	1	1	2015-07-25 11:58:42.651411	2015-07-25 12:14:47.791575	t	f	1
206	Big quiet flat - close to munich  in Markt Schwaben	https://www.airbnb.com/rooms/1980877	airbnb.com	{}		Private room for $40. We rent the attic of our house to nice guests. The attic consists of a bathroom, a living area and a sleep area. The house is in a quiet area never...	1	1	2015-07-25 11:58:37.6877	2015-07-25 12:14:47.794151	t	t	1
205	NeonMob | Collect, Exchange, and Trade Original Digital Art	https://www.neonmob.com/	neonmob.com	{}		A Thriving Digital Art Creation and Collecting Community	1	1	2015-07-25 11:58:31.105716	2015-07-25 12:14:47.796543	t	f	1
203	The Greatest Story NEVER Told - The Untold Story of Adolf Hitler	http://thegreateststorynevertold.tv/	thegreateststorynevertold.tv	{}		Watch The Greatest Story Never Told, Adolf Hitler and learn the real story about the most reviled man in history. A 6 hour Documentary by TruthWillOut Films	1	1	2015-07-25 11:58:18.661252	2015-07-25 12:14:47.800759	t	f	1
171	gorillatoolkit.org	http://www.gorillatoolkit.org/	gorillatoolkit.org	{}		\N	1	1	2015-07-25 11:52:23.206363	2015-07-25 12:14:47.865855	t	f	1
170	a8m/go-lang-cheat-sheet · GitHub	https://github.com/a8m/go-lang-cheat-sheet	github.com	{}		go-lang-cheat-sheet - An overview of Go syntax and features.	1	1	2015-07-25 11:52:16.448268	2015-07-25 12:14:47.867955	t	t	1
169	Typeplate » A typographic starter kit encouraging great type on the Web	http://typeplate.com/	typeplate.com	{}		A typographic starter kit for Web developers and designers, where we don’t make too many design choices, but we do set out patterns for proper markup and “pre-designed” styles for great Web typography.\n	1	1	2015-07-25 11:52:10.429585	2015-07-25 12:14:47.869959	t	f	1
142	Ruby on Rails development setup for Mac OSX - Created by Pete	http://www.createdbypete.com/articles/ruby-on-rails-development-setup-for-mac-osx/	createdbypete.com	{}		Most developers like to spend a bit of time setting up their development workspace. I’m no different, after a number of years tweaking and experimenting the following article details how I setup my environment for Mavericks/Yosemite.	1	1	2015-07-25 11:48:52.785978	2015-07-25 12:15:02.508479	t	t	1
111	Tropo - Cloud API for Voice and Messaging	https://www.tropo.com/	tropo.com	{}		Hosted Voice and SMS API	1	1	2015-07-25 11:44:58.238014	2015-07-25 12:15:06.039784	t	f	1
110	Quick Start – Harp, the static web server with built-in preprocessing	http://harpjs.com/docs/quick-start	harpjs.com	{}		Harp is a production-ready web server. Rapidly build static sites and client-side applications using Markdown, Sass, CoffeeScript, and more—no configuration necessary.	1	1	2015-07-25 11:44:52.830326	2015-07-25 12:15:06.041905	t	t	1
82	Documentation - Bootflat	http://bootflat.github.io/documentation.html	bootflat.github.io	{}		The complete style of the Bootflat Framework.	1	1	2015-07-25 11:41:28.404932	2015-07-25 12:15:06.102427	t	f	1
80	Landeshauptstadt München - Registration and Deregistration of Residency	http://www.muenchen.de/rathaus/home_en/Department-of-Public-Order/Registration-Deregistration	muenchen.de	{}		Residence Registration	1	1	2015-07-25 11:41:14.716469	2015-07-25 12:15:06.109174	t	t	1
112	univang.com	http://univang.com/	univang.com	{}		\N	1	1	2015-07-25 11:45:03.421742	2015-07-26 01:10:20.417843	t	f	3
216	TRIUMPH TIGER 800 XC Bikes for Sale | Used Motorbikes & Motorcycles For Sale | MCN	http://www.motorcyclenews.com/bikes-for-sale/triumph/tiger-800-xc/	motorcyclenews.com	{motor}		TRIUMPH TIGER 800 XC used motorbikes and new motorbikes for sale on MCN. Buy and sell TRIUMPH TIGER 800 XC bikes through MCN's bikes for sale service	1	1	2015-07-25 18:38:28.592009	2015-07-26 00:25:24.348174	t	t	4
218	English-Speaking Frontend Developer Ruby on Rails	http://de.dice.com/?Mode=AdvertView&AdvertId=9583734&xc=207&utm_source=Feed&utm_medium=Aggregator&utm_campaign=IndeedRecCons&rx_medium=cpc&rx_campaign=indeed25&rx_source=indeed	de.dice.com	{}		English-Speaking Frontend Developer Ruby on Rails	1	1	2015-07-28 21:21:21.584894	2015-07-28 21:21:29.626029	t	t	6
217	next level IT-Personalberatung	https://www.nextlevel.de/festangestellte/	nextlevel.de	{}		Vermittlung von IT-Experten in Festanstellungen und Projekte bei Top-Unternehmen. Unser Personalberater-Team hat selbst IT-Expertise und freut sich auf Sie!	1	1	2015-07-28 21:20:36.015163	2015-07-28 21:21:29.631039	t	f	6
219	flexbox.io	http://flexbox.io/	flexbox.io	{}		\N	1	1	2015-07-28 21:52:09.728834	2015-07-29 11:34:47.531189	t	f	11
220	drive.google.com	https://drive.google.com/folderview?id=0B0bQGZDHkWXBfkpmdkxWWTV6eXViVUZ2ZTFrTlZIdFVjQ2lsdHJoM1hzd01USFdrc09vWm8&usp=sharing	drive.google.com	{}		project description	1	1	2015-07-29 09:59:19.728487	2015-07-29 11:34:47.528283	t	t	12
221	github.com	https://github.com/2wunder/bauclub	github.com	{}		\N	1	1	2015-07-29 11:47:51.063416	2015-07-29 11:53:23.556466	t	t	12
222	Introduction to Human Behavioral Biology -\nRobert Sapolsky Rocks	http://www.robertsapolskyrocks.com/intro-to-human-behavioral-biology.html	robertsapolskyrocks.com	{}		Professor Sapolsky provides an overview of the course curriculum. Also, he awards a bagel with cream cheese to a fellow New Yorker.	1	1	2015-07-29 13:46:51.11804	2015-07-29 13:46:51.369223	t	t	1
232	Harp, the static web server with built-in preprocessing	http://harpjs.com/	harpjs.com	{}		Harp is a production-ready web server. Rapidly build static sites and client-side applications using Markdown, Sass, CoffeeScript, and more—no configuration necessary.	1	1	2015-08-04 09:31:30.981459	2015-08-05 09:47:24.293639	t	f	15
223	file.io	https://www.file.io/	file.io	{saas}		\N	1	1	2015-07-29 22:30:39.241267	2015-07-29 22:30:42.988132	t	f	1
224	sefaz.rs.gov.br	https://www.sefaz.rs.gov.br/nfe/nfe-val.aspx	sefaz.rs.gov.br	{}		\N	2	2	2015-07-31 00:27:33.418053	2015-07-31 00:27:33.588355	t	t	13
225	Yamaha MT01 - YouTube	https://www.youtube.com/watch?v=yB5B1xroxY0	youtube.com	{}	vid	Dave and our guest Road Tester Ellen Foster think this Yamaha is fun and nimble and smooth. Check out our Road Test. For everything motorcycle, visit www.mot...	1	1	2015-08-01 11:56:23.980083	2015-08-01 11:56:39.016041	t	t	4
226	Learner Approved Bikes Reviews - ProductReview.com.au	http://www.productreview.com.au/c/learner-approved-bikes.html	productreview.com.au	{}		Learner Approved Bikes: Find consumer reviews for 164 Learner Approved Bikes on ProductReview.com.au, Australia's No.1 Opinion Site.	1	1	2015-08-01 12:04:24.919407	2015-08-01 12:07:23.576249	t	t	4
228	Sequel: The Database Toolkit for Ruby - Documentation	http://sequel.jeremyevans.net/documentation.html	sequel.jeremyevans.net	{}		Ruby Sequel is a lightweight database toolkit for Ruby.	1	1	2015-08-01 16:13:42.226288	2015-08-01 20:19:42.279559	t	f	14
227	twin.github.io	http://twin.github.io/ode-to-sequel/	twin.github.io	{}		\N	1	1	2015-08-01 13:09:58.249403	2015-08-01 20:19:42.285232	t	t	14
229	The GravityLight — GravityLight	http://gravitylight.org/gravitylight	gravitylight.org	{}			1	1	2015-08-01 21:41:45.629367	2015-08-01 21:41:45.936082	t	f	1
230	FREE MOVIES ONLINE & TV ONLINE 2015 - Putlocker, Megashare9 on HDMOVIE14	http://hdmovie14.net	hdmovie14.net	{}		Watch free movies online and tv online (2015). We update daily and all free from PUTLOCKER, MEGASHARE9. You can watch free HD movies online without downloading (dvd download) | FREE MOVIES ONLINE & TV ONLINE 2015 - Putlocker, Megashare9 on HDMOVIE14	1	1	2015-08-02 00:36:42.627594	2015-08-02 00:36:42.800234	t	f	1
231	MovieSub - Watch Movies Online Free, Best Site to Watch Free Movies	http://moviesub.net	moviesub.net	{}		Watch & Download Movies Online for Free, Watch Movies Online, Streaming Free Movies Online, New Movies, Hot Movies, Drama Movies, Lastest Movies...	1	1	2015-08-02 01:11:10.228399	2015-08-02 01:11:10.459531	t	f	1
235	workpop.com	https://workpop.com/	workpop.com	{}		\N	1	1	2015-08-05 09:46:28.031829	2015-08-05 09:47:24.262187	t	f	7
234	How to play piano - flowkey is a new way to learn piano online	http://www.flowkey.com/en	flowkey.com	{}		flowkey is the easiest way to learn piano. Learn anywhere, anytime and start free, no experience needed.	1	1	2015-08-05 09:42:00.910009	2015-08-05 09:47:24.275667	t	f	17
236	classcraft.com	http://www.classcraft.com/	classcraft.com	{}		\N	1	1	2015-08-05 09:47:26.308312	2015-08-05 09:47:26.566451	t	f	1
237	Raise Your Flag | Awesome careers that don’t require college	https://raiseyourflag.com/	raiseyourflag.com	{}		Raise Your Flag helps young people without a degree or diploma find meaningful work, get the skills they need and connect to companies who are hiring.	1	1	2015-08-06 00:18:11.980099	2015-08-06 10:51:09.510033	t	f	7
240	Cloudimage.io - Image Resize in the cloud, Delivered By CDN	https://cloudimage.io/	cloudimage.io	{}			1	1	2015-08-07 08:49:11.839985	2015-08-07 09:16:58.220729	t	f	20
239	imgix • Real-time image processing and image CDN	https://www.imgix.com/	imgix.com	{}		imgix solves images. We tackle the complexity of responsive imagery to help you deliver the highest value image to the right device, at the right time, every time. On-demand image processing, optimization and delivery.	1	1	2015-08-07 08:43:20.565989	2015-08-07 09:16:58.224379	t	f	20
238	memrise.com	http://www.memrise.com/home/#	memrise.com	{}		\N	1	1	2015-08-07 08:33:57.932021	2015-08-07 09:16:58.228183	t	f	19
241	Cloudinary - Cloud image service, upload, storage & CDN	http://cloudinary.com/	cloudinary.com	{}		Seamlessly manage your website's images in the cloud - image upload, cloud storage, image manipulation, image API and fast CDN\n\ngerman service	1	1	2015-08-07 09:16:52.865778	2015-08-07 09:17:20.429451	t	f	20
243	Learn German with GermanPod101.com\n- YouTube	https://www.youtube.com/user/germanpod101	youtube.com	{}		Learn German with GermanPod101.com - The Fastest, Easiest and Most Fun Way to Learn German. :) Start speaking German in minutes with Audio and Video lessons....	1	1	2015-08-07 10:20:42.516512	2015-08-07 13:45:42.364165	t	t	19
242	zenhabits.net	http://zenhabits.net/how-to-learn-a-language-in-90-days/	zenhabits.net	{}		\N	1	1	2015-08-07 09:30:06.13124	2015-08-07 13:45:42.371377	t	t	19
247	Voynich- Home	http://voynich-manuskript.de/ms408/index.php?id=homeen	voynich-manuskript.de	{}		For decades many tried to suss the puzzle out and just can't get access. Nevertheless, they can't get rid of it...	1	1	2015-08-10 09:34:14.974576	2015-08-10 10:47:56.082601	t	t	1
246	Startup Jobs Search in Singapore , Malaysia , Hong Kong and Philippines	http://www.startupjobs.asia/	startupjobs.asia	{}		Startup Jobs Search, startup recruiting and hiring in Singapore, Malaysia, Hong Kong and Philippines . We bring great talents to great company	1	1	2015-08-10 07:33:31.147855	2015-08-10 10:47:56.092212	t	f	6
245	Everyday Economics | MRUniversity	http://mruniversity.com/courses/everyday-economics	mruniversity.com	{}		An entertaining video series that explores how the “big ideas” from economics relate to everyday topics.	1	1	2015-08-10 07:16:52.139661	2015-08-10 10:47:56.096531	t	t	1
244	Economics of the Media | MRUniversity	http://mruniversity.com/courses/economics-media	mruniversity.com	{}		The economics of the media and how government policy affects it.	1	1	2015-08-10 07:07:39.041909	2015-08-10 10:47:56.100649	t	t	1
233	About Us | YogaGlo	https://www.yogaglo.com/about	yogaglo.com	{}		Yoga videos and classes from the top yoga instructors. YogaGlo brings poses and styles like hatha, yin and vinyasa flow yoga right into your living room.	1	1	2015-08-04 15:27:13.071798	2015-08-20 12:58:53.916504	t	f	25
250	drive.google.com	https://drive.google.com/folderview?id=0B0bQGZDHkWXBfkpmdkxWWTV6eXViVUZ2ZTFrTlZIdFVjQ2lsdHJoM1hzd01USFdrc09vWm8&usp=sharing_eid	drive.google.com	{}		\N	1	1	2015-08-11 20:44:18.913647	2015-08-12 06:46:40.289924	t	t	22
249	hack.chat	https://www.hack.chat/	hack.chat	{saas}		\N	1	1	2015-08-10 20:11:18.417389	2015-08-12 06:46:40.295329	t	f	1
277	influxhq.com	https://influxhq.com/tour/	influxhq.com	{}		\N	1	1	2015-08-24 12:19:09.841576	2015-08-24 12:20:30.293812	t	f	25
251	Search & Compare Cheap Buses, Trains & Flights | GoEuro	http://www.goeuro.com/	goeuro.com	{saas}		Start your European journey with one click. GoEuro makes it easy to compare and combine air, rail, bus and car for better pricing and easier booking.	1	1	2015-08-12 06:41:42.390637	2015-08-12 06:46:40.281828	t	f	1
248	Nobel Laureate Smashes the Global Warming Hoax - YouTube	https://www.youtube.com/watch?v=TCy_UOjEir0	youtube.com	{}	vid	Nobel laureate Ivar Giaever's speech at the Nobel Laureates meeting 1st July 2015. Ivar points out the mistakes which Obama makes in his speeches about globa...	1	1	2015-08-10 14:42:10.32418	2015-08-12 06:46:40.300242	t	t	1
252	Bus travel through Europe | FlixBus	https://www.flixbus.com	flixbus.com	{saas}		Low cost bus travel. 10,000 daily connections to around 300 destinations in over 15 different European countries.	1	1	2015-08-12 06:47:25.01259	2015-08-12 06:47:29.739896	t	f	1
254	Markhor	http://themarkhor.com/	themarkhor.com	{shop}		High quality handcrafted shoes, delivered directly to you. Fast free shipping both way.	1	1	2015-08-14 07:27:20.957873	2015-08-14 07:27:36.716029	t	f	1
253	ferrolic.com	http://www.ferrolic.com/	ferrolic.com	{}		\N	1	1	2015-08-13 10:26:29.69292	2015-08-14 07:27:36.723829	t	f	1
257	25 Great Psychological Thrillers That Are Worth Your Time - Album on Imgur	http://imgur.com/gallery/B0frm	imgur.com	{}	\N	Images of favorite and forget uploaded by WhoHasSmeltRainbow	1	1	2015-08-18 09:57:45.819073	2015-08-18 09:58:28.843421	f	t	24
262	Download the latest indie games - itch.io	http://itch.io/	itch.io	{}		      itch.io is a simple way to find, download and distribute indie games\n      online. Whether you're a developer looking to upload your game or just\n      someone looking for something new to play itch.io has you covered.\n    	1	1	2015-08-19 12:30:35.370813	2015-08-19 12:30:54.183371	t	f	3
260	The 18 Best Philosophical Movies of All Time - Album on Imgur	http://imgur.com/gallery/M8qKj	imgur.com	{}		Images uploaded by WhoHasSmeltRainbow	1	1	2015-08-18 09:58:09.110019	2015-08-18 09:58:29.138315	t	t	24
259	25 Great Psychological Thrillers That Are Worth Your Time - Album on Imgur	http://imgur.com/gallery/B0frm	imgur.com	{}		Images of favorite and forget uploaded by WhoHasSmeltRainbow	1	1	2015-08-18 09:58:00.209498	2015-08-18 09:58:29.148202	t	t	24
256	Die besten Schnäppchen und Angebote bei mydealz.de	http://www.mydealz.de/	mydealz.de	{}		19364 Schnäppchen ✓ Kostenlose Nutzung ✓ Sicher dir die besten Angebote und Deals bei mydealz.de.	1	1	2015-08-18 09:13:39.470826	2015-08-18 09:58:29.16847	t	f	23
255	Crypt of the NecroDancer -33% on GOG.com	http://www.gog.com/game/crypt_of_the_necrodancer	gog.com	{}		Download the best classic and new games on Windows, Mac & Linux. A vast selection of titles, DRM-free, with free goodies and 30-day money-back guarantee.	1	1	2015-08-14 13:50:16.17222	2015-08-18 09:58:29.17821	t	f	3
258	25 Great Psychological Thrillers That Are Worth Your Time - Album on Imgur	http://imgur.com/gallery/B0frm	imgur.com	{}		Images of favorite and forget uploaded by WhoHasSmeltRainbow	1	1	2015-08-18 09:57:54.590369	2015-08-18 09:58:41.945972	f	t	24
261	Hey Imgur! Have some science and stuff - Album on Imgur	http://imgur.com/gallery/ucfdn	imgur.com	{}		Images of bullshit and citation needed uploaded by ThisIsNotMyDinnerSuit	1	1	2015-08-18 09:58:14.110379	2015-08-18 11:53:24.132925	t	f	24
266	Salty Bet	http://www.saltybet.com/	saltybet.com	{}		Salty Bet allows you to place bets on live competitive events.	1	1	2015-08-20 09:18:45.915021	2015-08-20 12:32:51.079723	t	f	1
265	The Simple CRM for Google Apps	https://www.prosperworks.com/	prosperworks.com	{}		ProsperWorks is easy-to-use customer relationship management for small businesses. Capture contacts and sales leads direct from Gmail with our simple CRM.	1	1	2015-08-20 08:11:33.832397	2015-08-20 12:32:51.087347	t	f	26
264	SilkStart.com | Membership Management Software | Online Registration System	http://silkstart.com/	silkstart.com	{}		SilkStart is online software for creating a membership website and managing its members and events. Online registration software. Try us for free!	1	1	2015-08-20 04:22:39.56192	2015-08-20 12:32:51.092789	t	f	25
263	Membership Software by Wild Apricot  | Get a free trial now!	http://www.wildapricot.com/	wildapricot.com	{}		Powerful, easy-to-use membership software with friendly and knowledgeable support. Get your instant free trial account now!	1	1	2015-08-19 14:49:54.938535	2015-08-20 12:32:51.097023	t	f	25
267	Bulletproof contracts, simple e-signing, integrated escrow for freelancers | Bonsai	https://www.hellobonsai.com/	hellobonsai.com	{saas}		Bonsai provides bulletproof freelance work contract templates, simple e-signing, and payment escrow for creative freelancers like designers and developers.	1	1	2015-08-20 12:33:40.854563	2015-08-20 13:18:44.028525	t	f	1
268	Narcolepsy medication modafinil is world's first safe 'smart drug' | Science | The Guardian	http://www.theguardian.com/science/2015/aug/20/narcolepsy-medication-modafinil-worlds-first-safe-smart-drug	theguardian.com	{}		Increasingly taken by healthy people to improve focus before exams, after a comprehensive review researchers say modafinil is safe in the short-term	1	1	2015-08-20 18:20:24.402774	2015-08-20 18:20:38.658975	t	t	1
269	movieo.me	http://movieo.me	movieo.me	{}		\N	3	3	2015-08-20 18:40:34.010192	2015-08-20 18:40:57.780773	t	f	27
270	imba.io	http://imba.io/	imba.io	{}		\N	1	1	2015-08-20 18:49:42.902294	2015-08-20 21:09:18.315106	t	f	28
271	Gigster - Hire a quality developer	https://www.trygigster.com/	trygigster.com	{}			1	1	2015-08-20 21:51:56.932768	2015-08-20 21:52:26.576237	t	f	7
275	MINDBODY: Online Business Management Software	https://www.mindbodyonline.com/	mindbodyonline.com	{}		A world of possibilities, from the world leader in software for class- and appointment-based businesses. See why over 45,000 of them rely on MINDBODY.	1	1	2015-08-24 12:14:05.257291	2015-08-24 12:20:30.304826	t	f	25
273	Uz aplikaciju Stin Jee pronađite povoljnu hranu u blizini	http://www.netokracija.com/stin-jee-aplikacija-hrana-102314	netokracija.com	{}		Zar još jedna aplikacija za 'naručivanje hrane'? Pomislila sam to nakon što sam čula za Stin Jee, koji je nakon Italije i Cipra lansiran i u Hrvatskoj.	1	1	2015-08-22 10:59:52.802055	2015-08-24 12:20:30.314862	t	t	29
272	Stin Jee. Eat & Drink For Less!	http://stinjee.com/	stinjee.com	{}		Stin Jee finds the best special deals on food and drink near you.  Just launch the app and you'll see unbeatable specials on food and drink near you.  Tap on the one you like for directions to the store.  When you get there, just show the store manager or	1	1	2015-08-22 10:46:32.017915	2015-08-24 12:20:30.319779	t	f	29
276	What is the best gym management software to use?	http://www.ideafit.com/answers/what-is-the-best-gym-management-software-to-use?	ideafit.com	{}		I am looking for a new software to use for my fitness center	1	1	2015-08-24 12:18:32.334474	2015-08-24 12:20:30.299112	t	t	25
274	China shares wipe out 2015 gains as stocks tumble 8.5% - MarketWatch	http://www.marketwatch.com/story/china-shares-wipe-out-2015-gains-as-stocks-tumble-85-2015-08-24?page=2	marketwatch.com	{design}		At the heart of the selloff is the concern that the once-highflying Chinese economy may be slowing down dramatically. Lack of action over the weekend by the central bank triggered fresh selling on Monday.	1	1	2015-08-24 11:13:15.729611	2015-08-24 12:20:30.309817	t	t	1
278	Home - Alma Career	http://www.almacareer.com/	almacareer.com	{}		vlasnik MojPosao.hr i ostalih portala u regiji	1	1	2015-08-24 14:25:52.98572	2015-08-24 14:29:01.443497	t	f	7
\.


--
-- Name: links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sbprod
--

SELECT pg_catalog.setval('links_id_seq', 278, true);


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: sbprod
--

COPY logs (id, kind, name, created_by, created_at, grp_id, grp_type) FROM stdin;
\.


--
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sbprod
--

SELECT pg_catalog.setval('logs_id_seq', 1, false);


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: sbprod
--

COPY notes (id, name, data, created_at, created_by, updated_at, updated_by, bucket_id, active, tags) FROM stdin;
1	Ideas	Povezati se sa founders institute	2015-08-06 10:50:22.295681	1	2015-08-06 10:50:48.630263	1	18	t	{}
2	Sample	\N	2015-08-06 23:36:30.151526	2	2015-08-06 23:36:30.151615	2	13	t	{}
3	Linux and Git	Kdiff3	2015-08-10 10:52:19.450478	1	2015-08-10 10:55:43.773582	1	1	t	{}
4	fdfgd	vdxfgdgf	2015-08-21 20:01:18.986068	3	2015-08-21 20:01:24.791738	3	27	t	{}
\.


--
-- Name: notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sbprod
--

SELECT pg_catalog.setval('notes_id_seq', 4, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: sbprod
--

COPY users (id, name, created_at, updated_at, email, avatar, active, pass, connect_via, description) FROM stdin;
2	Guido Malato	2015-07-31 00:25:26.327313	2015-07-31 01:59:36.792563	gmalato@hotmail.com	\N	\N	35f17fd645e191679445bab2b484f2f1b9a84c5f	\N	\N
1	Rejotl	2015-07-24 00:45:01.330854	2015-08-07 12:23:18.10087	rejotl@gmail.com	\N	\N	eb764d926190613387f2fe5d48fc66f5f3ffb60e	\N	\N
3	vmarcetic	2015-08-20 18:33:34.797278	2015-08-20 18:34:19.121643	vmarcetic@gmail.com	\N	\N	\N	\N	\N
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sbprod
--

SELECT pg_catalog.setval('users_id_seq', 3, true);


--
-- Name: buckets_pkey; Type: CONSTRAINT; Schema: public; Owner: sbprod; Tablespace: 
--

ALTER TABLE ONLY buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: sbprod; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: domains_pkey; Type: CONSTRAINT; Schema: public; Owner: sbprod; Tablespace: 
--

ALTER TABLE ONLY domains
    ADD CONSTRAINT domains_pkey PRIMARY KEY (id);


--
-- Name: links_pkey; Type: CONSTRAINT; Schema: public; Owner: sbprod; Tablespace: 
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: logs_pkey; Type: CONSTRAINT; Schema: public; Owner: sbprod; Tablespace: 
--

ALTER TABLE ONLY logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: sbprod; Tablespace: 
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: sbprod; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_logs_on_grp_id; Type: INDEX; Schema: public; Owner: sbprod; Tablespace: 
--

CREATE INDEX index_logs_on_grp_id ON logs USING btree (grp_id);


--
-- Name: index_logs_on_grp_type; Type: INDEX; Schema: public; Owner: sbprod; Tablespace: 
--

CREATE INDEX index_logs_on_grp_type ON logs USING btree (grp_type);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: sbprod; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

