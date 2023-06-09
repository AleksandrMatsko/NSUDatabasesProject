PGDMP         !                {            matsko_library_fund     15.1 (Ubuntu 15.1-1.pgdg22.04+1)    15.2 �               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                        0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            !           1262    23212    matsko_library_fund    DATABASE        CREATE DATABASE matsko_library_fund WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';
 #   DROP DATABASE matsko_library_fund;
                amatsko20205    false            �            1255    37271    authors_cascade_del()    FUNCTION     �   CREATE FUNCTION public.authors_cascade_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		DELETE FROM "public.AuthorsWorks" WHERE author_id = OLD.author_id;
		RETURN OLD;
	END;
$$;
 ,   DROP FUNCTION public.authors_cascade_del();
       public          amatsko20205    false            �            1255    37265    book_cascade_del()    FUNCTION     �   CREATE FUNCTION public.book_cascade_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		DELETE FROM "public.StorageInfo" SI WHERE SI.book_id = OLD.book_id;
		RETURN NEW;
	END;
$$;
 )   DROP FUNCTION public.book_cascade_del();
       public          amatsko20205    false                       1255    38039    change_user_category()    FUNCTION     �  CREATE FUNCTION public.change_user_category() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		old_u_category INTEGER;
		associated_table TEXT;
		
	BEGIN
		IF NOT (OLD.category_id = NEW.category_id) THEN
			SELECT "table_name" INTO associated_table FROM "public.UserCategories" UC
				WHERE UC.category_id = OLD.category_id;
			EXECUTE 'DELETE FROM public."'||associated_table||'" WHERE user_id = '||OLD.user_id||';';
		END IF;
		RETURN NEW;
	END;
$$;
 -   DROP FUNCTION public.change_user_category();
       public          amatsko20205    false                       1255    38045 (   delete_user_category_info(text, integer)    FUNCTION     �   CREATE FUNCTION public.delete_user_category_info(associated_table text, delid integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
		
	BEGIN
		EXECUTE 'DELETE FROM public."'||associated_table||'" WHERE user_id = '||delId||';';
		RETURN 0;
	END;
$$;
 V   DROP FUNCTION public.delete_user_category_info(associated_table text, delid integer);
       public          amatsko20205    false                       1255    30548     is_book_example_already_issued()    FUNCTION     �  CREATE FUNCTION public.is_book_example_already_issued() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		date_issue_prev DATE;
		
	BEGIN
		SELECT IJ.date_issue INTO date_issue_prev
			FROM "public.IssueJournal" IJ
			WHERE IJ.stored_id = NEW.stored_id AND IJ.date_return IS NULL;
		IF date_issue_prev IS NOT NULL AND NEW.date_issue > date_issue_prev THEN
			RAISE EXCEPTION 'cannot issue book with stored_id %, it has already been issued', NEW.stored_id;
		END IF;
		RETURN NEW;
	END;
$$;
 7   DROP FUNCTION public.is_book_example_already_issued();
       public          amatsko20205    false                       1255    30543    is_book_example_dispose()    FUNCTION     �  CREATE FUNCTION public.is_book_example_dispose() RETURNS trigger
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
 0   DROP FUNCTION public.is_book_example_dispose();
       public          amatsko20205    false            �            1255    30546    is_book_example_issued()    FUNCTION     �  CREATE FUNCTION public.is_book_example_issued() RETURNS trigger
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
 /   DROP FUNCTION public.is_book_example_issued();
       public          amatsko20205    false                       1255    30538 +   is_dates_from_range(date, date, date, date)    FUNCTION     r  CREATE FUNCTION public.is_dates_from_range(start_date_range date, end_date_range date, start_date date, end_date date) RETURNS boolean
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
 v   DROP FUNCTION public.is_dates_from_range(start_date_range date, end_date_range date, start_date date, end_date date);
       public          amatsko20205    false                       1255    30555    is_librn_from_lib_ij()    FUNCTION       CREATE FUNCTION public.is_librn_from_lib_ij() RETURNS trigger
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
 -   DROP FUNCTION public.is_librn_from_lib_ij();
       public          amatsko20205    false            	           1255    30553    is_librn_from_lib_rj()    FUNCTION     �  CREATE FUNCTION public.is_librn_from_lib_rj() RETURNS trigger
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
 -   DROP FUNCTION public.is_librn_from_lib_rj();
       public          amatsko20205    false            �            1255    30476    is_lw_from_category()    FUNCTION       CREATE FUNCTION public.is_lw_from_category() RETURNS trigger
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
 ,   DROP FUNCTION public.is_lw_from_category();
       public          amatsko20205    false                       1255    30550    is_reg_before_issue()    FUNCTION     �  CREATE FUNCTION public.is_reg_before_issue() RETURNS trigger
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
 ,   DROP FUNCTION public.is_reg_before_issue();
       public          amatsko20205    false                       1255    30407    is_user_from_category()    FUNCTION     �  CREATE FUNCTION public.is_user_from_category() RETURNS trigger
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
 .   DROP FUNCTION public.is_user_from_category();
       public          amatsko20205    false                       1255    30539    librarian_is_working_ij()    FUNCTION     �  CREATE FUNCTION public.librarian_is_working_ij() RETURNS trigger
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
 0   DROP FUNCTION public.librarian_is_working_ij();
       public          amatsko20205    false                       1255    30541    librarian_is_working_rj()    FUNCTION     $  CREATE FUNCTION public.librarian_is_working_rj() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		lbrn_date_hired DATE;
		lbrn_date_retired DATE;
		
	BEGIN
		SELECT date_hired, date_retired INTO lbrn_date_hired, lbrn_date_retired 
			FROM "public.Librarians" L
			WHERE L.librarian_id = NEW.librarian_id;
		IF NOT(is_dates_from_range(lbrn_date_hired, lbrn_date_retired, NEW.registration_date, NULL)) THEN
			RAISE EXCEPTION 'librarian with id % cannot register user, he is not working', NEW.librarian_id;
		END IF;
		RETURN NEW;
	END;
$$;
 0   DROP FUNCTION public.librarian_is_working_rj();
       public          amatsko20205    false            �            1255    37268    librn_cascade_del()    FUNCTION     �   CREATE FUNCTION public.librn_cascade_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		UPDATE "public.Librarians" SET date_retired = NOW() WHERE librarian_id = OLD.librarian_id;
		RETURN NEW;
	END;
$$;
 *   DROP FUNCTION public.librn_cascade_del();
       public          amatsko20205    false                       1255    37261    lw_cascade_del()    FUNCTION     -  CREATE FUNCTION public.lw_cascade_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		category_table_name TEXT;
		
	BEGIN
		SELECT "table_name" INTO category_table_name
		FROM "public.LWCategories" LWC
		INNER JOIN "public.LiteraryWorks" LW
		ON LW.category = LWC.category_id
		WHERE LW.lw_id = OLD.lw_id;
		
		EXECUTE 'DELETE FROM public."'||category_table_name||'" WHERE lw_id = '||OLD.lw_id||';';
		DELETE FROM "public.WorksInBook" WHERE lw_id = OLD.lw_id;
		DELETE FROM "public.AuthorsWorks" WHERE lw_id = OLD.lw_id;
		RETURN OLD;
	END;
$$;
 '   DROP FUNCTION public.lw_cascade_del();
       public          amatsko20205    false            �            1255    37263    si_cascade_del()    FUNCTION     +  CREATE FUNCTION public.si_cascade_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		DELETE FROM "public.IssueJournal" WHERE stored_id = OLD.stored_id AND date_return IS NULL;
		UPDATE "public.StorageInfo" SET date_dispose = NOW() WHERE stored_id = OLD.stored_id;
		RETURN NEW;
	END;
$$;
 '   DROP FUNCTION public.si_cascade_del();
       public          amatsko20205    false                       1255    37259    user_cascade_del()    FUNCTION     <  CREATE FUNCTION public.user_cascade_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	DECLARE
		category_table_name TEXT;
		
	BEGIN
		SELECT "table_name" INTO category_table_name
		FROM "public.UserCategories" UC
		INNER JOIN "public.Users" U
		ON U.category = UC.category_id
		WHERE U.user_id = OLD.user_id;
		
		EXECUTE 'DELETE FROM public."'||category_table_name||'" WHERE user_id = '||OLD.user_id||';';
		DELETE FROM "public.RegistrationJournal" WHERE user_id = OLD.user_id;
		DELETE FROM "public.IssueJournal" WHERE user_id = OLD.user_id;
		RETURN OLD;
	END;
$$;
 )   DROP FUNCTION public.user_cascade_del();
       public          amatsko20205    false            �            1259    23307    public.Authors    TABLE     �   CREATE TABLE public."public.Authors" (
    author_id integer NOT NULL,
    last_name text NOT NULL,
    first_name text NOT NULL,
    patronymic text
);
 $   DROP TABLE public."public.Authors";
       public         heap    amatsko20205    false            �            1259    23315    public.AuthorsWorks    TABLE     j   CREATE TABLE public."public.AuthorsWorks" (
    lw_id integer NOT NULL,
    author_id integer NOT NULL
);
 )   DROP TABLE public."public.AuthorsWorks";
       public         heap    amatsko20205    false            �            1259    23306    public.Authors_author_id_seq    SEQUENCE     �   CREATE SEQUENCE public."public.Authors_author_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."public.Authors_author_id_seq";
       public          amatsko20205    false    235            "           0    0    public.Authors_author_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."public.Authors_author_id_seq" OWNED BY public."public.Authors".author_id;
          public          amatsko20205    false    234            �            1259    23284    public.Books    TABLE     ]   CREATE TABLE public."public.Books" (
    book_id integer NOT NULL,
    name text NOT NULL
);
 "   DROP TABLE public."public.Books";
       public         heap    amatsko20205    false            �            1259    23283    public.Books_book_id_seq    SEQUENCE     �   CREATE SEQUENCE public."public.Books_book_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."public.Books_book_id_seq";
       public          amatsko20205    false    230            #           0    0    public.Books_book_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."public.Books_book_id_seq" OWNED BY public."public.Books".book_id;
          public          amatsko20205    false    229            �            1259    23261    public.Halls    TABLE     f   CREATE TABLE public."public.Halls" (
    hall_id integer NOT NULL,
    library_id integer NOT NULL
);
 "   DROP TABLE public."public.Halls";
       public         heap    amatsko20205    false            �            1259    23260    public.Halls_hall_id_seq    SEQUENCE     �   CREATE SEQUENCE public."public.Halls_hall_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."public.Halls_hall_id_seq";
       public          amatsko20205    false    225            $           0    0    public.Halls_hall_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."public.Halls_hall_id_seq" OWNED BY public."public.Halls".hall_id;
          public          amatsko20205    false    224            �            1259    23328    public.IssueJournal    TABLE     �  CREATE TABLE public."public.IssueJournal" (
    stored_id integer NOT NULL,
    date_issue date NOT NULL,
    date_return date,
    user_id integer NOT NULL,
    issued_by_lbrn integer NOT NULL,
    accepted_by_lbrn integer,
    issue_id integer NOT NULL,
    CONSTRAINT consistent_return CHECK ((((date_return IS NULL) AND (accepted_by_lbrn IS NULL)) OR ((date_return IS NOT NULL) AND (accepted_by_lbrn IS NOT NULL)))),
    CONSTRAINT date_issue_lower_date_return CHECK ((((date_return IS NOT NULL) AND (date_issue <= date_return) AND (date_issue <= now()) AND (date_return <= now())) OR ((date_return IS NULL) AND (date_issue <= now()))))
);
 )   DROP TABLE public."public.IssueJournal";
       public         heap    amatsko20205    false            �            1259    35764     public.IssueJournal_issue_id_seq    SEQUENCE     �   CREATE SEQUENCE public."public.IssueJournal_issue_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."public.IssueJournal_issue_id_seq";
       public          amatsko20205    false    239            %           0    0     public.IssueJournal_issue_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public."public.IssueJournal_issue_id_seq" OWNED BY public."public.IssueJournal".issue_id;
          public          amatsko20205    false    248            �            1259    30459    public.LWCategories    TABLE     �   CREATE TABLE public."public.LWCategories" (
    category_id integer NOT NULL,
    category_name text NOT NULL,
    table_name text NOT NULL
);
 )   DROP TABLE public."public.LWCategories";
       public         heap    amatsko20205    false            �            1259    30458 #   public.LWCategories_category_id_seq    SEQUENCE     �   CREATE SEQUENCE public."public.LWCategories_category_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."public.LWCategories_category_id_seq";
       public          amatsko20205    false    247            &           0    0 #   public.LWCategories_category_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public."public.LWCategories_category_id_seq" OWNED BY public."public.LWCategories".category_id;
          public          amatsko20205    false    246            �            1259    23268    public.Librarians    TABLE     �  CREATE TABLE public."public.Librarians" (
    librarian_id integer NOT NULL,
    hall_id integer NOT NULL,
    last_name text NOT NULL,
    first_name text NOT NULL,
    patronymic text,
    date_hired date NOT NULL,
    date_retired date,
    CONSTRAINT date_hired_lower_date_retired CHECK ((((date_retired IS NOT NULL) AND (date_hired <= date_retired) AND (date_hired <= now()) AND (date_retired <= now())) OR ((date_retired IS NULL) AND (date_hired <= now()))))
);
 '   DROP TABLE public."public.Librarians";
       public         heap    amatsko20205    false            �            1259    23267 "   public.Librarians_librarian_id_seq    SEQUENCE     �   CREATE SEQUENCE public."public.Librarians_librarian_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public."public.Librarians_librarian_id_seq";
       public          amatsko20205    false    227            '           0    0 "   public.Librarians_librarian_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."public.Librarians_librarian_id_seq" OWNED BY public."public.Librarians".librarian_id;
          public          amatsko20205    false    226            �            1259    23252    public.Libraries    TABLE     �   CREATE TABLE public."public.Libraries" (
    library_id integer NOT NULL,
    district text NOT NULL,
    street text NOT NULL,
    building text NOT NULL,
    name text NOT NULL
);
 &   DROP TABLE public."public.Libraries";
       public         heap    amatsko20205    false            �            1259    23251    public.Libraries_library_id_seq    SEQUENCE     �   CREATE SEQUENCE public."public.Libraries_library_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public."public.Libraries_library_id_seq";
       public          amatsko20205    false    223            (           0    0    public.Libraries_library_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public."public.Libraries_library_id_seq" OWNED BY public."public.Libraries".library_id;
          public          amatsko20205    false    222            �            1259    23293    public.LiteraryWorks    TABLE     y   CREATE TABLE public."public.LiteraryWorks" (
    lw_id integer NOT NULL,
    name text NOT NULL,
    category integer
);
 *   DROP TABLE public."public.LiteraryWorks";
       public         heap    amatsko20205    false            �            1259    23292    public.LiteraryWorks_lw_id_seq    SEQUENCE     �   CREATE SEQUENCE public."public.LiteraryWorks_lw_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public."public.LiteraryWorks_lw_id_seq";
       public          amatsko20205    false    232            )           0    0    public.LiteraryWorks_lw_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public."public.LiteraryWorks_lw_id_seq" OWNED BY public."public.LiteraryWorks".lw_id;
          public          amatsko20205    false    231            �            1259    23331    public.Novels    TABLE        CREATE TABLE public."public.Novels" (
    lw_id integer NOT NULL,
    number_chapters integer NOT NULL,
    short_desc text
);
 #   DROP TABLE public."public.Novels";
       public         heap    amatsko20205    false            �            1259    23247    public.Pensioners    TABLE     �   CREATE TABLE public."public.Pensioners" (
    user_id integer NOT NULL,
    discount integer NOT NULL,
    CONSTRAINT percent_check CHECK (((discount >= 0) AND (discount <= 100)))
);
 '   DROP TABLE public."public.Pensioners";
       public         heap    amatsko20205    false            �            1259    23350    public.Poems    TABLE     �   CREATE TABLE public."public.Poems" (
    lw_id integer NOT NULL,
    rhyming_method text NOT NULL,
    verse_size text NOT NULL
);
 "   DROP TABLE public."public.Poems";
       public         heap    amatsko20205    false            �            1259    23242    public.Pupils    TABLE     `   CREATE TABLE public."public.Pupils" (
    user_id integer NOT NULL,
    school text NOT NULL
);
 #   DROP TABLE public."public.Pupils";
       public         heap    amatsko20205    false            �            1259    23276    public.RegistrationJournal    TABLE       CREATE TABLE public."public.RegistrationJournal" (
    user_id integer NOT NULL,
    librarian_id integer NOT NULL,
    registration_date date NOT NULL,
    library_id integer NOT NULL,
    CONSTRAINT registration_date_lower_now CHECK ((registration_date <= now()))
);
 0   DROP TABLE public."public.RegistrationJournal";
       public         heap    amatsko20205    false            �            1259    23338    public.ScientificArticles    TABLE     n   CREATE TABLE public."public.ScientificArticles" (
    lw_id integer NOT NULL,
    date_issue date NOT NULL
);
 /   DROP TABLE public."public.ScientificArticles";
       public         heap    amatsko20205    false            �            1259    23222    public.Scientists    TABLE     d   CREATE TABLE public."public.Scientists" (
    user_id integer NOT NULL,
    degree text NOT NULL
);
 '   DROP TABLE public."public.Scientists";
       public         heap    amatsko20205    false            �            1259    23321    public.StorageInfo    TABLE     0  CREATE TABLE public."public.StorageInfo" (
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
 (   DROP TABLE public."public.StorageInfo";
       public         heap    amatsko20205    false            �            1259    23320     public.StorageInfo_stored_id_seq    SEQUENCE     �   CREATE SEQUENCE public."public.StorageInfo_stored_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public."public.StorageInfo_stored_id_seq";
       public          amatsko20205    false    238            *           0    0     public.StorageInfo_stored_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public."public.StorageInfo_stored_id_seq" OWNED BY public."public.StorageInfo".stored_id;
          public          amatsko20205    false    237            �            1259    23227    public.Students    TABLE     �   CREATE TABLE public."public.Students" (
    user_id integer NOT NULL,
    faculty text NOT NULL,
    university character varying(150) NOT NULL
);
 %   DROP TABLE public."public.Students";
       public         heap    amatsko20205    false            �            1259    23237    public.Teachers    TABLE     }   CREATE TABLE public."public.Teachers" (
    user_id integer NOT NULL,
    school text NOT NULL,
    subject text NOT NULL
);
 %   DROP TABLE public."public.Teachers";
       public         heap    amatsko20205    false            �            1259    23343    public.Textbooks    TABLE     �   CREATE TABLE public."public.Textbooks" (
    lw_id integer NOT NULL,
    subject text NOT NULL,
    complexity_level text NOT NULL
);
 &   DROP TABLE public."public.Textbooks";
       public         heap    amatsko20205    false            �            1259    30415    public.UserCategories    TABLE     �   CREATE TABLE public."public.UserCategories" (
    category_id integer NOT NULL,
    category_name text NOT NULL,
    table_name text NOT NULL
);
 +   DROP TABLE public."public.UserCategories";
       public         heap    amatsko20205    false            �            1259    30414 %   public.UserCategories_category_id_seq    SEQUENCE     �   CREATE SEQUENCE public."public.UserCategories_category_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public."public.UserCategories_category_id_seq";
       public          amatsko20205    false    245            +           0    0 %   public.UserCategories_category_id_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."public.UserCategories_category_id_seq" OWNED BY public."public.UserCategories".category_id;
          public          amatsko20205    false    244            �            1259    23214    public.Users    TABLE     �   CREATE TABLE public."public.Users" (
    user_id integer NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    patronymic text,
    category integer
);
 "   DROP TABLE public."public.Users";
       public         heap    amatsko20205    false            �            1259    23213    public.Users_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public."public.Users_user_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."public.Users_user_id_seq";
       public          amatsko20205    false    215            ,           0    0    public.Users_user_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."public.Users_user_id_seq" OWNED BY public."public.Users".user_id;
          public          amatsko20205    false    214            �            1259    23232    public.Workers    TABLE     y   CREATE TABLE public."public.Workers" (
    user_id integer NOT NULL,
    job text NOT NULL,
    company text NOT NULL
);
 $   DROP TABLE public."public.Workers";
       public         heap    amatsko20205    false            �            1259    23301    public.WorksInBook    TABLE     g   CREATE TABLE public."public.WorksInBook" (
    book_id integer NOT NULL,
    lw_id integer NOT NULL
);
 (   DROP TABLE public."public.WorksInBook";
       public         heap    amatsko20205    false            �           2604    23310    public.Authors author_id    DEFAULT     �   ALTER TABLE ONLY public."public.Authors" ALTER COLUMN author_id SET DEFAULT nextval('public."public.Authors_author_id_seq"'::regclass);
 I   ALTER TABLE public."public.Authors" ALTER COLUMN author_id DROP DEFAULT;
       public          amatsko20205    false    234    235    235            �           2604    23287    public.Books book_id    DEFAULT     �   ALTER TABLE ONLY public."public.Books" ALTER COLUMN book_id SET DEFAULT nextval('public."public.Books_book_id_seq"'::regclass);
 E   ALTER TABLE public."public.Books" ALTER COLUMN book_id DROP DEFAULT;
       public          amatsko20205    false    229    230    230            �           2604    23264    public.Halls hall_id    DEFAULT     �   ALTER TABLE ONLY public."public.Halls" ALTER COLUMN hall_id SET DEFAULT nextval('public."public.Halls_hall_id_seq"'::regclass);
 E   ALTER TABLE public."public.Halls" ALTER COLUMN hall_id DROP DEFAULT;
       public          amatsko20205    false    225    224    225            �           2604    35765    public.IssueJournal issue_id    DEFAULT     �   ALTER TABLE ONLY public."public.IssueJournal" ALTER COLUMN issue_id SET DEFAULT nextval('public."public.IssueJournal_issue_id_seq"'::regclass);
 M   ALTER TABLE public."public.IssueJournal" ALTER COLUMN issue_id DROP DEFAULT;
       public          amatsko20205    false    248    239            �           2604    30462    public.LWCategories category_id    DEFAULT     �   ALTER TABLE ONLY public."public.LWCategories" ALTER COLUMN category_id SET DEFAULT nextval('public."public.LWCategories_category_id_seq"'::regclass);
 P   ALTER TABLE public."public.LWCategories" ALTER COLUMN category_id DROP DEFAULT;
       public          amatsko20205    false    247    246    247            �           2604    23271    public.Librarians librarian_id    DEFAULT     �   ALTER TABLE ONLY public."public.Librarians" ALTER COLUMN librarian_id SET DEFAULT nextval('public."public.Librarians_librarian_id_seq"'::regclass);
 O   ALTER TABLE public."public.Librarians" ALTER COLUMN librarian_id DROP DEFAULT;
       public          amatsko20205    false    226    227    227            �           2604    23255    public.Libraries library_id    DEFAULT     �   ALTER TABLE ONLY public."public.Libraries" ALTER COLUMN library_id SET DEFAULT nextval('public."public.Libraries_library_id_seq"'::regclass);
 L   ALTER TABLE public."public.Libraries" ALTER COLUMN library_id DROP DEFAULT;
       public          amatsko20205    false    223    222    223            �           2604    23296    public.LiteraryWorks lw_id    DEFAULT     �   ALTER TABLE ONLY public."public.LiteraryWorks" ALTER COLUMN lw_id SET DEFAULT nextval('public."public.LiteraryWorks_lw_id_seq"'::regclass);
 K   ALTER TABLE public."public.LiteraryWorks" ALTER COLUMN lw_id DROP DEFAULT;
       public          amatsko20205    false    231    232    232            �           2604    23324    public.StorageInfo stored_id    DEFAULT     �   ALTER TABLE ONLY public."public.StorageInfo" ALTER COLUMN stored_id SET DEFAULT nextval('public."public.StorageInfo_stored_id_seq"'::regclass);
 M   ALTER TABLE public."public.StorageInfo" ALTER COLUMN stored_id DROP DEFAULT;
       public          amatsko20205    false    238    237    238            �           2604    30418 !   public.UserCategories category_id    DEFAULT     �   ALTER TABLE ONLY public."public.UserCategories" ALTER COLUMN category_id SET DEFAULT nextval('public."public.UserCategories_category_id_seq"'::regclass);
 R   ALTER TABLE public."public.UserCategories" ALTER COLUMN category_id DROP DEFAULT;
       public          amatsko20205    false    245    244    245            �           2604    23217    public.Users user_id    DEFAULT     �   ALTER TABLE ONLY public."public.Users" ALTER COLUMN user_id SET DEFAULT nextval('public."public.Users_user_id_seq"'::regclass);
 E   ALTER TABLE public."public.Users" ALTER COLUMN user_id DROP DEFAULT;
       public          amatsko20205    false    214    215    215                      0    23307    public.Authors 
   TABLE DATA           X   COPY public."public.Authors" (author_id, last_name, first_name, patronymic) FROM stdin;
    public          amatsko20205    false    235   m,                0    23315    public.AuthorsWorks 
   TABLE DATA           A   COPY public."public.AuthorsWorks" (lw_id, author_id) FROM stdin;
    public          amatsko20205    false    236   �-      	          0    23284    public.Books 
   TABLE DATA           7   COPY public."public.Books" (book_id, name) FROM stdin;
    public          amatsko20205    false    230   .                0    23261    public.Halls 
   TABLE DATA           =   COPY public."public.Halls" (hall_id, library_id) FROM stdin;
    public          amatsko20205    false    225   E/                0    23328    public.IssueJournal 
   TABLE DATA           �   COPY public."public.IssueJournal" (stored_id, date_issue, date_return, user_id, issued_by_lbrn, accepted_by_lbrn, issue_id) FROM stdin;
    public          amatsko20205    false    239   �/                0    30459    public.LWCategories 
   TABLE DATA           W   COPY public."public.LWCategories" (category_id, category_name, table_name) FROM stdin;
    public          amatsko20205    false    247   ?0                0    23268    public.Librarians 
   TABLE DATA           �   COPY public."public.Librarians" (librarian_id, hall_id, last_name, first_name, patronymic, date_hired, date_retired) FROM stdin;
    public          amatsko20205    false    227   �0                0    23252    public.Libraries 
   TABLE DATA           Z   COPY public."public.Libraries" (library_id, district, street, building, name) FROM stdin;
    public          amatsko20205    false    223   2                0    23293    public.LiteraryWorks 
   TABLE DATA           G   COPY public."public.LiteraryWorks" (lw_id, name, category) FROM stdin;
    public          amatsko20205    false    232   m3                0    23331    public.Novels 
   TABLE DATA           M   COPY public."public.Novels" (lw_id, number_chapters, short_desc) FROM stdin;
    public          amatsko20205    false    240   5                 0    23247    public.Pensioners 
   TABLE DATA           @   COPY public."public.Pensioners" (user_id, discount) FROM stdin;
    public          amatsko20205    false    221   /6                0    23350    public.Poems 
   TABLE DATA           K   COPY public."public.Poems" (lw_id, rhyming_method, verse_size) FROM stdin;
    public          amatsko20205    false    243   W6      �          0    23242    public.Pupils 
   TABLE DATA           :   COPY public."public.Pupils" (user_id, school) FROM stdin;
    public          amatsko20205    false    220   �6                0    23276    public.RegistrationJournal 
   TABLE DATA           l   COPY public."public.RegistrationJournal" (user_id, librarian_id, registration_date, library_id) FROM stdin;
    public          amatsko20205    false    228   �6                0    23338    public.ScientificArticles 
   TABLE DATA           H   COPY public."public.ScientificArticles" (lw_id, date_issue) FROM stdin;
    public          amatsko20205    false    241   �7      �          0    23222    public.Scientists 
   TABLE DATA           >   COPY public."public.Scientists" (user_id, degree) FROM stdin;
    public          amatsko20205    false    216   �7                0    23321    public.StorageInfo 
   TABLE DATA           �   COPY public."public.StorageInfo" (stored_id, hall_id, bookcase, shelf, book_id, available_issue, duration_issue, date_receipt, date_dispose) FROM stdin;
    public          amatsko20205    false    238   ?8      �          0    23227    public.Students 
   TABLE DATA           I   COPY public."public.Students" (user_id, faculty, university) FROM stdin;
    public          amatsko20205    false    217   |9      �          0    23237    public.Teachers 
   TABLE DATA           E   COPY public."public.Teachers" (user_id, school, subject) FROM stdin;
    public          amatsko20205    false    219   �9                0    23343    public.Textbooks 
   TABLE DATA           N   COPY public."public.Textbooks" (lw_id, subject, complexity_level) FROM stdin;
    public          amatsko20205    false    242   :                0    30415    public.UserCategories 
   TABLE DATA           Y   COPY public."public.UserCategories" (category_id, category_name, table_name) FROM stdin;
    public          amatsko20205    false    245   ^:      �          0    23214    public.Users 
   TABLE DATA           ^   COPY public."public.Users" (user_id, first_name, last_name, patronymic, category) FROM stdin;
    public          amatsko20205    false    215   �:      �          0    23232    public.Workers 
   TABLE DATA           A   COPY public."public.Workers" (user_id, job, company) FROM stdin;
    public          amatsko20205    false    218   x<                0    23301    public.WorksInBook 
   TABLE DATA           >   COPY public."public.WorksInBook" (book_id, lw_id) FROM stdin;
    public          amatsko20205    false    233   �<      -           0    0    public.Authors_author_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."public.Authors_author_id_seq"', 19, true);
          public          amatsko20205    false    234            .           0    0    public.Books_book_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."public.Books_book_id_seq"', 25, true);
          public          amatsko20205    false    229            /           0    0    public.Halls_hall_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."public.Halls_hall_id_seq"', 20, true);
          public          amatsko20205    false    224            0           0    0     public.IssueJournal_issue_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."public.IssueJournal_issue_id_seq"', 16, true);
          public          amatsko20205    false    248            1           0    0 #   public.LWCategories_category_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public."public.LWCategories_category_id_seq"', 4, true);
          public          amatsko20205    false    246            2           0    0 "   public.Librarians_librarian_id_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public."public.Librarians_librarian_id_seq"', 11, true);
          public          amatsko20205    false    226            3           0    0    public.Libraries_library_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."public.Libraries_library_id_seq"', 8, true);
          public          amatsko20205    false    222            4           0    0    public.LiteraryWorks_lw_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."public.LiteraryWorks_lw_id_seq"', 45, true);
          public          amatsko20205    false    231            5           0    0     public.StorageInfo_stored_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public."public.StorageInfo_stored_id_seq"', 46, true);
          public          amatsko20205    false    237            6           0    0 %   public.UserCategories_category_id_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."public.UserCategories_category_id_seq"', 6, true);
          public          amatsko20205    false    244            7           0    0    public.Users_user_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."public.Users_user_id_seq"', 36, true);
          public          amatsko20205    false    214                       2606    23314    public.Authors Authors_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public."public.Authors"
    ADD CONSTRAINT "Authors_pk" PRIMARY KEY (author_id);
 G   ALTER TABLE ONLY public."public.Authors" DROP CONSTRAINT "Authors_pk";
       public            amatsko20205    false    235                       2606    23291    public.Books Books_pk 
   CONSTRAINT     \   ALTER TABLE ONLY public."public.Books"
    ADD CONSTRAINT "Books_pk" PRIMARY KEY (book_id);
 C   ALTER TABLE ONLY public."public.Books" DROP CONSTRAINT "Books_pk";
       public            amatsko20205    false    230                       2606    23266    public.Halls Halls_pk 
   CONSTRAINT     \   ALTER TABLE ONLY public."public.Halls"
    ADD CONSTRAINT "Halls_pk" PRIMARY KEY (hall_id);
 C   ALTER TABLE ONLY public."public.Halls" DROP CONSTRAINT "Halls_pk";
       public            amatsko20205    false    225            3           2606    30466 #   public.LWCategories LWCategories_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public."public.LWCategories"
    ADD CONSTRAINT "LWCategories_pk" PRIMARY KEY (category_id);
 Q   ALTER TABLE ONLY public."public.LWCategories" DROP CONSTRAINT "LWCategories_pk";
       public            amatsko20205    false    247            	           2606    23275    public.Librarians Librarians_pk 
   CONSTRAINT     k   ALTER TABLE ONLY public."public.Librarians"
    ADD CONSTRAINT "Librarians_pk" PRIMARY KEY (librarian_id);
 M   ALTER TABLE ONLY public."public.Librarians" DROP CONSTRAINT "Librarians_pk";
       public            amatsko20205    false    227                       2606    23259    public.Libraries Libraries_pk 
   CONSTRAINT     g   ALTER TABLE ONLY public."public.Libraries"
    ADD CONSTRAINT "Libraries_pk" PRIMARY KEY (library_id);
 K   ALTER TABLE ONLY public."public.Libraries" DROP CONSTRAINT "Libraries_pk";
       public            amatsko20205    false    223                       2606    23300 %   public.LiteraryWorks LiteraryWorks_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public."public.LiteraryWorks"
    ADD CONSTRAINT "LiteraryWorks_pk" PRIMARY KEY (lw_id);
 S   ALTER TABLE ONLY public."public.LiteraryWorks" DROP CONSTRAINT "LiteraryWorks_pk";
       public            amatsko20205    false    232                       2606    23485    public.Novels Novels_unique_lw 
   CONSTRAINT     ^   ALTER TABLE ONLY public."public.Novels"
    ADD CONSTRAINT "Novels_unique_lw" UNIQUE (lw_id);
 L   ALTER TABLE ONLY public."public.Novels" DROP CONSTRAINT "Novels_unique_lw";
       public            amatsko20205    false    240                       2606    23483 (   public.Pensioners Pensioners_unique_user 
   CONSTRAINT     j   ALTER TABLE ONLY public."public.Pensioners"
    ADD CONSTRAINT "Pensioners_unique_user" UNIQUE (user_id);
 V   ALTER TABLE ONLY public."public.Pensioners" DROP CONSTRAINT "Pensioners_unique_user";
       public            amatsko20205    false    221            )           2606    23491    public.Poems Poems_unique_lw 
   CONSTRAINT     \   ALTER TABLE ONLY public."public.Poems"
    ADD CONSTRAINT "Poems_unique_lw" UNIQUE (lw_id);
 J   ALTER TABLE ONLY public."public.Poems" DROP CONSTRAINT "Poems_unique_lw";
       public            amatsko20205    false    243                       2606    23481     public.Pupils Pupils_unique_user 
   CONSTRAINT     b   ALTER TABLE ONLY public."public.Pupils"
    ADD CONSTRAINT "Pupils_unique_user" UNIQUE (user_id);
 N   ALTER TABLE ONLY public."public.Pupils" DROP CONSTRAINT "Pupils_unique_user";
       public            amatsko20205    false    220            !           2606    23487 6   public.ScientificArticles ScientificArticles_unique_lw 
   CONSTRAINT     v   ALTER TABLE ONLY public."public.ScientificArticles"
    ADD CONSTRAINT "ScientificArticles_unique_lw" UNIQUE (lw_id);
 d   ALTER TABLE ONLY public."public.ScientificArticles" DROP CONSTRAINT "ScientificArticles_unique_lw";
       public            amatsko20205    false    241            �           2606    23473 (   public.Scientists Scientists_unique_user 
   CONSTRAINT     j   ALTER TABLE ONLY public."public.Scientists"
    ADD CONSTRAINT "Scientists_unique_user" UNIQUE (user_id);
 V   ALTER TABLE ONLY public."public.Scientists" DROP CONSTRAINT "Scientists_unique_user";
       public            amatsko20205    false    216                       2606    23326 !   public.StorageInfo StorageInfo_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public."public.StorageInfo"
    ADD CONSTRAINT "StorageInfo_pk" PRIMARY KEY (stored_id);
 O   ALTER TABLE ONLY public."public.StorageInfo" DROP CONSTRAINT "StorageInfo_pk";
       public            amatsko20205    false    238            �           2606    23475 $   public.Students Students_unique_user 
   CONSTRAINT     f   ALTER TABLE ONLY public."public.Students"
    ADD CONSTRAINT "Students_unique_user" UNIQUE (user_id);
 R   ALTER TABLE ONLY public."public.Students" DROP CONSTRAINT "Students_unique_user";
       public            amatsko20205    false    217            �           2606    23479 $   public.Teachers Teachers_unique_user 
   CONSTRAINT     f   ALTER TABLE ONLY public."public.Teachers"
    ADD CONSTRAINT "Teachers_unique_user" UNIQUE (user_id);
 R   ALTER TABLE ONLY public."public.Teachers" DROP CONSTRAINT "Teachers_unique_user";
       public            amatsko20205    false    219            %           2606    23489 $   public.Textbooks Textbooks_unique_lw 
   CONSTRAINT     d   ALTER TABLE ONLY public."public.Textbooks"
    ADD CONSTRAINT "Textbooks_unique_lw" UNIQUE (lw_id);
 R   ALTER TABLE ONLY public."public.Textbooks" DROP CONSTRAINT "Textbooks_unique_lw";
       public            amatsko20205    false    242            -           2606    30422 '   public.UserCategories UserCategories_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public."public.UserCategories"
    ADD CONSTRAINT "UserCategories_pk" PRIMARY KEY (category_id);
 U   ALTER TABLE ONLY public."public.UserCategories" DROP CONSTRAINT "UserCategories_pk";
       public            amatsko20205    false    245            �           2606    23221    public.Users Users_pk 
   CONSTRAINT     \   ALTER TABLE ONLY public."public.Users"
    ADD CONSTRAINT "Users_pk" PRIMARY KEY (user_id);
 C   ALTER TABLE ONLY public."public.Users" DROP CONSTRAINT "Users_pk";
       public            amatsko20205    false    215            �           2606    23477 "   public.Workers Workers_unique_user 
   CONSTRAINT     d   ALTER TABLE ONLY public."public.Workers"
    ADD CONSTRAINT "Workers_unique_user" UNIQUE (user_id);
 P   ALTER TABLE ONLY public."public.Workers" DROP CONSTRAINT "Workers_unique_user";
       public            amatsko20205    false    218                       2606    23319 0   public.AuthorsWorks no_authors_duplication_in_lw 
   CONSTRAINT     y   ALTER TABLE ONLY public."public.AuthorsWorks"
    ADD CONSTRAINT no_authors_duplication_in_lw UNIQUE (lw_id, author_id);
 \   ALTER TABLE ONLY public."public.AuthorsWorks" DROP CONSTRAINT no_authors_duplication_in_lw;
       public            amatsko20205    false    236    236                       2606    23305 /   public.WorksInBook no_duplicates_lworks_in_book 
   CONSTRAINT     v   ALTER TABLE ONLY public."public.WorksInBook"
    ADD CONSTRAINT no_duplicates_lworks_in_book UNIQUE (book_id, lw_id);
 [   ALTER TABLE ONLY public."public.WorksInBook" DROP CONSTRAINT no_duplicates_lworks_in_book;
       public            amatsko20205    false    233    233                       2606    35770 ,   public.IssueJournal public.IssueJournal_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."public.IssueJournal"
    ADD CONSTRAINT "public.IssueJournal_pkey" PRIMARY KEY (issue_id);
 Z   ALTER TABLE ONLY public."public.IssueJournal" DROP CONSTRAINT "public.IssueJournal_pkey";
       public            amatsko20205    false    239                       2606    23337 %   public.Novels public.Novels_lw_id_key 
   CONSTRAINT     e   ALTER TABLE ONLY public."public.Novels"
    ADD CONSTRAINT "public.Novels_lw_id_key" UNIQUE (lw_id);
 S   ALTER TABLE ONLY public."public.Novels" DROP CONSTRAINT "public.Novels_lw_id_key";
       public            amatsko20205    false    240            +           2606    23356 #   public.Poems public.Poems_lw_id_key 
   CONSTRAINT     c   ALTER TABLE ONLY public."public.Poems"
    ADD CONSTRAINT "public.Poems_lw_id_key" UNIQUE (lw_id);
 Q   ALTER TABLE ONLY public."public.Poems" DROP CONSTRAINT "public.Poems_lw_id_key";
       public            amatsko20205    false    243                       2606    23280 A   public.RegistrationJournal public.RegistrationJournal_user_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY public."public.RegistrationJournal"
    ADD CONSTRAINT "public.RegistrationJournal_user_id_key" UNIQUE (user_id);
 o   ALTER TABLE ONLY public."public.RegistrationJournal" DROP CONSTRAINT "public.RegistrationJournal_user_id_key";
       public            amatsko20205    false    228            #           2606    23342 =   public.ScientificArticles public.ScientificArticles_lw_id_key 
   CONSTRAINT     }   ALTER TABLE ONLY public."public.ScientificArticles"
    ADD CONSTRAINT "public.ScientificArticles_lw_id_key" UNIQUE (lw_id);
 k   ALTER TABLE ONLY public."public.ScientificArticles" DROP CONSTRAINT "public.ScientificArticles_lw_id_key";
       public            amatsko20205    false    241            '           2606    23349 +   public.Textbooks public.Textbooks_lw_id_key 
   CONSTRAINT     k   ALTER TABLE ONLY public."public.Textbooks"
    ADD CONSTRAINT "public.Textbooks_lw_id_key" UNIQUE (lw_id);
 Y   ALTER TABLE ONLY public."public.Textbooks" DROP CONSTRAINT "public.Textbooks_lw_id_key";
       public            amatsko20205    false    242            /           2606    30424 *   public.UserCategories unique_category_name 
   CONSTRAINT     p   ALTER TABLE ONLY public."public.UserCategories"
    ADD CONSTRAINT unique_category_name UNIQUE (category_name);
 V   ALTER TABLE ONLY public."public.UserCategories" DROP CONSTRAINT unique_category_name;
       public            amatsko20205    false    245            5           2606    30468 &   public.LWCategories unique_lw_category 
   CONSTRAINT     l   ALTER TABLE ONLY public."public.LWCategories"
    ADD CONSTRAINT unique_lw_category UNIQUE (category_name);
 R   ALTER TABLE ONLY public."public.LWCategories" DROP CONSTRAINT unique_lw_category;
       public            amatsko20205    false    247            7           2606    30470 #   public.LWCategories unique_lw_table 
   CONSTRAINT     f   ALTER TABLE ONLY public."public.LWCategories"
    ADD CONSTRAINT unique_lw_table UNIQUE (table_name);
 O   ALTER TABLE ONLY public."public.LWCategories" DROP CONSTRAINT unique_lw_table;
       public            amatsko20205    false    247            1           2606    30426 '   public.UserCategories unique_table_name 
   CONSTRAINT     j   ALTER TABLE ONLY public."public.UserCategories"
    ADD CONSTRAINT unique_table_name UNIQUE (table_name);
 S   ALTER TABLE ONLY public."public.UserCategories" DROP CONSTRAINT unique_table_name;
       public            amatsko20205    false    245                       2606    23282 3   public.RegistrationJournal unique_user_registration 
   CONSTRAINT     s   ALTER TABLE ONLY public."public.RegistrationJournal"
    ADD CONSTRAINT unique_user_registration UNIQUE (user_id);
 _   ALTER TABLE ONLY public."public.RegistrationJournal" DROP CONSTRAINT unique_user_registration;
       public            amatsko20205    false    228            _           2620    37272 *   public.Authors trigger_authors_cascade_del    TRIGGER     �   CREATE TRIGGER trigger_authors_cascade_del BEFORE DELETE ON public."public.Authors" FOR EACH ROW EXECUTE FUNCTION public.authors_cascade_del();
 E   DROP TRIGGER trigger_authors_cascade_del ON public."public.Authors";
       public          amatsko20205    false    253    235            ]           2620    37266 %   public.Books trigger_book_cascade_del    TRIGGER     �   CREATE TRIGGER trigger_book_cascade_del BEFORE DELETE ON public."public.Books" FOR EACH ROW EXECUTE FUNCTION public.book_cascade_del();
 @   DROP TRIGGER trigger_book_cascade_del ON public."public.Books";
       public          amatsko20205    false    252    230            b           2620    30549 :   public.IssueJournal trigger_is_book_example_already_issued    TRIGGER     �   CREATE TRIGGER trigger_is_book_example_already_issued BEFORE INSERT OR UPDATE ON public."public.IssueJournal" FOR EACH ROW EXECUTE FUNCTION public.is_book_example_already_issued();
 U   DROP TRIGGER trigger_is_book_example_already_issued ON public."public.IssueJournal";
       public          amatsko20205    false    239    278            c           2620    30544 3   public.IssueJournal trigger_is_book_example_dispose    TRIGGER     �   CREATE TRIGGER trigger_is_book_example_dispose BEFORE INSERT OR UPDATE ON public."public.IssueJournal" FOR EACH ROW EXECUTE FUNCTION public.is_book_example_dispose();
 N   DROP TRIGGER trigger_is_book_example_dispose ON public."public.IssueJournal";
       public          amatsko20205    false    239    273            `           2620    30547 1   public.StorageInfo trigger_is_book_example_issued    TRIGGER     �   CREATE TRIGGER trigger_is_book_example_issued BEFORE INSERT OR UPDATE ON public."public.StorageInfo" FOR EACH ROW EXECUTE FUNCTION public.is_book_example_issued();
 L   DROP TRIGGER trigger_is_book_example_issued ON public."public.StorageInfo";
       public          amatsko20205    false    238    250            d           2620    30556 0   public.IssueJournal trigger_is_librn_from_lib_ij    TRIGGER     �   CREATE TRIGGER trigger_is_librn_from_lib_ij BEFORE INSERT OR UPDATE ON public."public.IssueJournal" FOR EACH ROW EXECUTE FUNCTION public.is_librn_from_lib_ij();
 K   DROP TRIGGER trigger_is_librn_from_lib_ij ON public."public.IssueJournal";
       public          amatsko20205    false    270    239            [           2620    30554 7   public.RegistrationJournal trigger_is_librn_from_lib_rj    TRIGGER     �   CREATE TRIGGER trigger_is_librn_from_lib_rj BEFORE INSERT OR UPDATE ON public."public.RegistrationJournal" FOR EACH ROW EXECUTE FUNCTION public.is_librn_from_lib_rj();
 R   DROP TRIGGER trigger_is_librn_from_lib_rj ON public."public.RegistrationJournal";
       public          amatsko20205    false    265    228            g           2620    30477 !   public.Novels trigger_is_lw_novel    TRIGGER     �   CREATE TRIGGER trigger_is_lw_novel BEFORE INSERT OR UPDATE ON public."public.Novels" FOR EACH ROW EXECUTE FUNCTION public.is_lw_from_category();
 <   DROP TRIGGER trigger_is_lw_novel ON public."public.Novels";
       public          amatsko20205    false    249    240            j           2620    30478    public.Poems trigger_is_lw_poem    TRIGGER     �   CREATE TRIGGER trigger_is_lw_poem BEFORE INSERT OR UPDATE ON public."public.Poems" FOR EACH ROW EXECUTE FUNCTION public.is_lw_from_category();
 :   DROP TRIGGER trigger_is_lw_poem ON public."public.Poems";
       public          amatsko20205    false    243    249            h           2620    30479 :   public.ScientificArticles trigger_is_lw_scientific_article    TRIGGER     �   CREATE TRIGGER trigger_is_lw_scientific_article BEFORE INSERT OR UPDATE ON public."public.ScientificArticles" FOR EACH ROW EXECUTE FUNCTION public.is_lw_from_category();
 U   DROP TRIGGER trigger_is_lw_scientific_article ON public."public.ScientificArticles";
       public          amatsko20205    false    241    249            i           2620    30480 '   public.Textbooks trigger_is_lw_textbook    TRIGGER     �   CREATE TRIGGER trigger_is_lw_textbook BEFORE INSERT OR UPDATE ON public."public.Textbooks" FOR EACH ROW EXECUTE FUNCTION public.is_lw_from_category();
 B   DROP TRIGGER trigger_is_lw_textbook ON public."public.Textbooks";
       public          amatsko20205    false    249    242            e           2620    30551 /   public.IssueJournal trigger_is_reg_before_issue    TRIGGER     �   CREATE TRIGGER trigger_is_reg_before_issue BEFORE INSERT OR UPDATE ON public."public.IssueJournal" FOR EACH ROW EXECUTE FUNCTION public.is_reg_before_issue();
 J   DROP TRIGGER trigger_is_reg_before_issue ON public."public.IssueJournal";
       public          amatsko20205    false    239    271            Y           2620    30411 +   public.Pensioners trigger_is_user_pensioner    TRIGGER     �   CREATE TRIGGER trigger_is_user_pensioner BEFORE INSERT OR UPDATE ON public."public.Pensioners" FOR EACH ROW EXECUTE FUNCTION public.is_user_from_category();
 F   DROP TRIGGER trigger_is_user_pensioner ON public."public.Pensioners";
       public          amatsko20205    false    221    267            X           2620    30410 #   public.Pupils trigger_is_user_pupil    TRIGGER     �   CREATE TRIGGER trigger_is_user_pupil BEFORE INSERT OR UPDATE ON public."public.Pupils" FOR EACH ROW EXECUTE FUNCTION public.is_user_from_category();
 >   DROP TRIGGER trigger_is_user_pupil ON public."public.Pupils";
       public          amatsko20205    false    220    267            T           2620    30412 +   public.Scientists trigger_is_user_scientist    TRIGGER     �   CREATE TRIGGER trigger_is_user_scientist BEFORE INSERT OR UPDATE ON public."public.Scientists" FOR EACH ROW EXECUTE FUNCTION public.is_user_from_category();
 F   DROP TRIGGER trigger_is_user_scientist ON public."public.Scientists";
       public          amatsko20205    false    216    267            U           2620    30401 '   public.Students trigger_is_user_student    TRIGGER     �   CREATE TRIGGER trigger_is_user_student BEFORE INSERT OR UPDATE ON public."public.Students" FOR EACH ROW EXECUTE FUNCTION public.is_user_from_category();
 B   DROP TRIGGER trigger_is_user_student ON public."public.Students";
       public          amatsko20205    false    217    267            W           2620    30413 '   public.Teachers trigger_is_user_teacher    TRIGGER     �   CREATE TRIGGER trigger_is_user_teacher BEFORE INSERT OR UPDATE ON public."public.Teachers" FOR EACH ROW EXECUTE FUNCTION public.is_user_from_category();
 B   DROP TRIGGER trigger_is_user_teacher ON public."public.Teachers";
       public          amatsko20205    false    219    267            V           2620    30408 %   public.Workers trigger_is_user_worker    TRIGGER     �   CREATE TRIGGER trigger_is_user_worker BEFORE INSERT OR UPDATE ON public."public.Workers" FOR EACH ROW EXECUTE FUNCTION public.is_user_from_category();
 @   DROP TRIGGER trigger_is_user_worker ON public."public.Workers";
       public          amatsko20205    false    218    267            f           2620    30540 3   public.IssueJournal trigger_librarian_is_working_ij    TRIGGER     �   CREATE TRIGGER trigger_librarian_is_working_ij BEFORE INSERT OR UPDATE ON public."public.IssueJournal" FOR EACH ROW EXECUTE FUNCTION public.librarian_is_working_ij();
 N   DROP TRIGGER trigger_librarian_is_working_ij ON public."public.IssueJournal";
       public          amatsko20205    false    239    269            \           2620    30542 :   public.RegistrationJournal trigger_librarian_is_working_rj    TRIGGER     �   CREATE TRIGGER trigger_librarian_is_working_rj BEFORE INSERT OR UPDATE ON public."public.RegistrationJournal" FOR EACH ROW EXECUTE FUNCTION public.librarian_is_working_rj();
 U   DROP TRIGGER trigger_librarian_is_working_rj ON public."public.RegistrationJournal";
       public          amatsko20205    false    228    274            Z           2620    37269 +   public.Librarians trigger_librn_cascade_del    TRIGGER     �   CREATE TRIGGER trigger_librn_cascade_del BEFORE DELETE ON public."public.Librarians" FOR EACH ROW EXECUTE FUNCTION public.librn_cascade_del();
 F   DROP TRIGGER trigger_librn_cascade_del ON public."public.Librarians";
       public          amatsko20205    false    254    227            ^           2620    37262 +   public.LiteraryWorks trigger_lw_cascade_del    TRIGGER     �   CREATE TRIGGER trigger_lw_cascade_del BEFORE DELETE ON public."public.LiteraryWorks" FOR EACH ROW EXECUTE FUNCTION public.lw_cascade_del();
 F   DROP TRIGGER trigger_lw_cascade_del ON public."public.LiteraryWorks";
       public          amatsko20205    false    232    275            a           2620    37264 )   public.StorageInfo trigger_si_cascade_del    TRIGGER     �   CREATE TRIGGER trigger_si_cascade_del BEFORE DELETE ON public."public.StorageInfo" FOR EACH ROW EXECUTE FUNCTION public.si_cascade_del();
 D   DROP TRIGGER trigger_si_cascade_del ON public."public.StorageInfo";
       public          amatsko20205    false    251    238            S           2620    37260 %   public.Users trigger_user_cascade_del    TRIGGER     �   CREATE TRIGGER trigger_user_cascade_del BEFORE DELETE ON public."public.Users" FOR EACH ROW EXECUTE FUNCTION public.user_cascade_del();
 @   DROP TRIGGER trigger_user_cascade_del ON public."public.Users";
       public          amatsko20205    false    215    272            G           2606    23412 $   public.AuthorsWorks AuthorsWorks_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.AuthorsWorks"
    ADD CONSTRAINT "AuthorsWorks_fk0" FOREIGN KEY (lw_id) REFERENCES public."public.LiteraryWorks"(lw_id);
 R   ALTER TABLE ONLY public."public.AuthorsWorks" DROP CONSTRAINT "AuthorsWorks_fk0";
       public          amatsko20205    false    232    236    3345            H           2606    23417 $   public.AuthorsWorks AuthorsWorks_fk1    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.AuthorsWorks"
    ADD CONSTRAINT "AuthorsWorks_fk1" FOREIGN KEY (author_id) REFERENCES public."public.Authors"(author_id);
 R   ALTER TABLE ONLY public."public.AuthorsWorks" DROP CONSTRAINT "AuthorsWorks_fk1";
       public          amatsko20205    false    235    3349    236            ?           2606    23382    public.Halls Halls_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.Halls"
    ADD CONSTRAINT "Halls_fk0" FOREIGN KEY (library_id) REFERENCES public."public.Libraries"(library_id);
 D   ALTER TABLE ONLY public."public.Halls" DROP CONSTRAINT "Halls_fk0";
       public          amatsko20205    false    225    3333    223            K           2606    23432 $   public.IssueJournal IssueJournal_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.IssueJournal"
    ADD CONSTRAINT "IssueJournal_fk0" FOREIGN KEY (stored_id) REFERENCES public."public.StorageInfo"(stored_id);
 R   ALTER TABLE ONLY public."public.IssueJournal" DROP CONSTRAINT "IssueJournal_fk0";
       public          amatsko20205    false    238    239    3353            L           2606    23437 $   public.IssueJournal IssueJournal_fk1    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.IssueJournal"
    ADD CONSTRAINT "IssueJournal_fk1" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);
 R   ALTER TABLE ONLY public."public.IssueJournal" DROP CONSTRAINT "IssueJournal_fk1";
       public          amatsko20205    false    239    3319    215            M           2606    23442 $   public.IssueJournal IssueJournal_fk2    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.IssueJournal"
    ADD CONSTRAINT "IssueJournal_fk2" FOREIGN KEY (issued_by_lbrn) REFERENCES public."public.Librarians"(librarian_id);
 R   ALTER TABLE ONLY public."public.IssueJournal" DROP CONSTRAINT "IssueJournal_fk2";
       public          amatsko20205    false    227    239    3337            @           2606    23387     public.Librarians Librarians_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.Librarians"
    ADD CONSTRAINT "Librarians_fk0" FOREIGN KEY (hall_id) REFERENCES public."public.Halls"(hall_id);
 N   ALTER TABLE ONLY public."public.Librarians" DROP CONSTRAINT "Librarians_fk0";
       public          amatsko20205    false    227    225    3335            O           2606    23447    public.Novels Novels_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.Novels"
    ADD CONSTRAINT "Novels_fk0" FOREIGN KEY (lw_id) REFERENCES public."public.LiteraryWorks"(lw_id);
 F   ALTER TABLE ONLY public."public.Novels" DROP CONSTRAINT "Novels_fk0";
       public          amatsko20205    false    232    3345    240            >           2606    23377     public.Pensioners Pensioners_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.Pensioners"
    ADD CONSTRAINT "Pensioners_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);
 N   ALTER TABLE ONLY public."public.Pensioners" DROP CONSTRAINT "Pensioners_fk0";
       public          amatsko20205    false    221    215    3319            R           2606    23462    public.Poems Poems_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.Poems"
    ADD CONSTRAINT "Poems_fk0" FOREIGN KEY (lw_id) REFERENCES public."public.LiteraryWorks"(lw_id);
 D   ALTER TABLE ONLY public."public.Poems" DROP CONSTRAINT "Poems_fk0";
       public          amatsko20205    false    243    3345    232            =           2606    23372    public.Pupils Pupils_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.Pupils"
    ADD CONSTRAINT "Pupils_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);
 F   ALTER TABLE ONLY public."public.Pupils" DROP CONSTRAINT "Pupils_fk0";
       public          amatsko20205    false    3319    215    220            A           2606    23392 2   public.RegistrationJournal RegistrationJournal_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.RegistrationJournal"
    ADD CONSTRAINT "RegistrationJournal_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);
 `   ALTER TABLE ONLY public."public.RegistrationJournal" DROP CONSTRAINT "RegistrationJournal_fk0";
       public          amatsko20205    false    228    215    3319            B           2606    23397 2   public.RegistrationJournal RegistrationJournal_fk1    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.RegistrationJournal"
    ADD CONSTRAINT "RegistrationJournal_fk1" FOREIGN KEY (librarian_id) REFERENCES public."public.Librarians"(librarian_id);
 `   ALTER TABLE ONLY public."public.RegistrationJournal" DROP CONSTRAINT "RegistrationJournal_fk1";
       public          amatsko20205    false    228    3337    227            C           2606    23522 2   public.RegistrationJournal RegistrationJournal_fk2    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.RegistrationJournal"
    ADD CONSTRAINT "RegistrationJournal_fk2" FOREIGN KEY (library_id) REFERENCES public."public.Libraries"(library_id);
 `   ALTER TABLE ONLY public."public.RegistrationJournal" DROP CONSTRAINT "RegistrationJournal_fk2";
       public          amatsko20205    false    223    228    3333            P           2606    23452 0   public.ScientificArticles ScientificArticles_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.ScientificArticles"
    ADD CONSTRAINT "ScientificArticles_fk0" FOREIGN KEY (lw_id) REFERENCES public."public.LiteraryWorks"(lw_id);
 ^   ALTER TABLE ONLY public."public.ScientificArticles" DROP CONSTRAINT "ScientificArticles_fk0";
       public          amatsko20205    false    232    241    3345            9           2606    23357     public.Scientists Scientists_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.Scientists"
    ADD CONSTRAINT "Scientists_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);
 N   ALTER TABLE ONLY public."public.Scientists" DROP CONSTRAINT "Scientists_fk0";
       public          amatsko20205    false    3319    215    216            I           2606    23422 "   public.StorageInfo StorageInfo_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.StorageInfo"
    ADD CONSTRAINT "StorageInfo_fk0" FOREIGN KEY (hall_id) REFERENCES public."public.Halls"(hall_id);
 P   ALTER TABLE ONLY public."public.StorageInfo" DROP CONSTRAINT "StorageInfo_fk0";
       public          amatsko20205    false    3335    225    238            J           2606    23427 "   public.StorageInfo StorageInfo_fk1    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.StorageInfo"
    ADD CONSTRAINT "StorageInfo_fk1" FOREIGN KEY (book_id) REFERENCES public."public.Books"(book_id);
 P   ALTER TABLE ONLY public."public.StorageInfo" DROP CONSTRAINT "StorageInfo_fk1";
       public          amatsko20205    false    238    230    3343            :           2606    23362    public.Students Students_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.Students"
    ADD CONSTRAINT "Students_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);
 J   ALTER TABLE ONLY public."public.Students" DROP CONSTRAINT "Students_fk0";
       public          amatsko20205    false    3319    215    217            <           2606    23367    public.Teachers Teachers_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.Teachers"
    ADD CONSTRAINT "Teachers_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);
 J   ALTER TABLE ONLY public."public.Teachers" DROP CONSTRAINT "Teachers_fk0";
       public          amatsko20205    false    219    215    3319            Q           2606    23457    public.Textbooks Textbooks_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.Textbooks"
    ADD CONSTRAINT "Textbooks_fk0" FOREIGN KEY (lw_id) REFERENCES public."public.LiteraryWorks"(lw_id);
 L   ALTER TABLE ONLY public."public.Textbooks" DROP CONSTRAINT "Textbooks_fk0";
       public          amatsko20205    false    242    3345    232            ;           2606    23467    public.Workers Workers_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.Workers"
    ADD CONSTRAINT "Workers_fk0" FOREIGN KEY (user_id) REFERENCES public."public.Users"(user_id);
 H   ALTER TABLE ONLY public."public.Workers" DROP CONSTRAINT "Workers_fk0";
       public          amatsko20205    false    3319    218    215            E           2606    23402 "   public.WorksInBook WorksInBook_fk0    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.WorksInBook"
    ADD CONSTRAINT "WorksInBook_fk0" FOREIGN KEY (book_id) REFERENCES public."public.Books"(book_id);
 P   ALTER TABLE ONLY public."public.WorksInBook" DROP CONSTRAINT "WorksInBook_fk0";
       public          amatsko20205    false    3343    230    233            F           2606    23407 "   public.WorksInBook WorksInBook_fk1    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.WorksInBook"
    ADD CONSTRAINT "WorksInBook_fk1" FOREIGN KEY (lw_id) REFERENCES public."public.LiteraryWorks"(lw_id);
 P   ALTER TABLE ONLY public."public.WorksInBook" DROP CONSTRAINT "WorksInBook_fk1";
       public          amatsko20205    false    232    233    3345            8           2606    34691    public.Users categories_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.Users"
    ADD CONSTRAINT categories_fk FOREIGN KEY (category) REFERENCES public."public.UserCategories"(category_id);
 F   ALTER TABLE ONLY public."public.Users" DROP CONSTRAINT categories_fk;
       public          amatsko20205    false    3373    245    215            N           2606    30528 $   public.IssueJournal issuejournal_fk3    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.IssueJournal"
    ADD CONSTRAINT issuejournal_fk3 FOREIGN KEY (accepted_by_lbrn) REFERENCES public."public.Librarians"(librarian_id);
 P   ALTER TABLE ONLY public."public.IssueJournal" DROP CONSTRAINT issuejournal_fk3;
       public          amatsko20205    false    239    227    3337            D           2606    30471 #   public.LiteraryWorks lw_category_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."public.LiteraryWorks"
    ADD CONSTRAINT lw_category_fk FOREIGN KEY (category) REFERENCES public."public.LWCategories"(category_id);
 O   ALTER TABLE ONLY public."public.LiteraryWorks" DROP CONSTRAINT lw_category_fk;
       public          amatsko20205    false    232    3379    247               E  x���]N�P��/�1�7�
����C��mc4&>iJ���^�pfG�;@����93ߜ�7x��,P��5�Q#G%!v��$0xE.R�s�Q��;5xC�ZB��,�]�`�&��P����DȔ=vr��(�ٴb]�~n��th�	����PZH8&�P�Y�#׆��
�_l�<�]<)���Z%q�>����?kYʜ���=�O�[�G;��`�5���)eI7�L��p��Ƶm:��q:+�)��ϊ%!{3|���+js��&L�Hd&���s�8��Yo�?��~0:;�����f?d����b��S�r�S��@�&'��}�q��         A   x����0�������ǁ��S#�ai�f��BZq���6uc(�P�d!����r*��"�2_      	   "  x�}�MJA��]��4�$���$AQQ!��m�4�df�+�����mȢ��z_��.��B�F��{�k�V���x<��Ǜ.�{
F�Rg^�d��̍��Br����1��ǊAd��e��dN�L�%����f��S�M�����vz˝j9s�D�m*�[�60�mD9w<��lir�,�o=ڬ7?|9+/�1LZIA��n̉Q���ޱ>Pћ;'v��ÆD<��/����q$t�<�g��I99�y|���g�ޠc��q5o��+s�j:���>{�?�� "�"O
         >   x�Ĺ !��*�����qr�K#\BRJ�s�\pM���)���x������Ic`         �   x�M���0��.�0��7A����Tw�b���I��.���N�ov+�&���)�6�8FvF9*jb���B�(6�)�B�t���ilQD[5:�g��xN���]��܁��@~��rP˙�en��đZY����ς�a�djݧ��a�kc4>         \   x�3���/K��,(M��L��q���8�Ssa�@v1�1gqrfj^IfZf�BbQIfrN*LE0\�"Q�e�Y�ZQ����S�s��qqq F*w         W  x���MN�0����N�$��=L[H���
�"!B�چ����6JT,��}3�Ɩ,�3|��=�[�6��O��%g���jg�Sn}bį��k�:�b�}���YV� ��
�����{�5�r�'��sҶ��%� �d#�l�G�g��m(biSjk��f�㾏9l[�����i��a�6sm��S6�qMd��Y����@����
*�_���(���G��hMpF��Q� $ ���|l�����������O�!jr�"�Gbt~"��0�afУ����b/�D�o�7c3��* ,��R� &]M���I�hgJ&יQ�����w�         K  x��RmN�@��{�^@�%��@I�D"�Ð ����[�R�\�͍|��sML��������Ll�@�N���V+4ؠ�ԇ2�����6�X����0³�e��.Ò�m���q���[=hCjFryp���aN��61�+����*��tN&��JH�d�e�{�b�0Et^;:�"Ly�ųd�k0�[(�\|V2Wp�N�QEةR�;��Ľ�o�|��]���]s��V��C�:�W5�))	w�{�䆛F�8
!���������w��X�@1�\w\+ϓv���	�����T��:ƾi3�j�����p�S����7ni�ސg��1���y�Z�,�5�         �  x��R�NA<�|�|qYz�ī��W#$^��D#�Gb�A���q`�B�Y=�YB������!~��K��7���c[鳓�8E)��g��n�{��Qh�-�)�, s� ��`��teAJQ,y5�JLq�pFce�r��j�Rŉ�e�L孂_�:9��Q݄į@/��^B�X�@��oO�(�T�&�_���:�\�QRT�xHQ ��"~�<jO3���R�E^�3my`�NN���[��l`��?���JYS�N8$�[H5�ѫl�~\�񁻊���z�����y�����թa��?j5�C9�1�y�E FG&DP��`�wzkN�����&�h�65��0��j�VjmPJ�e��T���p����yx��>��D&�
�5��jƘ?�Q�
           x���AN�0E��S��$M�\��0	,�j�
�S��)&m�+����b�L�?���������7�u�1"��	��>y\�Gb? �=�3����z˩�:�k���]#��v«>��[oF��ѳ��GR�ɵR\���-�(���J6	�3�a�9Ӂ���=β��%"N�qE)u�U)k��j�a[�}����-P�F��1�����j����î���J�p�����(�k�<�|�ǿ���L��Y'���x�+����@�             x�34�42�22�4����� �5         c   x����	�0�s�0���8L=�`q�*Uj]!��/��k�Br�-6��ٰ�	Og��Ha��$:�F��M^�k�Lw)�<";,j�n������D��<e�      �   #   x�34缰�®�.쾰A�Q�4C#C�=... �{o         �   x�M��D1��+>	Iz���X�V��a��Yd��*ꢃ�9�m1k�)
���f4���I
6�Y-x�Y$(�'Dgc��=����-�'{6��z}=~H�n޷GA\;Uz�R����>8�ٚ��d_��Oг��yכD�|?��j�0�         &   x���4202�54�5��24�4�4��50"�=... [FG      �   W   x�34�0�¾�.6]�w�A�b��\�q���֋�vY�
�^�p���..#��.l � �m�6) 5n�ڋKO� 1@�         -  x���mn�0���.� _b'��`�װq=U´�*�y�������e`��"vx|��a��,`�F���ᴾv����Ur���[�GG$���\ͮ��|��jsul-�2i�����}��д��e�E�~�F,QN�Z]m�K��=��wM�u�%�ψ#b��n�9"Gj!ih��U	��2j�s�~@���#�<�&�u���0e9<���("U,�����a���u�l�񸍬�f48B�ت�>���%�4X뤧R7S\C�'ߍ��L�<����F��K]}�;��3ϡ�4�>�Px|�� ����      �   1   x��估��8/̽0��b.CCt#tct��8������ �4       �   E   x�3�0��m�^ة�e�����^l���bÅ=6\l���®�,�)]��U���� ��.�         <   x�34漰����/쾰��΋�v�h��/6\�wa˅M@�ދ��.v_������ �� W         h   x�E�A
�0D�#�j���M7��������J����M�1o.K���{�D�²\(ux^H���Wo�@�\��ЮL�(�z���W��f��r��xw ~� 9&      �   �  x�mSKN�0\ۇA8��=A��*�@*_��ϊr?�ܴ	W߈yv����=ϼ�3Px�[�(�WxG��>C���'�,��D9��6C�WVe���N��6=�7���;����ߢ@�p��~X�(�}�\�~����`K���qP�2�'겴(K�]�2�#N�X�W
_�9��%U
j�DԊ�V�#H3}�ZBр���� ;��9���X���d��,���щs��,��6F��c����6A.����o��H�k#����b�ek.s%����	�	'W�\�>Zi��1��]"]P� 5�p7I�s�D��]��,ۃ��Պ��D'�Ќ/��/t�.��t.��6��{�Nx�������)"^��h�
!c$���f�hL���}��t�b�����\+�      �   ;   x�34�LJL�N�KQ��paÅ�`r�}�.�_�qa���^�ra�]�b���� ���         G   x����0���0E|��.��:~����WWV&Q;���,��8������f6�z/l��w�2��~�n�     