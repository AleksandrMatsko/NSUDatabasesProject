--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg22.04+1)
-- Dumped by pg_dump version 15.2

-- Started on 2023-04-13 18:05:40

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
-- TOC entry 267 (class 1255 OID 30548)
-- Name: is_book_example_already_issued(); Type: FUNCTION; Schema: public; Owner: amatsko20205
--

CREATE FUNCTION public.is_book_example_already_issued() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		date_issue DATE;
		
	BEGIN
		SELECT IJ.date_issue INTO date_issue
			FROM "public.IssueJournal" IJ
			WHERE IJ.stored_id = NEW.stored_id AND IJ.date_return IS NULL;
		IF date_issue IS NOT NULL THEN
			RAISE EXCEPTION 'cannot issue book with stored_id %, it has already been issued', NEW.stored_id;
		END IF;
		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.is_book_example_already_issued() OWNER TO amatsko20205;

--
-- TOC entry 269 (class 1255 OID 30543)
-- Name: is_book_example_dispose(); Type: FUNCTION; Schema: public; Owner: amatsko20205
--

CREATE FUNCTION public.is_book_example_dispose() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		date_receipt DATE;
		date_dispose DATE;
		
	BEGIN
		SELECT SI.date_receipt, SI.date_dispose INTO date_receipt, date_dispose 
			FROM "public.StorageInfo" SI
			WHERE SI.stored_id = NEW.stored_id;
		IF NEW.date_issue < date_receipt THEN
			RAISE EXCEPTION 'book with id % had not been receipt', NEW.stored_id;
		END IF;
		IF NOT(is_dates_from_range(date_receipt, date_dispose, NEW.date_issue, NEW.date_return)) THEN
			RAISE EXCEPTION 'cannot issue / accept book with stored_id %, it is disposed', NEW.stored_id;
		END IF;
		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.is_book_example_dispose() OWNER TO amatsko20205;

--
-- TOC entry 249 (class 1255 OID 30546)
-- Name: is_book_example_issued(); Type: FUNCTION; Schema: public; Owner: amatsko20205
--

CREATE FUNCTION public.is_book_example_issued() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		date_issue DATE;
		
	BEGIN
		SELECT IJ.date_issue INTO date_issue
			FROM "public.IssueJournal" IJ
			WHERE IJ.stored_id = NEW.stored_id AND IJ.date_return IS NULL;
		IF date_issue IS NOT NULL THEN
			RAISE EXCEPTION 'cannot dispose book with stored_id %, it is issued', NEW.stored_id;
		END IF;
		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.is_book_example_issued() OWNER TO amatsko20205;

--
-- TOC entry 264 (class 1255 OID 30538)
-- Name: is_dates_from_range(date, date, date, date); Type: FUNCTION; Schema: public; Owner: amatsko20205
--

CREATE FUNCTION public.is_dates_from_range(start_date_range date, end_date_range date, start_date date, end_date date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF start_date_range IS NULL OR start_date IS NULL THEN
			RAISE EXCEPTION 'start_date_range or start_date is NULL';
		END IF;
		
		IF end_date_range IS NOT NULL AND end_date_range < start_date_range THEN
			RAISE EXCEPTION 'start_date_range higher then end_date_range';
		END IF;
		
		IF end_date IS NOT NULL AND end_date < start_date THEN
				RAISE EXCEPTION 'start_date higher then end_date';
		END IF;
		
		IF end_date_range IS NULL THEN
			RETURN start_date_range <= start_date;
		ELSE
			IF end_date IS NULL THEN
				RETURN start_date_range <= start_date AND start_date <= end_date_range;
			ELSE
				RETURN start_date_range <= start_date AND end_date <= end_date_range;
			END IF;
		END IF;
	END;
$$;


ALTER FUNCTION public.is_dates_from_range(start_date_range date, end_date_range date, start_date date, end_date date) OWNER TO amatsko20205;

--
-- TOC entry 266 (class 1255 OID 30555)
-- Name: is_librn_from_lib_ij(); Type: FUNCTION; Schema: public; Owner: amatsko20205
--

CREATE FUNCTION public.is_librn_from_lib_ij() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		lib INTEGER;
		iss_lib INTEGER;
		acc_lib INTEGER;
		
	BEGIN
		SELECT library_id INTO lib
			FROM "public.StorageInfo" SI
			INNER JOIN "public.Halls" H
			ON H.hall_id = SI.hall_id
			WHERE SI.stored_id = NEW.stored_id;
		
		SELECT library_id INTO iss_lib
			FROM "public.Librarians" L
			INNER JOIN "public.Halls" H
			ON H.hall_id = L.hall_id
			WHERE L.librarian_id = NEW.issued_by_lbrn;
		IF NOT lib = iss_lib THEN
			RAISE EXCEPTION 'cannot issue book with stored_id %, it is stored in other library', NEW.stored_id;
		END IF;
		
		IF NEW.date_return IS NULL THEN
			RETURN NEW;
		END IF;
		
		SELECT library_id INTO acc_lib
			FROM "public.Librarians" L
			INNER JOIN "public.Halls" H
			ON H.hall_id = L.hall_id
			WHERE L.librarian_id = NEW.accepted_by_lbrn;
		IF NOT lib = acc_lib THEN
			RAISE EXCEPTION 'cannot accept book with stored_id %, it was issued from other library', NEW.stored_id;
		END IF;

		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.is_librn_from_lib_ij() OWNER TO amatsko20205;

--
-- TOC entry 261 (class 1255 OID 30553)
-- Name: is_librn_from_lib_rj(); Type: FUNCTION; Schema: public; Owner: amatsko20205
--

CREATE FUNCTION public.is_librn_from_lib_rj() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		lib INTEGER;
		
	BEGIN
		SELECT library_id INTO lib
			FROM "public.Librarians" L
			INNER JOIN "public.Halls" H
			ON H.hall_id = L.hall_id
			WHERE L.librarian_id = NEW.librarian_id;
		IF NOT lib = NEW.library_id THEN
			RAISE EXCEPTION 'librarian with id % cannot register user in this library', NEW.librarian_id;
		END IF;
		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.is_librn_from_lib_rj() OWNER TO amatsko20205;

--
-- TOC entry 248 (class 1255 OID 30476)
-- Name: is_lw_from_category(); Type: FUNCTION; Schema: public; Owner: amatsko20205
--

CREATE FUNCTION public.is_lw_from_category() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		new_lw_category INTEGER;
		associated_table TEXT;
		
	BEGIN
		SELECT category INTO new_lw_category FROM "public.LiteraryWorks" LW
			WHERE LW.lw_id = NEW.lw_id;
		IF new_lw_category IS NULL THEN
			RAISE EXCEPTION 'lw with id % does not have category', NEW.lw_id;
		END IF;
		SELECT "table_name" INTO associated_table FROM "public.LWCategories" LWC
			WHERE LWC.category_id = new_lw_category;
		IF associated_table != TG_TABLE_NAME THEN
			RAISE EXCEPTION 'wrong category for lw with id %', NEW.lw_id;
		END IF;
		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.is_lw_from_category() OWNER TO amatsko20205;

--
-- TOC entry 268 (class 1255 OID 30550)
-- Name: is_reg_before_issue(); Type: FUNCTION; Schema: public; Owner: amatsko20205
--

CREATE FUNCTION public.is_reg_before_issue() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		registration_date DATE;
		
	BEGIN
		SELECT RJ.registration_date INTO registration_date
			FROM "public.RegistrationJournal" RJ
			WHERE RJ.user_id = NEW.user_id;
		IF registration_date > NEW.date_issue THEN
			RAISE EXCEPTION 'cannot issue book % to unregistered user with id %', NEW.stored_id, NEW.user_id;
		END IF;
		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.is_reg_before_issue() OWNER TO amatsko20205;

--
-- TOC entry 263 (class 1255 OID 30407)
-- Name: is_user_from_category(); Type: FUNCTION; Schema: public; Owner: amatsko20205
--

CREATE FUNCTION public.is_user_from_category() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		new_u_category INTEGER;
		associated_table TEXT;
		
	BEGIN
		SELECT category INTO new_u_category FROM "public.Users" U
			WHERE U.user_id = NEW.user_id;
		IF new_u_category IS NULL THEN
			RAISE EXCEPTION 'user with id % does not have category', NEW.user_id;
		END IF;
		SELECT "table_name" INTO associated_table FROM "public.UserCategories" UC
			WHERE UC.category_id = new_u_category;
		IF associated_table  != TG_TABLE_NAME THEN
			RAISE EXCEPTION 'wrong category for user with id %', NEW.user_id;
		END IF;
		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.is_user_from_category() OWNER TO amatsko20205;

--
-- TOC entry 265 (class 1255 OID 30539)
-- Name: librarian_is_working_ij(); Type: FUNCTION; Schema: public; Owner: amatsko20205
--

CREATE FUNCTION public.librarian_is_working_ij() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		iss_date_hired DATE;
		iss_date_retired DATE;
		acc_date_hired DATE;
		acc_date_retired DATE;
		
	BEGIN
		SELECT date_hired, date_retired INTO iss_date_hired, iss_date_retired 
			FROM "public.Librarians" L
			WHERE L.librarian_id = NEW.issued_by_lbrn;
		IF NOT(is_dates_from_range(iss_date_hired, iss_date_retired, NEW.date_issue, NULL)) THEN
			RAISE EXCEPTION 'librarian with id % cannot issue book, he is not working', NEW.issued_by_lbrn;
		END IF;
		IF NEW.accepted_by_lbrn IS NULL THEN
			RETURN NEW;
		END IF;
		
		SELECT date_hired, date_retired INTO acc_date_hired, acc_date_retired 
			FROM "public.Librarians" L
			WHERE L.librarian_id = NEW.accepted_by_lbrn;
		IF NOT(is_dates_from_range(acc_date_hired, acc_date_retired, NEW.date_return, NULL)) THEN
			RAISE EXCEPTION 'librarian with id % cannot accept book, he is not working', NEW.accepted_by_lbrn;
		END IF;
		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.librarian_is_working_ij() OWNER TO amatsko20205;

--
-- TOC entry 250 (class 1255 OID 30541)
-- Name: librarian_is_working_rj(); Type: FUNCTION; Schema: public; Owner: amatsko20205
--

CREATE FUNCTION public.librarian_is_working_rj() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		date_hired DATE;
		date_retired DATE;
		
	BEGIN
		SELECT date_hired, date_retired INTO date_hired, date_retired 
			FROM "public.Librarians" L
			WHERE L.librarian_id = NEW.librarian_id;
		IF NOT(is_dates_from_range(date_hired, date_retired, NEW.registration_date, NULL)) THEN
			RAISE EXCEPTION 'librarian with id % cannot register user, he is not working', NEW.librarian_id;
		END IF;
		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.librarian_is_working_rj() OWNER TO amatsko20205;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 23307)
-- Name: public.Authors; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Authors" (
    author_id integer NOT NULL,
    last_name text NOT NULL,
    first_name text NOT NULL,
    patronymic text
);


ALTER TABLE public."public.Authors" OWNER TO amatsko20205;

--
-- TOC entry 236 (class 1259 OID 23315)
-- Name: public.AuthorsWorks; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.AuthorsWorks" (
    lw_id integer NOT NULL,
    author_id integer NOT NULL
);


ALTER TABLE public."public.AuthorsWorks" OWNER TO amatsko20205;

--
-- TOC entry 234 (class 1259 OID 23306)
-- Name: public.Authors_author_id_seq; Type: SEQUENCE; Schema: public; Owner: amatsko20205
--

CREATE SEQUENCE public."public.Authors_author_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."public.Authors_author_id_seq" OWNER TO amatsko20205;

--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 234
-- Name: public.Authors_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amatsko20205
--

ALTER SEQUENCE public."public.Authors_author_id_seq" OWNED BY public."public.Authors".author_id;


--
-- TOC entry 230 (class 1259 OID 23284)
-- Name: public.Books; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Books" (
    book_id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public."public.Books" OWNER TO amatsko20205;

--
-- TOC entry 229 (class 1259 OID 23283)
-- Name: public.Books_book_id_seq; Type: SEQUENCE; Schema: public; Owner: amatsko20205
--

CREATE SEQUENCE public."public.Books_book_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."public.Books_book_id_seq" OWNER TO amatsko20205;

--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 229
-- Name: public.Books_book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amatsko20205
--

ALTER SEQUENCE public."public.Books_book_id_seq" OWNED BY public."public.Books".book_id;


--
-- TOC entry 225 (class 1259 OID 23261)
-- Name: public.Halls; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Halls" (
    hall_id integer NOT NULL,
    library_id integer NOT NULL
);


ALTER TABLE public."public.Halls" OWNER TO amatsko20205;

--
-- TOC entry 224 (class 1259 OID 23260)
-- Name: public.Halls_hall_id_seq; Type: SEQUENCE; Schema: public; Owner: amatsko20205
--

CREATE SEQUENCE public."public.Halls_hall_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."public.Halls_hall_id_seq" OWNER TO amatsko20205;

--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 224
-- Name: public.Halls_hall_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amatsko20205
--

ALTER SEQUENCE public."public.Halls_hall_id_seq" OWNED BY public."public.Halls".hall_id;


--
-- TOC entry 239 (class 1259 OID 23328)
-- Name: public.IssueJournal; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.IssueJournal" (
    stored_id integer NOT NULL,
    date_issue date NOT NULL,
    date_return date,
    user_id integer NOT NULL,
    issued_by_lbrn integer NOT NULL,
    accepted_by_lbrn integer,
    CONSTRAINT consistent_return CHECK ((((date_return IS NULL) AND (accepted_by_lbrn IS NULL)) OR ((date_return IS NOT NULL) AND (accepted_by_lbrn IS NOT NULL)))),
    CONSTRAINT date_issue_lower_date_return CHECK ((((date_return IS NOT NULL) AND (date_issue <= date_return) AND (date_issue <= now()) AND (date_return <= now())) OR ((date_return IS NULL) AND (date_issue <= now()))))
);


ALTER TABLE public."public.IssueJournal" OWNER TO amatsko20205;

--
-- TOC entry 247 (class 1259 OID 30459)
-- Name: public.LWCategories; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.LWCategories" (
    category_id integer NOT NULL,
    category_name text NOT NULL,
    table_name text NOT NULL
);


ALTER TABLE public."public.LWCategories" OWNER TO amatsko20205;

--
-- TOC entry 246 (class 1259 OID 30458)
-- Name: public.LWCategories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: amatsko20205
--

CREATE SEQUENCE public."public.LWCategories_category_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."public.LWCategories_category_id_seq" OWNER TO amatsko20205;

--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 246
-- Name: public.LWCategories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amatsko20205
--

ALTER SEQUENCE public."public.LWCategories_category_id_seq" OWNED BY public."public.LWCategories".category_id;


--
-- TOC entry 227 (class 1259 OID 23268)
-- Name: public.Librarians; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Librarians" (
    librarian_id integer NOT NULL,
    hall_id integer NOT NULL,
    last_name text NOT NULL,
    first_name text NOT NULL,
    patronymic text,
    date_hired date NOT NULL,
    date_retired date,
    CONSTRAINT date_hired_lower_date_retired CHECK ((((date_retired IS NOT NULL) AND (date_hired <= date_retired) AND (date_hired <= now()) AND (date_retired <= now())) OR ((date_retired IS NULL) AND (date_hired <= now()))))
);


ALTER TABLE public."public.Librarians" OWNER TO amatsko20205;

--
-- TOC entry 226 (class 1259 OID 23267)
-- Name: public.Librarians_librarian_id_seq; Type: SEQUENCE; Schema: public; Owner: amatsko20205
--

CREATE SEQUENCE public."public.Librarians_librarian_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."public.Librarians_librarian_id_seq" OWNER TO amatsko20205;

--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 226
-- Name: public.Librarians_librarian_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amatsko20205
--

ALTER SEQUENCE public."public.Librarians_librarian_id_seq" OWNED BY public."public.Librarians".librarian_id;


--
-- TOC entry 223 (class 1259 OID 23252)
-- Name: public.Libraries; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Libraries" (
    library_id integer NOT NULL,
    district text NOT NULL,
    street text NOT NULL,
    building text NOT NULL,
    name text NOT NULL
);


ALTER TABLE public."public.Libraries" OWNER TO amatsko20205;

--
-- TOC entry 222 (class 1259 OID 23251)
-- Name: public.Libraries_library_id_seq; Type: SEQUENCE; Schema: public; Owner: amatsko20205
--

CREATE SEQUENCE public."public.Libraries_library_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."public.Libraries_library_id_seq" OWNER TO amatsko20205;

--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 222
-- Name: public.Libraries_library_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amatsko20205
--

ALTER SEQUENCE public."public.Libraries_library_id_seq" OWNED BY public."public.Libraries".library_id;


--
-- TOC entry 232 (class 1259 OID 23293)
-- Name: public.LiteraryWorks; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.LiteraryWorks" (
    lw_id integer NOT NULL,
    name text NOT NULL,
    category integer
);


ALTER TABLE public."public.LiteraryWorks" OWNER TO amatsko20205;

--
-- TOC entry 231 (class 1259 OID 23292)
-- Name: public.LiteraryWorks_lw_id_seq; Type: SEQUENCE; Schema: public; Owner: amatsko20205
--

CREATE SEQUENCE public."public.LiteraryWorks_lw_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."public.LiteraryWorks_lw_id_seq" OWNER TO amatsko20205;

--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 231
-- Name: public.LiteraryWorks_lw_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amatsko20205
--

ALTER SEQUENCE public."public.LiteraryWorks_lw_id_seq" OWNED BY public."public.LiteraryWorks".lw_id;


--
-- TOC entry 240 (class 1259 OID 23331)
-- Name: public.Novels; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Novels" (
    lw_id integer NOT NULL,
    number_chapters integer NOT NULL,
    short_desc text
);


ALTER TABLE public."public.Novels" OWNER TO amatsko20205;

--
-- TOC entry 221 (class 1259 OID 23247)
-- Name: public.Pensioners; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Pensioners" (
    user_id integer NOT NULL,
    discount integer NOT NULL,
    CONSTRAINT percent_check CHECK (((discount >= 0) AND (discount <= 100)))
);


ALTER TABLE public."public.Pensioners" OWNER TO amatsko20205;

--
-- TOC entry 243 (class 1259 OID 23350)
-- Name: public.Poems; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Poems" (
    lw_id integer NOT NULL,
    rhyming_method text NOT NULL,
    verse_size text NOT NULL
);


ALTER TABLE public."public.Poems" OWNER TO amatsko20205;

--
-- TOC entry 220 (class 1259 OID 23242)
-- Name: public.Pupils; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Pupils" (
    user_id integer NOT NULL,
    school text NOT NULL
);


ALTER TABLE public."public.Pupils" OWNER TO amatsko20205;

--
-- TOC entry 228 (class 1259 OID 23276)
-- Name: public.RegistrationJournal; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.RegistrationJournal" (
    user_id integer NOT NULL,
    librarian_id integer NOT NULL,
    registration_date date NOT NULL,
    library_id integer NOT NULL,
    CONSTRAINT registration_date_lower_now CHECK ((registration_date <= now()))
);


ALTER TABLE public."public.RegistrationJournal" OWNER TO amatsko20205;

--
-- TOC entry 241 (class 1259 OID 23338)
-- Name: public.ScientificArticles; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.ScientificArticles" (
    lw_id integer NOT NULL,
    date_issue date NOT NULL
);


ALTER TABLE public."public.ScientificArticles" OWNER TO amatsko20205;

--
-- TOC entry 216 (class 1259 OID 23222)
-- Name: public.Scientists; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Scientists" (
    user_id integer NOT NULL,
    degree text NOT NULL
);


ALTER TABLE public."public.Scientists" OWNER TO amatsko20205;

--
-- TOC entry 238 (class 1259 OID 23321)
-- Name: public.StorageInfo; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.StorageInfo" (
    stored_id integer NOT NULL,
    hall_id integer NOT NULL,
    bookcase integer NOT NULL,
    shelf integer NOT NULL,
    book_id integer NOT NULL,
    available_issue boolean NOT NULL,
    duration_issue integer NOT NULL,
    date_receipt date NOT NULL,
    date_dispose date,
    CONSTRAINT date_receipt_lower_date_dispose CHECK ((((date_dispose IS NOT NULL) AND (date_receipt <= date_dispose) AND (date_receipt <= now()) AND (date_dispose <= now())) OR ((date_dispose IS NULL) AND (date_receipt <= now()))))
);


ALTER TABLE public."public.StorageInfo" OWNER TO amatsko20205;

--
-- TOC entry 237 (class 1259 OID 23320)
-- Name: public.StorageInfo_stored_id_seq; Type: SEQUENCE; Schema: public; Owner: amatsko20205
--

CREATE SEQUENCE public."public.StorageInfo_stored_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."public.StorageInfo_stored_id_seq" OWNER TO amatsko20205;

--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 237
-- Name: public.StorageInfo_stored_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amatsko20205
--

ALTER SEQUENCE public."public.StorageInfo_stored_id_seq" OWNED BY public."public.StorageInfo".stored_id;


--
-- TOC entry 217 (class 1259 OID 23227)
-- Name: public.Students; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Students" (
    user_id integer NOT NULL,
    faculty text NOT NULL,
    university character varying(150) NOT NULL
);


ALTER TABLE public."public.Students" OWNER TO amatsko20205;

--
-- TOC entry 219 (class 1259 OID 23237)
-- Name: public.Teachers; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Teachers" (
    user_id integer NOT NULL,
    school text NOT NULL,
    subject text NOT NULL
);


ALTER TABLE public."public.Teachers" OWNER TO amatsko20205;

--
-- TOC entry 242 (class 1259 OID 23343)
-- Name: public.Textbooks; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Textbooks" (
    lw_id integer NOT NULL,
    subject text NOT NULL,
    complexity_level text NOT NULL
);


ALTER TABLE public."public.Textbooks" OWNER TO amatsko20205;

--
-- TOC entry 245 (class 1259 OID 30415)
-- Name: public.UserCategories; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.UserCategories" (
    category_id integer NOT NULL,
    category_name text NOT NULL,
    table_name text NOT NULL
);


ALTER TABLE public."public.UserCategories" OWNER TO amatsko20205;

--
-- TOC entry 244 (class 1259 OID 30414)
-- Name: public.UserCategories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: amatsko20205
--

CREATE SEQUENCE public."public.UserCategories_category_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."public.UserCategories_category_id_seq" OWNER TO amatsko20205;

--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 244
-- Name: public.UserCategories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amatsko20205
--

ALTER SEQUENCE public."public.UserCategories_category_id_seq" OWNED BY public."public.UserCategories".category_id;


--
-- TOC entry 215 (class 1259 OID 23214)
-- Name: public.Users; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Users" (
    user_id integer NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    patronymic text,
    category integer
);


ALTER TABLE public."public.Users" OWNER TO amatsko20205;

--
-- TOC entry 214 (class 1259 OID 23213)
-- Name: public.Users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: amatsko20205
--

CREATE SEQUENCE public."public.Users_user_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."public.Users_user_id_seq" OWNER TO amatsko20205;

--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 214
-- Name: public.Users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: amatsko20205
--

ALTER SEQUENCE public."public.Users_user_id_seq" OWNED BY public."public.Users".user_id;


--
-- TOC entry 218 (class 1259 OID 23232)
-- Name: public.Workers; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.Workers" (
    user_id integer NOT NULL,
    job text NOT NULL,
    company text NOT NULL
);


ALTER TABLE public."public.Workers" OWNER TO amatsko20205;

--
-- TOC entry 233 (class 1259 OID 23301)
-- Name: public.WorksInBook; Type: TABLE; Schema: public; Owner: amatsko20205
--

CREATE TABLE public."public.WorksInBook" (
    book_id integer NOT NULL,
    lw_id integer NOT NULL
);


ALTER TABLE public."public.WorksInBook" OWNER TO amatsko20205;

--
-- TOC entry 3298 (class 2604 OID 23310)
-- Name: public.Authors author_id; Type: DEFAULT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Authors" ALTER COLUMN author_id SET DEFAULT nextval('public."public.Authors_author_id_seq"'::regclass);


--
-- TOC entry 3296 (class 2604 OID 23287)
-- Name: public.Books book_id; Type: DEFAULT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Books" ALTER COLUMN book_id SET DEFAULT nextval('public."public.Books_book_id_seq"'::regclass);


--
-- TOC entry 3294 (class 2604 OID 23264)
-- Name: public.Halls hall_id; Type: DEFAULT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Halls" ALTER COLUMN hall_id SET DEFAULT nextval('public."public.Halls_hall_id_seq"'::regclass);


--
-- TOC entry 3301 (class 2604 OID 30462)
-- Name: public.LWCategories category_id; Type: DEFAULT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.LWCategories" ALTER COLUMN category_id SET DEFAULT nextval('public."public.LWCategories_category_id_seq"'::regclass);


--
-- TOC entry 3295 (class 2604 OID 23271)
-- Name: public.Librarians librarian_id; Type: DEFAULT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Librarians" ALTER COLUMN librarian_id SET DEFAULT nextval('public."public.Librarians_librarian_id_seq"'::regclass);


--
-- TOC entry 3293 (class 2604 OID 23255)
-- Name: public.Libraries library_id; Type: DEFAULT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Libraries" ALTER COLUMN library_id SET DEFAULT nextval('public."public.Libraries_library_id_seq"'::regclass);


--
-- TOC entry 3297 (class 2604 OID 23296)
-- Name: public.LiteraryWorks lw_id; Type: DEFAULT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.LiteraryWorks" ALTER COLUMN lw_id SET DEFAULT nextval('public."public.LiteraryWorks_lw_id_seq"'::regclass);


--
-- TOC entry 3299 (class 2604 OID 23324)
-- Name: public.StorageInfo stored_id; Type: DEFAULT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.StorageInfo" ALTER COLUMN stored_id SET DEFAULT nextval('public."public.StorageInfo_stored_id_seq"'::regclass);


--
-- TOC entry 3300 (class 2604 OID 30418)
-- Name: public.UserCategories category_id; Type: DEFAULT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.UserCategories" ALTER COLUMN category_id SET DEFAULT nextval('public."public.UserCategories_category_id_seq"'::regclass);


--
-- TOC entry 3292 (class 2604 OID 23217)
-- Name: public.Users user_id; Type: DEFAULT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Users" ALTER COLUMN user_id SET DEFAULT nextval('public."public.Users_user_id_seq"'::regclass);


--
-- TOC entry 3580 (class 0 OID 23307)
-- Dependencies: 235
-- Data for Name: public.Authors; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Authors" (author_id, last_name, first_name, patronymic) FROM stdin;
1	Пушкин	Александр	Сергеевич
2	Толстой	Лев	Николаевич
3	Стругацкий	Аркадий	Натанович
4	Стругацкий	Борис	Натанович
5	Лермонтов	Михаил	Юрьевич
6	Колмогоров	Андрей	Николаевич
7	Пальчунов	Дмитрий	Евгеньевич
8	Трегубов	Артём	Сергеевич
9	Достоевский	Фёдор	Михайлович
\.


--
-- TOC entry 3581 (class 0 OID 23315)
-- Dependencies: 236
-- Data for Name: public.AuthorsWorks; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.AuthorsWorks" (lw_id, author_id) FROM stdin;
1	1
2	1
3	1
4	5
5	5
6	5
7	3
7	4
8	4
8	3
9	7
9	8
10	6
11	9
12	9
\.


--
-- TOC entry 3575 (class 0 OID 23284)
-- Dependencies: 230
-- Data for Name: public.Books; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Books" (book_id, name) FROM stdin;
1	Сборник стихов А.С. Пушкина
2	Сборник стихов М.Ю. Лермонтова
3	Евгений Онегин
4	Герой нашего времени
5	Хромая судьба
6	Улитка на склоне
7	Преступление и наказание
8	Идиот
\.


--
-- TOC entry 3570 (class 0 OID 23261)
-- Dependencies: 225
-- Data for Name: public.Halls; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Halls" (hall_id, library_id) FROM stdin;
1	1
2	1
3	1
4	1
5	1
6	1
7	2
8	2
9	3
10	3
11	3
\.


--
-- TOC entry 3584 (class 0 OID 23328)
-- Dependencies: 239
-- Data for Name: public.IssueJournal; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.IssueJournal" (stored_id, date_issue, date_return, user_id, issued_by_lbrn, accepted_by_lbrn) FROM stdin;
18	2023-03-21	\N	16	3	\N
32	2022-12-30	\N	13	4	\N
7	2023-03-20	\N	12	1	\N
1	2020-02-26	2020-03-04	15	1	1
7	2018-01-20	2018-03-10	17	2	2
24	2021-05-21	2021-06-01	11	4	4
40	2017-09-10	2017-09-10	8	4	4
41	2020-11-29	2020-11-29	7	5	5
\.


--
-- TOC entry 3592 (class 0 OID 30459)
-- Dependencies: 247
-- Data for Name: public.LWCategories; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.LWCategories" (category_id, category_name, table_name) FROM stdin;
1	novel	public.Novels
2	poem	public.Poems
3	scientific article	public.ScientificArticles
4	textbook	public.Textbooks
\.


--
-- TOC entry 3572 (class 0 OID 23268)
-- Dependencies: 227
-- Data for Name: public.Librarians; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Librarians" (librarian_id, hall_id, last_name, first_name, patronymic, date_hired, date_retired) FROM stdin;
1	1	Книжников	Андрей	\N	2010-01-20	\N
2	1	Книгин	Пётр	Антонович	2010-05-10	2019-07-01
3	7	Буков	Фёдор	Антонович	2015-05-10	\N
4	10	Букварёв	Иван	Александрович	2014-08-11	\N
5	11	Орлов	Василий	Александрович	2012-10-02	2022-06-12
6	3	Орлова	Анна	Владимировна	2012-10-02	\N
7	8	Маркова	Ольга	Анатольевна	2017-11-12	\N
\.


--
-- TOC entry 3568 (class 0 OID 23252)
-- Dependencies: 223
-- Data for Name: public.Libraries; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Libraries" (library_id, district, street, building, name) FROM stdin;
1	Ленинский	Советская	6	Новосибирская государственная областная научная библиотека
2	Кировский	Новогодняя	11	Центральная районная библиотека им. П.П. Бажова
3	Заельцовский	Красный проспект	163	Центральная городская библиотека им. К. Маркса
\.


--
-- TOC entry 3577 (class 0 OID 23293)
-- Dependencies: 232
-- Data for Name: public.LiteraryWorks; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.LiteraryWorks" (lw_id, name, category) FROM stdin;
9	Программная система OntoAssist	3
10	Об аналитических методах в теории вероятностей	3
1	Руслан и Людмила	2
3	Медный всадник	2
4	Бородино	2
5	Демон	2
2	Евгений Онегин	1
6	Герой нашего времени	1
7	Хромая судьба	1
8	Улитка на склоне	1
11	Преступление и наказание	1
12	Идиот	1
\.


--
-- TOC entry 3585 (class 0 OID 23331)
-- Dependencies: 240
-- Data for Name: public.Novels; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Novels" (lw_id, number_chapters, short_desc) FROM stdin;
\.


--
-- TOC entry 3566 (class 0 OID 23247)
-- Dependencies: 221
-- Data for Name: public.Pensioners; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Pensioners" (user_id, discount) FROM stdin;
\.


--
-- TOC entry 3588 (class 0 OID 23350)
-- Dependencies: 243
-- Data for Name: public.Poems; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Poems" (lw_id, rhyming_method, verse_size) FROM stdin;
\.


--
-- TOC entry 3565 (class 0 OID 23242)
-- Dependencies: 220
-- Data for Name: public.Pupils; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Pupils" (user_id, school) FROM stdin;
17	Школа №121
\.


--
-- TOC entry 3573 (class 0 OID 23276)
-- Dependencies: 228
-- Data for Name: public.RegistrationJournal; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.RegistrationJournal" (user_id, librarian_id, registration_date, library_id) FROM stdin;
7	1	2020-02-04	1
9	2	2018-11-04	1
8	3	2016-01-04	2
11	4	2019-02-06	3
12	5	2021-03-15	3
13	6	2013-05-15	1
14	7	2013-05-15	2
15	1	2023-01-16	1
16	2	2010-06-04	1
17	3	2017-02-04	2
18	6	2018-05-10	2
20	2	2011-04-29	1
19	5	2016-11-23	3
\.


--
-- TOC entry 3586 (class 0 OID 23338)
-- Dependencies: 241
-- Data for Name: public.ScientificArticles; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.ScientificArticles" (lw_id, date_issue) FROM stdin;
\.


--
-- TOC entry 3561 (class 0 OID 23222)
-- Dependencies: 216
-- Data for Name: public.Scientists; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Scientists" (user_id, degree) FROM stdin;
14	Доктор химических наук
20	Кандидат технических наук
\.


--
-- TOC entry 3583 (class 0 OID 23321)
-- Dependencies: 238
-- Data for Name: public.StorageInfo; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.StorageInfo" (stored_id, hall_id, bookcase, shelf, book_id, available_issue, duration_issue, date_receipt, date_dispose) FROM stdin;
1	1	1	1	1	t	14	2017-01-08	\N
3	1	1	1	1	t	14	2017-01-08	\N
4	1	1	1	1	t	14	2017-01-08	\N
5	1	1	2	1	t	14	2017-01-08	\N
6	1	1	2	2	t	14	2017-01-08	\N
7	2	3	2	3	t	14	2017-01-08	\N
8	2	3	2	3	t	14	2017-01-08	\N
9	2	3	1	3	t	14	2017-01-08	\N
10	2	3	1	3	t	14	2017-01-08	\N
11	2	3	1	3	t	14	2017-01-08	\N
12	7	1	1	4	t	14	2019-11-18	\N
13	7	1	1	4	t	14	2019-11-18	\N
14	7	1	1	4	t	14	2019-11-18	\N
15	7	1	2	4	t	14	2019-11-18	\N
16	7	1	2	4	t	14	2019-11-18	\N
17	7	1	2	4	t	14	2019-11-18	\N
19	7	1	2	5	t	14	2019-11-18	\N
20	11	1	2	6	t	14	2019-11-18	\N
21	11	2	2	6	t	14	2019-11-18	\N
22	11	2	2	6	t	14	2019-11-18	\N
24	10	2	3	7	t	14	2019-11-18	\N
25	2	1	3	8	t	14	2016-05-24	\N
26	2	1	3	8	t	14	2016-05-24	\N
27	3	1	3	8	t	14	2016-05-24	\N
28	3	2	3	8	t	14	2016-05-24	\N
29	8	2	3	8	t	14	2016-05-24	\N
30	8	2	3	5	t	21	2009-04-25	2022-02-17
31	1	2	3	5	t	21	2009-04-25	2022-02-17
32	9	2	3	5	t	21	2009-04-25	2022-02-17
33	11	2	3	5	t	21	2009-04-25	2022-02-17
39	11	2	1	4	f	0	1998-09-11	\N
40	10	2	1	4	f	0	1998-09-11	\N
41	9	2	1	4	f	0	1998-09-11	\N
42	6	2	1	4	f	0	1998-09-11	\N
34	4	2	3	3	f	0	1999-12-01	\N
35	4	1	1	3	f	0	1999-12-01	\N
36	4	1	1	3	f	0	1999-12-01	\N
37	8	1	1	3	f	0	1999-12-01	\N
38	11	1	1	3	f	0	1999-12-01	\N
18	7	1	2	5	t	14	2019-11-18	2023-04-09
\.


--
-- TOC entry 3562 (class 0 OID 23227)
-- Dependencies: 217
-- Data for Name: public.Students; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Students" (user_id, faculty, university) FROM stdin;
9	ФИТ	НГУ
11	ФИТ	НГУ
12	ФИТ	НГУ
13	ФИТ	НГУ
18	ФФ	НГУ
19	ФФ	НГУ
\.


--
-- TOC entry 3564 (class 0 OID 23237)
-- Dependencies: 219
-- Data for Name: public.Teachers; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Teachers" (user_id, school, subject) FROM stdin;
7	Лицей №130	Информатика
8	Лицей №130	Физика
\.


--
-- TOC entry 3587 (class 0 OID 23343)
-- Dependencies: 242
-- Data for Name: public.Textbooks; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Textbooks" (lw_id, subject, complexity_level) FROM stdin;
\.


--
-- TOC entry 3590 (class 0 OID 30415)
-- Dependencies: 245
-- Data for Name: public.UserCategories; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.UserCategories" (category_id, category_name, table_name) FROM stdin;
1	worker	public.Workers
2	student	public.Students
3	pupil	public.Pupils
4	pensioner	public.Pensioners
5	scientist	public.Scientists
6	teacher	public.Teachers
\.


--
-- TOC entry 3560 (class 0 OID 23214)
-- Dependencies: 215
-- Data for Name: public.Users; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Users" (user_id, first_name, last_name, patronymic, category) FROM stdin;
16	Евгений	Петров	Сергеевич	1
17	Иван	Иванов	Иванович	3
14	Михаил	Мацько	Александрович	5
20	Андрей	Власенко	Юрьевич	5
7	Андрей	Минак	Геннадьевич	6
8	Юлия	Трибунская	Валерьевна	6
15	Абрик	Валишев	Ибрагимович	4
9	Игорь	Архипов	Анатольевич	2
11	Роман	Шувалов	Денисович	2
12	Александра	Шунина	Станиславовна	2
13	Александр	Мацько	Михайлович	2
18	Александр	Петров	Иванович	2
19	Вадим	Турло	\N	2
\.


--
-- TOC entry 3563 (class 0 OID 23232)
-- Dependencies: 218
-- Data for Name: public.Workers; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.Workers" (user_id, job, company) FROM stdin;
16	backend разработчик	Яндекс
\.


--
-- TOC entry 3578 (class 0 OID 23301)
-- Dependencies: 233
-- Data for Name: public.WorksInBook; Type: TABLE DATA; Schema: public; Owner: amatsko20205
--

COPY public."public.WorksInBook" (book_id, lw_id) FROM stdin;
1	1
1	2
1	3
2	4
2	5
3	2
4	6
5	7
6	8
7	11
8	12
\.


--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 234
-- Name: public.Authors_author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amatsko20205
--

SELECT pg_catalog.setval('public."public.Authors_author_id_seq"', 9, true);


--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 229
-- Name: public.Books_book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amatsko20205
--

SELECT pg_catalog.setval('public."public.Books_book_id_seq"', 8, true);


--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 224
-- Name: public.Halls_hall_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amatsko20205
--

SELECT pg_catalog.setval('public."public.Halls_hall_id_seq"', 11, true);


--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 246
-- Name: public.LWCategories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amatsko20205
--

SELECT pg_catalog.setval('public."public.LWCategories_category_id_seq"', 4, true);


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 226
-- Name: public.Librarians_librarian_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amatsko20205
--

SELECT pg_catalog.setval('public."public.Librarians_librarian_id_seq"', 7, true);


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 222
-- Name: public.Libraries_library_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amatsko20205
--

SELECT pg_catalog.setval('public."public.Libraries_library_id_seq"', 3, true);


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 231
-- Name: public.LiteraryWorks_lw_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amatsko20205
--

SELECT pg_catalog.setval('public."public.LiteraryWorks_lw_id_seq"', 12, true);


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 237
-- Name: public.StorageInfo_stored_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amatsko20205
--

SELECT pg_catalog.setval('public."public.StorageInfo_stored_id_seq"', 42, true);


--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 244
-- Name: public.UserCategories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amatsko20205
--

SELECT pg_catalog.setval('public."public.UserCategories_category_id_seq"', 6, true);


--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 214
-- Name: public.Users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: amatsko20205
--

SELECT pg_catalog.setval('public."public.Users_user_id_seq"', 20, true);


--
-- TOC entry 3339 (class 2606 OID 23314)
-- Name: public.Authors Authors_pk; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Authors"
    ADD CONSTRAINT "Authors_pk" PRIMARY KEY (author_id);


--
-- TOC entry 3333 (class 2606 OID 23291)
-- Name: public.Books Books_pk; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Books"
    ADD CONSTRAINT "Books_pk" PRIMARY KEY (book_id);


--
-- TOC entry 3325 (class 2606 OID 23266)
-- Name: public.Halls Halls_pk; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Halls"
    ADD CONSTRAINT "Halls_pk" PRIMARY KEY (hall_id);


--
-- TOC entry 3367 (class 2606 OID 30466)
-- Name: public.LWCategories LWCategories_pk; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.LWCategories"
    ADD CONSTRAINT "LWCategories_pk" PRIMARY KEY (category_id);


--
-- TOC entry 3327 (class 2606 OID 23275)
-- Name: public.Librarians Librarians_pk; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Librarians"
    ADD CONSTRAINT "Librarians_pk" PRIMARY KEY (librarian_id);


--
-- TOC entry 3323 (class 2606 OID 23259)
-- Name: public.Libraries Libraries_pk; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Libraries"
    ADD CONSTRAINT "Libraries_pk" PRIMARY KEY (library_id);


--
-- TOC entry 3335 (class 2606 OID 23300)
-- Name: public.LiteraryWorks LiteraryWorks_pk; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.LiteraryWorks"
    ADD CONSTRAINT "LiteraryWorks_pk" PRIMARY KEY (lw_id);


--
-- TOC entry 3345 (class 2606 OID 23485)
-- Name: public.Novels Novels_unique_lw; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Novels"
    ADD CONSTRAINT "Novels_unique_lw" UNIQUE (lw_id);


--
-- TOC entry 3321 (class 2606 OID 23483)
-- Name: public.Pensioners Pensioners_unique_user; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Pensioners"
    ADD CONSTRAINT "Pensioners_unique_user" UNIQUE (user_id);


--
-- TOC entry 3357 (class 2606 OID 23491)
-- Name: public.Poems Poems_unique_lw; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Poems"
    ADD CONSTRAINT "Poems_unique_lw" UNIQUE (lw_id);


--
-- TOC entry 3319 (class 2606 OID 23481)
-- Name: public.Pupils Pupils_unique_user; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Pupils"
    ADD CONSTRAINT "Pupils_unique_user" UNIQUE (user_id);


--
-- TOC entry 3349 (class 2606 OID 23487)
-- Name: public.ScientificArticles ScientificArticles_unique_lw; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.ScientificArticles"
    ADD CONSTRAINT "ScientificArticles_unique_lw" UNIQUE (lw_id);


--
-- TOC entry 3311 (class 2606 OID 23473)
-- Name: public.Scientists Scientists_unique_user; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Scientists"
    ADD CONSTRAINT "Scientists_unique_user" UNIQUE (user_id);


--
-- TOC entry 3343 (class 2606 OID 23326)
-- Name: public.StorageInfo StorageInfo_pk; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.StorageInfo"
    ADD CONSTRAINT "StorageInfo_pk" PRIMARY KEY (stored_id);


--
-- TOC entry 3313 (class 2606 OID 23475)
-- Name: public.Students Students_unique_user; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Students"
    ADD CONSTRAINT "Students_unique_user" UNIQUE (user_id);


--
-- TOC entry 3317 (class 2606 OID 23479)
-- Name: public.Teachers Teachers_unique_user; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Teachers"
    ADD CONSTRAINT "Teachers_unique_user" UNIQUE (user_id);


--
-- TOC entry 3353 (class 2606 OID 23489)
-- Name: public.Textbooks Textbooks_unique_lw; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Textbooks"
    ADD CONSTRAINT "Textbooks_unique_lw" UNIQUE (lw_id);


--
-- TOC entry 3361 (class 2606 OID 30422)
-- Name: public.UserCategories UserCategories_pk; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.UserCategories"
    ADD CONSTRAINT "UserCategories_pk" PRIMARY KEY (category_id);


--
-- TOC entry 3309 (class 2606 OID 23221)
-- Name: public.Users Users_pk; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Users"
    ADD CONSTRAINT "Users_pk" PRIMARY KEY (user_id);


--
-- TOC entry 3315 (class 2606 OID 23477)
-- Name: public.Workers Workers_unique_user; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Workers"
    ADD CONSTRAINT "Workers_unique_user" UNIQUE (user_id);


--
-- TOC entry 3341 (class 2606 OID 23319)
-- Name: public.AuthorsWorks no_authors_duplication_in_lw; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.AuthorsWorks"
    ADD CONSTRAINT no_authors_duplication_in_lw UNIQUE (lw_id, author_id);


--
-- TOC entry 3337 (class 2606 OID 23305)
-- Name: public.WorksInBook no_duplicates_lworks_in_book; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.WorksInBook"
    ADD CONSTRAINT no_duplicates_lworks_in_book UNIQUE (book_id, lw_id);


--
-- TOC entry 3347 (class 2606 OID 23337)
-- Name: public.Novels public.Novels_lw_id_key; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Novels"
    ADD CONSTRAINT "public.Novels_lw_id_key" UNIQUE (lw_id);


--
-- TOC entry 3359 (class 2606 OID 23356)
-- Name: public.Poems public.Poems_lw_id_key; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Poems"
    ADD CONSTRAINT "public.Poems_lw_id_key" UNIQUE (lw_id);


--
-- TOC entry 3329 (class 2606 OID 23280)
-- Name: public.RegistrationJournal public.RegistrationJournal_user_id_key; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.RegistrationJournal"
    ADD CONSTRAINT "public.RegistrationJournal_user_id_key" UNIQUE (user_id);


--
-- TOC entry 3351 (class 2606 OID 23342)
-- Name: public.ScientificArticles public.ScientificArticles_lw_id_key; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.ScientificArticles"
    ADD CONSTRAINT "public.ScientificArticles_lw_id_key" UNIQUE (lw_id);


--
-- TOC entry 3355 (class 2606 OID 23349)
-- Name: public.Textbooks public.Textbooks_lw_id_key; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Textbooks"
    ADD CONSTRAINT "public.Textbooks_lw_id_key" UNIQUE (lw_id);


--
-- TOC entry 3363 (class 2606 OID 30424)
-- Name: public.UserCategories unique_category_name; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.UserCategories"
    ADD CONSTRAINT unique_category_name UNIQUE (category_name);


--
-- TOC entry 3369 (class 2606 OID 30468)
-- Name: public.LWCategories unique_lw_category; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.LWCategories"
    ADD CONSTRAINT unique_lw_category UNIQUE (category_name);


--
-- TOC entry 3371 (class 2606 OID 30470)
-- Name: public.LWCategories unique_lw_table; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.LWCategories"
    ADD CONSTRAINT unique_lw_table UNIQUE (table_name);


--
-- TOC entry 3365 (class 2606 OID 30426)
-- Name: public.UserCategories unique_table_name; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.UserCategories"
    ADD CONSTRAINT unique_table_name UNIQUE (table_name);


--
-- TOC entry 3331 (class 2606 OID 23282)
-- Name: public.RegistrationJournal unique_user_registration; Type: CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.RegistrationJournal"
    ADD CONSTRAINT unique_user_registration UNIQUE (user_id);


--
-- TOC entry 3408 (class 2620 OID 30549)
-- Name: public.IssueJournal trigger_is_book_example_already_issued; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_book_example_already_issued BEFORE INSERT OR UPDATE ON public."public.IssueJournal" FOR EACH ROW EXECUTE FUNCTION public.is_book_example_already_issued();


--
-- TOC entry 3409 (class 2620 OID 30544)
-- Name: public.IssueJournal trigger_is_book_example_dispose; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_book_example_dispose BEFORE INSERT OR UPDATE ON public."public.IssueJournal" FOR EACH ROW EXECUTE FUNCTION public.is_book_example_dispose();


--
-- TOC entry 3407 (class 2620 OID 30547)
-- Name: public.StorageInfo trigger_is_book_example_issued; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_book_example_issued BEFORE INSERT OR UPDATE ON public."public.StorageInfo" FOR EACH ROW EXECUTE FUNCTION public.is_book_example_issued();


--
-- TOC entry 3410 (class 2620 OID 30556)
-- Name: public.IssueJournal trigger_is_librn_from_lib_ij; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_librn_from_lib_ij BEFORE INSERT OR UPDATE ON public."public.IssueJournal" FOR EACH ROW EXECUTE FUNCTION public.is_librn_from_lib_ij();


--
-- TOC entry 3405 (class 2620 OID 30554)
-- Name: public.RegistrationJournal trigger_is_librn_from_lib_rj; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_librn_from_lib_rj BEFORE INSERT OR UPDATE ON public."public.RegistrationJournal" FOR EACH ROW EXECUTE FUNCTION public.is_librn_from_lib_rj();


--
-- TOC entry 3413 (class 2620 OID 30477)
-- Name: public.Novels trigger_is_lw_novel; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_lw_novel BEFORE INSERT OR UPDATE ON public."public.Novels" FOR EACH ROW EXECUTE FUNCTION public.is_lw_from_category();


--
-- TOC entry 3416 (class 2620 OID 30478)
-- Name: public.Poems trigger_is_lw_poem; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_lw_poem BEFORE INSERT OR UPDATE ON public."public.Poems" FOR EACH ROW EXECUTE FUNCTION public.is_lw_from_category();


--
-- TOC entry 3414 (class 2620 OID 30479)
-- Name: public.ScientificArticles trigger_is_lw_scientific_article; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_lw_scientific_article BEFORE INSERT OR UPDATE ON public."public.ScientificArticles" FOR EACH ROW EXECUTE FUNCTION public.is_lw_from_category();


--
-- TOC entry 3415 (class 2620 OID 30480)
-- Name: public.Textbooks trigger_is_lw_textbook; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_lw_textbook BEFORE INSERT OR UPDATE ON public."public.Textbooks" FOR EACH ROW EXECUTE FUNCTION public.is_lw_from_category();


--
-- TOC entry 3411 (class 2620 OID 30551)
-- Name: public.IssueJournal trigger_is_reg_before_issue; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_reg_before_issue BEFORE INSERT OR UPDATE ON public."public.IssueJournal" FOR EACH ROW EXECUTE FUNCTION public.is_reg_before_issue();


--
-- TOC entry 3404 (class 2620 OID 30411)
-- Name: public.Pensioners trigger_is_user_pensioner; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_user_pensioner BEFORE INSERT OR UPDATE ON public."public.Pensioners" FOR EACH ROW EXECUTE FUNCTION public.is_user_from_category();


--
-- TOC entry 3403 (class 2620 OID 30410)
-- Name: public.Pupils trigger_is_user_pupil; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_user_pupil BEFORE INSERT OR UPDATE ON public."public.Pupils" FOR EACH ROW EXECUTE FUNCTION public.is_user_from_category();


--
-- TOC entry 3399 (class 2620 OID 30412)
-- Name: public.Scientists trigger_is_user_scientist; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_user_scientist BEFORE INSERT OR UPDATE ON public."public.Scientists" FOR EACH ROW EXECUTE FUNCTION public.is_user_from_category();


--
-- TOC entry 3400 (class 2620 OID 30401)
-- Name: public.Students trigger_is_user_student; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_user_student BEFORE INSERT OR UPDATE ON public."public.Students" FOR EACH ROW EXECUTE FUNCTION public.is_user_from_category();


--
-- TOC entry 3402 (class 2620 OID 30413)
-- Name: public.Teachers trigger_is_user_teacher; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_user_teacher BEFORE INSERT OR UPDATE ON public."public.Teachers" FOR EACH ROW EXECUTE FUNCTION public.is_user_from_category();


--
-- TOC entry 3401 (class 2620 OID 30408)
-- Name: public.Workers trigger_is_user_worker; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_is_user_worker BEFORE INSERT OR UPDATE ON public."public.Workers" FOR EACH ROW EXECUTE FUNCTION public.is_user_from_category();


--
-- TOC entry 3412 (class 2620 OID 30540)
-- Name: public.IssueJournal trigger_librarian_is_working_ij; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_librarian_is_working_ij BEFORE INSERT OR UPDATE ON public."public.IssueJournal" FOR EACH ROW EXECUTE FUNCTION public.librarian_is_working_ij();


--
-- TOC entry 3406 (class 2620 OID 30542)
-- Name: public.RegistrationJournal trigger_librarian_is_working_rj; Type: TRIGGER; Schema: public; Owner: amatsko20205
--

CREATE TRIGGER trigger_librarian_is_working_rj BEFORE INSERT OR UPDATE ON public."public.RegistrationJournal" FOR EACH ROW EXECUTE FUNCTION public.librarian_is_working_rj();


--
-- TOC entry 3387 (class 2606 OID 23412)
-- Name: public.AuthorsWorks AuthorsWorks_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.AuthorsWorks"
    ADD CONSTRAINT "AuthorsWorks_fk0" FOREIGN KEY (lw_id) REFERENCES public."public.LiteraryWorks"(lw_id);


--
-- TOC entry 3388 (class 2606 OID 23417)
-- Name: public.AuthorsWorks AuthorsWorks_fk1; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.AuthorsWorks"
    ADD CONSTRAINT "AuthorsWorks_fk1" FOREIGN KEY (author_id) REFERENCES public."public.Authors"(author_id);


--
-- TOC entry 3379 (class 2606 OID 23382)
-- Name: public.Halls Halls_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Halls"
    ADD CONSTRAINT "Halls_fk0" FOREIGN KEY (library_id) REFERENCES public."public.Libraries"(library_id);


--
-- TOC entry 3391 (class 2606 OID 23432)
-- Name: public.IssueJournal IssueJournal_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.IssueJournal"
    ADD CONSTRAINT "IssueJournal_fk0" FOREIGN KEY (stored_id) REFERENCES public."public.StorageInfo"(stored_id);


--
-- TOC entry 3392 (class 2606 OID 23437)
-- Name: public.IssueJournal IssueJournal_fk1; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.IssueJournal"
    ADD CONSTRAINT "IssueJournal_fk1" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);


--
-- TOC entry 3393 (class 2606 OID 23442)
-- Name: public.IssueJournal IssueJournal_fk2; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.IssueJournal"
    ADD CONSTRAINT "IssueJournal_fk2" FOREIGN KEY (issued_by_lbrn) REFERENCES public."public.Librarians"(librarian_id);


--
-- TOC entry 3380 (class 2606 OID 23387)
-- Name: public.Librarians Librarians_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Librarians"
    ADD CONSTRAINT "Librarians_fk0" FOREIGN KEY (hall_id) REFERENCES public."public.Halls"(hall_id);


--
-- TOC entry 3395 (class 2606 OID 23447)
-- Name: public.Novels Novels_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Novels"
    ADD CONSTRAINT "Novels_fk0" FOREIGN KEY (lw_id) REFERENCES public."public.LiteraryWorks"(lw_id);


--
-- TOC entry 3378 (class 2606 OID 23377)
-- Name: public.Pensioners Pensioners_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Pensioners"
    ADD CONSTRAINT "Pensioners_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);


--
-- TOC entry 3398 (class 2606 OID 23462)
-- Name: public.Poems Poems_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Poems"
    ADD CONSTRAINT "Poems_fk0" FOREIGN KEY (lw_id) REFERENCES public."public.LiteraryWorks"(lw_id);


--
-- TOC entry 3377 (class 2606 OID 23372)
-- Name: public.Pupils Pupils_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Pupils"
    ADD CONSTRAINT "Pupils_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);


--
-- TOC entry 3381 (class 2606 OID 23392)
-- Name: public.RegistrationJournal RegistrationJournal_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.RegistrationJournal"
    ADD CONSTRAINT "RegistrationJournal_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);


--
-- TOC entry 3382 (class 2606 OID 23397)
-- Name: public.RegistrationJournal RegistrationJournal_fk1; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.RegistrationJournal"
    ADD CONSTRAINT "RegistrationJournal_fk1" FOREIGN KEY (librarian_id) REFERENCES public."public.Librarians"(librarian_id);


--
-- TOC entry 3383 (class 2606 OID 23522)
-- Name: public.RegistrationJournal RegistrationJournal_fk2; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.RegistrationJournal"
    ADD CONSTRAINT "RegistrationJournal_fk2" FOREIGN KEY (library_id) REFERENCES public."public.Libraries"(library_id);


--
-- TOC entry 3396 (class 2606 OID 23452)
-- Name: public.ScientificArticles ScientificArticles_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.ScientificArticles"
    ADD CONSTRAINT "ScientificArticles_fk0" FOREIGN KEY (lw_id) REFERENCES public."public.LiteraryWorks"(lw_id);


--
-- TOC entry 3373 (class 2606 OID 23357)
-- Name: public.Scientists Scientists_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Scientists"
    ADD CONSTRAINT "Scientists_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);


--
-- TOC entry 3389 (class 2606 OID 23422)
-- Name: public.StorageInfo StorageInfo_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.StorageInfo"
    ADD CONSTRAINT "StorageInfo_fk0" FOREIGN KEY (hall_id) REFERENCES public."public.Halls"(hall_id);


--
-- TOC entry 3390 (class 2606 OID 23427)
-- Name: public.StorageInfo StorageInfo_fk1; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.StorageInfo"
    ADD CONSTRAINT "StorageInfo_fk1" FOREIGN KEY (book_id) REFERENCES public."public.Books"(book_id);


--
-- TOC entry 3374 (class 2606 OID 23362)
-- Name: public.Students Students_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Students"
    ADD CONSTRAINT "Students_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);


--
-- TOC entry 3376 (class 2606 OID 23367)
-- Name: public.Teachers Teachers_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Teachers"
    ADD CONSTRAINT "Teachers_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);


--
-- TOC entry 3397 (class 2606 OID 23457)
-- Name: public.Textbooks Textbooks_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Textbooks"
    ADD CONSTRAINT "Textbooks_fk0" FOREIGN KEY (lw_id) REFERENCES public."public.LiteraryWorks"(lw_id);


--
-- TOC entry 3375 (class 2606 OID 23467)
-- Name: public.Workers Workers_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Workers"
    ADD CONSTRAINT "Workers_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);


--
-- TOC entry 3385 (class 2606 OID 23402)
-- Name: public.WorksInBook WorksInBook_fk0; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.WorksInBook"
    ADD CONSTRAINT "WorksInBook_fk0" FOREIGN KEY (book_id) REFERENCES public."public.Books"(book_id);


--
-- TOC entry 3386 (class 2606 OID 23407)
-- Name: public.WorksInBook WorksInBook_fk1; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.WorksInBook"
    ADD CONSTRAINT "WorksInBook_fk1" FOREIGN KEY (lw_id) REFERENCES public."public.LiteraryWorks"(lw_id);


--
-- TOC entry 3372 (class 2606 OID 30427)
-- Name: public.Users categories_fk; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.Users"
    ADD CONSTRAINT categories_fk FOREIGN KEY (category) REFERENCES public."public.UserCategories"(category_id);


--
-- TOC entry 3394 (class 2606 OID 30528)
-- Name: public.IssueJournal issuejournal_fk3; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.IssueJournal"
    ADD CONSTRAINT issuejournal_fk3 FOREIGN KEY (accepted_by_lbrn) REFERENCES public."public.Librarians"(librarian_id);


--
-- TOC entry 3384 (class 2606 OID 30471)
-- Name: public.LiteraryWorks lw_category_fk; Type: FK CONSTRAINT; Schema: public; Owner: amatsko20205
--

ALTER TABLE ONLY public."public.LiteraryWorks"
    ADD CONSTRAINT lw_category_fk FOREIGN KEY (category) REFERENCES public."public.LWCategories"(category_id);


-- Completed on 2023-04-13 18:05:42

--
-- PostgreSQL database dump complete
--

