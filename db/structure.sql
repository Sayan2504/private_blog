SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: action_text_rich_texts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.action_text_rich_texts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    body text,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN id SET (pg_attver=145984440);
ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN name SET (pg_attver=145984440);
ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN body SET (pg_attver=145984440);
ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN record_type SET (pg_attver=145984440);
ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN record_id SET (pg_attver=145984440);
ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN created_at SET (pg_attver=145984440);
ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN updated_at SET (pg_attver=145984440);


--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.action_text_rich_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.action_text_rich_texts_id_seq OWNED BY public.action_text_rich_texts.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET (pg_attver=146007616);
ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN name SET (pg_attver=146007616);
ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN record_type SET (pg_attver=146007616);
ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN record_id SET (pg_attver=146007616);
ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN blob_id SET (pg_attver=146007616);
ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN created_at SET (pg_attver=146007616);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET (pg_attver=146026536);
ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN key SET (pg_attver=146026536);
ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN filename SET (pg_attver=146026536);
ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN content_type SET (pg_attver=146026536);
ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN metadata SET (pg_attver=146026536);
ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN service_name SET (pg_attver=146026536);
ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN byte_size SET (pg_attver=146026536);
ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN checksum SET (pg_attver=146026536);
ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN created_at SET (pg_attver=146026536);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);
ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET (pg_attver=146050176);
ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN blob_id SET (pg_attver=146050176);
ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN variation_digest SET (pg_attver=146050176);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.ar_internal_metadata ALTER COLUMN key SET (pg_attver=146066688);
ALTER TABLE ONLY public.ar_internal_metadata ALTER COLUMN value SET (pg_attver=146066688);
ALTER TABLE ONLY public.ar_internal_metadata ALTER COLUMN created_at SET (pg_attver=146066688);
ALTER TABLE ONLY public.ar_internal_metadata ALTER COLUMN updated_at SET (pg_attver=146066688);


--
-- Name: bookmarks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bookmarks (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    post_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.bookmarks ALTER COLUMN id SET (pg_attver=146079080);
ALTER TABLE ONLY public.bookmarks ALTER COLUMN user_id SET (pg_attver=146079080);
ALTER TABLE ONLY public.bookmarks ALTER COLUMN post_id SET (pg_attver=146079080);
ALTER TABLE ONLY public.bookmarks ALTER COLUMN created_at SET (pg_attver=146079080);
ALTER TABLE ONLY public.bookmarks ALTER COLUMN updated_at SET (pg_attver=146079080);


--
-- Name: bookmarks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bookmarks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookmarks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bookmarks_id_seq OWNED BY public.bookmarks.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    post_id bigint NOT NULL,
    user_id bigint NOT NULL,
    body text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.comments ALTER COLUMN id SET (pg_attver=146090424);
ALTER TABLE ONLY public.comments ALTER COLUMN post_id SET (pg_attver=146090424);
ALTER TABLE ONLY public.comments ALTER COLUMN user_id SET (pg_attver=146090424);
ALTER TABLE ONLY public.comments ALTER COLUMN body SET (pg_attver=146090424);
ALTER TABLE ONLY public.comments ALTER COLUMN created_at SET (pg_attver=146090424);
ALTER TABLE ONLY public.comments ALTER COLUMN updated_at SET (pg_attver=146090424);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: follows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.follows (
    id bigint NOT NULL,
    follower_id bigint NOT NULL,
    followed_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.follows ALTER COLUMN id SET (pg_attver=206568368);
ALTER TABLE ONLY public.follows ALTER COLUMN follower_id SET (pg_attver=206568368);
ALTER TABLE ONLY public.follows ALTER COLUMN followed_id SET (pg_attver=206568368);
ALTER TABLE ONLY public.follows ALTER COLUMN created_at SET (pg_attver=206568368);
ALTER TABLE ONLY public.follows ALTER COLUMN updated_at SET (pg_attver=206568368);


--
-- Name: follows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.follows_id_seq OWNED BY public.follows.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    recipient_id bigint NOT NULL,
    actor_id bigint NOT NULL,
    notifiable_type character varying NOT NULL,
    notifiable_id bigint NOT NULL,
    action character varying NOT NULL,
    read_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.notifications ALTER COLUMN id SET (pg_attver=206643912);
ALTER TABLE ONLY public.notifications ALTER COLUMN recipient_id SET (pg_attver=206643912);
ALTER TABLE ONLY public.notifications ALTER COLUMN actor_id SET (pg_attver=206643912);
ALTER TABLE ONLY public.notifications ALTER COLUMN notifiable_type SET (pg_attver=206643912);
ALTER TABLE ONLY public.notifications ALTER COLUMN notifiable_id SET (pg_attver=206643912);
ALTER TABLE ONLY public.notifications ALTER COLUMN action SET (pg_attver=206643912);
ALTER TABLE ONLY public.notifications ALTER COLUMN read_at SET (pg_attver=206643912);
ALTER TABLE ONLY public.notifications ALTER COLUMN created_at SET (pg_attver=206643912);
ALTER TABLE ONLY public.notifications ALTER COLUMN updated_at SET (pg_attver=206643912);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: post_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.post_tags (
    id bigint NOT NULL,
    post_id bigint NOT NULL,
    tag_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.post_tags ALTER COLUMN id SET (pg_attver=146108312);
ALTER TABLE ONLY public.post_tags ALTER COLUMN post_id SET (pg_attver=146108312);
ALTER TABLE ONLY public.post_tags ALTER COLUMN tag_id SET (pg_attver=146108312);
ALTER TABLE ONLY public.post_tags ALTER COLUMN created_at SET (pg_attver=146108312);
ALTER TABLE ONLY public.post_tags ALTER COLUMN updated_at SET (pg_attver=146108312);


--
-- Name: post_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.post_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.post_tags_id_seq OWNED BY public.post_tags.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id bigint NOT NULL,
    title character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    author character varying,
    published_at timestamp(6) without time zone,
    slug character varying,
    views_count integer DEFAULT 0 NOT NULL,
    user_id bigint,
    reactions_count integer DEFAULT 0 NOT NULL,
    scheduled_for timestamp(6) without time zone,
    search_vector tsvector
);
ALTER TABLE ONLY public.posts ALTER COLUMN id SET (pg_attver=146119200);
ALTER TABLE ONLY public.posts ALTER COLUMN title SET (pg_attver=146119200);
ALTER TABLE ONLY public.posts ALTER COLUMN created_at SET (pg_attver=146119200);
ALTER TABLE ONLY public.posts ALTER COLUMN updated_at SET (pg_attver=146119200);
ALTER TABLE ONLY public.posts ALTER COLUMN author SET (pg_attver=146119200);
ALTER TABLE ONLY public.posts ALTER COLUMN published_at SET (pg_attver=146119200);
ALTER TABLE ONLY public.posts ALTER COLUMN slug SET (pg_attver=146119200);
ALTER TABLE ONLY public.posts ALTER COLUMN views_count SET (pg_attver=146119200);
ALTER TABLE ONLY public.posts ALTER COLUMN user_id SET (pg_attver=146119200);
ALTER TABLE ONLY public.posts ALTER COLUMN reactions_count SET (pg_attver=146119200);
ALTER TABLE ONLY public.posts ALTER COLUMN scheduled_for SET (pg_attver=206437936);
ALTER TABLE ONLY public.posts ALTER COLUMN search_vector SET (pg_attver=206520944);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: reactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reactions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    post_id bigint NOT NULL,
    count integer DEFAULT 1 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.reactions ALTER COLUMN id SET (pg_attver=146142416);
ALTER TABLE ONLY public.reactions ALTER COLUMN user_id SET (pg_attver=146142416);
ALTER TABLE ONLY public.reactions ALTER COLUMN post_id SET (pg_attver=146142416);
ALTER TABLE ONLY public.reactions ALTER COLUMN count SET (pg_attver=146142416);
ALTER TABLE ONLY public.reactions ALTER COLUMN created_at SET (pg_attver=146142416);
ALTER TABLE ONLY public.reactions ALTER COLUMN updated_at SET (pg_attver=146142416);


--
-- Name: reactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reactions_id_seq OWNED BY public.reactions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);
ALTER TABLE ONLY public.schema_migrations ALTER COLUMN version SET (pg_attver=146154696);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
ALTER TABLE ONLY public.tags ALTER COLUMN id SET (pg_attver=146165656);
ALTER TABLE ONLY public.tags ALTER COLUMN name SET (pg_attver=146165656);
ALTER TABLE ONLY public.tags ALTER COLUMN slug SET (pg_attver=146165656);
ALTER TABLE ONLY public.tags ALTER COLUMN created_at SET (pg_attver=146165656);
ALTER TABLE ONLY public.tags ALTER COLUMN updated_at SET (pg_attver=146165656);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying,
    address text,
    mobile_number character varying,
    interests character varying[] DEFAULT '{}'::character varying[] NOT NULL
);
ALTER TABLE ONLY public.users ALTER COLUMN id SET (pg_attver=146183888);
ALTER TABLE ONLY public.users ALTER COLUMN email SET (pg_attver=146183888);
ALTER TABLE ONLY public.users ALTER COLUMN encrypted_password SET (pg_attver=146183888);
ALTER TABLE ONLY public.users ALTER COLUMN reset_password_token SET (pg_attver=146183888);
ALTER TABLE ONLY public.users ALTER COLUMN reset_password_sent_at SET (pg_attver=146183888);
ALTER TABLE ONLY public.users ALTER COLUMN remember_created_at SET (pg_attver=146183888);
ALTER TABLE ONLY public.users ALTER COLUMN created_at SET (pg_attver=146183888);
ALTER TABLE ONLY public.users ALTER COLUMN updated_at SET (pg_attver=146183888);
ALTER TABLE ONLY public.users ALTER COLUMN name SET (pg_attver=146183888);
ALTER TABLE ONLY public.users ALTER COLUMN address SET (pg_attver=146183888);
ALTER TABLE ONLY public.users ALTER COLUMN mobile_number SET (pg_attver=146183888);
ALTER TABLE ONLY public.users ALTER COLUMN interests SET (pg_attver=146183888);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: action_text_rich_texts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN id SET DEFAULT nextval('public.action_text_rich_texts_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: bookmarks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookmarks ALTER COLUMN id SET DEFAULT nextval('public.bookmarks_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: follows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows ALTER COLUMN id SET DEFAULT nextval('public.follows_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: post_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_tags ALTER COLUMN id SET DEFAULT nextval('public.post_tags_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: reactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reactions ALTER COLUMN id SET DEFAULT nextval('public.reactions_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: action_text_rich_texts action_text_rich_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_text_rich_texts
    ADD CONSTRAINT action_text_rich_texts_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: bookmarks bookmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT bookmarks_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: follows follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: post_tags post_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_tags
    ADD CONSTRAINT post_tags_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: reactions reactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reactions
    ADD CONSTRAINT reactions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_action_text_rich_texts_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_action_text_rich_texts_uniqueness ON public.action_text_rich_texts USING btree (record_type, record_id, name);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_bookmarks_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookmarks_on_post_id ON public.bookmarks USING btree (post_id);


--
-- Name: index_bookmarks_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookmarks_on_user_id ON public.bookmarks USING btree (user_id);


--
-- Name: index_bookmarks_on_user_id_and_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bookmarks_on_user_id_and_post_id ON public.bookmarks USING btree (user_id, post_id);


--
-- Name: index_comments_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_post_id ON public.comments USING btree (post_id);


--
-- Name: index_comments_on_post_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_post_id_and_created_at ON public.comments USING btree (post_id, created_at);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


--
-- Name: index_follows_on_followed_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_follows_on_followed_id ON public.follows USING btree (followed_id);


--
-- Name: index_follows_on_follower_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_follows_on_follower_id ON public.follows USING btree (follower_id);


--
-- Name: index_follows_on_follower_id_and_followed_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_follows_on_follower_id_and_followed_id ON public.follows USING btree (follower_id, followed_id);


--
-- Name: index_notifications_on_actor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_actor_id ON public.notifications USING btree (actor_id);


--
-- Name: index_notifications_on_notifiable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_notifiable ON public.notifications USING btree (notifiable_type, notifiable_id);


--
-- Name: index_notifications_on_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_recipient_id ON public.notifications USING btree (recipient_id);


--
-- Name: index_notifications_on_recipient_id_and_read_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_recipient_id_and_read_at ON public.notifications USING btree (recipient_id, read_at);


--
-- Name: index_post_tags_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_post_tags_on_post_id ON public.post_tags USING btree (post_id);


--
-- Name: index_post_tags_on_post_id_and_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_post_tags_on_post_id_and_tag_id ON public.post_tags USING btree (post_id, tag_id);


--
-- Name: index_post_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_post_tags_on_tag_id ON public.post_tags USING btree (tag_id);


--
-- Name: index_posts_on_scheduled_for; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_scheduled_for ON public.posts USING btree (scheduled_for);


--
-- Name: index_posts_on_search_vector; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_search_vector ON public.posts USING gin (search_vector);


--
-- Name: index_posts_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_posts_on_slug ON public.posts USING btree (slug);


--
-- Name: index_posts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_user_id ON public.posts USING btree (user_id);


--
-- Name: index_reactions_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reactions_on_post_id ON public.reactions USING btree (post_id);


--
-- Name: index_reactions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reactions_on_user_id ON public.reactions USING btree (user_id);


--
-- Name: index_reactions_on_user_id_and_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_reactions_on_user_id_and_post_id ON public.reactions USING btree (user_id, post_id);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_tags_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_slug ON public.tags USING btree (slug);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: comments fk_rails_03de2dc08c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_03de2dc08c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: notifications fk_rails_06a39bb8cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_06a39bb8cc FOREIGN KEY (actor_id) REFERENCES public.users(id);


--
-- Name: comments fk_rails_2fd19c0db7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_2fd19c0db7 FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: notifications fk_rails_4aea6afa11; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_4aea6afa11 FOREIGN KEY (recipient_id) REFERENCES public.users(id);


--
-- Name: posts fk_rails_5b5ddfd518; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_rails_5b5ddfd518 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: follows fk_rails_5ef72a3867; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT fk_rails_5ef72a3867 FOREIGN KEY (followed_id) REFERENCES public.users(id);


--
-- Name: follows fk_rails_622d34a301; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT fk_rails_622d34a301 FOREIGN KEY (follower_id) REFERENCES public.users(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: reactions fk_rails_9f02fc96a0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reactions
    ADD CONSTRAINT fk_rails_9f02fc96a0 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: bookmarks fk_rails_c1ff6fa4ac; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT fk_rails_c1ff6fa4ac FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: post_tags fk_rails_c9d8c5063e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_tags
    ADD CONSTRAINT fk_rails_c9d8c5063e FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: reactions fk_rails_cb32010de7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reactions
    ADD CONSTRAINT fk_rails_cb32010de7 FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: bookmarks fk_rails_d8b54790ff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT fk_rails_d8b54790ff FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: post_tags fk_rails_fdf74b486b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.post_tags
    ADD CONSTRAINT fk_rails_fdf74b486b FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20261114153327'),
('20261114151457'),
('20260830120000'),
('20260815150000'),
('20260815143000'),
('20260815140000'),
('20260815134912'),
('20260614052802'),
('20260524050000'),
('20260524043515'),
('20260524041505'),
('20260524041313'),
('20260524041312');

