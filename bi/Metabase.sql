--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5
-- Dumped by pg_dump version 12.5

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

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.activity (
    id integer NOT NULL,
    topic character varying(32) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    user_id integer,
    model character varying(16),
    model_id integer,
    database_id integer,
    table_id integer,
    custom_id character varying(48),
    details character varying NOT NULL
);


ALTER TABLE public.activity OWNER TO raywu;

--
-- Name: activity_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activity_id_seq OWNER TO raywu;

--
-- Name: activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.activity_id_seq OWNED BY public.activity.id;


--
-- Name: card_label; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.card_label (
    id integer NOT NULL,
    card_id integer NOT NULL,
    label_id integer NOT NULL
);


ALTER TABLE public.card_label OWNER TO raywu;

--
-- Name: card_label_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.card_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.card_label_id_seq OWNER TO raywu;

--
-- Name: card_label_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.card_label_id_seq OWNED BY public.card_label.id;


--
-- Name: collection; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.collection (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    color character(7) NOT NULL,
    archived boolean DEFAULT false NOT NULL,
    location character varying(254) DEFAULT '/'::character varying NOT NULL,
    personal_owner_id integer,
    slug character varying(254) NOT NULL,
    namespace character varying(254)
);


ALTER TABLE public.collection OWNER TO raywu;

--
-- Name: TABLE collection; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.collection IS 'Collections are an optional way to organize Cards and handle permissions for them.';


--
-- Name: COLUMN collection.name; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection.name IS 'The user-facing name of this Collection.';


--
-- Name: COLUMN collection.description; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection.description IS 'Optional description for this Collection.';


--
-- Name: COLUMN collection.color; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection.color IS 'Seven-character hex color for this Collection, including the preceding hash sign.';


--
-- Name: COLUMN collection.archived; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection.archived IS 'Whether this Collection has been archived and should be hidden from users.';


--
-- Name: COLUMN collection.location; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection.location IS 'Directory-structure path of ancestor Collections. e.g. "/1/2/" means our Parent is Collection 2, and their parent is Collection 1.';


--
-- Name: COLUMN collection.personal_owner_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection.personal_owner_id IS 'If set, this Collection is a personal Collection, for exclusive use of the User with this ID.';


--
-- Name: COLUMN collection.slug; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection.slug IS 'Sluggified version of the Collection name. Used only for display purposes in URL; not unique or indexed.';


--
-- Name: COLUMN collection.namespace; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection.namespace IS 'The namespace (hierachy) this Collection belongs to. NULL means the Collection is in the default namespace.';


--
-- Name: collection_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.collection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collection_id_seq OWNER TO raywu;

--
-- Name: collection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.collection_id_seq OWNED BY public.collection.id;


--
-- Name: collection_revision; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.collection_revision (
    id integer NOT NULL,
    before text NOT NULL,
    after text NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    remark text
);


ALTER TABLE public.collection_revision OWNER TO raywu;

--
-- Name: TABLE collection_revision; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.collection_revision IS 'Used to keep track of changes made to collections.';


--
-- Name: COLUMN collection_revision.before; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection_revision.before IS 'Serialized JSON of the collections graph before the changes.';


--
-- Name: COLUMN collection_revision.after; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection_revision.after IS 'Serialized JSON of the collections graph after the changes.';


--
-- Name: COLUMN collection_revision.user_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection_revision.user_id IS 'The ID of the admin who made this set of changes.';


--
-- Name: COLUMN collection_revision.created_at; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection_revision.created_at IS 'The timestamp of when these changes were made.';


--
-- Name: COLUMN collection_revision.remark; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.collection_revision.remark IS 'Optional remarks explaining why these changes were made.';


--
-- Name: collection_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.collection_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collection_revision_id_seq OWNER TO raywu;

--
-- Name: collection_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.collection_revision_id_seq OWNED BY public.collection_revision.id;


--
-- Name: computation_job; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.computation_job (
    id integer NOT NULL,
    creator_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying(254) NOT NULL,
    status character varying(254) NOT NULL,
    context text,
    ended_at timestamp without time zone
);


ALTER TABLE public.computation_job OWNER TO raywu;

--
-- Name: TABLE computation_job; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.computation_job IS 'Stores submitted async computation jobs.';


--
-- Name: computation_job_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.computation_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.computation_job_id_seq OWNER TO raywu;

--
-- Name: computation_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.computation_job_id_seq OWNED BY public.computation_job.id;


--
-- Name: computation_job_result; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.computation_job_result (
    id integer NOT NULL,
    job_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    permanence character varying(254) NOT NULL,
    payload text NOT NULL
);


ALTER TABLE public.computation_job_result OWNER TO raywu;

--
-- Name: TABLE computation_job_result; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.computation_job_result IS 'Stores results of async computation jobs.';


--
-- Name: computation_job_result_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.computation_job_result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.computation_job_result_id_seq OWNER TO raywu;

--
-- Name: computation_job_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.computation_job_result_id_seq OWNED BY public.computation_job_result.id;


--
-- Name: core_session; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.core_session (
    id character varying(254) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    anti_csrf_token text
);


ALTER TABLE public.core_session OWNER TO raywu;

--
-- Name: COLUMN core_session.anti_csrf_token; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.core_session.anti_csrf_token IS 'Anti-CSRF token for full-app embed sessions.';


--
-- Name: core_user; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.core_user (
    id integer NOT NULL,
    email public.citext NOT NULL,
    first_name character varying(254) NOT NULL,
    last_name character varying(254) NOT NULL,
    password character varying(254) NOT NULL,
    password_salt character varying(254) DEFAULT 'default'::character varying NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    reset_token character varying(254),
    reset_triggered bigint,
    is_qbnewb boolean DEFAULT true NOT NULL,
    google_auth boolean DEFAULT false NOT NULL,
    ldap_auth boolean DEFAULT false NOT NULL,
    login_attributes text,
    updated_at timestamp without time zone,
    sso_source character varying(254),
    locale character varying(5)
);


ALTER TABLE public.core_user OWNER TO raywu;

--
-- Name: COLUMN core_user.login_attributes; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.core_user.login_attributes IS 'JSON serialized map with attributes used for row level permissions';


--
-- Name: COLUMN core_user.updated_at; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.core_user.updated_at IS 'When was this User last updated?';


--
-- Name: COLUMN core_user.sso_source; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.core_user.sso_source IS 'String to indicate the SSO backend the user is from';


--
-- Name: COLUMN core_user.locale; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.core_user.locale IS 'Preferred ISO locale (language/country) code, e.g "en" or "en-US", for this User. Overrides site default.';


--
-- Name: core_user_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.core_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_user_id_seq OWNER TO raywu;

--
-- Name: core_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.core_user_id_seq OWNED BY public.core_user.id;


--
-- Name: dashboard_favorite; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.dashboard_favorite (
    id integer NOT NULL,
    user_id integer NOT NULL,
    dashboard_id integer NOT NULL
);


ALTER TABLE public.dashboard_favorite OWNER TO raywu;

--
-- Name: TABLE dashboard_favorite; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.dashboard_favorite IS 'Presence of a row here indicates a given User has favorited a given Dashboard.';


--
-- Name: COLUMN dashboard_favorite.user_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.dashboard_favorite.user_id IS 'ID of the User who favorited the Dashboard.';


--
-- Name: COLUMN dashboard_favorite.dashboard_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.dashboard_favorite.dashboard_id IS 'ID of the Dashboard favorited by the User.';


--
-- Name: dashboard_favorite_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.dashboard_favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dashboard_favorite_id_seq OWNER TO raywu;

--
-- Name: dashboard_favorite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.dashboard_favorite_id_seq OWNED BY public.dashboard_favorite.id;


--
-- Name: dashboardcard_series; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.dashboardcard_series (
    id integer NOT NULL,
    dashboardcard_id integer NOT NULL,
    card_id integer NOT NULL,
    "position" integer NOT NULL
);


ALTER TABLE public.dashboardcard_series OWNER TO raywu;

--
-- Name: dashboardcard_series_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.dashboardcard_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dashboardcard_series_id_seq OWNER TO raywu;

--
-- Name: dashboardcard_series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.dashboardcard_series_id_seq OWNED BY public.dashboardcard_series.id;


--
-- Name: data_migrations; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.data_migrations (
    id character varying(254) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL
);


ALTER TABLE public.data_migrations OWNER TO raywu;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO raywu;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO raywu;

--
-- Name: dependency; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.dependency (
    id integer NOT NULL,
    model character varying(32) NOT NULL,
    model_id integer NOT NULL,
    dependent_on_model character varying(32) NOT NULL,
    dependent_on_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.dependency OWNER TO raywu;

--
-- Name: dependency_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.dependency_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dependency_id_seq OWNER TO raywu;

--
-- Name: dependency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.dependency_id_seq OWNED BY public.dependency.id;


--
-- Name: dimension; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.dimension (
    id integer NOT NULL,
    field_id integer NOT NULL,
    name character varying(254) NOT NULL,
    type character varying(254) NOT NULL,
    human_readable_field_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.dimension OWNER TO raywu;

--
-- Name: TABLE dimension; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.dimension IS 'Stores references to alternate views of existing fields, such as remapping an integer to a description, like an enum';


--
-- Name: COLUMN dimension.field_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.dimension.field_id IS 'ID of the field this dimension row applies to';


--
-- Name: COLUMN dimension.name; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.dimension.name IS 'Short description used as the display name of this new column';


--
-- Name: COLUMN dimension.type; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.dimension.type IS 'Either internal for a user defined remapping or external for a foreign key based remapping';


--
-- Name: COLUMN dimension.human_readable_field_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.dimension.human_readable_field_id IS 'Only used with external type remappings. Indicates which field on the FK related table to use for display';


--
-- Name: COLUMN dimension.created_at; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.dimension.created_at IS 'The timestamp of when the dimension was created.';


--
-- Name: COLUMN dimension.updated_at; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.dimension.updated_at IS 'The timestamp of when these dimension was last updated.';


--
-- Name: dimension_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.dimension_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dimension_id_seq OWNER TO raywu;

--
-- Name: dimension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.dimension_id_seq OWNED BY public.dimension.id;


--
-- Name: group_table_access_policy; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.group_table_access_policy (
    id integer NOT NULL,
    group_id integer NOT NULL,
    table_id integer NOT NULL,
    card_id integer,
    attribute_remappings text
);


ALTER TABLE public.group_table_access_policy OWNER TO raywu;

--
-- Name: TABLE group_table_access_policy; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.group_table_access_policy IS 'Records that a given Card (Question) should automatically replace a given Table as query source for a given a Perms Group.';


--
-- Name: COLUMN group_table_access_policy.group_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.group_table_access_policy.group_id IS 'ID of the Permissions Group this policy affects.';


--
-- Name: COLUMN group_table_access_policy.table_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.group_table_access_policy.table_id IS 'ID of the Table that should get automatically replaced as query source for the Permissions Group.';


--
-- Name: COLUMN group_table_access_policy.card_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.group_table_access_policy.card_id IS 'ID of the Card (Question) to be used to replace the Table.';


--
-- Name: COLUMN group_table_access_policy.attribute_remappings; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.group_table_access_policy.attribute_remappings IS 'JSON-encoded map of user attribute identifier to the param name used in the Card.';


--
-- Name: group_table_access_policy_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.group_table_access_policy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_table_access_policy_id_seq OWNER TO raywu;

--
-- Name: group_table_access_policy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.group_table_access_policy_id_seq OWNED BY public.group_table_access_policy.id;


--
-- Name: label; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.label (
    id integer NOT NULL,
    name character varying(254) NOT NULL,
    slug character varying(254) NOT NULL,
    icon character varying(128)
);


ALTER TABLE public.label OWNER TO raywu;

--
-- Name: label_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.label_id_seq OWNER TO raywu;

--
-- Name: label_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.label_id_seq OWNED BY public.label.id;


--
-- Name: metabase_database; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.metabase_database (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    details text,
    engine character varying(254) NOT NULL,
    is_sample boolean DEFAULT false NOT NULL,
    is_full_sync boolean DEFAULT true NOT NULL,
    points_of_interest text,
    caveats text,
    metadata_sync_schedule character varying(254) DEFAULT '0 50 * * * ? *'::character varying NOT NULL,
    cache_field_values_schedule character varying(254) DEFAULT '0 50 0 * * ? *'::character varying NOT NULL,
    timezone character varying(254),
    is_on_demand boolean DEFAULT false NOT NULL,
    options text,
    auto_run_queries boolean DEFAULT true NOT NULL
);


ALTER TABLE public.metabase_database OWNER TO raywu;

--
-- Name: COLUMN metabase_database.metadata_sync_schedule; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.metabase_database.metadata_sync_schedule IS 'The cron schedule string for when this database should undergo the metadata sync process (and analysis for new fields).';


--
-- Name: COLUMN metabase_database.cache_field_values_schedule; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.metabase_database.cache_field_values_schedule IS 'The cron schedule string for when FieldValues for eligible Fields should be updated.';


--
-- Name: COLUMN metabase_database.timezone; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.metabase_database.timezone IS 'Timezone identifier for the database, set by the sync process';


--
-- Name: COLUMN metabase_database.is_on_demand; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.metabase_database.is_on_demand IS 'Whether we should do On-Demand caching of FieldValues for this DB. This means FieldValues are updated when their Field is used in a Dashboard or Card param.';


--
-- Name: COLUMN metabase_database.options; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.metabase_database.options IS 'Serialized JSON containing various options like QB behavior.';


--
-- Name: COLUMN metabase_database.auto_run_queries; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.metabase_database.auto_run_queries IS 'Whether to automatically run queries when doing simple filtering and summarizing in the Query Builder.';


--
-- Name: metabase_database_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.metabase_database_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_database_id_seq OWNER TO raywu;

--
-- Name: metabase_database_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.metabase_database_id_seq OWNED BY public.metabase_database.id;


--
-- Name: metabase_field; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.metabase_field (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    base_type character varying(255) NOT NULL,
    special_type character varying(255),
    active boolean DEFAULT true NOT NULL,
    description text,
    preview_display boolean DEFAULT true NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    table_id integer NOT NULL,
    parent_id integer,
    display_name character varying(254),
    visibility_type character varying(32) DEFAULT 'normal'::character varying NOT NULL,
    fk_target_field_id integer,
    last_analyzed timestamp with time zone,
    points_of_interest text,
    caveats text,
    fingerprint text,
    fingerprint_version integer DEFAULT 0 NOT NULL,
    database_type text NOT NULL,
    has_field_values text,
    settings text,
    database_position integer DEFAULT 0 NOT NULL,
    custom_position integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.metabase_field OWNER TO raywu;

--
-- Name: COLUMN metabase_field.fingerprint; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.metabase_field.fingerprint IS 'Serialized JSON containing non-identifying information about this Field, such as min, max, and percent JSON. Used for classification.';


--
-- Name: COLUMN metabase_field.fingerprint_version; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.metabase_field.fingerprint_version IS 'The version of the fingerprint for this Field. Used so we can keep track of which Fields need to be analyzed again when new things are added to fingerprints.';


--
-- Name: COLUMN metabase_field.database_type; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.metabase_field.database_type IS 'The actual type of this column in the database. e.g. VARCHAR or TEXT.';


--
-- Name: COLUMN metabase_field.has_field_values; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.metabase_field.has_field_values IS 'Whether we have FieldValues ("list"), should ad-hoc search ("search"), disable entirely ("none"), or infer dynamically (null)"';


--
-- Name: COLUMN metabase_field.settings; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.metabase_field.settings IS 'Serialized JSON FE-specific settings like formatting, etc. Scope of what is stored here may increase in future.';


--
-- Name: metabase_field_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.metabase_field_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_field_id_seq OWNER TO raywu;

--
-- Name: metabase_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.metabase_field_id_seq OWNED BY public.metabase_field.id;


--
-- Name: metabase_fieldvalues; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.metabase_fieldvalues (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    "values" text,
    human_readable_values text,
    field_id integer NOT NULL
);


ALTER TABLE public.metabase_fieldvalues OWNER TO raywu;

--
-- Name: metabase_fieldvalues_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.metabase_fieldvalues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_fieldvalues_id_seq OWNER TO raywu;

--
-- Name: metabase_fieldvalues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.metabase_fieldvalues_id_seq OWNED BY public.metabase_fieldvalues.id;


--
-- Name: metabase_table; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.metabase_table (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    entity_name character varying(254),
    entity_type character varying(254),
    active boolean NOT NULL,
    db_id integer NOT NULL,
    display_name character varying(254),
    visibility_type character varying(254),
    schema character varying(254),
    points_of_interest text,
    caveats text,
    show_in_getting_started boolean DEFAULT false NOT NULL,
    field_order character varying(254) DEFAULT 'database'::character varying NOT NULL
);


ALTER TABLE public.metabase_table OWNER TO raywu;

--
-- Name: metabase_table_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.metabase_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_table_id_seq OWNER TO raywu;

--
-- Name: metabase_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.metabase_table_id_seq OWNED BY public.metabase_table.id;


--
-- Name: metric; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.metric (
    id integer NOT NULL,
    table_id integer NOT NULL,
    creator_id integer NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    archived boolean DEFAULT false NOT NULL,
    definition text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    points_of_interest text,
    caveats text,
    how_is_this_calculated text,
    show_in_getting_started boolean DEFAULT false NOT NULL
);


ALTER TABLE public.metric OWNER TO raywu;

--
-- Name: metric_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.metric_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metric_id_seq OWNER TO raywu;

--
-- Name: metric_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.metric_id_seq OWNED BY public.metric.id;


--
-- Name: metric_important_field; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.metric_important_field (
    id integer NOT NULL,
    metric_id integer NOT NULL,
    field_id integer NOT NULL
);


ALTER TABLE public.metric_important_field OWNER TO raywu;

--
-- Name: metric_important_field_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.metric_important_field_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metric_important_field_id_seq OWNER TO raywu;

--
-- Name: metric_important_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.metric_important_field_id_seq OWNED BY public.metric_important_field.id;


--
-- Name: native_query_snippet; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.native_query_snippet (
    id integer NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    content text NOT NULL,
    creator_id integer NOT NULL,
    archived boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    collection_id integer
);


ALTER TABLE public.native_query_snippet OWNER TO raywu;

--
-- Name: TABLE native_query_snippet; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.native_query_snippet IS 'Query snippets (raw text) to be substituted in native queries';


--
-- Name: COLUMN native_query_snippet.name; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.native_query_snippet.name IS 'Name of the query snippet';


--
-- Name: COLUMN native_query_snippet.content; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.native_query_snippet.content IS 'Raw query snippet';


--
-- Name: COLUMN native_query_snippet.collection_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.native_query_snippet.collection_id IS 'ID of the Snippet Folder (Collection) this Snippet is in, if any';


--
-- Name: native_query_snippet_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.native_query_snippet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.native_query_snippet_id_seq OWNER TO raywu;

--
-- Name: native_query_snippet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.native_query_snippet_id_seq OWNED BY public.native_query_snippet.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    object character varying(254) NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.permissions OWNER TO raywu;

--
-- Name: permissions_group; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.permissions_group (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.permissions_group OWNER TO raywu;

--
-- Name: permissions_group_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.permissions_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_group_id_seq OWNER TO raywu;

--
-- Name: permissions_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.permissions_group_id_seq OWNED BY public.permissions_group.id;


--
-- Name: permissions_group_membership; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.permissions_group_membership (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.permissions_group_membership OWNER TO raywu;

--
-- Name: permissions_group_membership_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.permissions_group_membership_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_group_membership_id_seq OWNER TO raywu;

--
-- Name: permissions_group_membership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.permissions_group_membership_id_seq OWNED BY public.permissions_group_membership.id;


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO raywu;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: permissions_revision; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.permissions_revision (
    id integer NOT NULL,
    before text NOT NULL,
    after text NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    remark text
);


ALTER TABLE public.permissions_revision OWNER TO raywu;

--
-- Name: TABLE permissions_revision; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.permissions_revision IS 'Used to keep track of changes made to permissions.';


--
-- Name: COLUMN permissions_revision.before; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.permissions_revision.before IS 'Serialized JSON of the permissions before the changes.';


--
-- Name: COLUMN permissions_revision.after; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.permissions_revision.after IS 'Serialized JSON of the permissions after the changes.';


--
-- Name: COLUMN permissions_revision.user_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.permissions_revision.user_id IS 'The ID of the admin who made this set of changes.';


--
-- Name: COLUMN permissions_revision.created_at; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.permissions_revision.created_at IS 'The timestamp of when these changes were made.';


--
-- Name: COLUMN permissions_revision.remark; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.permissions_revision.remark IS 'Optional remarks explaining why these changes were made.';


--
-- Name: permissions_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.permissions_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_revision_id_seq OWNER TO raywu;

--
-- Name: permissions_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.permissions_revision_id_seq OWNED BY public.permissions_revision.id;


--
-- Name: pulse; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.pulse (
    id integer NOT NULL,
    creator_id integer NOT NULL,
    name character varying(254),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    skip_if_empty boolean DEFAULT false NOT NULL,
    alert_condition character varying(254),
    alert_first_only boolean,
    alert_above_goal boolean,
    collection_id integer,
    collection_position smallint,
    archived boolean DEFAULT false
);


ALTER TABLE public.pulse OWNER TO raywu;

--
-- Name: COLUMN pulse.skip_if_empty; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.pulse.skip_if_empty IS 'Skip a scheduled Pulse if none of its questions have any results';


--
-- Name: COLUMN pulse.alert_condition; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.pulse.alert_condition IS 'Condition (i.e. "rows" or "goal") used as a guard for alerts';


--
-- Name: COLUMN pulse.alert_first_only; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.pulse.alert_first_only IS 'True if the alert should be disabled after the first notification';


--
-- Name: COLUMN pulse.alert_above_goal; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.pulse.alert_above_goal IS 'For a goal condition, alert when above the goal';


--
-- Name: COLUMN pulse.collection_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.pulse.collection_id IS 'Options ID of Collection this Pulse belongs to.';


--
-- Name: COLUMN pulse.collection_position; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.pulse.collection_position IS 'Optional pinned position for this item in its Collection. NULL means item is not pinned.';


--
-- Name: COLUMN pulse.archived; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.pulse.archived IS 'Has this pulse been archived?';


--
-- Name: pulse_card; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.pulse_card (
    id integer NOT NULL,
    pulse_id integer NOT NULL,
    card_id integer NOT NULL,
    "position" integer NOT NULL,
    include_csv boolean DEFAULT false NOT NULL,
    include_xls boolean DEFAULT false NOT NULL
);


ALTER TABLE public.pulse_card OWNER TO raywu;

--
-- Name: COLUMN pulse_card.include_csv; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.pulse_card.include_csv IS 'True if a CSV of the data should be included for this pulse card';


--
-- Name: COLUMN pulse_card.include_xls; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.pulse_card.include_xls IS 'True if a XLS of the data should be included for this pulse card';


--
-- Name: pulse_card_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.pulse_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pulse_card_id_seq OWNER TO raywu;

--
-- Name: pulse_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.pulse_card_id_seq OWNED BY public.pulse_card.id;


--
-- Name: pulse_channel; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.pulse_channel (
    id integer NOT NULL,
    pulse_id integer NOT NULL,
    channel_type character varying(32) NOT NULL,
    details text NOT NULL,
    schedule_type character varying(32) NOT NULL,
    schedule_hour integer,
    schedule_day character varying(64),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    schedule_frame character varying(32),
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.pulse_channel OWNER TO raywu;

--
-- Name: pulse_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.pulse_channel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pulse_channel_id_seq OWNER TO raywu;

--
-- Name: pulse_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.pulse_channel_id_seq OWNED BY public.pulse_channel.id;


--
-- Name: pulse_channel_recipient; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.pulse_channel_recipient (
    id integer NOT NULL,
    pulse_channel_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.pulse_channel_recipient OWNER TO raywu;

--
-- Name: pulse_channel_recipient_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.pulse_channel_recipient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pulse_channel_recipient_id_seq OWNER TO raywu;

--
-- Name: pulse_channel_recipient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.pulse_channel_recipient_id_seq OWNED BY public.pulse_channel_recipient.id;


--
-- Name: pulse_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.pulse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pulse_id_seq OWNER TO raywu;

--
-- Name: pulse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.pulse_id_seq OWNED BY public.pulse.id;


--
-- Name: qrtz_blob_triggers; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.qrtz_blob_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    blob_data bytea
);


ALTER TABLE public.qrtz_blob_triggers OWNER TO raywu;

--
-- Name: TABLE qrtz_blob_triggers; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.qrtz_blob_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_calendars; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.qrtz_calendars (
    sched_name character varying(120) NOT NULL,
    calendar_name character varying(200) NOT NULL,
    calendar bytea NOT NULL
);


ALTER TABLE public.qrtz_calendars OWNER TO raywu;

--
-- Name: TABLE qrtz_calendars; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.qrtz_calendars IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_cron_triggers; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.qrtz_cron_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    cron_expression character varying(120) NOT NULL,
    time_zone_id character varying(80)
);


ALTER TABLE public.qrtz_cron_triggers OWNER TO raywu;

--
-- Name: TABLE qrtz_cron_triggers; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.qrtz_cron_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_fired_triggers; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.qrtz_fired_triggers (
    sched_name character varying(120) NOT NULL,
    entry_id character varying(95) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    instance_name character varying(200) NOT NULL,
    fired_time bigint NOT NULL,
    sched_time bigint,
    priority integer NOT NULL,
    state character varying(16) NOT NULL,
    job_name character varying(200),
    job_group character varying(200),
    is_nonconcurrent boolean,
    requests_recovery boolean
);


ALTER TABLE public.qrtz_fired_triggers OWNER TO raywu;

--
-- Name: TABLE qrtz_fired_triggers; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.qrtz_fired_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_job_details; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.qrtz_job_details (
    sched_name character varying(120) NOT NULL,
    job_name character varying(200) NOT NULL,
    job_group character varying(200) NOT NULL,
    description character varying(250),
    job_class_name character varying(250) NOT NULL,
    is_durable boolean NOT NULL,
    is_nonconcurrent boolean NOT NULL,
    is_update_data boolean NOT NULL,
    requests_recovery boolean NOT NULL,
    job_data bytea
);


ALTER TABLE public.qrtz_job_details OWNER TO raywu;

--
-- Name: TABLE qrtz_job_details; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.qrtz_job_details IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_locks; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.qrtz_locks (
    sched_name character varying(120) NOT NULL,
    lock_name character varying(40) NOT NULL
);


ALTER TABLE public.qrtz_locks OWNER TO raywu;

--
-- Name: TABLE qrtz_locks; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.qrtz_locks IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_paused_trigger_grps; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.qrtz_paused_trigger_grps (
    sched_name character varying(120) NOT NULL,
    trigger_group character varying(200) NOT NULL
);


ALTER TABLE public.qrtz_paused_trigger_grps OWNER TO raywu;

--
-- Name: TABLE qrtz_paused_trigger_grps; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.qrtz_paused_trigger_grps IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_scheduler_state; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.qrtz_scheduler_state (
    sched_name character varying(120) NOT NULL,
    instance_name character varying(200) NOT NULL,
    last_checkin_time bigint NOT NULL,
    checkin_interval bigint NOT NULL
);


ALTER TABLE public.qrtz_scheduler_state OWNER TO raywu;

--
-- Name: TABLE qrtz_scheduler_state; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.qrtz_scheduler_state IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_simple_triggers; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.qrtz_simple_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    repeat_count bigint NOT NULL,
    repeat_interval bigint NOT NULL,
    times_triggered bigint NOT NULL
);


ALTER TABLE public.qrtz_simple_triggers OWNER TO raywu;

--
-- Name: TABLE qrtz_simple_triggers; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.qrtz_simple_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_simprop_triggers; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.qrtz_simprop_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    str_prop_1 character varying(512),
    str_prop_2 character varying(512),
    str_prop_3 character varying(512),
    int_prop_1 integer,
    int_prop_2 integer,
    long_prop_1 bigint,
    long_prop_2 bigint,
    dec_prop_1 numeric(13,4),
    dec_prop_2 numeric(13,4),
    bool_prop_1 boolean,
    bool_prop_2 boolean
);


ALTER TABLE public.qrtz_simprop_triggers OWNER TO raywu;

--
-- Name: TABLE qrtz_simprop_triggers; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.qrtz_simprop_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_triggers; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.qrtz_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    job_name character varying(200) NOT NULL,
    job_group character varying(200) NOT NULL,
    description character varying(250),
    next_fire_time bigint,
    prev_fire_time bigint,
    priority integer,
    trigger_state character varying(16) NOT NULL,
    trigger_type character varying(8) NOT NULL,
    start_time bigint NOT NULL,
    end_time bigint,
    calendar_name character varying(200),
    misfire_instr smallint,
    job_data bytea
);


ALTER TABLE public.qrtz_triggers OWNER TO raywu;

--
-- Name: TABLE qrtz_triggers; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.qrtz_triggers IS 'Used for Quartz scheduler.';


--
-- Name: query; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.query (
    query_hash bytea NOT NULL,
    average_execution_time integer NOT NULL,
    query text
);


ALTER TABLE public.query OWNER TO raywu;

--
-- Name: TABLE query; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.query IS 'Information (such as average execution time) for different queries that have been previously ran.';


--
-- Name: COLUMN query.query_hash; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query.query_hash IS 'The hash of the query dictionary. (This is a 256-bit SHA3 hash of the query dict.)';


--
-- Name: COLUMN query.average_execution_time; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query.average_execution_time IS 'Average execution time for the query, round to nearest number of milliseconds. This is updated as a rolling average.';


--
-- Name: COLUMN query.query; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query.query IS 'The actual "query dictionary" for this query.';


--
-- Name: query_cache; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.query_cache (
    query_hash bytea NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    results bytea NOT NULL
);


ALTER TABLE public.query_cache OWNER TO raywu;

--
-- Name: TABLE query_cache; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.query_cache IS 'Cached results of queries are stored here when using the DB-based query cache.';


--
-- Name: COLUMN query_cache.query_hash; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_cache.query_hash IS 'The hash of the query dictionary. (This is a 256-bit SHA3 hash of the query dict).';


--
-- Name: COLUMN query_cache.updated_at; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_cache.updated_at IS 'The timestamp of when these query results were last refreshed.';


--
-- Name: COLUMN query_cache.results; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_cache.results IS 'Cached, compressed results of running the query with the given hash.';


--
-- Name: query_execution; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.query_execution (
    id integer NOT NULL,
    hash bytea NOT NULL,
    started_at timestamp with time zone NOT NULL,
    running_time integer NOT NULL,
    result_rows integer NOT NULL,
    native boolean NOT NULL,
    context character varying(32),
    error text,
    executor_id integer,
    card_id integer,
    dashboard_id integer,
    pulse_id integer,
    database_id integer
);


ALTER TABLE public.query_execution OWNER TO raywu;

--
-- Name: TABLE query_execution; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.query_execution IS 'A log of executed queries, used for calculating historic execution times, auditing, and other purposes.';


--
-- Name: COLUMN query_execution.hash; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_execution.hash IS 'The hash of the query dictionary. This is a 256-bit SHA3 hash of the query.';


--
-- Name: COLUMN query_execution.started_at; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_execution.started_at IS 'Timestamp of when this query started running.';


--
-- Name: COLUMN query_execution.running_time; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_execution.running_time IS 'The time, in milliseconds, this query took to complete.';


--
-- Name: COLUMN query_execution.result_rows; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_execution.result_rows IS 'Number of rows in the query results.';


--
-- Name: COLUMN query_execution.native; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_execution.native IS 'Whether the query was a native query, as opposed to an MBQL one (e.g., created with the GUI).';


--
-- Name: COLUMN query_execution.context; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_execution.context IS 'Short string specifying how this query was executed, e.g. in a Dashboard or Pulse.';


--
-- Name: COLUMN query_execution.error; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_execution.error IS 'Error message returned by failed query, if any.';


--
-- Name: COLUMN query_execution.executor_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_execution.executor_id IS 'The ID of the User who triggered this query execution, if any.';


--
-- Name: COLUMN query_execution.card_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_execution.card_id IS 'The ID of the Card (Question) associated with this query execution, if any.';


--
-- Name: COLUMN query_execution.dashboard_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_execution.dashboard_id IS 'The ID of the Dashboard associated with this query execution, if any.';


--
-- Name: COLUMN query_execution.pulse_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_execution.pulse_id IS 'The ID of the Pulse associated with this query execution, if any.';


--
-- Name: COLUMN query_execution.database_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.query_execution.database_id IS 'ID of the database this query was ran against.';


--
-- Name: query_execution_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.query_execution_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.query_execution_id_seq OWNER TO raywu;

--
-- Name: query_execution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.query_execution_id_seq OWNED BY public.query_execution.id;


--
-- Name: report_card; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.report_card (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    display character varying(254) NOT NULL,
    dataset_query text NOT NULL,
    visualization_settings text NOT NULL,
    creator_id integer NOT NULL,
    database_id integer,
    table_id integer,
    query_type character varying(16),
    archived boolean DEFAULT false NOT NULL,
    collection_id integer,
    public_uuid character(36),
    made_public_by_id integer,
    enable_embedding boolean DEFAULT false NOT NULL,
    embedding_params text,
    cache_ttl integer,
    result_metadata text,
    collection_position smallint
);


ALTER TABLE public.report_card OWNER TO raywu;

--
-- Name: COLUMN report_card.collection_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_card.collection_id IS 'Optional ID of Collection this Card belongs to.';


--
-- Name: COLUMN report_card.public_uuid; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_card.public_uuid IS 'Unique UUID used to in publically-accessible links to this Card.';


--
-- Name: COLUMN report_card.made_public_by_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_card.made_public_by_id IS 'The ID of the User who first publically shared this Card.';


--
-- Name: COLUMN report_card.enable_embedding; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_card.enable_embedding IS 'Is this Card allowed to be embedded in different websites (using a signed JWT)?';


--
-- Name: COLUMN report_card.embedding_params; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_card.embedding_params IS 'Serialized JSON containing information about required parameters that must be supplied when embedding this Card.';


--
-- Name: COLUMN report_card.cache_ttl; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_card.cache_ttl IS 'The maximum time, in seconds, to return cached results for this Card rather than running a new query.';


--
-- Name: COLUMN report_card.result_metadata; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_card.result_metadata IS 'Serialized JSON containing metadata about the result columns from running the query.';


--
-- Name: COLUMN report_card.collection_position; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_card.collection_position IS 'Optional pinned position for this item in its Collection. NULL means item is not pinned.';


--
-- Name: report_card_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.report_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_card_id_seq OWNER TO raywu;

--
-- Name: report_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.report_card_id_seq OWNED BY public.report_card.id;


--
-- Name: report_cardfavorite; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.report_cardfavorite (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    card_id integer NOT NULL,
    owner_id integer NOT NULL
);


ALTER TABLE public.report_cardfavorite OWNER TO raywu;

--
-- Name: report_cardfavorite_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.report_cardfavorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_cardfavorite_id_seq OWNER TO raywu;

--
-- Name: report_cardfavorite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.report_cardfavorite_id_seq OWNED BY public.report_cardfavorite.id;


--
-- Name: report_dashboard; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.report_dashboard (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    creator_id integer NOT NULL,
    parameters text NOT NULL,
    points_of_interest text,
    caveats text,
    show_in_getting_started boolean DEFAULT false NOT NULL,
    public_uuid character(36),
    made_public_by_id integer,
    enable_embedding boolean DEFAULT false NOT NULL,
    embedding_params text,
    archived boolean DEFAULT false NOT NULL,
    "position" integer,
    collection_id integer,
    collection_position smallint
);


ALTER TABLE public.report_dashboard OWNER TO raywu;

--
-- Name: COLUMN report_dashboard.public_uuid; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_dashboard.public_uuid IS 'Unique UUID used to in publically-accessible links to this Dashboard.';


--
-- Name: COLUMN report_dashboard.made_public_by_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_dashboard.made_public_by_id IS 'The ID of the User who first publically shared this Dashboard.';


--
-- Name: COLUMN report_dashboard.enable_embedding; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_dashboard.enable_embedding IS 'Is this Dashboard allowed to be embedded in different websites (using a signed JWT)?';


--
-- Name: COLUMN report_dashboard.embedding_params; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_dashboard.embedding_params IS 'Serialized JSON containing information about required parameters that must be supplied when embedding this Dashboard.';


--
-- Name: COLUMN report_dashboard.archived; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_dashboard.archived IS 'Is this Dashboard archived (effectively treated as deleted?)';


--
-- Name: COLUMN report_dashboard."position"; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_dashboard."position" IS 'The position this Dashboard should appear in the Dashboards list, lower-numbered positions appearing before higher numbered ones.';


--
-- Name: COLUMN report_dashboard.collection_id; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_dashboard.collection_id IS 'Optional ID of Collection this Dashboard belongs to.';


--
-- Name: COLUMN report_dashboard.collection_position; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.report_dashboard.collection_position IS 'Optional pinned position for this item in its Collection. NULL means item is not pinned.';


--
-- Name: report_dashboard_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.report_dashboard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_dashboard_id_seq OWNER TO raywu;

--
-- Name: report_dashboard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.report_dashboard_id_seq OWNED BY public.report_dashboard.id;


--
-- Name: report_dashboardcard; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.report_dashboardcard (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    "sizeX" integer NOT NULL,
    "sizeY" integer NOT NULL,
    "row" integer DEFAULT 0 NOT NULL,
    col integer DEFAULT 0 NOT NULL,
    card_id integer,
    dashboard_id integer NOT NULL,
    parameter_mappings text NOT NULL,
    visualization_settings text NOT NULL
);


ALTER TABLE public.report_dashboardcard OWNER TO raywu;

--
-- Name: report_dashboardcard_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.report_dashboardcard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_dashboardcard_id_seq OWNER TO raywu;

--
-- Name: report_dashboardcard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.report_dashboardcard_id_seq OWNED BY public.report_dashboardcard.id;


--
-- Name: revision; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.revision (
    id integer NOT NULL,
    model character varying(16) NOT NULL,
    model_id integer NOT NULL,
    user_id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    object character varying NOT NULL,
    is_reversion boolean DEFAULT false NOT NULL,
    is_creation boolean DEFAULT false NOT NULL,
    message text
);


ALTER TABLE public.revision OWNER TO raywu;

--
-- Name: revision_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.revision_id_seq OWNER TO raywu;

--
-- Name: revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.revision_id_seq OWNED BY public.revision.id;


--
-- Name: segment; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.segment (
    id integer NOT NULL,
    table_id integer NOT NULL,
    creator_id integer NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    archived boolean DEFAULT false NOT NULL,
    definition text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    points_of_interest text,
    caveats text,
    show_in_getting_started boolean DEFAULT false NOT NULL
);


ALTER TABLE public.segment OWNER TO raywu;

--
-- Name: segment_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.segment_id_seq OWNER TO raywu;

--
-- Name: segment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.segment_id_seq OWNED BY public.segment.id;


--
-- Name: setting; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.setting (
    key character varying(254) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.setting OWNER TO raywu;

--
-- Name: task_history; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.task_history (
    id integer NOT NULL,
    task character varying(254) NOT NULL,
    db_id integer,
    started_at timestamp without time zone NOT NULL,
    ended_at timestamp without time zone NOT NULL,
    duration integer NOT NULL,
    task_details text
);


ALTER TABLE public.task_history OWNER TO raywu;

--
-- Name: TABLE task_history; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON TABLE public.task_history IS 'Timing and metadata info about background/quartz processes';


--
-- Name: COLUMN task_history.task; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.task_history.task IS 'Name of the task';


--
-- Name: COLUMN task_history.task_details; Type: COMMENT; Schema: public; Owner: raywu
--

COMMENT ON COLUMN public.task_history.task_details IS 'JSON string with additional info on the task';


--
-- Name: task_history_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.task_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_history_id_seq OWNER TO raywu;

--
-- Name: task_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.task_history_id_seq OWNED BY public.task_history.id;


--
-- Name: view_log; Type: TABLE; Schema: public; Owner: raywu
--

CREATE TABLE public.view_log (
    id integer NOT NULL,
    user_id integer,
    model character varying(16) NOT NULL,
    model_id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE public.view_log OWNER TO raywu;

--
-- Name: view_log_id_seq; Type: SEQUENCE; Schema: public; Owner: raywu
--

CREATE SEQUENCE public.view_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.view_log_id_seq OWNER TO raywu;

--
-- Name: view_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: raywu
--

ALTER SEQUENCE public.view_log_id_seq OWNED BY public.view_log.id;


--
-- Name: activity id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.activity ALTER COLUMN id SET DEFAULT nextval('public.activity_id_seq'::regclass);


--
-- Name: card_label id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.card_label ALTER COLUMN id SET DEFAULT nextval('public.card_label_id_seq'::regclass);


--
-- Name: collection id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.collection ALTER COLUMN id SET DEFAULT nextval('public.collection_id_seq'::regclass);


--
-- Name: collection_revision id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.collection_revision ALTER COLUMN id SET DEFAULT nextval('public.collection_revision_id_seq'::regclass);


--
-- Name: computation_job id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.computation_job ALTER COLUMN id SET DEFAULT nextval('public.computation_job_id_seq'::regclass);


--
-- Name: computation_job_result id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.computation_job_result ALTER COLUMN id SET DEFAULT nextval('public.computation_job_result_id_seq'::regclass);


--
-- Name: core_user id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.core_user ALTER COLUMN id SET DEFAULT nextval('public.core_user_id_seq'::regclass);


--
-- Name: dashboard_favorite id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dashboard_favorite ALTER COLUMN id SET DEFAULT nextval('public.dashboard_favorite_id_seq'::regclass);


--
-- Name: dashboardcard_series id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dashboardcard_series ALTER COLUMN id SET DEFAULT nextval('public.dashboardcard_series_id_seq'::regclass);


--
-- Name: dependency id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dependency ALTER COLUMN id SET DEFAULT nextval('public.dependency_id_seq'::regclass);


--
-- Name: dimension id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dimension ALTER COLUMN id SET DEFAULT nextval('public.dimension_id_seq'::regclass);


--
-- Name: group_table_access_policy id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.group_table_access_policy ALTER COLUMN id SET DEFAULT nextval('public.group_table_access_policy_id_seq'::regclass);


--
-- Name: label id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.label ALTER COLUMN id SET DEFAULT nextval('public.label_id_seq'::regclass);


--
-- Name: metabase_database id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_database ALTER COLUMN id SET DEFAULT nextval('public.metabase_database_id_seq'::regclass);


--
-- Name: metabase_field id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_field ALTER COLUMN id SET DEFAULT nextval('public.metabase_field_id_seq'::regclass);


--
-- Name: metabase_fieldvalues id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_fieldvalues ALTER COLUMN id SET DEFAULT nextval('public.metabase_fieldvalues_id_seq'::regclass);


--
-- Name: metabase_table id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_table ALTER COLUMN id SET DEFAULT nextval('public.metabase_table_id_seq'::regclass);


--
-- Name: metric id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metric ALTER COLUMN id SET DEFAULT nextval('public.metric_id_seq'::regclass);


--
-- Name: metric_important_field id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metric_important_field ALTER COLUMN id SET DEFAULT nextval('public.metric_important_field_id_seq'::regclass);


--
-- Name: native_query_snippet id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.native_query_snippet ALTER COLUMN id SET DEFAULT nextval('public.native_query_snippet_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: permissions_group id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions_group ALTER COLUMN id SET DEFAULT nextval('public.permissions_group_id_seq'::regclass);


--
-- Name: permissions_group_membership id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions_group_membership ALTER COLUMN id SET DEFAULT nextval('public.permissions_group_membership_id_seq'::regclass);


--
-- Name: permissions_revision id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions_revision ALTER COLUMN id SET DEFAULT nextval('public.permissions_revision_id_seq'::regclass);


--
-- Name: pulse id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse ALTER COLUMN id SET DEFAULT nextval('public.pulse_id_seq'::regclass);


--
-- Name: pulse_card id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse_card ALTER COLUMN id SET DEFAULT nextval('public.pulse_card_id_seq'::regclass);


--
-- Name: pulse_channel id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse_channel ALTER COLUMN id SET DEFAULT nextval('public.pulse_channel_id_seq'::regclass);


--
-- Name: pulse_channel_recipient id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse_channel_recipient ALTER COLUMN id SET DEFAULT nextval('public.pulse_channel_recipient_id_seq'::regclass);


--
-- Name: query_execution id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.query_execution ALTER COLUMN id SET DEFAULT nextval('public.query_execution_id_seq'::regclass);


--
-- Name: report_card id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_card ALTER COLUMN id SET DEFAULT nextval('public.report_card_id_seq'::regclass);


--
-- Name: report_cardfavorite id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_cardfavorite ALTER COLUMN id SET DEFAULT nextval('public.report_cardfavorite_id_seq'::regclass);


--
-- Name: report_dashboard id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_dashboard ALTER COLUMN id SET DEFAULT nextval('public.report_dashboard_id_seq'::regclass);


--
-- Name: report_dashboardcard id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_dashboardcard ALTER COLUMN id SET DEFAULT nextval('public.report_dashboardcard_id_seq'::regclass);


--
-- Name: revision id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.revision ALTER COLUMN id SET DEFAULT nextval('public.revision_id_seq'::regclass);


--
-- Name: segment id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.segment ALTER COLUMN id SET DEFAULT nextval('public.segment_id_seq'::regclass);


--
-- Name: task_history id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.task_history ALTER COLUMN id SET DEFAULT nextval('public.task_history_id_seq'::regclass);


--
-- Name: view_log id; Type: DEFAULT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.view_log ALTER COLUMN id SET DEFAULT nextval('public.view_log_id_seq'::regclass);


--
-- Data for Name: activity; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.activity (id, topic, "timestamp", user_id, model, model_id, database_id, table_id, custom_id, details) FROM stdin;
1	install	2021-02-16 13:06:40.963576+00	\N	install	\N	\N	\N	\N	{}
2	user-joined	2021-02-16 13:09:13.453239+00	1	user	1	\N	\N	\N	{}
3	dashboard-create	2021-02-16 13:12:04.5477+00	1	dashboard	1	\N	\N	\N	{"description":null,"name":"basic"}
4	card-create	2021-02-16 13:13:45.260281+00	1	card	1	2	\N	\N	{"name":"SELECT","description":null}
5	dashboard-add-cards	2021-02-16 13:13:54.414379+00	1	dashboard	1	\N	\N	\N	{"description":null,"name":"basic","dashcards":[{"name":"SELECT","description":null,"id":1,"card_id":1}]}
\.


--
-- Data for Name: card_label; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.card_label (id, card_id, label_id) FROM stdin;
\.


--
-- Data for Name: collection; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.collection (id, name, description, color, archived, location, personal_owner_id, slug, namespace) FROM stdin;
1	ray wu's Personal Collection	\N	#31698A	f	/	1	ray_wu_s_personal_collection	\N
\.


--
-- Data for Name: collection_revision; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.collection_revision (id, before, after, user_id, created_at, remark) FROM stdin;
\.


--
-- Data for Name: computation_job; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.computation_job (id, creator_id, created_at, updated_at, type, status, context, ended_at) FROM stdin;
\.


--
-- Data for Name: computation_job_result; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.computation_job_result (id, job_id, created_at, updated_at, permanence, payload) FROM stdin;
\.


--
-- Data for Name: core_session; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.core_session (id, user_id, created_at, anti_csrf_token) FROM stdin;
26f88a06-a08a-4549-a3f8-8d2218306e4e	1	2021-02-16 13:09:13.249848+00	\N
\.


--
-- Data for Name: core_user; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.core_user (id, email, first_name, last_name, password, password_salt, date_joined, last_login, is_superuser, is_active, reset_token, reset_triggered, is_qbnewb, google_auth, ldap_auth, login_attributes, updated_at, sso_source, locale) FROM stdin;
1	wuhaohsiang1992@gmail.com	ray	wu	$2a$10$CdrJecOVPYIdqpGwYZC2G..o3NWkI63FTvZfqXTtVvY8jldAfNvbG	ce78240d-856a-4109-8a4c-2c32af80b74d	2021-02-16 13:09:13.249848+00	2021-02-16 13:09:13.453146+00	t	t	\N	\N	f	f	f	\N	2021-02-16 13:14:21.43017	\N	\N
\.


--
-- Data for Name: dashboard_favorite; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.dashboard_favorite (id, user_id, dashboard_id) FROM stdin;
\.


--
-- Data for Name: dashboardcard_series; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.dashboardcard_series (id, dashboardcard_id, card_id, "position") FROM stdin;
\.


--
-- Data for Name: data_migrations; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.data_migrations (id, "timestamp") FROM stdin;
add-users-to-default-permissions-groups	2021-02-16 13:06:40.222834
add-admin-group-root-entry	2021-02-16 13:06:40.278697
add-databases-to-magic-permissions-groups	2021-02-16 13:06:40.287632
migrate-field-types	2021-02-16 13:06:40.363252
fix-invalid-field-types	2021-02-16 13:06:40.372763
copy-site-url-setting-and-remove-trailing-slashes	2021-02-16 13:06:40.379079
ensure-protocol-specified-in-site-url	2021-02-16 13:06:40.436726
populate-card-database-id	2021-02-16 13:06:40.446795
migrate-humanization-setting	2021-02-16 13:06:40.503929
mark-category-fields-as-list	2021-02-16 13:06:40.51745
add-legacy-sql-directive-to-bigquery-sql-cards	2021-02-16 13:06:40.528608
clear-ldap-user-local-passwords	2021-02-16 13:06:40.538718
add-migrated-collections	2021-02-16 13:06:40.568516
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:24.708658	1	EXECUTED	8:7182ca8e82947c24fa827d31f78b19aa	createTable tableName=core_organization; createTable tableName=core_user; createTable tableName=core_userorgperm; addUniqueConstraint constraintName=idx_unique_user_id_organization_id, tableName=core_userorgperm; createIndex indexName=idx_userorgp...		\N	3.6.3	\N	\N	3480780818
2	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:24.774497	2	EXECUTED	8:bdcf1238e2ccb4fbe66d7f9e1d9b9529	createTable tableName=core_session		\N	3.6.3	\N	\N	3480780818
4	cammsaul	migrations/000_migrations.yaml	2021-02-16 13:06:24.891031	3	EXECUTED	8:a8e7822a91ea122212d376f5c2d4158f	createTable tableName=setting		\N	3.6.3	\N	\N	3480780818
5	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:24.907586	4	EXECUTED	8:4f8653d16f4b102b3dff647277b6b988	addColumn tableName=core_organization		\N	3.6.3	\N	\N	3480780818
6	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:24.932186	5	EXECUTED	8:2d2f5d1756ecb81da7c09ccfb9b1565a	dropNotNullConstraint columnName=organization_id, tableName=metabase_database; dropForeignKeyConstraint baseTableName=metabase_database, constraintName=fk_database_ref_organization_id; dropNotNullConstraint columnName=organization_id, tableName=re...		\N	3.6.3	\N	\N	3480780818
7	cammsaul	migrations/000_migrations.yaml	2021-02-16 13:06:24.949435	6	EXECUTED	8:c57c69fd78d804beb77d261066521f7f	addColumn tableName=metabase_field		\N	3.6.3	\N	\N	3480780818
8	tlrobinson	migrations/000_migrations.yaml	2021-02-16 13:06:24.966099	7	EXECUTED	8:960ec59bbcb4c9f3fa8362eca9af4075	addColumn tableName=metabase_table; addColumn tableName=metabase_field		\N	3.6.3	\N	\N	3480780818
9	tlrobinson	migrations/000_migrations.yaml	2021-02-16 13:06:24.982636	8	EXECUTED	8:d560283a190e3c60802eb04f5532a49d	addColumn tableName=metabase_table		\N	3.6.3	\N	\N	3480780818
10	cammsaul	migrations/000_migrations.yaml	2021-02-16 13:06:25.158082	9	EXECUTED	8:9f03a236be31f54e8e5c894fe5fc7f00	createTable tableName=revision; createIndex indexName=idx_revision_model_model_id, tableName=revision		\N	3.6.3	\N	\N	3480780818
11	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:25.168737	10	EXECUTED	8:ca6561cab1eedbcf4dcb6d6e22cd46c6	sql		\N	3.6.3	\N	\N	3480780818
12	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:25.182105	11	EXECUTED	8:e862a199cba5b4ce0cba713110f66cfb	addColumn tableName=report_card; addColumn tableName=report_card; addColumn tableName=report_card		\N	3.6.3	\N	\N	3480780818
13	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:25.458801	12	EXECUTED	8:c2c65930bad8d3e9bab3bb6ae562fe0c	createTable tableName=activity; createIndex indexName=idx_activity_timestamp, tableName=activity; createIndex indexName=idx_activity_user_id, tableName=activity; createIndex indexName=idx_activity_custom_id, tableName=activity		\N	3.6.3	\N	\N	3480780818
14	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:25.633469	13	EXECUTED	8:320d2ca8ead3f31309674b2b7f54f395	createTable tableName=view_log; createIndex indexName=idx_view_log_user_id, tableName=view_log; createIndex indexName=idx_view_log_timestamp, tableName=view_log		\N	3.6.3	\N	\N	3480780818
15	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:25.649769	14	EXECUTED	8:505b91530103673a9be3382cd2db1070	addColumn tableName=revision		\N	3.6.3	\N	\N	3480780818
16	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:25.666405	15	EXECUTED	8:ecc7f02641a589e6d35f88587ac6e02b	dropNotNullConstraint columnName=last_login, tableName=core_user		\N	3.6.3	\N	\N	3480780818
17	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:25.683144	16	EXECUTED	8:051c23cd15359364b9895c1569c319e7	addColumn tableName=metabase_database; sql		\N	3.6.3	\N	\N	3480780818
18	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:25.800784	17	EXECUTED	8:62a0483dde183cfd18dd0a86e9354288	createTable tableName=data_migrations; createIndex indexName=idx_data_migrations_id, tableName=data_migrations		\N	3.6.3	\N	\N	3480780818
19	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:25.816612	18	EXECUTED	8:269b129dbfc39a6f9e0d3bc61c3c3b70	addColumn tableName=metabase_table		\N	3.6.3	\N	\N	3480780818
20	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:26.384693	19	EXECUTED	8:0afa34e8b528b83aa19b4142984f8095	createTable tableName=pulse; createIndex indexName=idx_pulse_creator_id, tableName=pulse; createTable tableName=pulse_card; createIndex indexName=idx_pulse_card_pulse_id, tableName=pulse_card; createIndex indexName=idx_pulse_card_card_id, tableNam...		\N	3.6.3	\N	\N	3480780818
21	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:26.684546	20	EXECUTED	8:fb2cd308b17ab81b502d057ecde4fc1b	createTable tableName=segment; createIndex indexName=idx_segment_creator_id, tableName=segment; createIndex indexName=idx_segment_table_id, tableName=segment		\N	3.6.3	\N	\N	3480780818
22	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:26.700674	21	EXECUTED	8:80bc8a62a90791a79adedcf1ac3c6f08	addColumn tableName=revision		\N	3.6.3	\N	\N	3480780818
23	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:26.851675	22	EXECUTED	8:b6f054835db2b2688a1be1de3707f9a9	modifyDataType columnName=rows, tableName=metabase_table		\N	3.6.3	\N	\N	3480780818
24	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:27.260074	23	EXECUTED	8:60825b125b452747098b577310c142b1	createTable tableName=dependency; createIndex indexName=idx_dependency_model, tableName=dependency; createIndex indexName=idx_dependency_model_id, tableName=dependency; createIndex indexName=idx_dependency_dependent_on_model, tableName=dependency;...		\N	3.6.3	\N	\N	3480780818
25	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:27.477281	24	EXECUTED	8:61f25563911117df72f5621d78f10089	createTable tableName=metric; createIndex indexName=idx_metric_creator_id, tableName=metric; createIndex indexName=idx_metric_table_id, tableName=metric		\N	3.6.3	\N	\N	3480780818
26	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:27.492781	25	EXECUTED	8:ddef40b95c55cf4ac0e6a5161911a4cb	addColumn tableName=metabase_database; sql		\N	3.6.3	\N	\N	3480780818
27	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:27.668217	26	EXECUTED	8:001855139df2d5dac4eb954e5abe6486	createTable tableName=dashboardcard_series; createIndex indexName=idx_dashboardcard_series_dashboardcard_id, tableName=dashboardcard_series; createIndex indexName=idx_dashboardcard_series_card_id, tableName=dashboardcard_series		\N	3.6.3	\N	\N	3480780818
28	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:27.684616	27	EXECUTED	8:428e4eb05e4e29141735adf9ae141a0b	addColumn tableName=core_user		\N	3.6.3	\N	\N	3480780818
29	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:27.70132	28	EXECUTED	8:8b02731cc34add3722c926dfd7376ae0	addColumn tableName=pulse_channel		\N	3.6.3	\N	\N	3480780818
30	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:27.719083	29	EXECUTED	8:2c3a50cef177cb90d47a9973cd5934e5	addColumn tableName=metabase_field; addNotNullConstraint columnName=visibility_type, tableName=metabase_field		\N	3.6.3	\N	\N	3480780818
31	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:27.734181	30	EXECUTED	8:30a33a82bab0bcbb2ccb6738d48e1421	addColumn tableName=metabase_field		\N	3.6.3	\N	\N	3480780818
57	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:31.855003	56	EXECUTED	8:aab81d477e2d19a9ab18c58b78c9af88	addColumn tableName=report_card	Added 0.25.0	\N	3.6.3	\N	\N	3480780818
32	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:28.168914	31	EXECUTED	8:40830260b92cedad8da273afd5eca678	createTable tableName=label; createIndex indexName=idx_label_slug, tableName=label; createTable tableName=card_label; addUniqueConstraint constraintName=unique_card_label_card_id_label_id, tableName=card_label; createIndex indexName=idx_card_label...		\N	3.6.3	\N	\N	3480780818
32	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:28.602747	32	EXECUTED	8:483c6c6c8e0a8d056f7b9112d0b0125c	createTable tableName=raw_table; createIndex indexName=idx_rawtable_database_id, tableName=raw_table; addUniqueConstraint constraintName=uniq_raw_table_db_schema_name, tableName=raw_table; createTable tableName=raw_column; createIndex indexName=id...		\N	3.6.3	\N	\N	3480780818
34	tlrobinson	migrations/000_migrations.yaml	2021-02-16 13:06:28.618831	33	EXECUTED	8:52b082600b05bbbc46bfe837d1f37a82	addColumn tableName=pulse_channel		\N	3.6.3	\N	\N	3480780818
35	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:28.635425	34	EXECUTED	8:91b72167fca724e6b6a94b64f886cf09	modifyDataType columnName=value, tableName=setting		\N	3.6.3	\N	\N	3480780818
36	agilliland	migrations/000_migrations.yaml	2021-02-16 13:06:28.711865	35	EXECUTED	8:252e08892449dceb16c3d91337bd9573	addColumn tableName=report_dashboard; addNotNullConstraint columnName=parameters, tableName=report_dashboard; addColumn tableName=report_dashboardcard; addNotNullConstraint columnName=parameter_mappings, tableName=report_dashboardcard		\N	3.6.3	\N	\N	3480780818
37	tlrobinson	migrations/000_migrations.yaml	2021-02-16 13:06:28.828221	36	EXECUTED	8:07d959eff81777e5690e2920583cfe5f	addColumn tableName=query_queryexecution; addNotNullConstraint columnName=query_hash, tableName=query_queryexecution; createIndex indexName=idx_query_queryexecution_query_hash, tableName=query_queryexecution; createIndex indexName=idx_query_querye...		\N	3.6.3	\N	\N	3480780818
38	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:29.245349	37	EXECUTED	8:43604ab55179b50306eb39353e760b46	addColumn tableName=metabase_database; addColumn tableName=metabase_table; addColumn tableName=metabase_field; addColumn tableName=report_dashboard; addColumn tableName=metric; addColumn tableName=segment; addColumn tableName=metabase_database; ad...		\N	3.6.3	\N	\N	3480780818
39	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:29.261564	38	EXECUTED	8:334adc22af5ded71ff27759b7a556951	addColumn tableName=core_user		\N	3.6.3	\N	\N	3480780818
40	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:30.179825	39	EXECUTED	8:ee7f50a264d6cf8d891bd01241eebd2c	createTable tableName=permissions_group; createIndex indexName=idx_permissions_group_name, tableName=permissions_group; createTable tableName=permissions_group_membership; addUniqueConstraint constraintName=unique_permissions_group_membership_user...		\N	3.6.3	\N	\N	3480780818
41	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:30.195248	40	EXECUTED	8:fae0855adf2f702f1133e32fc98d02a5	dropColumn columnName=field_type, tableName=metabase_field; addDefaultValue columnName=active, tableName=metabase_field; addDefaultValue columnName=preview_display, tableName=metabase_field; addDefaultValue columnName=position, tableName=metabase_...		\N	3.6.3	\N	\N	3480780818
42	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:30.239517	41	EXECUTED	8:e32b3a1624fa289a6ee1f3f0a2dac1f6	dropForeignKeyConstraint baseTableName=query_queryexecution, constraintName=fk_queryexecution_ref_query_id; dropColumn columnName=query_id, tableName=query_queryexecution; dropColumn columnName=is_staff, tableName=core_user; dropColumn columnName=...		\N	3.6.3	\N	\N	3480780818
43	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:30.362445	42	EXECUTED	8:165e9384e46d6f9c0330784955363f70	createTable tableName=permissions_revision		\N	3.6.3	\N	\N	3480780818
44	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:30.379201	43	EXECUTED	8:2e356e8a1049286f1c78324828ee7867	dropColumn columnName=public_perms, tableName=report_card; dropColumn columnName=public_perms, tableName=report_dashboard; dropColumn columnName=public_perms, tableName=pulse		\N	3.6.3	\N	\N	3480780818
45	tlrobinson	migrations/000_migrations.yaml	2021-02-16 13:06:30.395729	44	EXECUTED	8:421edd38ee0cb0983162f57193f81b0b	addColumn tableName=report_dashboardcard; addNotNullConstraint columnName=visualization_settings, tableName=report_dashboardcard		\N	3.6.3	\N	\N	3480780818
46	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:30.412704	45	EXECUTED	8:131df3cdd9a8c67b32c5988a3fb7fe3d	addNotNullConstraint columnName=row, tableName=report_dashboardcard; addNotNullConstraint columnName=col, tableName=report_dashboardcard; addDefaultValue columnName=row, tableName=report_dashboardcard; addDefaultValue columnName=col, tableName=rep...		\N	3.6.3	\N	\N	3480780818
47	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:30.688081	46	EXECUTED	8:1d2474e49a27db344c250872df58a6ed	createTable tableName=collection; createIndex indexName=idx_collection_slug, tableName=collection; addColumn tableName=report_card; createIndex indexName=idx_card_collection_id, tableName=report_card		\N	3.6.3	\N	\N	3480780818
48	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:30.813206	47	EXECUTED	8:720ce9d4b9e6f0917aea035e9dc5d95d	createTable tableName=collection_revision		\N	3.6.3	\N	\N	3480780818
49	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:31.055302	48	EXECUTED	8:4508e7d5f6d4da3c4a2de3bf5e3c5851	addColumn tableName=report_card; addColumn tableName=report_card; createIndex indexName=idx_card_public_uuid, tableName=report_card; addColumn tableName=report_dashboard; addColumn tableName=report_dashboard; createIndex indexName=idx_dashboard_pu...		\N	3.6.3	\N	\N	3480780818
50	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:31.070953	49	EXECUTED	8:98a6ab6428ea7a589507464e34ade58a	addColumn tableName=report_card; addColumn tableName=report_card; addColumn tableName=report_dashboard; addColumn tableName=report_dashboard		\N	3.6.3	\N	\N	3480780818
51	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:31.313634	50	EXECUTED	8:43c90b5b9f6c14bfd0e41cc0b184617e	createTable tableName=query_execution; createIndex indexName=idx_query_execution_started_at, tableName=query_execution; createIndex indexName=idx_query_execution_query_hash_started_at, tableName=query_execution		\N	3.6.3	\N	\N	3480780818
52	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:31.479952	51	EXECUTED	8:5af9ea2a96cd6e75a8ac1e6afde7126b	createTable tableName=query_cache; createIndex indexName=idx_query_cache_updated_at, tableName=query_cache; addColumn tableName=report_card		\N	3.6.3	\N	\N	3480780818
53	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:31.588229	52	EXECUTED	8:78d015c5090c57cd6972eb435601d3d0	createTable tableName=query		\N	3.6.3	\N	\N	3480780818
54	tlrobinson	migrations/000_migrations.yaml	2021-02-16 13:06:31.604881	53	EXECUTED	8:e410005b585f5eeb5f202076ff9468f7	addColumn tableName=pulse		\N	3.6.3	\N	\N	3480780818
55	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:31.822321	54	EXECUTED	8:11bbd199bfa57b908ea3b1a470197de9	addColumn tableName=report_dashboard; addColumn tableName=report_dashboard; createTable tableName=dashboard_favorite; addUniqueConstraint constraintName=unique_dashboard_favorite_user_id_dashboard_id, tableName=dashboard_favorite; createIndex inde...		\N	3.6.3	\N	\N	3480780818
56	wwwiiilll	migrations/000_migrations.yaml	2021-02-16 13:06:31.838345	55	EXECUTED	8:9f46051abaee599e2838733512a32ad0	addColumn tableName=core_user	Added 0.25.0	\N	3.6.3	\N	\N	3480780818
58	senior	migrations/000_migrations.yaml	2021-02-16 13:06:32.080671	57	EXECUTED	8:3554219ca39e0fd682d0fba57531e917	createTable tableName=dimension; addUniqueConstraint constraintName=unique_dimension_field_id_name, tableName=dimension; createIndex indexName=idx_dimension_field_id, tableName=dimension	Added 0.25.0	\N	3.6.3	\N	\N	3480780818
59	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:32.096942	58	EXECUTED	8:5b6ce52371e0e9eee88e6d766225a94b	addColumn tableName=metabase_field	Added 0.26.0	\N	3.6.3	\N	\N	3480780818
60	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:32.113635	59	EXECUTED	8:2141162a1c99a5dd95e5a67c5595e6d7	addColumn tableName=metabase_database; addColumn tableName=metabase_database	Added 0.26.0	\N	3.6.3	\N	\N	3480780818
61	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:32.1303	60	EXECUTED	8:7dded6fd5bf74d79b9a0b62511981272	addColumn tableName=metabase_field	Added 0.26.0	\N	3.6.3	\N	\N	3480780818
62	senior	migrations/000_migrations.yaml	2021-02-16 13:06:32.147011	61	EXECUTED	8:cb32e6eaa1a2140703def2730f81fef2	addColumn tableName=metabase_database	Added 0.26.0	\N	3.6.3	\N	\N	3480780818
63	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:32.163758	62	EXECUTED	8:226f73b9f6617495892d281b0f8303db	addColumn tableName=metabase_database	Added 0.26.0	\N	3.6.3	\N	\N	3480780818
64	senior	migrations/000_migrations.yaml	2021-02-16 13:06:32.18045	63	EXECUTED	8:4dcc8ffd836b56756f494d5dfce07b50	dropForeignKeyConstraint baseTableName=raw_table, constraintName=fk_rawtable_ref_database	Added 0.26.0	\N	3.6.3	\N	\N	3480780818
66	senior	migrations/000_migrations.yaml	2021-02-16 13:06:32.199534	64	EXECUTED	8:e77d66af8e3b83d46c5a0064a75a1aac	sql; sql	Added 0.26.0	\N	3.6.3	\N	\N	3480780818
67	attekei	migrations/000_migrations.yaml	2021-02-16 13:06:32.430871	65	EXECUTED	8:59dfc37744fc362e0e312488fbc9a69b	createTable tableName=computation_job; createTable tableName=computation_job_result	Added 0.27.0	\N	3.6.3	\N	\N	3480780818
68	sbelak	migrations/000_migrations.yaml	2021-02-16 13:06:32.447531	66	EXECUTED	8:b4ac06d133dfbdc6567d992c7e18c6ec	addColumn tableName=computation_job; addColumn tableName=computation_job	Added 0.27.0	\N	3.6.3	\N	\N	3480780818
69	senior	migrations/000_migrations.yaml	2021-02-16 13:06:32.514387	67	EXECUTED	8:eadbe00e97eb53df4b3df60462f593f6	addColumn tableName=pulse; addColumn tableName=pulse; addColumn tableName=pulse; dropNotNullConstraint columnName=name, tableName=pulse	Added 0.27.0	\N	3.6.3	\N	\N	3480780818
70	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:32.530782	68	EXECUTED	8:4e4eff7abb983b1127a32ba8107e7fb8	addColumn tableName=metabase_field; addNotNullConstraint columnName=database_type, tableName=metabase_field	Added 0.28.0	\N	3.6.3	\N	\N	3480780818
71	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:32.547523	69	EXECUTED	8:755e5c3dd8a55793f29b2c95cb79c211	dropNotNullConstraint columnName=card_id, tableName=report_dashboardcard	Added 0.28.0	\N	3.6.3	\N	\N	3480780818
72	senior	migrations/000_migrations.yaml	2021-02-16 13:06:32.564078	70	EXECUTED	8:4dc6debdf779ab9273cf2158a84bb154	addColumn tableName=pulse_card; addColumn tableName=pulse_card	Added 0.28.0	\N	3.6.3	\N	\N	3480780818
73	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:32.580616	71	EXECUTED	8:3c0f03d18ff78a0bcc9915e1d9c518d6	addColumn tableName=metabase_database	Added 0.29.0	\N	3.6.3	\N	\N	3480780818
74	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:32.597482	72	EXECUTED	8:16726d6560851325930c25caf3c8ab96	addColumn tableName=metabase_field	Added 0.29.0	\N	3.6.3	\N	\N	3480780818
75	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:32.614313	73	EXECUTED	8:6072cabfe8188872d8e3da9a675f88c1	addColumn tableName=report_card	Added 0.28.2	\N	3.6.3	\N	\N	3480780818
76	senior	migrations/000_migrations.yaml	2021-02-16 13:06:32.630664	74	EXECUTED	8:9b7190c9171ccca72617d508875c3c82	addColumn tableName=metabase_table	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
77	senior	migrations/000_migrations.yaml	2021-02-16 13:06:32.647714	75	EXECUTED	8:07f0a6cd8dbbd9b89be0bd7378f7bdc8	addColumn tableName=core_user	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
78	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:32.882025	76	EXECUTED	8:1977d7278269cdd0dc4f941f9e82f548	createTable tableName=group_table_access_policy; createIndex indexName=idx_gtap_table_id_group_id, tableName=group_table_access_policy; addUniqueConstraint constraintName=unique_gtap_table_id_group_id, tableName=group_table_access_policy	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
79	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:33.006477	77	EXECUTED	8:3f31cb67f9cdf7754ca95cade22d87a2	addColumn tableName=report_dashboard; createIndex indexName=idx_dashboard_collection_id, tableName=report_dashboard; addColumn tableName=pulse; createIndex indexName=idx_pulse_collection_id, tableName=pulse	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
80	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:33.074454	78	EXECUTED	8:199d0ce28955117819ca15bcc29323e5	addColumn tableName=collection; createIndex indexName=idx_collection_location, tableName=collection		\N	3.6.3	\N	\N	3480780818
81	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:33.09049	79	EXECUTED	8:3a6dc22403660529194d004ca7f7ad39	addColumn tableName=report_dashboard; addColumn tableName=report_card; addColumn tableName=pulse	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
82	senior	migrations/000_migrations.yaml	2021-02-16 13:06:33.107387	80	EXECUTED	8:ac4b94df8c648f88cfff661284d6392d	addColumn tableName=core_user; sql	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
83	senior	migrations/000_migrations.yaml	2021-02-16 13:06:33.123988	81	EXECUTED	8:ccd897d737737c05248293c7d56efe96	dropNotNullConstraint columnName=card_id, tableName=group_table_access_policy	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
84	senior	migrations/000_migrations.yaml	2021-02-16 13:06:33.140844	82	EXECUTED	8:58afc10c3e283a8050ea471aac447a97	renameColumn newColumnName=archived, oldColumnName=is_active, tableName=metric; addDefaultValue columnName=archived, tableName=metric; renameColumn newColumnName=archived, oldColumnName=is_active, tableName=segment; addDefaultValue columnName=arch...	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
85	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:33.266157	83	EXECUTED	8:9b4c9878a5018452dd63eb6d7c17f415	addColumn tableName=collection; createIndex indexName=idx_collection_personal_owner_id, tableName=collection; addColumn tableName=collection; sql; addNotNullConstraint columnName=_slug, tableName=collection; dropColumn columnName=slug, tableName=c...	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
86	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:33.275391	84	EXECUTED	8:50c75bb29f479e0b3fb782d89f7d6717	sql	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
87	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:33.291213	85	EXECUTED	8:0eccf19a93cb0ba4017aafd1d308c097	dropTable tableName=raw_column; dropTable tableName=raw_table	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
88	senior	migrations/000_migrations.yaml	2021-02-16 13:06:33.307553	86	EXECUTED	8:04ff5a0738473938fc31d68c1d9952e1	addColumn tableName=core_user	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
129	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.351511	125	MARK_RAN	8:f890168c47cc2113a8af77ed3875c4b3	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
130	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.359884	126	MARK_RAN	8:ecdcf1fd66b3477e5b6882c3286b2fd8	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
89	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:35.370485	87	EXECUTED	8:94d5c406e3ec44e2bc85abe96f6fd91c	createTable tableName=QRTZ_JOB_DETAILS; addPrimaryKey constraintName=PK_QRTZ_JOB_DETAILS, tableName=QRTZ_JOB_DETAILS; createTable tableName=QRTZ_TRIGGERS; addPrimaryKey constraintName=PK_QRTZ_TRIGGERS, tableName=QRTZ_TRIGGERS; addForeignKeyConstra...	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
90	senior	migrations/000_migrations.yaml	2021-02-16 13:06:35.383581	88	EXECUTED	8:8562a72a1190deadc5fa59a23a6396dc	addColumn tableName=core_user; sql; dropColumn columnName=saml_auth, tableName=core_user	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
91	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:35.400879	89	EXECUTED	8:9b8831e1e409f08e874c4ece043d0340	dropColumn columnName=raw_table_id, tableName=metabase_table; dropColumn columnName=raw_column_id, tableName=metabase_field	Added 0.30.0	\N	3.6.3	\N	\N	3480780818
92	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:35.417855	90	EXECUTED	8:1e5bc2d66778316ea640a561862c23b4	addColumn tableName=query_execution	Added 0.31.0	\N	3.6.3	\N	\N	3480780818
93	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:35.434364	91	EXECUTED	8:93b0d408a3970e30d7184ed1166b5476	addColumn tableName=query	Added 0.31.0	\N	3.6.3	\N	\N	3480780818
94	senior	migrations/000_migrations.yaml	2021-02-16 13:06:35.6684	92	EXECUTED	8:a2a1eedf1e8f8756856c9d49c7684bfe	createTable tableName=task_history; createIndex indexName=idx_task_history_end_time, tableName=task_history; createIndex indexName=idx_task_history_db_id, tableName=task_history	Added 0.31.0	\N	3.6.3	\N	\N	3480780818
95	senior	migrations/000_migrations.yaml	2021-02-16 13:06:35.735536	93	EXECUTED	8:9824808283004e803003b938399a4cf0	addUniqueConstraint constraintName=idx_databasechangelog_id_author_filename, tableName=DATABASECHANGELOG	Added 0.31.0	\N	3.6.3	\N	\N	3480780818
96	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:35.751733	94	EXECUTED	8:5cb2f36edcca9c6e14c5e109d6aeb68b	addColumn tableName=metabase_field	Added 0.31.0	\N	3.6.3	\N	\N	3480780818
97	senior	migrations/000_migrations.yaml	2021-02-16 13:06:35.760545	95	MARK_RAN	8:9169e238663c5d036bd83428d2fa8e4b	modifyDataType columnName=results, tableName=query_cache	Added 0.32.0	\N	3.6.3	\N	\N	3480780818
98	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:35.885434	96	EXECUTED	8:f036d20a4dc86fb60ffb64ea838ed6b9	addUniqueConstraint constraintName=idx_uniq_table_db_id_schema_name, tableName=metabase_table; sql	Added 0.32.0	\N	3.6.3	\N	\N	3480780818
99	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.001741	97	EXECUTED	8:274bb516dd95b76c954b26084eed1dfe	addUniqueConstraint constraintName=idx_uniq_field_table_id_parent_id_name, tableName=metabase_field; sql	Added 0.32.0	\N	3.6.3	\N	\N	3480780818
100	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.014038	98	EXECUTED	8:948014f13b6198b50e3b7a066fae2ae0	sql	Added 0.32.0	\N	3.6.3	\N	\N	3480780818
101	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.068016	99	EXECUTED	8:58eabb08a175fafe8985208545374675	createIndex indexName=idx_field_parent_id, tableName=metabase_field	Added 0.32.0	\N	3.6.3	\N	\N	3480780818
103	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.084641	100	EXECUTED	8:fda3670fd16a40fd9d0f89a003098d54	addColumn tableName=metabase_database	Added 0.32.10	\N	3.6.3	\N	\N	3480780818
104	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.143121	101	EXECUTED	8:21709f17e6d1b521d3d3b8cbb5445218	addColumn tableName=core_session	Added EE 1.1.6/CE 0.33.0	\N	3.6.3	\N	\N	3480780818
106	sb	migrations/000_migrations.yaml	2021-02-16 13:06:36.16007	102	EXECUTED	8:a3dd42bbe25c415ce21e4c180dc1c1d7	modifyDataType columnName=database_type, tableName=metabase_field	Added 0.33.5	\N	3.6.3	\N	\N	3480780818
107	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.16844	103	MARK_RAN	8:605c2b4d212315c83727aa3d914cf57f	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
108	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.176543	104	MARK_RAN	8:d11419da9384fd27d7b1670707ac864c	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
109	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.184784	105	MARK_RAN	8:a5f4ea412eb1d5c1bc824046ad11692f	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
110	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.193482	106	MARK_RAN	8:82343097044b9652f73f3d3a2ddd04fe	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
111	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.201777	107	MARK_RAN	8:528de1245ba3aa106871d3e5b3eee0ba	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
112	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.209995	108	MARK_RAN	8:010a3931299429d1adfa91941c806ea4	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
113	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.218265	109	MARK_RAN	8:8f8e0836064bdea82487ecf64a129767	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
114	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.226309	110	MARK_RAN	8:7a0bcb25ece6d9a311d6c6be7ed89bb7	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
115	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.234696	111	MARK_RAN	8:55c10c2ff7e967e3ea1fdffc5aeed93a	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
116	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.24295	112	MARK_RAN	8:dbf7c3a1d8b1eb77b7f5888126b13c2e	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
117	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.251312	113	MARK_RAN	8:f2d7f9fb1b6713bc5362fe40bfe3f91f	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
118	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.260407	114	MARK_RAN	8:17f4410e30a0c7e84a36517ebf4dab64	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
119	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.268061	115	MARK_RAN	8:195cf171ac1d5531e455baf44d9d6561	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
120	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.276616	116	MARK_RAN	8:61f53fac337020aec71868656a719bba	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
121	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.284842	117	MARK_RAN	8:1baa145d2ffe1e18d097a63a95476c5f	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
122	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.29397	118	MARK_RAN	8:929b3c551a8f631cdce2511612d82d62	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
123	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.301484	119	MARK_RAN	8:35e5baddf78df5829fe6889d216436e5	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
124	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.309765	120	MARK_RAN	8:ce2322ca187dfac51be8f12f6a132818	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
125	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.318109	121	MARK_RAN	8:dd948ac004ceb9d0a300a8e06806945f	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
126	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.326675	122	MARK_RAN	8:3d34c0d4e5dbb32b432b83d5322e2aa3	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
127	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.334881	123	MARK_RAN	8:18314b269fe11898a433ca9048400975	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
128	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.344008	124	MARK_RAN	8:44acbe257817286d88b7892e79363b66	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
131	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.368191	127	MARK_RAN	8:453af2935194978c65b19eae445d85c9	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
132	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.377496	128	MARK_RAN	8:d2c37bc80b42a15b65f148bcb1daa86e	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
133	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.38514	129	MARK_RAN	8:5b9b539d146fbdb762577dc98e7f3430	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
134	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.393554	130	MARK_RAN	8:4d0f688a168db3e357a808263b6ad355	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
135	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.401845	131	MARK_RAN	8:2ca54b0828c6aca615fb42064f1ec728	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
136	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.410106	132	MARK_RAN	8:7115eebbcf664509b9fc0c39cb6f29e9	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
137	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.41827	133	MARK_RAN	8:da754ac6e51313a32de6f6389b29e1ca	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
138	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.426564	134	MARK_RAN	8:bfb201761052189e96538f0de3ac76cf	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
139	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.434933	135	MARK_RAN	8:fdad4ec86aefb0cdf850b1929b618508	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
140	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.444117	136	MARK_RAN	8:a0cfe6468160bba8c9d602da736c41fb	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
141	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.451563	137	MARK_RAN	8:b6b7faa02cba069e1ed13e365f59cb6b	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
142	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.460674	138	MARK_RAN	8:0c291eb50cc0f1fef3d55cfe6b62bedb	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
143	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.469245	139	MARK_RAN	8:3d9a5cb41f77a33e834d0562fdddeab6	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
144	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.476684	140	MARK_RAN	8:1d5b7f79f97906105e90d330a17c4062	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
145	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.484991	141	MARK_RAN	8:b162dd48ef850ab4300e2d714eac504e	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
146	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.494204	142	MARK_RAN	8:8c0c1861582d15fe7859358f5d553c91	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
147	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.501599	143	MARK_RAN	8:5ccf590332ea0744414e40a990a43275	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
148	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.510495	144	MARK_RAN	8:12b42e87d40cd7b6399c1fb0c6704fa7	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
149	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.518488	145	MARK_RAN	8:dd45bfc4af5e05701a064a5f2a046d7f	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
150	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.526611	146	MARK_RAN	8:48beda94aeaa494f798c38a66b90fb2a	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
151	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.535012	147	MARK_RAN	8:bb752a7d09d437c7ac294d5ab2600079	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
152	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.544301	148	MARK_RAN	8:4bcbc472f2d6ae3a5e7eca425940e52b	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
153	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.551567	149	MARK_RAN	8:adce2cca96fe0531b00f9bed6bed8352	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
154	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.560127	150	MARK_RAN	8:7a1df4f7a679f47459ea1a1c0991cfba	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
155	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.618608	151	MARK_RAN	8:3c78b79c784e3a3ce09a77db1b1d0374	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
156	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.626549	152	MARK_RAN	8:51859ee6cca4aca9d141a3350eb5d6b1	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
157	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.635045	153	MARK_RAN	8:0197c46bf8536a75dbf7e9aee731f3b2	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
158	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.643393	154	MARK_RAN	8:2ebdd5a179ce2487b2e23b6be74a407c	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
159	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.652557	155	MARK_RAN	8:c62719dad239c51f045315273b56e2a9	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
160	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.659885	156	MARK_RAN	8:1441c71af662abb809cba3b3b360ce81	sql	Added 0.34.2	\N	3.6.3	\N	\N	3480780818
162	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.684682	157	EXECUTED	8:c37f015ad11d77d66e09925eed605cdf	dropTable tableName=query_queryexecution	Added 0.23.0 as a data migration; converted to Liquibase migration in 0.35.0	\N	3.6.3	\N	\N	3480780818
163	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.702196	158	EXECUTED	8:9ef66a82624d70738fc89807a2398ed1	dropColumn columnName=read_permissions, tableName=report_card	Added 0.35.0	\N	3.6.3	\N	\N	3480780818
164	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.759959	159	EXECUTED	8:f19470701bbb33f19f91b1199a915881	addColumn tableName=core_user	Added 0.35.0	\N	3.6.3	\N	\N	3480780818
165	sb	migrations/000_migrations.yaml	2021-02-16 13:06:36.78443	160	EXECUTED	8:b3ae2b90db5c4264ea2ac50d304d6ad4	addColumn tableName=metabase_field; addColumn tableName=metabase_field; addColumn tableName=metabase_table; sql	Added field_order to Table and database_position to Field	\N	3.6.3	\N	\N	3480780818
166	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:36.851549	161	EXECUTED	8:92dafa5c15c46e2af8380304449c7dfa	modifyDataType columnName=updated_at, tableName=metabase_fieldvalues; modifyDataType columnName=updated_at, tableName=query_cache	Added 0.36.0/1.35.4	\N	3.6.3	\N	\N	3480780818
167	walterl, camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.086031	162	EXECUTED	8:4c11dc8c5e829b5263c198fe7879f161	sql; createTable tableName=native_query_snippet; createIndex indexName=idx_snippet_name, tableName=native_query_snippet	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
168	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.202067	163	EXECUTED	8:6d40bfa472bccd2d54284aeb89e1ec3c	modifyDataType columnName=started_at, tableName=query_execution	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
169	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.218267	164	EXECUTED	8:2b97e6eaa7854e179abb9f3749f73b18	dropColumn columnName=rows, tableName=metabase_table	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
170	sb	migrations/000_migrations.yaml	2021-02-16 13:06:37.234996	165	EXECUTED	8:dbd6ee52b0f9195e449a6d744606b599	dropColumn columnName=fields_hash, tableName=metabase_table	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
171	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.310286	166	EXECUTED	8:0798080c0796e6ab3e791bff007118b8	addColumn tableName=native_query_snippet; createIndex indexName=idx_snippet_collection_id, tableName=native_query_snippet	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
172	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.326639	167	EXECUTED	8:212f4010b504e358853fd017032f844f	addColumn tableName=collection	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
173	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.344332	168	EXECUTED	8:4d32b4b7be3f4801e51aeffa5dd47649	dropForeignKeyConstraint baseTableName=activity, constraintName=fk_activity_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
174	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.360111	169	EXECUTED	8:66f31503ba532702e54ea531af668531	addForeignKeyConstraint baseTableName=activity, constraintName=fk_activity_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
175	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.376699	170	EXECUTED	8:c3ceddfca8827d73474cd9a70ea01d1c	dropForeignKeyConstraint baseTableName=card_label, constraintName=fk_card_label_ref_card_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
176	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.393843	171	EXECUTED	8:89c918faa84b7f3f5fa291d4da74414c	addForeignKeyConstraint baseTableName=card_label, constraintName=fk_card_label_ref_card_id, referencedTableName=report_card	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
177	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.410382	172	EXECUTED	8:d45f2198befc83de1f1f963c750607af	dropForeignKeyConstraint baseTableName=card_label, constraintName=fk_card_label_ref_label_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
178	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.426811	173	EXECUTED	8:63d396999449da2d42b3d3e22f3454fa	addForeignKeyConstraint baseTableName=card_label, constraintName=fk_card_label_ref_label_id, referencedTableName=label	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
179	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.461283	174	EXECUTED	8:2a0a7956402ef074e5d54c73ac2d5405	dropForeignKeyConstraint baseTableName=collection, constraintName=fk_collection_personal_owner_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
180	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.476856	175	EXECUTED	8:b02225e5940a2bcca3d550f24f80123e	addForeignKeyConstraint baseTableName=collection, constraintName=fk_collection_personal_owner_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
181	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.493837	176	EXECUTED	8:16923f06b2bbb60c6ac78a0c4b7e4d4f	dropForeignKeyConstraint baseTableName=collection_revision, constraintName=fk_collection_revision_user_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
182	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.510161	177	EXECUTED	8:d59d864c038c530a49056704c93f231d	addForeignKeyConstraint baseTableName=collection_revision, constraintName=fk_collection_revision_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
183	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.526626	178	EXECUTED	8:c5ed9a4f44ee92af620a47c80e010a6b	dropForeignKeyConstraint baseTableName=computation_job, constraintName=fk_computation_job_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
184	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.543501	179	EXECUTED	8:70317e2bdaac90b9ddc33b1b93ada479	addForeignKeyConstraint baseTableName=computation_job, constraintName=fk_computation_job_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
185	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.560131	180	EXECUTED	8:12e7457ec2d2b1a99a3fadfc64d7b7f9	dropForeignKeyConstraint baseTableName=computation_job_result, constraintName=fk_computation_result_ref_job_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
186	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.576838	181	EXECUTED	8:526987d0f6b2f01d7bfc9e3179721be6	addForeignKeyConstraint baseTableName=computation_job_result, constraintName=fk_computation_result_ref_job_id, referencedTableName=computation_job	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
187	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.593631	182	EXECUTED	8:3fbb75c0c491dc6628583184202b8f39	dropForeignKeyConstraint baseTableName=core_session, constraintName=fk_session_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
188	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.610407	183	EXECUTED	8:4dc500830cd4c5715ca8b0956e37b3d5	addForeignKeyConstraint baseTableName=core_session, constraintName=fk_session_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
189	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.626957	184	EXECUTED	8:e07396e0ee587dcf321d21cffa9eec29	dropForeignKeyConstraint baseTableName=dashboardcard_series, constraintName=fk_dashboardcard_series_ref_card_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
190	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.643772	185	EXECUTED	8:eded791094a16bf398896c790645c411	addForeignKeyConstraint baseTableName=dashboardcard_series, constraintName=fk_dashboardcard_series_ref_card_id, referencedTableName=report_card	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
191	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.660356	186	EXECUTED	8:bb5b9a3d64b2e44318e159e7f1fecde2	dropForeignKeyConstraint baseTableName=dashboardcard_series, constraintName=fk_dashboardcard_series_ref_dashboardcard_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
192	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.677917	187	EXECUTED	8:7d96911036dec2fee64fe8ae57c131b3	addForeignKeyConstraint baseTableName=dashboardcard_series, constraintName=fk_dashboardcard_series_ref_dashboardcard_id, referencedTableName=report_dashboardcard	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
193	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.6937	188	EXECUTED	8:db171179fe094db9fee7e2e7df60fa4e	dropForeignKeyConstraint baseTableName=group_table_access_policy, constraintName=fk_gtap_card_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
194	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.710453	189	EXECUTED	8:fccb724d7ae7606e2e7638de1791392a	addForeignKeyConstraint baseTableName=group_table_access_policy, constraintName=fk_gtap_card_id, referencedTableName=report_card	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
195	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.727193	190	EXECUTED	8:1d720af9f917007024c91d40410bc91d	dropForeignKeyConstraint baseTableName=metabase_field, constraintName=fk_field_parent_ref_field_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
196	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.744192	191	EXECUTED	8:c52f5dbf742feef12a3803bda92a425b	addForeignKeyConstraint baseTableName=metabase_field, constraintName=fk_field_parent_ref_field_id, referencedTableName=metabase_field	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
197	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.760495	192	EXECUTED	8:9c1c950b709050abe91cea17fd5970cc	dropForeignKeyConstraint baseTableName=metabase_field, constraintName=fk_field_ref_table_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
198	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.777231	193	EXECUTED	8:e24198ff4825a41d17ceaebd71692103	addForeignKeyConstraint baseTableName=metabase_field, constraintName=fk_field_ref_table_id, referencedTableName=metabase_table	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
199	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.794228	194	EXECUTED	8:146efae3f2938538961835fe07433ee1	dropForeignKeyConstraint baseTableName=metabase_fieldvalues, constraintName=fk_fieldvalues_ref_field_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
200	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.810705	195	EXECUTED	8:f5e7e79cb81b8d2245663c482746c853	addForeignKeyConstraint baseTableName=metabase_fieldvalues, constraintName=fk_fieldvalues_ref_field_id, referencedTableName=metabase_field	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
201	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.827551	196	EXECUTED	8:2d79321a27fde6cb3c4fabdb86dc60ec	dropForeignKeyConstraint baseTableName=metabase_table, constraintName=fk_table_ref_database_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
202	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.84407	197	EXECUTED	8:d0cefed061c4abbf2b0a0fd2a66817cb	addForeignKeyConstraint baseTableName=metabase_table, constraintName=fk_table_ref_database_id, referencedTableName=metabase_database	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
203	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.860258	198	EXECUTED	8:28b4ec07bfbf4b86532fe9357effdb8b	dropForeignKeyConstraint baseTableName=metric, constraintName=fk_metric_ref_creator_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
204	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.877457	199	EXECUTED	8:7195937fd2144533edfa2302ba2ae653	addForeignKeyConstraint baseTableName=metric, constraintName=fk_metric_ref_creator_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
205	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.89399	200	EXECUTED	8:4b2d5f1458641dd1b9dbc5f41600be8e	dropForeignKeyConstraint baseTableName=metric, constraintName=fk_metric_ref_table_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
206	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.910742	201	EXECUTED	8:959ef448c23aaf3acf5b69f297fe4b2f	addForeignKeyConstraint baseTableName=metric, constraintName=fk_metric_ref_table_id, referencedTableName=metabase_table	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
207	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.927426	202	EXECUTED	8:18135d674f2fe502313adb0475f5f139	dropForeignKeyConstraint baseTableName=metric_important_field, constraintName=fk_metric_important_field_metabase_field_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
208	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.944223	203	EXECUTED	8:4c86c17a00a81dfdf35a181e3dd3b08f	addForeignKeyConstraint baseTableName=metric_important_field, constraintName=fk_metric_important_field_metabase_field_id, referencedTableName=metabase_field	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
209	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.96063	204	EXECUTED	8:1b9c3544bf89093fc9e4f7f191fdc6df	dropForeignKeyConstraint baseTableName=metric_important_field, constraintName=fk_metric_important_field_metric_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
210	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.977552	205	EXECUTED	8:842d166cdf7b0a29c88efdaf95c9d0bf	addForeignKeyConstraint baseTableName=metric_important_field, constraintName=fk_metric_important_field_metric_id, referencedTableName=metric	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
211	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:37.994139	206	EXECUTED	8:91c64815a1aefb07dd124d493bfeeea9	dropForeignKeyConstraint baseTableName=native_query_snippet, constraintName=fk_snippet_collection_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
212	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.010851	207	EXECUTED	8:b25064ee26b71f61906a833bc22ebbc2	addForeignKeyConstraint baseTableName=native_query_snippet, constraintName=fk_snippet_collection_id, referencedTableName=collection	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
213	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.027446	208	EXECUTED	8:60a7d628e4f68ee4c85f5f298b1d9865	dropForeignKeyConstraint baseTableName=permissions, constraintName=fk_permissions_group_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
214	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.043775	209	EXECUTED	8:1c3c480313967a2d9f324a094ba25f4d	addForeignKeyConstraint baseTableName=permissions, constraintName=fk_permissions_group_id, referencedTableName=permissions_group	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
215	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.060345	210	EXECUTED	8:5d2c67ccead52970e9d85beb7eda48b9	dropForeignKeyConstraint baseTableName=permissions_group_membership, constraintName=fk_permissions_group_group_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
216	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.077253	211	EXECUTED	8:35fcd5d48600e887188eb1b990e6cc35	addForeignKeyConstraint baseTableName=permissions_group_membership, constraintName=fk_permissions_group_group_id, referencedTableName=permissions_group	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
217	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.094291	212	EXECUTED	8:da7460a35a724109ae9b5096cd18666b	dropForeignKeyConstraint baseTableName=permissions_group_membership, constraintName=fk_permissions_group_membership_user_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
218	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.160921	213	EXECUTED	8:dc04b7eb04cd870c53102cb37fd75a5f	addForeignKeyConstraint baseTableName=permissions_group_membership, constraintName=fk_permissions_group_membership_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
219	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.177866	214	EXECUTED	8:02c690f34fe8803e42441f5037d33017	dropForeignKeyConstraint baseTableName=permissions_revision, constraintName=fk_permissions_revision_user_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
220	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.19422	215	EXECUTED	8:8b8447405d7b2b52358c9676d64b7651	addForeignKeyConstraint baseTableName=permissions_revision, constraintName=fk_permissions_revision_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
221	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.210888	216	EXECUTED	8:54a4c0d8a4eda80dc81fb549a629d075	dropForeignKeyConstraint baseTableName=pulse, constraintName=fk_pulse_collection_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
222	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.227777	217	EXECUTED	8:c5f22e925be3a8fd0e4f47a491f599ee	addForeignKeyConstraint baseTableName=pulse, constraintName=fk_pulse_collection_id, referencedTableName=collection	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
223	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.245079	218	EXECUTED	8:de743e384ff90a6a31a3caebe0abb775	dropForeignKeyConstraint baseTableName=pulse, constraintName=fk_pulse_ref_creator_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
224	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.261301	219	EXECUTED	8:b8fdf9c14d7ea3131a0a6b1f1036f91a	addForeignKeyConstraint baseTableName=pulse, constraintName=fk_pulse_ref_creator_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
225	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.277731	220	EXECUTED	8:495a4e12cf75cac5ff54738772e6a998	dropForeignKeyConstraint baseTableName=pulse_card, constraintName=fk_pulse_card_ref_card_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
226	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.294486	221	EXECUTED	8:cf383d74bc407065c78c060203ba4560	addForeignKeyConstraint baseTableName=pulse_card, constraintName=fk_pulse_card_ref_card_id, referencedTableName=report_card	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
227	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.311348	222	EXECUTED	8:e23eaf74ab7edacfb34bd5caf05cf66f	dropForeignKeyConstraint baseTableName=pulse_card, constraintName=fk_pulse_card_ref_pulse_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
228	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.328127	223	EXECUTED	8:d458ddb160f61e93bb69738f262de2b4	addForeignKeyConstraint baseTableName=pulse_card, constraintName=fk_pulse_card_ref_pulse_id, referencedTableName=pulse	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
229	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.344766	224	EXECUTED	8:1cb939d172989cb1629e9a3da768596d	dropForeignKeyConstraint baseTableName=pulse_channel, constraintName=fk_pulse_channel_ref_pulse_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
230	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.361353	225	EXECUTED	8:62baea3334ac5f21feac84497f6bf643	addForeignKeyConstraint baseTableName=pulse_channel, constraintName=fk_pulse_channel_ref_pulse_id, referencedTableName=pulse	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
231	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.377924	226	EXECUTED	8:d096a9ce70fc0b7dfbc67ee1be4c3e31	dropForeignKeyConstraint baseTableName=pulse_channel_recipient, constraintName=fk_pulse_channel_recipient_ref_pulse_channel_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
232	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.395377	227	EXECUTED	8:be2457ae1e386c9d5ec5bfa4ae681fd6	addForeignKeyConstraint baseTableName=pulse_channel_recipient, constraintName=fk_pulse_channel_recipient_ref_pulse_channel_id, referencedTableName=pulse_channel	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
233	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.411035	228	EXECUTED	8:d5c018882af16093de446e025e2599b7	dropForeignKeyConstraint baseTableName=pulse_channel_recipient, constraintName=fk_pulse_channel_recipient_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
234	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.477947	229	EXECUTED	8:edb6ced6c353064c46fa00b54e187aef	addForeignKeyConstraint baseTableName=pulse_channel_recipient, constraintName=fk_pulse_channel_recipient_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
235	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.494548	230	EXECUTED	8:550c64e41e55233d52ac3ef24d664be1	dropForeignKeyConstraint baseTableName=report_card, constraintName=fk_card_collection_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
236	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.511365	231	EXECUTED	8:04300b298b663fc2a2f3a324d1051c3c	addForeignKeyConstraint baseTableName=report_card, constraintName=fk_card_collection_id, referencedTableName=collection	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
237	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.527918	232	EXECUTED	8:227a9133cdff9f1b60d8af53688ab12e	dropForeignKeyConstraint baseTableName=report_card, constraintName=fk_card_made_public_by_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
238	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.544719	233	EXECUTED	8:7000766ddca2c914ac517611e7d86549	addForeignKeyConstraint baseTableName=report_card, constraintName=fk_card_made_public_by_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
239	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.611573	234	EXECUTED	8:672f4972653f70464982008a7abea3e1	dropForeignKeyConstraint baseTableName=report_card, constraintName=fk_card_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
240	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.628091	235	EXECUTED	8:165b07c8ceb004097c83ee1b689164e4	addForeignKeyConstraint baseTableName=report_card, constraintName=fk_card_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
241	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.645311	236	EXECUTED	8:b0a9e3d801e64e0a66c3190e458c01ae	dropForeignKeyConstraint baseTableName=report_card, constraintName=fk_report_card_ref_database_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
242	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.661355	237	EXECUTED	8:bf10f944715f87c3ad0dd7472d84df62	addForeignKeyConstraint baseTableName=report_card, constraintName=fk_report_card_ref_database_id, referencedTableName=metabase_database	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
243	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.678164	238	EXECUTED	8:cba5d2bfb36e13c60d82cc6cca659b61	dropForeignKeyConstraint baseTableName=report_card, constraintName=fk_report_card_ref_table_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
244	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.694688	239	EXECUTED	8:4d40104eaa47d01981644462ef56f369	addForeignKeyConstraint baseTableName=report_card, constraintName=fk_report_card_ref_table_id, referencedTableName=metabase_table	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
245	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.760869	240	EXECUTED	8:a8f9206dadfe23662d547035f71e3846	dropForeignKeyConstraint baseTableName=report_cardfavorite, constraintName=fk_cardfavorite_ref_card_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
246	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.777708	241	EXECUTED	8:e5db34b9db22254f7445fd65ecf45356	addForeignKeyConstraint baseTableName=report_cardfavorite, constraintName=fk_cardfavorite_ref_card_id, referencedTableName=report_card	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
247	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.794185	242	EXECUTED	8:76de7337a12a5ef42dcbb9274bd2d70f	dropForeignKeyConstraint baseTableName=report_cardfavorite, constraintName=fk_cardfavorite_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
248	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.810993	243	EXECUTED	8:0640fb00a090cbe5dc545afbe0d25811	addForeignKeyConstraint baseTableName=report_cardfavorite, constraintName=fk_cardfavorite_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
249	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.827773	244	EXECUTED	8:16ef5909a72ac4779427e432b3b3ce18	dropForeignKeyConstraint baseTableName=report_dashboard, constraintName=fk_dashboard_collection_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
250	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.920393	245	EXECUTED	8:2e80ebe19816b7bde99050638772cf99	addForeignKeyConstraint baseTableName=report_dashboard, constraintName=fk_dashboard_collection_id, referencedTableName=collection	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
251	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.937352	246	EXECUTED	8:c12aa099f293b1e3d71da5e3edb3c45a	dropForeignKeyConstraint baseTableName=report_dashboard, constraintName=fk_dashboard_made_public_by_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
252	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.953087	247	EXECUTED	8:26b16d4d0cf7a77c1d687f49b029f421	addForeignKeyConstraint baseTableName=report_dashboard, constraintName=fk_dashboard_made_public_by_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
253	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.969975	248	EXECUTED	8:bbf118edaa88a8ad486ec0d6965504b6	dropForeignKeyConstraint baseTableName=report_dashboard, constraintName=fk_dashboard_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
254	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:38.986504	249	EXECUTED	8:7fc35d78c63f41eb4dbd23cfd1505f0b	addForeignKeyConstraint baseTableName=report_dashboard, constraintName=fk_dashboard_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
255	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.00351	250	EXECUTED	8:f6564a7516ace55104a3173eebf4c629	dropForeignKeyConstraint baseTableName=report_dashboardcard, constraintName=fk_dashboardcard_ref_card_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
256	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.086653	251	EXECUTED	8:61db9be3b4dd7ed1e9d01a7254e87544	addForeignKeyConstraint baseTableName=report_dashboardcard, constraintName=fk_dashboardcard_ref_card_id, referencedTableName=report_card	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
257	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.1287	252	EXECUTED	8:c8b51dc7ba4da9f7995a0b0c17fadad2	dropForeignKeyConstraint baseTableName=report_dashboardcard, constraintName=fk_dashboardcard_ref_dashboard_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
258	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.228936	253	EXECUTED	8:58974c6ad8aee63f09e6e48b1a78c267	addForeignKeyConstraint baseTableName=report_dashboardcard, constraintName=fk_dashboardcard_ref_dashboard_id, referencedTableName=report_dashboard	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
259	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.279174	254	EXECUTED	8:be4a52feb3b12e655c0bbd34477749b0	dropForeignKeyConstraint baseTableName=revision, constraintName=fk_revision_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
260	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.321288	255	EXECUTED	8:4b370f9c9073a6f8f585aab713c57f47	addForeignKeyConstraint baseTableName=revision, constraintName=fk_revision_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
261	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.362896	256	EXECUTED	8:173fe552fdf72fdb4efbc01a6ac4f7ad	dropForeignKeyConstraint baseTableName=segment, constraintName=fk_segment_ref_creator_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
262	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.405165	257	EXECUTED	8:50927b8b1d1809f32c11d2e649dbcb94	addForeignKeyConstraint baseTableName=segment, constraintName=fk_segment_ref_creator_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
263	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.454754	258	EXECUTED	8:0b10c8664506917cc50359e9634c121c	dropForeignKeyConstraint baseTableName=segment, constraintName=fk_segment_ref_table_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
264	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.496669	259	EXECUTED	8:b132aedf6fbdcc5d956a2d3a154cc035	addForeignKeyConstraint baseTableName=segment, constraintName=fk_segment_ref_table_id, referencedTableName=metabase_table	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
265	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.5386	260	EXECUTED	8:2e339ecb05463b3765f9bb266bd28297	dropForeignKeyConstraint baseTableName=view_log, constraintName=fk_view_log_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
266	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.588532	261	EXECUTED	8:31506e118764f5e520f755f26c696bb8	addForeignKeyConstraint baseTableName=view_log, constraintName=fk_view_log_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	3480780818
268	rlotun	migrations/000_migrations.yaml	2021-02-16 13:06:39.697161	262	EXECUTED	8:9da2f706a7cd42b5101601e0106fa929	createIndex indexName=idx_lower_email, tableName=core_user	Added 0.37.0	\N	3.6.3	\N	\N	3480780818
269	rlotun	migrations/000_migrations.yaml	2021-02-16 13:06:39.709047	263	EXECUTED	8:215609ca9dce2181687b4fa65e7351ba	sql	Added 0.37.0	\N	3.6.3	\N	\N	3480780818
270	rlotun	migrations/000_migrations.yaml	2021-02-16 13:06:39.800782	264	EXECUTED	8:17001a192ba1df02104cc0d15569cbe5	sql	Added 0.37.0	\N	3.6.3	\N	\N	3480780818
271	rlotun	migrations/000_migrations.yaml	2021-02-16 13:06:39.934424	265	EXECUTED	8:ce8ddb253a303d4f8924ff5a187080c0	modifyDataType columnName=email, tableName=core_user	Added 0.37.0	\N	3.6.3	\N	\N	3480780818
273	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.950512	266	EXECUTED	8:5348576bb9852f6f947e1aa39cd1626f	addDefaultValue columnName=is_superuser, tableName=core_user	Added 0.37.1	\N	3.6.3	\N	\N	3480780818
274	camsaul	migrations/000_migrations.yaml	2021-02-16 13:06:39.967236	267	EXECUTED	8:11a8a84b9ba7634aeda625ff3f487d22	addDefaultValue columnName=is_active, tableName=core_user	Added 0.37.1	\N	3.6.3	\N	\N	3480780818
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
\.


--
-- Data for Name: dependency; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.dependency (id, model, model_id, dependent_on_model, dependent_on_id, created_at) FROM stdin;
\.


--
-- Data for Name: dimension; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.dimension (id, field_id, name, type, human_readable_field_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: group_table_access_policy; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.group_table_access_policy (id, group_id, table_id, card_id, attribute_remappings) FROM stdin;
\.


--
-- Data for Name: label; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.label (id, name, slug, icon) FROM stdin;
\.


--
-- Data for Name: metabase_database; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.metabase_database (id, created_at, updated_at, name, description, details, engine, is_sample, is_full_sync, points_of_interest, caveats, metadata_sync_schedule, cache_field_values_schedule, timezone, is_on_demand, options, auto_run_queries) FROM stdin;
1	2021-02-16 13:06:40.964517+00	2021-02-16 13:06:41.483417+00	Sample Dataset	\N	{"db":"zip:/app/metabase.jar!/sample-dataset.db;USER=GUEST;PASSWORD=guest"}	h2	t	t	\N	\N	0 50 * * * ? *	0 50 0 * * ? *	UTC	f	\N	t
2	2021-02-16 13:09:13.249848+00	2021-02-16 13:09:13.49419+00	world	\N	{"host":"localhost","port":5432,"dbname":"world","user":"raywu","password":"raywu60kg","ssl":false,"additional-options":null,"tunnel-enabled":false}	postgres	f	t	\N	\N	0 0 * * * ? *	0 0 0 * * ? *	UTC	f	\N	t
\.


--
-- Data for Name: metabase_field; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.metabase_field (id, created_at, updated_at, name, base_type, special_type, active, description, preview_display, "position", table_id, parent_id, display_name, visibility_type, fk_target_field_id, last_analyzed, points_of_interest, caveats, fingerprint, fingerprint_version, database_type, has_field_values, settings, database_position, custom_position) FROM stdin;
9	2021-02-16 13:06:41.851101+00	2021-02-16 13:06:41.851101+00	ID	type/BigInteger	type/PK	t	This is a unique ID for the product. It is also called the “Invoice number” or “Confirmation number” in customer facing emails and screens.	t	0	2	\N	ID	normal	\N	\N	\N	\N	\N	0	BIGINT	\N	\N	0	0
14	2021-02-16 13:06:42.017514+00	2021-02-16 13:06:45.637024+00	NAME	type/Text	type/Name	t	The name of the user who owns an account	t	4	3	\N	Name	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":2499,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":13.532}}}	5	VARCHAR	\N	\N	4	0
22	2021-02-16 13:06:42.08477+00	2021-02-16 13:06:42.08477+00	ID	type/BigInteger	type/PK	t	A unique identifier given to each user.	t	0	3	\N	ID	normal	\N	\N	\N	\N	\N	0	BIGINT	\N	\N	0	0
30	2021-02-16 13:06:42.23433+00	2021-02-16 13:06:42.23433+00	ID	type/BigInteger	type/PK	t	The numerical product number. Only used internally. All external communication should use the title or EAN.	t	0	1	\N	ID	normal	\N	\N	\N	\N	\N	0	BIGINT	\N	\N	0	0
36	2021-02-16 13:06:42.36016+00	2021-02-16 13:06:42.36016+00	ID	type/BigInteger	type/PK	t	A unique internal identifier for the review. Should not be used externally.	t	0	4	\N	ID	normal	\N	\N	\N	\N	\N	0	BIGINT	\N	\N	0	0
17	2021-02-16 13:06:42.042318+00	2021-02-16 13:06:45.652004+00	STATE	type/Text	type/State	t	The state or province of the account’s billing address	t	7	3	\N	State	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":49,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":1.0,"average-length":2.0}}}	5	CHAR	auto-list	\N	7	0
35	2021-02-16 13:06:42.300955+00	2021-02-16 13:06:45.518069+00	REVIEWER	type/Text	\N	t	The user who left the review	t	2	4	\N	Reviewer	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":1076,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.001798561151079137,"average-length":9.972122302158274}}}	5	VARCHAR	\N	\N	2	0
8	2021-02-16 13:06:41.842969+00	2021-02-16 13:06:44.009624+00	TAX	type/Float	\N	t	This is the amount of local and federal taxes that are collected on the purchase. Note that other governmental fees on some products are not included here, but instead are accounted for in the subtotal.	t	4	2	\N	Tax	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":797,"nil%":0.0},"type":{"type/Number":{"min":0.0,"q1":2.273340386603857,"q3":5.337275338216307,"max":11.12,"sd":2.3206651358900316,"avg":3.8722100000000004}}}	5	DOUBLE	\N	\N	4	0
7	2021-02-16 13:06:41.834394+00	2021-02-16 13:06:44.018073+00	TOTAL	type/Float	\N	t	The total billed amount.	t	5	2	\N	Total	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":10000,"nil%":0.0},"type":{"type/Number":{"min":12.061602936923117,"q1":52.006147617878135,"q3":109.55803018499738,"max":238.32732001721533,"sd":38.35967664847571,"avg":82.96014815230805}}}	5	DOUBLE	\N	\N	5	0
13	2021-02-16 13:06:41.966912+00	2021-02-16 13:06:44.990162+00	ADDRESS	type/Text	\N	t	The street address of the account’s billing address	t	1	3	\N	Address	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":2490,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":20.85}}}	5	VARCHAR	\N	\N	1	0
6	2021-02-16 13:06:41.826066+00	2021-02-16 13:06:44.00139+00	SUBTOTAL	type/Float	\N	t	The raw, pre-tax cost of the order. Note that this might be different in the future from the product price due to promotions, credits, etc.	t	3	2	\N	Subtotal	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":340,"nil%":0.0},"type":{"type/Number":{"min":15.691943673970439,"q1":49.74894519060184,"q3":105.42965746993103,"max":148.22900526552291,"sd":32.53705013056317,"avg":77.01295465356547}}}	5	DOUBLE	\N	\N	3	0
16	2021-02-16 13:06:42.033632+00	2021-02-16 13:06:45.000434+00	BIRTH_DATE	type/Date	\N	t	The date of birth of the user	t	9	3	\N	Birth Date	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":2308,"nil%":0.0},"type":{"type/DateTime":{"earliest":"1958-04-26","latest":"2000-04-03"}}}	5	DATE	\N	\N	9	0
19	2021-02-16 13:06:42.059783+00	2021-02-16 13:06:45.61936+00	LATITUDE	type/Float	type/Latitude	t	This is the latitude of the user on sign-up. It might be updated in the future to the last seen location.	t	11	3	\N	Latitude	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":2491,"nil%":0.0},"type":{"type/Number":{"min":25.775827,"q1":35.302705923023126,"q3":43.773802584662,"max":70.6355001,"sd":6.390832341883712,"avg":39.87934670484002}}}	5	DOUBLE	\N	\N	11	0
18	2021-02-16 13:06:42.050238+00	2021-02-16 13:06:45.645219+00	SOURCE	type/Text	type/Source	t	The channel through which we acquired this user. Valid values include: Affiliate, Facebook, Google, Organic and Twitter	t	8	3	\N	Source	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":5,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":7.4084}}}	5	VARCHAR	auto-list	\N	8	0
5	2021-02-16 13:06:41.817736+00	2021-02-16 13:06:43.984397+00	PRODUCT_ID	type/Integer	type/FK	t	The product ID. This is an internal identifier for the product, NOT the SKU.	t	2	2	\N	Product ID	normal	30	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":200,"nil%":0.0}}	5	INTEGER	\N	\N	2	0
10	2021-02-16 13:06:41.938326+00	2021-02-16 13:06:45.602287+00	CREATED_AT	type/DateTime	type/CreationTimestamp	t	The date the user record was created. Also referred to as the user’s "join date"	t	12	3	\N	Created At	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":2500,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2016-04-19T21:35:18.752Z","latest":"2019-04-19T14:06:27.3Z"}}}	5	TIMESTAMP	\N	\N	12	0
29	2021-02-16 13:06:42.225936+00	2021-02-16 13:06:45.676392+00	CREATED_AT	type/DateTime	type/CreationTimestamp	t	The date the product was added to our catalog.	t	7	1	\N	Created At	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":200,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2016-04-26T19:29:55.147Z","latest":"2019-04-15T13:34:19.931Z"}}}	5	TIMESTAMP	\N	\N	7	0
28	2021-02-16 13:06:42.217734+00	2021-02-16 13:06:45.688706+00	RATING	type/Float	type/Score	t	The average rating users have given the product. This ranges from 1 - 5	t	6	1	\N	Rating	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":23,"nil%":0.0},"type":{"type/Number":{"min":0.0,"q1":3.5120465053408525,"q3":4.216124969497314,"max":5.0,"sd":1.3605488657451452,"avg":3.4715}}}	5	DOUBLE	\N	\N	6	0
24	2021-02-16 13:06:42.142297+00	2021-02-16 13:06:45.176241+00	EAN	type/Text	\N	t	The international article number. A 13 digit number uniquely identifying the product.	t	1	1	\N	Ean	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":200,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":13.0}}}	5	CHAR	\N	\N	1	0
25	2021-02-16 13:06:42.19289+00	2021-02-16 13:06:45.703302+00	VENDOR	type/Text	type/Company	t	The source of the product.	t	4	1	\N	Vendor	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":200,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":20.6}}}	5	VARCHAR	\N	\N	4	0
34	2021-02-16 13:06:42.292668+00	2021-02-16 13:06:45.764313+00	CREATED_AT	type/DateTime	type/CreationTimestamp	t	The day and time a review was written by a user.	t	5	4	\N	Created At	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":1112,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2016-06-03T00:37:05.818Z","latest":"2020-04-19T14:15:25.677Z"}}}	5	TIMESTAMP	\N	\N	5	0
33	2021-02-16 13:06:42.284126+00	2021-02-16 13:06:45.501297+00	PRODUCT_ID	type/Integer	type/FK	t	The product the review was for	t	1	4	\N	Product ID	normal	30	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":176,"nil%":0.0}}	5	INTEGER	\N	\N	1	0
1	2021-02-16 13:06:41.738782+00	2021-02-16 13:06:45.560491+00	DISCOUNT	type/Float	type/Discount	t	Discount amount.	t	6	2	\N	Discount	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":701,"nil%":0.898},"type":{"type/Number":{"min":0.17088996672584322,"q1":2.9786226681458743,"q3":7.338187788658235,"max":61.69684269960571,"sd":3.053663125001991,"avg":5.161255547580326}}}	5	DOUBLE	\N	\N	6	0
3	2021-02-16 13:06:41.751258+00	2021-02-16 13:06:44.02601+00	USER_ID	type/Integer	type/FK	t	The id of the user who made this order. Note that in some cases where an order was created on behalf of a customer who phoned the order in, this might be the employee who handled the request.	t	1	2	\N	User ID	normal	22	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":929,"nil%":0.0}}	5	INTEGER	\N	\N	1	0
11	2021-02-16 13:06:41.950526+00	2021-02-16 13:06:45.059477+00	PASSWORD	type/Text	\N	t	This is the salted password of the user. It should not be visible	t	3	3	\N	Password	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":2500,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":36.0}}}	5	VARCHAR	\N	\N	3	0
20	2021-02-16 13:06:42.066902+00	2021-02-16 13:06:45.085363+00	ZIP	type/Text	type/ZipCode	t	The postal code of the account’s billing address	t	10	3	\N	Zip	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":2234,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":5.0}}}	5	CHAR	\N	\N	10	0
23	2021-02-16 13:06:42.134116+00	2021-02-16 13:06:45.184836+00	PRICE	type/Float	\N	t	The list price of the product. Note that this is not always the price the product sold for due to discounts, promotions, etc.	t	5	1	\N	Price	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":170,"nil%":0.0},"type":{"type/Number":{"min":15.691943673970439,"q1":37.25154462926434,"q3":75.45898071609447,"max":98.81933684368194,"sd":21.711481557852057,"avg":55.74639966792074}}}	5	DOUBLE	\N	\N	5	0
32	2021-02-16 13:06:42.275455+00	2021-02-16 13:06:45.487194+00	BODY	type/Text	type/Description	t	The review the user left. Limited to 2000 characters.	t	4	4	\N	Body	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":1112,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":177.41996402877697}}}	5	CLOB	\N	\N	4	0
4	2021-02-16 13:06:41.809871+00	2021-02-16 13:06:45.555532+00	CREATED_AT	type/DateTime	type/CreationTimestamp	t	The date and time an order was submitted.	t	7	2	\N	Created At	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":9998,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2016-04-30T18:56:13.352Z","latest":"2020-04-19T14:07:15.657Z"}}}	5	TIMESTAMP	\N	\N	7	0
2	2021-02-16 13:06:41.745964+00	2021-02-16 13:06:45.573218+00	QUANTITY	type/Integer	type/Quantity	t	Number of products bought.	t	8	2	\N	Quantity	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":62,"nil%":0.0},"type":{"type/Number":{"min":0.0,"q1":1.755882607764982,"q3":4.882654507928044,"max":100.0,"sd":4.214258386403798,"avg":3.7015}}}	5	INTEGER	auto-list	\N	8	0
21	2021-02-16 13:06:42.075836+00	2021-02-16 13:06:45.597336+00	CITY	type/Text	type/City	t	The city of the account’s billing address	t	5	3	\N	City	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":1966,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.002,"average-length":8.284}}}	5	VARCHAR	\N	\N	5	0
15	2021-02-16 13:06:42.025423+00	2021-02-16 13:06:45.611267+00	EMAIL	type/Text	type/Email	t	The contact email for the account.	t	2	3	\N	Email	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":2500,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":1.0,"percent-state":0.0,"average-length":24.1824}}}	5	VARCHAR	\N	\N	2	0
12	2021-02-16 13:06:41.959021+00	2021-02-16 13:06:45.626779+00	LONGITUDE	type/Float	type/Longitude	t	This is the longitude of the user on sign-up. It might be updated in the future to the last seen location.	t	6	3	\N	Longitude	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":2491,"nil%":0.0},"type":{"type/Number":{"min":-166.5425726,"q1":-101.58350792373135,"q3":-84.65289348288829,"max":-67.96735199999999,"sd":15.399698968175663,"avg":-95.18741780363999}}}	5	DOUBLE	\N	\N	6	0
26	2021-02-16 13:06:42.200894+00	2021-02-16 13:06:45.670352+00	CATEGORY	type/Text	type/Category	t	The type of product, valid values include: Doohicky, Gadget, Gizmo and Widget	t	3	1	\N	Category	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":4,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":6.375}}}	5	VARCHAR	auto-list	\N	3	0
27	2021-02-16 13:06:42.210063+00	2021-02-16 13:06:45.694475+00	TITLE	type/Text	type/Title	t	The name of the product as it should be displayed to customers.	t	2	1	\N	Title	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":199,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":21.495}}}	5	VARCHAR	\N	\N	2	0
31	2021-02-16 13:06:42.271168+00	2021-02-16 13:06:45.768976+00	RATING	type/Integer	type/Score	t	The rating (on a scale of 1-5) the user left.	t	3	4	\N	Rating	normal	\N	2021-02-16 13:06:45.855884+00	\N	\N	{"global":{"distinct-count":5,"nil%":0.0},"type":{"type/Number":{"min":1.0,"q1":3.54744353181696,"q3":4.764807071650455,"max":5.0,"sd":1.0443899855660577,"avg":3.987410071942446}}}	5	SMALLINT	auto-list	\N	3	0
40	2021-02-16 13:09:13.667456+00	2021-02-16 13:09:13.667456+00	id	type/Integer	type/PK	t	\N	t	0	7	\N	ID	normal	\N	\N	\N	\N	\N	0	int4	\N	\N	0	0
45	2021-02-16 13:09:13.742015+00	2021-02-16 13:09:13.742015+00	code	type/Text	type/PK	t	\N	t	0	5	\N	Code	normal	\N	\N	\N	\N	\N	0	bpchar	\N	\N	0	0
58	2021-02-16 13:09:13.892488+00	2021-02-16 13:09:13.892488+00	language	type/Text	type/PK	t	\N	t	1	6	\N	Language	normal	\N	\N	\N	\N	\N	0	text	\N	\N	1	0
47	2021-02-16 13:09:13.75857+00	2021-02-16 13:09:14.459353+00	gnp	type/Decimal	\N	t	\N	t	8	5	\N	Gnp	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":214,"nil%":0.0},"type":{"type/Number":{"min":0.0,"q1":920.879291269945,"q3":30778.952926912098,"max":8510700.0,"sd":637997.4076188041,"avg":122823.88242677825}}}	5	numeric	\N	\N	8	0
37	2021-02-16 13:09:13.61133+00	2021-02-16 13:09:14.301253+00	population	type/Integer	\N	t	\N	t	4	7	\N	Population	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":3896,"nil%":0.0},"type":{"type/Number":{"min":42.0,"q1":117538.7460393194,"q3":310030.1913941276,"max":1.05E7,"sd":723416.1206957065,"avg":350468.22358421184}}}	5	int4	\N	\N	4	0
39	2021-02-16 13:09:13.625307+00	2021-02-16 13:09:14.626653+00	countrycode	type/Text	type/Country	t	\N	t	2	7	\N	Country Code	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":232,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":3.0}}}	5	bpchar	\N	\N	2	0
42	2021-02-16 13:09:13.719359+00	2021-02-16 13:09:14.647393+00	continent	type/Text	type/Category	t	\N	t	2	5	\N	Continent	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":7,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":7.2677824267782425}}}	5	text	auto-list	\N	2	0
41	2021-02-16 13:09:13.675716+00	2021-02-16 13:09:14.325718+00	district	type/Text	\N	t	\N	t	3	7	\N	District	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":1367,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.06692816866879137,"average-length":9.01936749203236}}}	5	text	\N	\N	3	0
43	2021-02-16 13:09:13.728714+00	2021-02-16 13:09:14.651052+00	name	type/Text	type/Name	t	\N	t	1	5	\N	Name	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":239,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.004184100418410042,"average-length":10.096234309623432}}}	5	text	\N	\N	1	0
48	2021-02-16 13:09:13.76736+00	2021-02-16 13:09:14.660746+00	region	type/Text	type/Category	t	\N	t	3	5	\N	Region	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":25,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":13.748953974895397}}}	5	text	auto-list	\N	3	0
44	2021-02-16 13:09:13.734299+00	2021-02-16 13:09:14.442447+00	capital	type/Integer	type/FK	t	\N	t	13	5	\N	Capital	normal	40	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":233,"nil%":0.02928870292887029}}	5	int4	\N	\N	13	0
46	2021-02-16 13:09:13.750766+00	2021-02-16 13:09:14.450933+00	localname	type/Text	\N	t	\N	t	10	5	\N	Local Name	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":239,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":11.807531380753138}}}	5	text	\N	\N	10	0
49	2021-02-16 13:09:13.775631+00	2021-02-16 13:09:14.668623+00	indepyear	type/Integer	\N	t	\N	t	5	5	\N	Inde Pye Ar	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":89,"nil%":0.196652719665272},"type":{"type/Number":{"min":-1523.0,"q1":1906.5,"q3":1973.882983404476,"max":1994.0,"sd":420.8312080721728,"avg":1847.2604166666667}}}	5	int2	auto-list	\N	5	0
50	2021-02-16 13:09:13.78353+00	2021-02-16 13:09:14.677569+00	governmentform	type/Text	\N	t	\N	t	11	5	\N	Government Form	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":35,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":15.518828451882845}}}	5	text	auto-list	\N	11	0
60	2021-02-16 13:09:13.909192+00	2021-02-16 13:09:14.694246+00	isofficial	type/Boolean	type/Category	t	\N	t	2	6	\N	Is Official	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.0}}	5	bool	auto-list	\N	2	0
51	2021-02-16 13:09:13.792615+00	2021-02-16 13:09:14.49295+00	code2	type/Text	\N	t	\N	t	14	5	\N	Code2	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":239,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.104602510460251,"average-length":2.0}}}	5	bpchar	\N	\N	14	0
52	2021-02-16 13:09:13.801287+00	2021-02-16 13:09:14.500881+00	headofstate	type/Text	\N	t	\N	t	12	5	\N	Head Ofs Tate	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":180,"nil%":0.004184100418410042},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":15.602510460251047}}}	5	text	\N	\N	12	0
53	2021-02-16 13:09:13.809304+00	2021-02-16 13:09:14.509509+00	population	type/Integer	\N	t	\N	t	6	5	\N	Population	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":226,"nil%":0.0},"type":{"type/Number":{"min":0.0,"q1":402604.96930427913,"q3":1.4835858179561444E7,"max":1.277558E9,"sd":1.0933969651649864E8,"avg":2.543409811715481E7}}}	5	int4	\N	\N	6	0
54	2021-02-16 13:09:13.817031+00	2021-02-16 13:09:14.51773+00	surfacearea	type/Float	\N	t	\N	t	4	5	\N	Surface Area	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":238,"nil%":0.0},"type":{"type/Number":{"min":0.4000000059604645,"q1":8776.00871549848,"q3":401704.45493341633,"max":1.70754E7,"sd":1924134.9360171442,"avg":623248.1460251047}}}	5	float4	\N	\N	4	0
56	2021-02-16 13:09:13.833385+00	2021-02-16 13:09:14.53406+00	gnpold	type/Decimal	\N	t	\N	t	9	5	\N	Gnp Old	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":179,"nil%":0.2552301255230126},"type":{"type/Number":{"min":157.0,"q1":2198.013205032525,"q3":73132.0,"max":8110900.0,"sd":720468.8163461669,"avg":165534.31460674157}}}	5	numeric	\N	\N	9	0
59	2021-02-16 13:09:13.901079+00	2021-02-16 13:09:14.591967+00	countrycode	type/Text	type/FK	t	\N	t	0	6	\N	Country Code	normal	45	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":233,"nil%":0.0}}	5	bpchar	\N	\N	0	0
55	2021-02-16 13:09:13.825095+00	2021-02-16 13:09:14.526179+00	lifeexpectancy	type/Float	\N	t	\N	t	7	5	\N	Life Expectancy	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":161,"nil%":0.07112970711297072},"type":{"type/Number":{"min":37.20000076293945,"q1":60.28749966621399,"q3":75.502699758148,"max":83.5,"sd":11.518572140930228,"avg":66.48603611164263}}}	5	float4	\N	\N	7	0
38	2021-02-16 13:09:13.617417+00	2021-02-16 13:09:14.619744+00	name	type/Text	type/Name	t	\N	t	1	7	\N	Name	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":4000,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":4.903162539838196E-4,"average-length":8.529541554302526}}}	5	text	\N	\N	1	0
57	2021-02-16 13:09:13.883239+00	2021-02-16 13:09:14.701131+00	percentage	type/Float	type/Share	t	\N	t	3	6	\N	Percentage	normal	\N	2021-02-16 13:09:14.768332+00	\N	\N	{"global":{"distinct-count":357,"nil%":0.0},"type":{"type/Number":{"min":0.0,"q1":1.2376652238176384,"q3":21.262500286102295,"max":100.0,"sd":30.82742303699335,"avg":20.374390190845826}}}	5	float4	\N	\N	3	0
\.


--
-- Data for Name: metabase_fieldvalues; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.metabase_fieldvalues (id, created_at, updated_at, "values", human_readable_values, field_id) FROM stdin;
1	2021-02-16 13:06:46.419164+00	2021-02-16 13:06:46.419164+00	[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,63,65,67,68,69,70,71,72,73,75,78,82,83,88,100]	\N	2
2	2021-02-16 13:06:46.462477+00	2021-02-16 13:06:46.462477+00	["Affiliate","Facebook","Google","Organic","Twitter"]	\N	18
3	2021-02-16 13:06:46.486559+00	2021-02-16 13:06:46.486559+00	["AK","AL","AR","AZ","CA","CO","CT","DE","FL","GA","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VA","VT","WA","WI","WV","WY"]	\N	17
4	2021-02-16 13:06:46.512895+00	2021-02-16 13:06:46.512895+00	["Doohickey","Gadget","Gizmo","Widget"]	\N	26
5	2021-02-16 13:06:46.543337+00	2021-02-16 13:06:46.543337+00	[1,2,3,4,5]	\N	31
6	2021-02-16 13:09:14.806999+00	2021-02-16 13:09:14.806999+00	["Africa","Antarctica","Asia","Europe","North America","Oceania","South America"]	\N	42
7	2021-02-16 13:09:14.841148+00	2021-02-16 13:09:14.841148+00	["Antarctica","Australia and New Zealand","Baltic Countries","British Islands","Caribbean","Central Africa","Central America","Eastern Africa","Eastern Asia","Eastern Europe","Melanesia","Micronesia","Micronesia/Caribbean","Middle East","Nordic Countries","North America","Northern Africa","Polynesia","South America","Southeast Asia","Southern Africa","Southern Europe","Southern and Central Asia","Western Africa","Western Europe"]	\N	48
8	2021-02-16 13:09:14.873792+00	2021-02-16 13:09:14.873792+00	[-1523,-1000,-660,800,836,843,885,1066,1143,1278,1350,1492,1499,1581,1769,1776,1804,1806,1810,1811,1816,1821,1822,1825,1828,1830,1838,1841,1844,1847,1861,1867,1878,1901,1902,1903,1905,1906,1907,1908,1910,1912,1917,1918,1919,1921,1922,1923,1929,1932,1941,1944,1945,1946,1947,1948,1951,1953,1955,1956,1957,1958,1960,1961,1962,1963,1964,1965,1966,1968,1970,1971,1973,1974,1975,1976,1977,1978,1979,1980,1981,1983,1984,1990,1991,1992,1993,1994,null]	\N	49
9	2021-02-16 13:09:14.915505+00	2021-02-16 13:09:14.915505+00	["Administrated by the UN","Autonomous Area","Co-administrated","Commonwealth of the US","Constitutional Monarchy","Constitutional Monarchy (Emirate)","Constitutional Monarchy, Federation","Dependent Territory of Norway","Dependent Territory of the UK","Dependent Territory of the US","Emirate Federation","Federal Republic","Federation","Independent Church State","Islamic Emirate","Islamic Republic","Monarchy","Monarchy (Emirate)","Monarchy (Sultanate)","Nonmetropolitan Territory of France","Nonmetropolitan Territory of New Zealand","Nonmetropolitan Territory of The Netherlands","Occupied by Marocco","Overseas Department of France","Parlementary Monarchy","Parliamentary Coprincipality","Part of Denmark","People'sRepublic","Republic","Socialistic Republic","Socialistic State","Special Administrative Region of China","Territorial Collectivity of France","Territory of Australia","US Territory"]	\N	50
10	2021-02-16 13:09:14.957392+00	2021-02-16 13:09:14.957392+00	[false,true]	\N	60
\.


--
-- Data for Name: metabase_table; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.metabase_table (id, created_at, updated_at, name, description, entity_name, entity_type, active, db_id, display_name, visibility_type, schema, points_of_interest, caveats, show_in_getting_started, field_order) FROM stdin;
2	2021-02-16 13:06:41.618557+00	2021-02-16 13:06:45.785916+00	ORDERS	This is a confirmed order for a product from a user.	\N	entity/TransactionTable	t	1	Orders	\N	PUBLIC	\N	\N	f	database
3	2021-02-16 13:06:41.634979+00	2021-02-16 13:06:45.792567+00	PEOPLE	This is a user account. Note that employees and customer support staff will have accounts.	\N	entity/UserTable	t	1	People	\N	PUBLIC	\N	\N	f	database
1	2021-02-16 13:06:41.596436+00	2021-02-16 13:06:45.802675+00	PRODUCTS	This is our product catalog. It includes all products ever sold by the Sample Company.	\N	entity/ProductTable	t	1	Products	\N	PUBLIC	\N	\N	f	database
4	2021-02-16 13:06:41.649811+00	2021-02-16 13:06:45.81291+00	REVIEWS	These are reviews our customers have left on products. Note that these are not tied to orders so it is possible people have reviewed products they did not purchase from us.	\N	entity/GenericTable	t	1	Reviews	\N	PUBLIC	\N	\N	f	database
7	2021-02-16 13:09:13.565728+00	2021-02-16 13:09:14.713708+00	city	\N	\N	entity/GenericTable	t	2	City	\N	public	\N	\N	f	database
5	2021-02-16 13:09:13.533122+00	2021-02-16 13:09:14.72033+00	country	\N	\N	entity/GenericTable	t	2	Country	\N	public	\N	\N	f	database
6	2021-02-16 13:09:13.550774+00	2021-02-16 13:09:14.727389+00	countrylanguage	\N	\N	entity/GenericTable	t	2	Country Language	\N	public	\N	\N	f	database
\.


--
-- Data for Name: metric; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.metric (id, table_id, creator_id, name, description, archived, definition, created_at, updated_at, points_of_interest, caveats, how_is_this_calculated, show_in_getting_started) FROM stdin;
\.


--
-- Data for Name: metric_important_field; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.metric_important_field (id, metric_id, field_id) FROM stdin;
\.


--
-- Data for Name: native_query_snippet; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.native_query_snippet (id, name, description, content, creator_id, archived, created_at, updated_at, collection_id) FROM stdin;
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.permissions (id, object, group_id) FROM stdin;
1	/	2
2	/collection/root/	1
3	/collection/root/	3
4	/db/1/	1
5	/db/2/	1
\.


--
-- Data for Name: permissions_group; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.permissions_group (id, name) FROM stdin;
1	All Users
2	Administrators
3	MetaBot
\.


--
-- Data for Name: permissions_group_membership; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.permissions_group_membership (id, user_id, group_id) FROM stdin;
1	1	1
2	1	2
\.


--
-- Data for Name: permissions_revision; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.permissions_revision (id, before, after, user_id, created_at, remark) FROM stdin;
\.


--
-- Data for Name: pulse; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.pulse (id, creator_id, name, created_at, updated_at, skip_if_empty, alert_condition, alert_first_only, alert_above_goal, collection_id, collection_position, archived) FROM stdin;
\.


--
-- Data for Name: pulse_card; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.pulse_card (id, pulse_id, card_id, "position", include_csv, include_xls) FROM stdin;
\.


--
-- Data for Name: pulse_channel; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.pulse_channel (id, pulse_id, channel_type, details, schedule_type, schedule_hour, schedule_day, created_at, updated_at, schedule_frame, enabled) FROM stdin;
\.


--
-- Data for Name: pulse_channel_recipient; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.pulse_channel_recipient (id, pulse_channel_id, user_id) FROM stdin;
\.


--
-- Data for Name: qrtz_blob_triggers; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.qrtz_blob_triggers (sched_name, trigger_name, trigger_group, blob_data) FROM stdin;
\.


--
-- Data for Name: qrtz_calendars; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.qrtz_calendars (sched_name, calendar_name, calendar) FROM stdin;
\.


--
-- Data for Name: qrtz_cron_triggers; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.qrtz_cron_triggers (sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) FROM stdin;
MetabaseScheduler	metabase.task.upgrade-checks.trigger	DEFAULT	0 15 6,18 * * ? *	GMT
MetabaseScheduler	metabase.task.anonymous-stats.trigger	DEFAULT	0 15 7 * * ? *	GMT
MetabaseScheduler	metabase.task.abandonment-emails.trigger	DEFAULT	0 0 12 * * ? *	GMT
MetabaseScheduler	metabase.task.send-pulses.trigger	DEFAULT	0 0 * * * ? *	GMT
MetabaseScheduler	metabase.task.follow-up-emails.trigger	DEFAULT	0 0 12 * * ? *	GMT
MetabaseScheduler	metabase.task.task-history-cleanup.trigger	DEFAULT	0 0 * * * ? *	GMT
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.1	DEFAULT	0 50 * * * ? *	GMT
MetabaseScheduler	metabase.task.update-field-values.trigger.1	DEFAULT	0 50 0 * * ? *	GMT
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.2	DEFAULT	0 0 * * * ? *	GMT
MetabaseScheduler	metabase.task.update-field-values.trigger.2	DEFAULT	0 0 0 * * ? *	GMT
\.


--
-- Data for Name: qrtz_fired_triggers; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.qrtz_fired_triggers (sched_name, entry_id, trigger_name, trigger_group, instance_name, fired_time, sched_time, priority, state, job_name, job_group, is_nonconcurrent, requests_recovery) FROM stdin;
\.


--
-- Data for Name: qrtz_job_details; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.qrtz_job_details (sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) FROM stdin;
MetabaseScheduler	metabase.task.sync-and-analyze.job	DEFAULT	sync-and-analyze for all databases	metabase.task.sync_databases.SyncAndAnalyzeDatabase	t	t	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.update-field-values.job	DEFAULT	update-field-values for all databases	metabase.task.sync_databases.UpdateFieldValues	t	t	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.upgrade-checks.job	DEFAULT	\N	metabase.task.upgrade_checks.CheckForNewVersions	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.anonymous-stats.job	DEFAULT	\N	metabase.task.send_anonymous_stats.SendAnonymousUsageStats	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.abandonment-emails.job	DEFAULT	\N	metabase.task.follow_up_emails.AbandonmentEmail	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.send-pulses.job	DEFAULT	\N	metabase.task.send_pulses.SendPulses	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.follow-up-emails.job	DEFAULT	\N	metabase.task.follow_up_emails.FollowUpEmail	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.task-history-cleanup.job	DEFAULT	\N	metabase.task.task_history_cleanup.TaskHistoryCleanup	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
\.


--
-- Data for Name: qrtz_locks; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.qrtz_locks (sched_name, lock_name) FROM stdin;
MetabaseScheduler	STATE_ACCESS
MetabaseScheduler	TRIGGER_ACCESS
\.


--
-- Data for Name: qrtz_paused_trigger_grps; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.qrtz_paused_trigger_grps (sched_name, trigger_group) FROM stdin;
\.


--
-- Data for Name: qrtz_scheduler_state; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.qrtz_scheduler_state (sched_name, instance_name, last_checkin_time, checkin_interval) FROM stdin;
MetabaseScheduler	wu-System-Product-Name1613480800647	1613482270924	7500
\.


--
-- Data for Name: qrtz_simple_triggers; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.qrtz_simple_triggers (sched_name, trigger_name, trigger_group, repeat_count, repeat_interval, times_triggered) FROM stdin;
\.


--
-- Data for Name: qrtz_simprop_triggers; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.qrtz_simprop_triggers (sched_name, trigger_name, trigger_group, str_prop_1, str_prop_2, str_prop_3, int_prop_1, int_prop_2, long_prop_1, long_prop_2, dec_prop_1, dec_prop_2, bool_prop_1, bool_prop_2) FROM stdin;
\.


--
-- Data for Name: qrtz_triggers; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.qrtz_triggers (sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) FROM stdin;
MetabaseScheduler	metabase.task.upgrade-checks.trigger	DEFAULT	metabase.task.upgrade-checks.job	DEFAULT	\N	1613499300000	-1	5	WAITING	CRON	1613480800000	0	\N	0	\\x
MetabaseScheduler	metabase.task.anonymous-stats.trigger	DEFAULT	metabase.task.anonymous-stats.job	DEFAULT	\N	1613546100000	-1	5	WAITING	CRON	1613480800000	0	\N	0	\\x
MetabaseScheduler	metabase.task.abandonment-emails.trigger	DEFAULT	metabase.task.abandonment-emails.job	DEFAULT	\N	1613563200000	-1	5	WAITING	CRON	1613480800000	0	\N	0	\\x
MetabaseScheduler	metabase.task.send-pulses.trigger	DEFAULT	metabase.task.send-pulses.job	DEFAULT	\N	1613484000000	-1	5	WAITING	CRON	1613480800000	0	\N	1	\\x
MetabaseScheduler	metabase.task.follow-up-emails.trigger	DEFAULT	metabase.task.follow-up-emails.job	DEFAULT	\N	1613563200000	-1	5	WAITING	CRON	1613480800000	0	\N	0	\\x
MetabaseScheduler	metabase.task.task-history-cleanup.trigger	DEFAULT	metabase.task.task-history-cleanup.job	DEFAULT	\N	1613484000000	-1	5	WAITING	CRON	1613480800000	0	\N	0	\\x
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.1	DEFAULT	metabase.task.sync-and-analyze.job	DEFAULT	sync-and-analyze Database 1	1613483400000	-1	5	WAITING	CRON	1613480800000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000017800
MetabaseScheduler	metabase.task.update-field-values.trigger.1	DEFAULT	metabase.task.update-field-values.job	DEFAULT	update-field-values Database 1	1613523000000	-1	5	WAITING	CRON	1613480800000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000017800
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.2	DEFAULT	metabase.task.sync-and-analyze.job	DEFAULT	sync-and-analyze Database 2	1613484000000	-1	5	WAITING	CRON	1613480953000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000027800
MetabaseScheduler	metabase.task.update-field-values.trigger.2	DEFAULT	metabase.task.update-field-values.job	DEFAULT	update-field-values Database 2	1613520000000	-1	5	WAITING	CRON	1613480953000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000027800
\.


--
-- Data for Name: query; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.query (query_hash, average_execution_time, query) FROM stdin;
\\x8bdeffeaf809ef29bb93300a5fa0943feac0d441959f05eb9f29c594bb0dc349	42	{"type":"native","native":{"query":"SELECT * FROM city\\nLIMIT 10;","template-tags":{}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x103fe9e491bf5de3905337700fad9ae72e10c9f462e1b1b35534d4c9c2a57c5e	179	{"database":2,"query":{"source-table":7},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xf4428f898da794454ea493eeb33b7c90d5d7f7bf69a3f7c8576081951d3c11d7	31	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true},"native":{"query":"SELECT * FROM city\\nLIMIT 10;","template-tags":{}},"database":2,"async?":true,"cache-ttl":null}
\.


--
-- Data for Name: query_cache; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.query_cache (query_hash, updated_at, results) FROM stdin;
\.


--
-- Data for Name: query_execution; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.query_execution (id, hash, started_at, running_time, result_rows, native, context, error, executor_id, card_id, dashboard_id, pulse_id, database_id) FROM stdin;
1	\\x8bdeffeaf809ef29bb93300a5fa0943feac0d441959f05eb9f29c594bb0dc349	2021-02-16 13:13:13.107537+00	42	10	t	ad-hoc	\N	1	\N	\N	\N	2
2	\\xf4428f898da794454ea493eeb33b7c90d5d7f7bf69a3f7c8576081951d3c11d7	2021-02-16 13:13:49.763183+00	30	10	t	question	\N	1	1	\N	\N	2
3	\\xf4428f898da794454ea493eeb33b7c90d5d7f7bf69a3f7c8576081951d3c11d7	2021-02-16 13:14:19.948558+00	26	10	t	question	\N	1	1	\N	\N	2
4	\\x103fe9e491bf5de3905337700fad9ae72e10c9f462e1b1b35534d4c9c2a57c5e	2021-02-16 13:14:39.756073+00	179	2000	f	ad-hoc	\N	1	\N	\N	\N	2
5	\\xf4428f898da794454ea493eeb33b7c90d5d7f7bf69a3f7c8576081951d3c11d7	2021-02-16 13:15:31.69189+00	38	10	t	question	\N	1	1	\N	\N	2
\.


--
-- Data for Name: report_card; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.report_card (id, created_at, updated_at, name, description, display, dataset_query, visualization_settings, creator_id, database_id, table_id, query_type, archived, collection_id, public_uuid, made_public_by_id, enable_embedding, embedding_params, cache_ttl, result_metadata, collection_position) FROM stdin;
1	2021-02-16 13:13:45.218033+00	2021-02-16 13:15:31.706686+00	SELECT	\N	table	{"type":"native","native":{"query":"SELECT * FROM city\\nLIMIT 10;","template-tags":{}},"database":2}	{"table.pivot_column":"countrycode","table.cell_column":"id"}	1	2	\N	native	f	\N	\N	\N	f	\N	\N	[{"base_type":"type/Integer","display_name":"id","name":"id","special_type":"type/PK","fingerprint":null},{"base_type":"type/Text","display_name":"name","name":"name","special_type":"type/Name","fingerprint":{"global":{"distinct-count":10,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":7.7}}}},{"base_type":"type/Text","display_name":"countrycode","name":"countrycode","special_type":"type/Country","fingerprint":{"global":{"distinct-count":2,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":3.0}}}},{"base_type":"type/Text","display_name":"district","name":"district","special_type":null,"fingerprint":{"global":{"distinct-count":8,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":9.3}}}},{"base_type":"type/Integer","display_name":"population","name":"population","special_type":null,"fingerprint":{"global":{"distinct-count":10,"nil%":0.0},"type":{"type/Number":{"min":127800.0,"q1":193238.0,"q3":593321.0,"max":1780000.0,"sd":500634.7285752469,"avg":472692.5}}}}]	\N
\.


--
-- Data for Name: report_cardfavorite; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.report_cardfavorite (id, created_at, updated_at, card_id, owner_id) FROM stdin;
\.


--
-- Data for Name: report_dashboard; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.report_dashboard (id, created_at, updated_at, name, description, creator_id, parameters, points_of_interest, caveats, show_in_getting_started, public_uuid, made_public_by_id, enable_embedding, embedding_params, archived, "position", collection_id, collection_position) FROM stdin;
1	2021-02-16 13:12:04.534802+00	2021-02-16 13:15:56.222561+00	basic	\N	1	[]	\N	\N	f	\N	\N	f	\N	f	\N	\N	1
\.


--
-- Data for Name: report_dashboardcard; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.report_dashboardcard (id, created_at, updated_at, "sizeX", "sizeY", "row", col, card_id, dashboard_id, parameter_mappings, visualization_settings) FROM stdin;
1	2021-02-16 13:13:54.370038+00	2021-02-16 13:13:54.458904+00	4	4	0	0	1	1	[]	{}
\.


--
-- Data for Name: revision; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.revision (id, model, model_id, user_id, "timestamp", object, is_reversion, is_creation, message) FROM stdin;
1	Card	1	1	2021-02-16 13:13:45.26833+00	{"description":null,"archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"SELECT","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"native","native":{"query":"SELECT * FROM city\\nLIMIT 10;","template-tags":{}},"database":2},"id":1,"display":"table","visualization_settings":{"table.pivot_column":"countrycode","table.cell_column":"id"},"public_uuid":null}	f	t	\N
2	Dashboard	1	1	2021-02-16 13:13:54.420101+00	{"description":null,"name":"basic","cards":[{"sizeX":2,"sizeY":2,"row":0,"col":0,"id":1,"card_id":1,"series":[]}]}	f	f	\N
3	Dashboard	1	1	2021-02-16 13:13:54.485952+00	{"description":null,"name":"basic","cards":[{"sizeX":4,"sizeY":4,"row":0,"col":0,"id":1,"card_id":1,"series":[]}]}	f	f	\N
4	Dashboard	1	1	2021-02-16 13:13:54.519333+00	{"description":null,"name":"basic","cards":[{"sizeX":4,"sizeY":4,"row":0,"col":0,"id":1,"card_id":1,"series":[]}]}	f	f	\N
5	Dashboard	1	1	2021-02-16 13:14:12.147962+00	{"description":null,"name":"basic","cards":[{"sizeX":4,"sizeY":4,"row":0,"col":0,"id":1,"card_id":1,"series":[]}]}	f	f	\N
6	Dashboard	1	1	2021-02-16 13:15:56.24602+00	{"description":null,"name":"basic","cards":[{"sizeX":4,"sizeY":4,"row":0,"col":0,"id":1,"card_id":1,"series":[]}]}	f	f	\N
\.


--
-- Data for Name: segment; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.segment (id, table_id, creator_id, name, description, archived, definition, created_at, updated_at, points_of_interest, caveats, show_in_getting_started) FROM stdin;
\.


--
-- Data for Name: setting; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.setting (key, value) FROM stdin;
redirect-all-requests-to-https	false
site-url	http://localhost:3000
site-name	raywu
admin-email	wuhaohsiang1992@gmail.com
site-locale	en
anon-tracking-enabled	true
settings-last-updated	2021-02-16 13:09:13.249848+00
\.


--
-- Data for Name: task_history; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.task_history (id, task, db_id, started_at, ended_at, duration, task_details) FROM stdin;
1	sync	1	2021-02-16 13:06:41.098649	2021-02-16 13:06:42.817669	1719	\N
2	sync-timezone	1	2021-02-16 13:06:41.099402	2021-02-16 13:06:41.525786	426	{"timezone-id":"UTC"}
3	sync-tables	1	2021-02-16 13:06:41.526324	2021-02-16 13:06:41.664222	137	{"updated-tables":4,"total-tables":0}
4	sync-fields	1	2021-02-16 13:06:41.664345	2021-02-16 13:06:42.376677	712	{"total-fields":36,"updated-fields":36}
5	sync-fks	1	2021-02-16 13:06:42.376741	2021-02-16 13:06:42.442053	65	{"total-fks":3,"updated-fks":3,"total-failed":0}
6	sync-metabase-metadata	1	2021-02-16 13:06:42.442119	2021-02-16 13:06:42.81759	375	\N
7	analyze	1	2021-02-16 13:06:42.932331	2021-02-16 13:06:45.81764	2885	\N
8	fingerprint-fields	1	2021-02-16 13:06:42.93237	2021-02-16 13:06:45.527444	2595	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":32,"fingerprints-attempted":32}
9	classify-fields	1	2021-02-16 13:06:45.527554	2021-02-16 13:06:45.778234	250	{"fields-classified":32,"fields-failed":0}
10	classify-tables	1	2021-02-16 13:06:45.778328	2021-02-16 13:06:45.817561	39	{"total-tables":4,"tables-classified":4}
11	field values scanning	1	2021-02-16 13:06:45.919095	2021-02-16 13:06:46.553435	634	\N
12	update-field-values	1	2021-02-16 13:06:45.919152	2021-02-16 13:06:46.55335	634	{"errors":0,"created":5,"updated":0,"deleted":0}
13	sync	2	2021-02-16 13:09:13.456888	2021-02-16 13:09:14.014147	557	\N
14	sync-timezone	2	2021-02-16 13:09:13.456943	2021-02-16 13:09:13.499984	43	{"timezone-id":"UTC"}
15	sync-tables	2	2021-02-16 13:09:13.500061	2021-02-16 13:09:13.577319	77	{"updated-tables":3,"total-tables":0}
16	sync-fields	2	2021-02-16 13:09:13.577377	2021-02-16 13:09:13.925826	348	{"total-fields":24,"updated-fields":24}
17	sync-fks	2	2021-02-16 13:09:13.925933	2021-02-16 13:09:14.000388	74	{"total-fks":2,"updated-fks":2,"total-failed":0}
18	sync-metabase-metadata	2	2021-02-16 13:09:14.000475	2021-02-16 13:09:14.014104	13	\N
19	analyze	2	2021-02-16 13:09:14.072336	2021-02-16 13:09:14.734282	661	\N
20	fingerprint-fields	2	2021-02-16 13:09:14.072391	2021-02-16 13:09:14.611477	539	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":21,"fingerprints-attempted":21}
21	classify-fields	2	2021-02-16 13:09:14.611647	2021-02-16 13:09:14.709561	97	{"fields-classified":21,"fields-failed":0}
22	classify-tables	2	2021-02-16 13:09:14.709654	2021-02-16 13:09:14.734212	24	{"total-tables":3,"tables-classified":3}
23	field values scanning	2	2021-02-16 13:09:14.776548	2021-02-16 13:09:14.969269	192	\N
24	update-field-values	2	2021-02-16 13:09:14.776604	2021-02-16 13:09:14.969226	192	{"errors":0,"created":5,"updated":0,"deleted":0}
\.


--
-- Data for Name: view_log; Type: TABLE DATA; Schema: public; Owner: raywu
--

COPY public.view_log (id, user_id, model, model_id, "timestamp") FROM stdin;
1	1	dashboard	1	2021-02-16 13:12:04.667412+00
2	1	card	1	2021-02-16 13:13:45.251981+00
3	1	dashboard	1	2021-02-16 13:13:49.566824+00
4	1	card	1	2021-02-16 13:13:49.656115+00
5	1	dashboard	1	2021-02-16 13:13:54.545749+00
6	1	dashboard	1	2021-02-16 13:14:12.180402+00
7	1	card	1	2021-02-16 13:14:19.703157+00
8	1	card	1	2021-02-16 13:15:31.495149+00
\.


--
-- Name: activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.activity_id_seq', 5, true);


--
-- Name: card_label_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.card_label_id_seq', 1, false);


--
-- Name: collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.collection_id_seq', 1, true);


--
-- Name: collection_revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.collection_revision_id_seq', 1, false);


--
-- Name: computation_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.computation_job_id_seq', 1, false);


--
-- Name: computation_job_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.computation_job_result_id_seq', 1, false);


--
-- Name: core_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.core_user_id_seq', 1, true);


--
-- Name: dashboard_favorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.dashboard_favorite_id_seq', 1, false);


--
-- Name: dashboardcard_series_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.dashboardcard_series_id_seq', 1, false);


--
-- Name: dependency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.dependency_id_seq', 1, false);


--
-- Name: dimension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.dimension_id_seq', 1, false);


--
-- Name: group_table_access_policy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.group_table_access_policy_id_seq', 1, false);


--
-- Name: label_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.label_id_seq', 1, false);


--
-- Name: metabase_database_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.metabase_database_id_seq', 2, true);


--
-- Name: metabase_field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.metabase_field_id_seq', 60, true);


--
-- Name: metabase_fieldvalues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.metabase_fieldvalues_id_seq', 10, true);


--
-- Name: metabase_table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.metabase_table_id_seq', 7, true);


--
-- Name: metric_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.metric_id_seq', 1, false);


--
-- Name: metric_important_field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.metric_important_field_id_seq', 1, false);


--
-- Name: native_query_snippet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.native_query_snippet_id_seq', 1, false);


--
-- Name: permissions_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.permissions_group_id_seq', 3, true);


--
-- Name: permissions_group_membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.permissions_group_membership_id_seq', 2, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.permissions_id_seq', 5, true);


--
-- Name: permissions_revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.permissions_revision_id_seq', 1, false);


--
-- Name: pulse_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.pulse_card_id_seq', 1, false);


--
-- Name: pulse_channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.pulse_channel_id_seq', 1, false);


--
-- Name: pulse_channel_recipient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.pulse_channel_recipient_id_seq', 1, false);


--
-- Name: pulse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.pulse_id_seq', 1, false);


--
-- Name: query_execution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.query_execution_id_seq', 5, true);


--
-- Name: report_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.report_card_id_seq', 1, true);


--
-- Name: report_cardfavorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.report_cardfavorite_id_seq', 1, false);


--
-- Name: report_dashboard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.report_dashboard_id_seq', 1, true);


--
-- Name: report_dashboardcard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.report_dashboardcard_id_seq', 1, true);


--
-- Name: revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.revision_id_seq', 6, true);


--
-- Name: segment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.segment_id_seq', 1, false);


--
-- Name: task_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.task_history_id_seq', 24, true);


--
-- Name: view_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: raywu
--

SELECT pg_catalog.setval('public.view_log_id_seq', 8, true);


--
-- Name: activity activity_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT activity_pkey PRIMARY KEY (id);


--
-- Name: card_label card_label_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT card_label_pkey PRIMARY KEY (id);


--
-- Name: collection collection_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (id);


--
-- Name: collection_revision collection_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.collection_revision
    ADD CONSTRAINT collection_revision_pkey PRIMARY KEY (id);


--
-- Name: computation_job computation_job_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.computation_job
    ADD CONSTRAINT computation_job_pkey PRIMARY KEY (id);


--
-- Name: computation_job_result computation_job_result_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.computation_job_result
    ADD CONSTRAINT computation_job_result_pkey PRIMARY KEY (id);


--
-- Name: core_session core_session_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.core_session
    ADD CONSTRAINT core_session_pkey PRIMARY KEY (id);


--
-- Name: core_user core_user_email_key; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.core_user
    ADD CONSTRAINT core_user_email_key UNIQUE (email);


--
-- Name: core_user core_user_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.core_user
    ADD CONSTRAINT core_user_pkey PRIMARY KEY (id);


--
-- Name: dashboard_favorite dashboard_favorite_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT dashboard_favorite_pkey PRIMARY KEY (id);


--
-- Name: dashboardcard_series dashboardcard_series_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dashboardcard_series
    ADD CONSTRAINT dashboardcard_series_pkey PRIMARY KEY (id);


--
-- Name: data_migrations data_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.data_migrations
    ADD CONSTRAINT data_migrations_pkey PRIMARY KEY (id);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: dependency dependency_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dependency
    ADD CONSTRAINT dependency_pkey PRIMARY KEY (id);


--
-- Name: dimension dimension_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT dimension_pkey PRIMARY KEY (id);


--
-- Name: group_table_access_policy group_table_access_policy_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.group_table_access_policy
    ADD CONSTRAINT group_table_access_policy_pkey PRIMARY KEY (id);


--
-- Name: databasechangelog idx_databasechangelog_id_author_filename; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.databasechangelog
    ADD CONSTRAINT idx_databasechangelog_id_author_filename UNIQUE (id, author, filename);


--
-- Name: metabase_field idx_uniq_field_table_id_parent_id_name; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT idx_uniq_field_table_id_parent_id_name UNIQUE (table_id, parent_id, name);


--
-- Name: metabase_table idx_uniq_table_db_id_schema_name; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_table
    ADD CONSTRAINT idx_uniq_table_db_id_schema_name UNIQUE (db_id, schema, name);


--
-- Name: report_cardfavorite idx_unique_cardfavorite_card_id_owner_id; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT idx_unique_cardfavorite_card_id_owner_id UNIQUE (card_id, owner_id);


--
-- Name: label label_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.label
    ADD CONSTRAINT label_pkey PRIMARY KEY (id);


--
-- Name: label label_slug_key; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.label
    ADD CONSTRAINT label_slug_key UNIQUE (slug);


--
-- Name: metabase_database metabase_database_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_database
    ADD CONSTRAINT metabase_database_pkey PRIMARY KEY (id);


--
-- Name: metabase_field metabase_field_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT metabase_field_pkey PRIMARY KEY (id);


--
-- Name: metabase_fieldvalues metabase_fieldvalues_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_fieldvalues
    ADD CONSTRAINT metabase_fieldvalues_pkey PRIMARY KEY (id);


--
-- Name: metabase_table metabase_table_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_table
    ADD CONSTRAINT metabase_table_pkey PRIMARY KEY (id);


--
-- Name: metric_important_field metric_important_field_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT metric_important_field_pkey PRIMARY KEY (id);


--
-- Name: metric metric_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metric
    ADD CONSTRAINT metric_pkey PRIMARY KEY (id);


--
-- Name: native_query_snippet native_query_snippet_name_key; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.native_query_snippet
    ADD CONSTRAINT native_query_snippet_name_key UNIQUE (name);


--
-- Name: native_query_snippet native_query_snippet_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.native_query_snippet
    ADD CONSTRAINT native_query_snippet_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_group_id_object_key; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_group_id_object_key UNIQUE (group_id, object);


--
-- Name: permissions_group_membership permissions_group_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT permissions_group_membership_pkey PRIMARY KEY (id);


--
-- Name: permissions_group permissions_group_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions_group
    ADD CONSTRAINT permissions_group_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: permissions_revision permissions_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions_revision
    ADD CONSTRAINT permissions_revision_pkey PRIMARY KEY (id);


--
-- Name: qrtz_blob_triggers pk_qrtz_blob_triggers; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_blob_triggers
    ADD CONSTRAINT pk_qrtz_blob_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_calendars pk_qrtz_calendars; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_calendars
    ADD CONSTRAINT pk_qrtz_calendars PRIMARY KEY (sched_name, calendar_name);


--
-- Name: qrtz_cron_triggers pk_qrtz_cron_triggers; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_cron_triggers
    ADD CONSTRAINT pk_qrtz_cron_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_fired_triggers pk_qrtz_fired_triggers; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_fired_triggers
    ADD CONSTRAINT pk_qrtz_fired_triggers PRIMARY KEY (sched_name, entry_id);


--
-- Name: qrtz_job_details pk_qrtz_job_details; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_job_details
    ADD CONSTRAINT pk_qrtz_job_details PRIMARY KEY (sched_name, job_name, job_group);


--
-- Name: qrtz_locks pk_qrtz_locks; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_locks
    ADD CONSTRAINT pk_qrtz_locks PRIMARY KEY (sched_name, lock_name);


--
-- Name: qrtz_scheduler_state pk_qrtz_scheduler_state; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_scheduler_state
    ADD CONSTRAINT pk_qrtz_scheduler_state PRIMARY KEY (sched_name, instance_name);


--
-- Name: qrtz_simple_triggers pk_qrtz_simple_triggers; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_simple_triggers
    ADD CONSTRAINT pk_qrtz_simple_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simprop_triggers pk_qrtz_simprop_triggers; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_simprop_triggers
    ADD CONSTRAINT pk_qrtz_simprop_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_triggers pk_qrtz_triggers; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_triggers
    ADD CONSTRAINT pk_qrtz_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_paused_trigger_grps pk_sched_name; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_paused_trigger_grps
    ADD CONSTRAINT pk_sched_name PRIMARY KEY (sched_name, trigger_group);


--
-- Name: pulse_card pulse_card_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT pulse_card_pkey PRIMARY KEY (id);


--
-- Name: pulse_channel pulse_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse_channel
    ADD CONSTRAINT pulse_channel_pkey PRIMARY KEY (id);


--
-- Name: pulse_channel_recipient pulse_channel_recipient_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse_channel_recipient
    ADD CONSTRAINT pulse_channel_recipient_pkey PRIMARY KEY (id);


--
-- Name: pulse pulse_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT pulse_pkey PRIMARY KEY (id);


--
-- Name: query_cache query_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.query_cache
    ADD CONSTRAINT query_cache_pkey PRIMARY KEY (query_hash);


--
-- Name: query_execution query_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.query_execution
    ADD CONSTRAINT query_execution_pkey PRIMARY KEY (id);


--
-- Name: query query_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.query
    ADD CONSTRAINT query_pkey PRIMARY KEY (query_hash);


--
-- Name: report_card report_card_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT report_card_pkey PRIMARY KEY (id);


--
-- Name: report_card report_card_public_uuid_key; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT report_card_public_uuid_key UNIQUE (public_uuid);


--
-- Name: report_cardfavorite report_cardfavorite_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT report_cardfavorite_pkey PRIMARY KEY (id);


--
-- Name: report_dashboard report_dashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT report_dashboard_pkey PRIMARY KEY (id);


--
-- Name: report_dashboard report_dashboard_public_uuid_key; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT report_dashboard_public_uuid_key UNIQUE (public_uuid);


--
-- Name: report_dashboardcard report_dashboardcard_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_dashboardcard
    ADD CONSTRAINT report_dashboardcard_pkey PRIMARY KEY (id);


--
-- Name: revision revision_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.revision
    ADD CONSTRAINT revision_pkey PRIMARY KEY (id);


--
-- Name: segment segment_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT segment_pkey PRIMARY KEY (id);


--
-- Name: setting setting_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.setting
    ADD CONSTRAINT setting_pkey PRIMARY KEY (key);


--
-- Name: task_history task_history_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_pkey PRIMARY KEY (id);


--
-- Name: card_label unique_card_label_card_id_label_id; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT unique_card_label_card_id_label_id UNIQUE (card_id, label_id);


--
-- Name: collection unique_collection_personal_owner_id; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT unique_collection_personal_owner_id UNIQUE (personal_owner_id);


--
-- Name: dashboard_favorite unique_dashboard_favorite_user_id_dashboard_id; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT unique_dashboard_favorite_user_id_dashboard_id UNIQUE (user_id, dashboard_id);


--
-- Name: dimension unique_dimension_field_id_name; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT unique_dimension_field_id_name UNIQUE (field_id, name);


--
-- Name: group_table_access_policy unique_gtap_table_id_group_id; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.group_table_access_policy
    ADD CONSTRAINT unique_gtap_table_id_group_id UNIQUE (table_id, group_id);


--
-- Name: metric_important_field unique_metric_important_field_metric_id_field_id; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT unique_metric_important_field_metric_id_field_id UNIQUE (metric_id, field_id);


--
-- Name: permissions_group_membership unique_permissions_group_membership_user_id_group_id; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT unique_permissions_group_membership_user_id_group_id UNIQUE (user_id, group_id);


--
-- Name: permissions_group unique_permissions_group_name; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions_group
    ADD CONSTRAINT unique_permissions_group_name UNIQUE (name);


--
-- Name: view_log view_log_pkey; Type: CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.view_log
    ADD CONSTRAINT view_log_pkey PRIMARY KEY (id);


--
-- Name: idx_activity_custom_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_activity_custom_id ON public.activity USING btree (custom_id);


--
-- Name: idx_activity_timestamp; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_activity_timestamp ON public.activity USING btree ("timestamp");


--
-- Name: idx_activity_user_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_activity_user_id ON public.activity USING btree (user_id);


--
-- Name: idx_card_collection_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_card_collection_id ON public.report_card USING btree (collection_id);


--
-- Name: idx_card_creator_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_card_creator_id ON public.report_card USING btree (creator_id);


--
-- Name: idx_card_label_card_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_card_label_card_id ON public.card_label USING btree (card_id);


--
-- Name: idx_card_label_label_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_card_label_label_id ON public.card_label USING btree (label_id);


--
-- Name: idx_card_public_uuid; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_card_public_uuid ON public.report_card USING btree (public_uuid);


--
-- Name: idx_cardfavorite_card_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_cardfavorite_card_id ON public.report_cardfavorite USING btree (card_id);


--
-- Name: idx_cardfavorite_owner_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_cardfavorite_owner_id ON public.report_cardfavorite USING btree (owner_id);


--
-- Name: idx_collection_location; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_collection_location ON public.collection USING btree (location);


--
-- Name: idx_collection_personal_owner_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_collection_personal_owner_id ON public.collection USING btree (personal_owner_id);


--
-- Name: idx_dashboard_collection_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dashboard_collection_id ON public.report_dashboard USING btree (collection_id);


--
-- Name: idx_dashboard_creator_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dashboard_creator_id ON public.report_dashboard USING btree (creator_id);


--
-- Name: idx_dashboard_favorite_dashboard_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dashboard_favorite_dashboard_id ON public.dashboard_favorite USING btree (dashboard_id);


--
-- Name: idx_dashboard_favorite_user_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dashboard_favorite_user_id ON public.dashboard_favorite USING btree (user_id);


--
-- Name: idx_dashboard_public_uuid; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dashboard_public_uuid ON public.report_dashboard USING btree (public_uuid);


--
-- Name: idx_dashboardcard_card_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dashboardcard_card_id ON public.report_dashboardcard USING btree (card_id);


--
-- Name: idx_dashboardcard_dashboard_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dashboardcard_dashboard_id ON public.report_dashboardcard USING btree (dashboard_id);


--
-- Name: idx_dashboardcard_series_card_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dashboardcard_series_card_id ON public.dashboardcard_series USING btree (card_id);


--
-- Name: idx_dashboardcard_series_dashboardcard_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dashboardcard_series_dashboardcard_id ON public.dashboardcard_series USING btree (dashboardcard_id);


--
-- Name: idx_data_migrations_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_data_migrations_id ON public.data_migrations USING btree (id);


--
-- Name: idx_dependency_dependent_on_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dependency_dependent_on_id ON public.dependency USING btree (dependent_on_id);


--
-- Name: idx_dependency_dependent_on_model; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dependency_dependent_on_model ON public.dependency USING btree (dependent_on_model);


--
-- Name: idx_dependency_model; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dependency_model ON public.dependency USING btree (model);


--
-- Name: idx_dependency_model_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dependency_model_id ON public.dependency USING btree (model_id);


--
-- Name: idx_dimension_field_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_dimension_field_id ON public.dimension USING btree (field_id);


--
-- Name: idx_field_parent_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_field_parent_id ON public.metabase_field USING btree (parent_id);


--
-- Name: idx_field_table_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_field_table_id ON public.metabase_field USING btree (table_id);


--
-- Name: idx_fieldvalues_field_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_fieldvalues_field_id ON public.metabase_fieldvalues USING btree (field_id);


--
-- Name: idx_gtap_table_id_group_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_gtap_table_id_group_id ON public.group_table_access_policy USING btree (table_id, group_id);


--
-- Name: idx_label_slug; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_label_slug ON public.label USING btree (slug);


--
-- Name: idx_lower_email; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_lower_email ON public.core_user USING btree (lower((email)::text));


--
-- Name: idx_metabase_table_db_id_schema; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_metabase_table_db_id_schema ON public.metabase_table USING btree (db_id, schema);


--
-- Name: idx_metabase_table_show_in_getting_started; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_metabase_table_show_in_getting_started ON public.metabase_table USING btree (show_in_getting_started);


--
-- Name: idx_metric_creator_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_metric_creator_id ON public.metric USING btree (creator_id);


--
-- Name: idx_metric_important_field_field_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_metric_important_field_field_id ON public.metric_important_field USING btree (field_id);


--
-- Name: idx_metric_important_field_metric_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_metric_important_field_metric_id ON public.metric_important_field USING btree (metric_id);


--
-- Name: idx_metric_show_in_getting_started; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_metric_show_in_getting_started ON public.metric USING btree (show_in_getting_started);


--
-- Name: idx_metric_table_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_metric_table_id ON public.metric USING btree (table_id);


--
-- Name: idx_permissions_group_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_permissions_group_id ON public.permissions USING btree (group_id);


--
-- Name: idx_permissions_group_id_object; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_permissions_group_id_object ON public.permissions USING btree (group_id, object);


--
-- Name: idx_permissions_group_membership_group_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_permissions_group_membership_group_id ON public.permissions_group_membership USING btree (group_id);


--
-- Name: idx_permissions_group_membership_group_id_user_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_permissions_group_membership_group_id_user_id ON public.permissions_group_membership USING btree (group_id, user_id);


--
-- Name: idx_permissions_group_membership_user_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_permissions_group_membership_user_id ON public.permissions_group_membership USING btree (user_id);


--
-- Name: idx_permissions_group_name; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_permissions_group_name ON public.permissions_group USING btree (name);


--
-- Name: idx_permissions_object; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_permissions_object ON public.permissions USING btree (object);


--
-- Name: idx_pulse_card_card_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_pulse_card_card_id ON public.pulse_card USING btree (card_id);


--
-- Name: idx_pulse_card_pulse_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_pulse_card_pulse_id ON public.pulse_card USING btree (pulse_id);


--
-- Name: idx_pulse_channel_pulse_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_pulse_channel_pulse_id ON public.pulse_channel USING btree (pulse_id);


--
-- Name: idx_pulse_channel_schedule_type; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_pulse_channel_schedule_type ON public.pulse_channel USING btree (schedule_type);


--
-- Name: idx_pulse_collection_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_pulse_collection_id ON public.pulse USING btree (collection_id);


--
-- Name: idx_pulse_creator_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_pulse_creator_id ON public.pulse USING btree (creator_id);


--
-- Name: idx_qrtz_ft_inst_job_req_rcvry; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_ft_inst_job_req_rcvry ON public.qrtz_fired_triggers USING btree (sched_name, instance_name, requests_recovery);


--
-- Name: idx_qrtz_ft_j_g; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_ft_j_g ON public.qrtz_fired_triggers USING btree (sched_name, job_name, job_group);


--
-- Name: idx_qrtz_ft_jg; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_ft_jg ON public.qrtz_fired_triggers USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_ft_t_g; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_ft_t_g ON public.qrtz_fired_triggers USING btree (sched_name, trigger_name, trigger_group);


--
-- Name: idx_qrtz_ft_tg; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_ft_tg ON public.qrtz_fired_triggers USING btree (sched_name, trigger_group);


--
-- Name: idx_qrtz_ft_trig_inst_name; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_ft_trig_inst_name ON public.qrtz_fired_triggers USING btree (sched_name, instance_name);


--
-- Name: idx_qrtz_j_grp; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_j_grp ON public.qrtz_job_details USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_j_req_recovery; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_j_req_recovery ON public.qrtz_job_details USING btree (sched_name, requests_recovery);


--
-- Name: idx_qrtz_t_c; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_t_c ON public.qrtz_triggers USING btree (sched_name, calendar_name);


--
-- Name: idx_qrtz_t_g; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_t_g ON public.qrtz_triggers USING btree (sched_name, trigger_group);


--
-- Name: idx_qrtz_t_j; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_t_j ON public.qrtz_triggers USING btree (sched_name, job_name, job_group);


--
-- Name: idx_qrtz_t_jg; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_t_jg ON public.qrtz_triggers USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_t_n_g_state; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_t_n_g_state ON public.qrtz_triggers USING btree (sched_name, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_n_state; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_t_n_state ON public.qrtz_triggers USING btree (sched_name, trigger_name, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_next_fire_time; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_t_next_fire_time ON public.qrtz_triggers USING btree (sched_name, next_fire_time);


--
-- Name: idx_qrtz_t_nft_misfire; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_t_nft_misfire ON public.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time);


--
-- Name: idx_qrtz_t_nft_st; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_t_nft_st ON public.qrtz_triggers USING btree (sched_name, trigger_state, next_fire_time);


--
-- Name: idx_qrtz_t_nft_st_misfire; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_t_nft_st_misfire ON public.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_state);


--
-- Name: idx_qrtz_t_nft_st_misfire_grp; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_t_nft_st_misfire_grp ON public.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_state; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_qrtz_t_state ON public.qrtz_triggers USING btree (sched_name, trigger_state);


--
-- Name: idx_query_cache_updated_at; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_query_cache_updated_at ON public.query_cache USING btree (updated_at);


--
-- Name: idx_query_execution_query_hash_started_at; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_query_execution_query_hash_started_at ON public.query_execution USING btree (hash, started_at);


--
-- Name: idx_query_execution_started_at; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_query_execution_started_at ON public.query_execution USING btree (started_at);


--
-- Name: idx_report_dashboard_show_in_getting_started; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_report_dashboard_show_in_getting_started ON public.report_dashboard USING btree (show_in_getting_started);


--
-- Name: idx_revision_model_model_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_revision_model_model_id ON public.revision USING btree (model, model_id);


--
-- Name: idx_segment_creator_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_segment_creator_id ON public.segment USING btree (creator_id);


--
-- Name: idx_segment_show_in_getting_started; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_segment_show_in_getting_started ON public.segment USING btree (show_in_getting_started);


--
-- Name: idx_segment_table_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_segment_table_id ON public.segment USING btree (table_id);


--
-- Name: idx_snippet_collection_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_snippet_collection_id ON public.native_query_snippet USING btree (collection_id);


--
-- Name: idx_snippet_name; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_snippet_name ON public.native_query_snippet USING btree (name);


--
-- Name: idx_table_db_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_table_db_id ON public.metabase_table USING btree (db_id);


--
-- Name: idx_task_history_db_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_task_history_db_id ON public.task_history USING btree (db_id);


--
-- Name: idx_task_history_end_time; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_task_history_end_time ON public.task_history USING btree (ended_at);


--
-- Name: idx_uniq_field_table_id_parent_id_name_2col; Type: INDEX; Schema: public; Owner: raywu
--

CREATE UNIQUE INDEX idx_uniq_field_table_id_parent_id_name_2col ON public.metabase_field USING btree (table_id, name) WHERE (parent_id IS NULL);


--
-- Name: idx_uniq_table_db_id_schema_name_2col; Type: INDEX; Schema: public; Owner: raywu
--

CREATE UNIQUE INDEX idx_uniq_table_db_id_schema_name_2col ON public.metabase_table USING btree (db_id, name) WHERE (schema IS NULL);


--
-- Name: idx_view_log_timestamp; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_view_log_timestamp ON public.view_log USING btree (model_id);


--
-- Name: idx_view_log_user_id; Type: INDEX; Schema: public; Owner: raywu
--

CREATE INDEX idx_view_log_user_id ON public.view_log USING btree (user_id);


--
-- Name: activity fk_activity_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT fk_activity_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_card fk_card_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_card_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id) ON DELETE SET NULL;


--
-- Name: card_label fk_card_label_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT fk_card_label_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id) ON DELETE CASCADE;


--
-- Name: card_label fk_card_label_ref_label_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT fk_card_label_ref_label_id FOREIGN KEY (label_id) REFERENCES public.label(id) ON DELETE CASCADE;


--
-- Name: report_card fk_card_made_public_by_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_card_made_public_by_id FOREIGN KEY (made_public_by_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_card fk_card_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_card_ref_user_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_cardfavorite fk_cardfavorite_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT fk_cardfavorite_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id) ON DELETE CASCADE;


--
-- Name: report_cardfavorite fk_cardfavorite_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT fk_cardfavorite_ref_user_id FOREIGN KEY (owner_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: collection fk_collection_personal_owner_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT fk_collection_personal_owner_id FOREIGN KEY (personal_owner_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: collection_revision fk_collection_revision_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.collection_revision
    ADD CONSTRAINT fk_collection_revision_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: computation_job fk_computation_job_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.computation_job
    ADD CONSTRAINT fk_computation_job_ref_user_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: computation_job_result fk_computation_result_ref_job_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.computation_job_result
    ADD CONSTRAINT fk_computation_result_ref_job_id FOREIGN KEY (job_id) REFERENCES public.computation_job(id) ON DELETE CASCADE;


--
-- Name: report_dashboard fk_dashboard_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT fk_dashboard_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id) ON DELETE SET NULL;


--
-- Name: dashboard_favorite fk_dashboard_favorite_dashboard_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT fk_dashboard_favorite_dashboard_id FOREIGN KEY (dashboard_id) REFERENCES public.report_dashboard(id) ON DELETE CASCADE;


--
-- Name: dashboard_favorite fk_dashboard_favorite_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT fk_dashboard_favorite_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_dashboard fk_dashboard_made_public_by_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT fk_dashboard_made_public_by_id FOREIGN KEY (made_public_by_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_dashboard fk_dashboard_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT fk_dashboard_ref_user_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_dashboardcard fk_dashboardcard_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_dashboardcard
    ADD CONSTRAINT fk_dashboardcard_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id) ON DELETE CASCADE;


--
-- Name: report_dashboardcard fk_dashboardcard_ref_dashboard_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_dashboardcard
    ADD CONSTRAINT fk_dashboardcard_ref_dashboard_id FOREIGN KEY (dashboard_id) REFERENCES public.report_dashboard(id) ON DELETE CASCADE;


--
-- Name: dashboardcard_series fk_dashboardcard_series_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dashboardcard_series
    ADD CONSTRAINT fk_dashboardcard_series_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id) ON DELETE CASCADE;


--
-- Name: dashboardcard_series fk_dashboardcard_series_ref_dashboardcard_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dashboardcard_series
    ADD CONSTRAINT fk_dashboardcard_series_ref_dashboardcard_id FOREIGN KEY (dashboardcard_id) REFERENCES public.report_dashboardcard(id) ON DELETE CASCADE;


--
-- Name: dimension fk_dimension_displayfk_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT fk_dimension_displayfk_ref_field_id FOREIGN KEY (human_readable_field_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: dimension fk_dimension_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT fk_dimension_ref_field_id FOREIGN KEY (field_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: metabase_field fk_field_parent_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT fk_field_parent_ref_field_id FOREIGN KEY (parent_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: metabase_field fk_field_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT fk_field_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id) ON DELETE CASCADE;


--
-- Name: metabase_fieldvalues fk_fieldvalues_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_fieldvalues
    ADD CONSTRAINT fk_fieldvalues_ref_field_id FOREIGN KEY (field_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: group_table_access_policy fk_gtap_card_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.group_table_access_policy
    ADD CONSTRAINT fk_gtap_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id) ON DELETE CASCADE;


--
-- Name: group_table_access_policy fk_gtap_group_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.group_table_access_policy
    ADD CONSTRAINT fk_gtap_group_id FOREIGN KEY (group_id) REFERENCES public.permissions_group(id) ON DELETE CASCADE;


--
-- Name: group_table_access_policy fk_gtap_table_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.group_table_access_policy
    ADD CONSTRAINT fk_gtap_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id) ON DELETE CASCADE;


--
-- Name: metric_important_field fk_metric_important_field_metabase_field_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT fk_metric_important_field_metabase_field_id FOREIGN KEY (field_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: metric_important_field fk_metric_important_field_metric_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT fk_metric_important_field_metric_id FOREIGN KEY (metric_id) REFERENCES public.metric(id) ON DELETE CASCADE;


--
-- Name: metric fk_metric_ref_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metric
    ADD CONSTRAINT fk_metric_ref_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: metric fk_metric_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metric
    ADD CONSTRAINT fk_metric_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id) ON DELETE CASCADE;


--
-- Name: permissions_group_membership fk_permissions_group_group_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT fk_permissions_group_group_id FOREIGN KEY (group_id) REFERENCES public.permissions_group(id) ON DELETE CASCADE;


--
-- Name: permissions fk_permissions_group_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT fk_permissions_group_id FOREIGN KEY (group_id) REFERENCES public.permissions_group(id) ON DELETE CASCADE;


--
-- Name: permissions_group_membership fk_permissions_group_membership_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT fk_permissions_group_membership_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: permissions_revision fk_permissions_revision_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.permissions_revision
    ADD CONSTRAINT fk_permissions_revision_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: pulse_card fk_pulse_card_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT fk_pulse_card_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id) ON DELETE CASCADE;


--
-- Name: pulse_card fk_pulse_card_ref_pulse_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT fk_pulse_card_ref_pulse_id FOREIGN KEY (pulse_id) REFERENCES public.pulse(id) ON DELETE CASCADE;


--
-- Name: pulse_channel_recipient fk_pulse_channel_recipient_ref_pulse_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse_channel_recipient
    ADD CONSTRAINT fk_pulse_channel_recipient_ref_pulse_channel_id FOREIGN KEY (pulse_channel_id) REFERENCES public.pulse_channel(id) ON DELETE CASCADE;


--
-- Name: pulse_channel_recipient fk_pulse_channel_recipient_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse_channel_recipient
    ADD CONSTRAINT fk_pulse_channel_recipient_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: pulse_channel fk_pulse_channel_ref_pulse_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse_channel
    ADD CONSTRAINT fk_pulse_channel_ref_pulse_id FOREIGN KEY (pulse_id) REFERENCES public.pulse(id) ON DELETE CASCADE;


--
-- Name: pulse fk_pulse_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT fk_pulse_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id) ON DELETE SET NULL;


--
-- Name: pulse fk_pulse_ref_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT fk_pulse_ref_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: qrtz_blob_triggers fk_qrtz_blob_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_blob_triggers
    ADD CONSTRAINT fk_qrtz_blob_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_cron_triggers fk_qrtz_cron_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_cron_triggers
    ADD CONSTRAINT fk_qrtz_cron_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simple_triggers fk_qrtz_simple_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_simple_triggers
    ADD CONSTRAINT fk_qrtz_simple_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simprop_triggers fk_qrtz_simprop_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_simprop_triggers
    ADD CONSTRAINT fk_qrtz_simprop_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_triggers fk_qrtz_triggers_job_details; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.qrtz_triggers
    ADD CONSTRAINT fk_qrtz_triggers_job_details FOREIGN KEY (sched_name, job_name, job_group) REFERENCES public.qrtz_job_details(sched_name, job_name, job_group);


--
-- Name: report_card fk_report_card_ref_database_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_report_card_ref_database_id FOREIGN KEY (database_id) REFERENCES public.metabase_database(id) ON DELETE CASCADE;


--
-- Name: report_card fk_report_card_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_report_card_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id) ON DELETE CASCADE;


--
-- Name: revision fk_revision_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.revision
    ADD CONSTRAINT fk_revision_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: segment fk_segment_ref_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT fk_segment_ref_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: segment fk_segment_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT fk_segment_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id) ON DELETE CASCADE;


--
-- Name: core_session fk_session_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.core_session
    ADD CONSTRAINT fk_session_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: native_query_snippet fk_snippet_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.native_query_snippet
    ADD CONSTRAINT fk_snippet_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id) ON DELETE SET NULL;


--
-- Name: native_query_snippet fk_snippet_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.native_query_snippet
    ADD CONSTRAINT fk_snippet_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: metabase_table fk_table_ref_database_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.metabase_table
    ADD CONSTRAINT fk_table_ref_database_id FOREIGN KEY (db_id) REFERENCES public.metabase_database(id) ON DELETE CASCADE;


--
-- Name: view_log fk_view_log_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: raywu
--

ALTER TABLE ONLY public.view_log
    ADD CONSTRAINT fk_view_log_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

