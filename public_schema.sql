


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


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."bahan" (
    "bahan_id" integer NOT NULL,
    "nama_bahan" "text" NOT NULL
);


ALTER TABLE "public"."bahan" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."bahan_bahan_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."bahan_bahan_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."bahan_bahan_id_seq" OWNED BY "public"."bahan"."bahan_id";



CREATE TABLE IF NOT EXISTS "public"."kategori" (
    "kategori_id" integer NOT NULL,
    "nama_kategori" "text" NOT NULL
);


ALTER TABLE "public"."kategori" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."kategori_kategori_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."kategori_kategori_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."kategori_kategori_id_seq" OWNED BY "public"."kategori"."kategori_id";



CREATE TABLE IF NOT EXISTS "public"."langkah_resep" (
    "langkah_id" integer NOT NULL,
    "resep_id" integer,
    "urutan" integer NOT NULL,
    "deskripsi" "text" NOT NULL
);


ALTER TABLE "public"."langkah_resep" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."langkah_resep_langkah_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."langkah_resep_langkah_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."langkah_resep_langkah_id_seq" OWNED BY "public"."langkah_resep"."langkah_id";



CREATE TABLE IF NOT EXISTS "public"."peralatan" (
    "peralatan_id" integer NOT NULL,
    "nama_peralatan" "text" NOT NULL
);


ALTER TABLE "public"."peralatan" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."peralatan_peralatan_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."peralatan_peralatan_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."peralatan_peralatan_id_seq" OWNED BY "public"."peralatan"."peralatan_id";



CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "nama" "text",
    "username" "text",
    "created_at" timestamp without time zone DEFAULT "now"(),
    "gambar_url" "text"
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."resep" (
    "resep_id" integer NOT NULL,
    "judul" "text" NOT NULL,
    "deskripsi" "text",
    "durasi" integer,
    "kategori_id" integer,
    "user_id" "uuid",
    "tanggal_upload" timestamp without time zone DEFAULT "now"(),
    "is_public" boolean DEFAULT true,
    "gambar_url" "text"
);


ALTER TABLE "public"."resep" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."resep_bahan" (
    "resep_id" integer NOT NULL,
    "bahan_id" integer NOT NULL,
    "jumlah" "text"
);


ALTER TABLE "public"."resep_bahan" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."resep_peralatan" (
    "resep_id" integer NOT NULL,
    "peralatan_id" integer NOT NULL
);


ALTER TABLE "public"."resep_peralatan" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."resep_resep_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."resep_resep_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."resep_resep_id_seq" OWNED BY "public"."resep"."resep_id";



ALTER TABLE ONLY "public"."bahan" ALTER COLUMN "bahan_id" SET DEFAULT "nextval"('"public"."bahan_bahan_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."kategori" ALTER COLUMN "kategori_id" SET DEFAULT "nextval"('"public"."kategori_kategori_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."langkah_resep" ALTER COLUMN "langkah_id" SET DEFAULT "nextval"('"public"."langkah_resep_langkah_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."peralatan" ALTER COLUMN "peralatan_id" SET DEFAULT "nextval"('"public"."peralatan_peralatan_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."resep" ALTER COLUMN "resep_id" SET DEFAULT "nextval"('"public"."resep_resep_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."bahan"
    ADD CONSTRAINT "bahan_pkey" PRIMARY KEY ("bahan_id");



ALTER TABLE ONLY "public"."kategori"
    ADD CONSTRAINT "kategori_pkey" PRIMARY KEY ("kategori_id");



ALTER TABLE ONLY "public"."langkah_resep"
    ADD CONSTRAINT "langkah_resep_pkey" PRIMARY KEY ("langkah_id");



ALTER TABLE ONLY "public"."peralatan"
    ADD CONSTRAINT "peralatan_pkey" PRIMARY KEY ("peralatan_id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_username_key" UNIQUE ("username");



ALTER TABLE ONLY "public"."resep_bahan"
    ADD CONSTRAINT "resep_bahan_pkey" PRIMARY KEY ("resep_id", "bahan_id");



ALTER TABLE ONLY "public"."resep_peralatan"
    ADD CONSTRAINT "resep_peralatan_pkey" PRIMARY KEY ("resep_id", "peralatan_id");



ALTER TABLE ONLY "public"."resep"
    ADD CONSTRAINT "resep_pkey" PRIMARY KEY ("resep_id");



ALTER TABLE ONLY "public"."langkah_resep"
    ADD CONSTRAINT "langkah_resep_resep_id_fkey" FOREIGN KEY ("resep_id") REFERENCES "public"."resep"("resep_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."resep_bahan"
    ADD CONSTRAINT "resep_bahan_bahan_id_fkey" FOREIGN KEY ("bahan_id") REFERENCES "public"."bahan"("bahan_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."resep_bahan"
    ADD CONSTRAINT "resep_bahan_resep_id_fkey" FOREIGN KEY ("resep_id") REFERENCES "public"."resep"("resep_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."resep"
    ADD CONSTRAINT "resep_kategori_id_fkey" FOREIGN KEY ("kategori_id") REFERENCES "public"."kategori"("kategori_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."resep_peralatan"
    ADD CONSTRAINT "resep_peralatan_peralatan_id_fkey" FOREIGN KEY ("peralatan_id") REFERENCES "public"."peralatan"("peralatan_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."resep_peralatan"
    ADD CONSTRAINT "resep_peralatan_resep_id_fkey" FOREIGN KEY ("resep_id") REFERENCES "public"."resep"("resep_id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."resep"
    ADD CONSTRAINT "resep_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;



CREATE POLICY "Allow insert for authenticated users" ON "public"."bahan" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Allow insert for authenticated users" ON "public"."langkah_resep" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Allow insert for authenticated users" ON "public"."peralatan" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Allow insert for authenticated users" ON "public"."resep" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Allow insert for authenticated users" ON "public"."resep_bahan" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Allow insert for authenticated users" ON "public"."resep_peralatan" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Allow insert for own profile" ON "public"."profiles" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() = "id"));



CREATE POLICY "Allow select for all authenticated users" ON "public"."bahan" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Allow select for all authenticated users" ON "public"."kategori" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Allow select for all authenticated users" ON "public"."langkah_resep" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Allow select for all authenticated users" ON "public"."peralatan" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Allow select for all authenticated users" ON "public"."profiles" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Allow select for all authenticated users" ON "public"."resep" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Allow select for all authenticated users" ON "public"."resep_bahan" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Allow select for all authenticated users" ON "public"."resep_peralatan" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Allow select for all users" ON "public"."peralatan" FOR SELECT USING (true);



CREATE POLICY "Users can update own profile" ON "public"."profiles" FOR UPDATE USING (("auth"."uid"() = "id")) WITH CHECK (("auth"."uid"() = "id"));



ALTER TABLE "public"."bahan" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."kategori" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."langkah_resep" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."peralatan" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."resep" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."resep_bahan" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."resep_peralatan" ENABLE ROW LEVEL SECURITY;


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON TABLE "public"."bahan" TO "anon";
GRANT ALL ON TABLE "public"."bahan" TO "authenticated";
GRANT ALL ON TABLE "public"."bahan" TO "service_role";



GRANT ALL ON SEQUENCE "public"."bahan_bahan_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."bahan_bahan_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."bahan_bahan_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."kategori" TO "anon";
GRANT ALL ON TABLE "public"."kategori" TO "authenticated";
GRANT ALL ON TABLE "public"."kategori" TO "service_role";



GRANT ALL ON SEQUENCE "public"."kategori_kategori_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."kategori_kategori_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."kategori_kategori_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."langkah_resep" TO "anon";
GRANT ALL ON TABLE "public"."langkah_resep" TO "authenticated";
GRANT ALL ON TABLE "public"."langkah_resep" TO "service_role";



GRANT ALL ON SEQUENCE "public"."langkah_resep_langkah_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."langkah_resep_langkah_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."langkah_resep_langkah_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."peralatan" TO "anon";
GRANT ALL ON TABLE "public"."peralatan" TO "authenticated";
GRANT ALL ON TABLE "public"."peralatan" TO "service_role";



GRANT ALL ON SEQUENCE "public"."peralatan_peralatan_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."peralatan_peralatan_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."peralatan_peralatan_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."resep" TO "anon";
GRANT ALL ON TABLE "public"."resep" TO "authenticated";
GRANT ALL ON TABLE "public"."resep" TO "service_role";



GRANT ALL ON TABLE "public"."resep_bahan" TO "anon";
GRANT ALL ON TABLE "public"."resep_bahan" TO "authenticated";
GRANT ALL ON TABLE "public"."resep_bahan" TO "service_role";



GRANT ALL ON TABLE "public"."resep_peralatan" TO "anon";
GRANT ALL ON TABLE "public"."resep_peralatan" TO "authenticated";
GRANT ALL ON TABLE "public"."resep_peralatan" TO "service_role";



GRANT ALL ON SEQUENCE "public"."resep_resep_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."resep_resep_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."resep_resep_id_seq" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";







