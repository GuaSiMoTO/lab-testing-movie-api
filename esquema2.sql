--
-- PostgreSQL database dump
--

\restrict RSnb6tsShUGk1pDX0DUy1pW9SWNPEtb6yJyaNOBOvtIogRi1LVgAndEQLsQUfHD

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: registrar_cambio_pelicula(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.registrar_cambio_pelicula() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO auditoria_peliculas (pelicula_id, operacion, datos_despues)
    VALUES (NEW.id, 'INSERT', row_to_json(NEW));

  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO auditoria_peliculas (pelicula_id, operacion, datos_antes, datos_despues)
    VALUES (NEW.id, 'UPDATE', row_to_json(OLD), row_to_json(NEW));

  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO auditoria_peliculas (pelicula_id, operacion, datos_antes)
    VALUES (OLD.id, 'DELETE', row_to_json(OLD));
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.registrar_cambio_pelicula() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auditoria_peliculas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auditoria_peliculas (
    id integer NOT NULL,
    pelicula_id integer,
    operacion character varying(10) NOT NULL,
    datos_antes jsonb,
    datos_despues jsonb,
    usuario_db character varying(100) DEFAULT CURRENT_USER,
    fecha timestamp with time zone DEFAULT now()
);


ALTER TABLE public.auditoria_peliculas OWNER TO postgres;

--
-- Name: auditoria_peliculas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auditoria_peliculas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auditoria_peliculas_id_seq OWNER TO postgres;

--
-- Name: auditoria_peliculas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auditoria_peliculas_id_seq OWNED BY public.auditoria_peliculas.id;


--
-- Name: directores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directores (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    nacionalidad character varying(50),
    fecha_nac date
);


ALTER TABLE public.directores OWNER TO postgres;

--
-- Name: directores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directores_id_seq OWNER TO postgres;

--
-- Name: directores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directores_id_seq OWNED BY public.directores.id;


--
-- Name: generos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.generos (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    slug character varying(50) NOT NULL
);


ALTER TABLE public.generos OWNER TO postgres;

--
-- Name: generos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.generos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.generos_id_seq OWNER TO postgres;

--
-- Name: generos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.generos_id_seq OWNED BY public.generos.id;


--
-- Name: peliculas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.peliculas (
    id integer NOT NULL,
    titulo character varying(255) NOT NULL,
    anio integer NOT NULL,
    nota numeric(3,1),
    director_id integer,
    genero_id integer,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT peliculas_anio_check CHECK (((anio >= 1888) AND (anio <= 2100))),
    CONSTRAINT peliculas_nota_check CHECK (((nota >= (0)::numeric) AND (nota <= (10)::numeric)))
);


ALTER TABLE public.peliculas OWNER TO postgres;

--
-- Name: peliculas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.peliculas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.peliculas_id_seq OWNER TO postgres;

--
-- Name: peliculas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.peliculas_id_seq OWNED BY public.peliculas.id;


--
-- Name: resenas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resenas (
    id integer NOT NULL,
    pelicula_id integer NOT NULL,
    autor character varying(100) NOT NULL,
    texto text NOT NULL,
    puntuacion integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT resenas_puntuacion_check CHECK (((puntuacion >= 1) AND (puntuacion <= 10)))
);


ALTER TABLE public.resenas OWNER TO postgres;

--
-- Name: resenas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resenas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.resenas_id_seq OWNER TO postgres;

--
-- Name: resenas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resenas_id_seq OWNED BY public.resenas.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying(50) NOT NULL,
    aplicada_en timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password_hash character varying(255) NOT NULL,
    rol character varying(20) DEFAULT 'usuario'::character varying NOT NULL,
    activo boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT usuarios_rol_check CHECK (((rol)::text = ANY ((ARRAY['usuario'::character varying, 'admin'::character varying])::text[])))
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- Name: v_peliculas_completas; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_peliculas_completas AS
 SELECT p.id,
    p.titulo,
    p.anio,
    p.nota AS nota_editorial,
    d.nombre AS director,
    g.nombre AS genero,
    g.slug AS genero_slug,
    count(r.id) AS num_resenas,
    round(avg(r.puntuacion), 2) AS media_usuarios
   FROM (((public.peliculas p
     LEFT JOIN public.directores d ON ((d.id = p.director_id)))
     LEFT JOIN public.generos g ON ((g.id = p.genero_id)))
     LEFT JOIN public.resenas r ON ((r.pelicula_id = p.id)))
  GROUP BY p.id, p.titulo, p.anio, p.nota, d.nombre, g.nombre, g.slug;


ALTER VIEW public.v_peliculas_completas OWNER TO postgres;

--
-- Name: auditoria_peliculas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria_peliculas ALTER COLUMN id SET DEFAULT nextval('public.auditoria_peliculas_id_seq'::regclass);


--
-- Name: directores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directores ALTER COLUMN id SET DEFAULT nextval('public.directores_id_seq'::regclass);


--
-- Name: generos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generos ALTER COLUMN id SET DEFAULT nextval('public.generos_id_seq'::regclass);


--
-- Name: peliculas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.peliculas ALTER COLUMN id SET DEFAULT nextval('public.peliculas_id_seq'::regclass);


--
-- Name: resenas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resenas ALTER COLUMN id SET DEFAULT nextval('public.resenas_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- Name: auditoria_peliculas auditoria_peliculas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria_peliculas
    ADD CONSTRAINT auditoria_peliculas_pkey PRIMARY KEY (id);


--
-- Name: directores directores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directores
    ADD CONSTRAINT directores_pkey PRIMARY KEY (id);


--
-- Name: generos generos_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generos
    ADD CONSTRAINT generos_nombre_key UNIQUE (nombre);


--
-- Name: generos generos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generos
    ADD CONSTRAINT generos_pkey PRIMARY KEY (id);


--
-- Name: generos generos_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generos
    ADD CONSTRAINT generos_slug_key UNIQUE (slug);


--
-- Name: peliculas peliculas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.peliculas
    ADD CONSTRAINT peliculas_pkey PRIMARY KEY (id);


--
-- Name: resenas resenas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resenas
    ADD CONSTRAINT resenas_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: idx_peliculas_anio; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_peliculas_anio ON public.peliculas USING btree (anio);


--
-- Name: idx_peliculas_director; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_peliculas_director ON public.peliculas USING btree (director_id);


--
-- Name: idx_peliculas_genero; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_peliculas_genero ON public.peliculas USING btree (genero_id);


--
-- Name: idx_peliculas_genero_nota; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_peliculas_genero_nota ON public.peliculas USING btree (genero_id, nota DESC);


--
-- Name: peliculas trigger_auditoria_peliculas; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_auditoria_peliculas AFTER INSERT OR DELETE OR UPDATE ON public.peliculas FOR EACH ROW EXECUTE FUNCTION public.registrar_cambio_pelicula();


--
-- Name: peliculas peliculas_director_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.peliculas
    ADD CONSTRAINT peliculas_director_id_fkey FOREIGN KEY (director_id) REFERENCES public.directores(id) ON DELETE SET NULL;


--
-- Name: peliculas peliculas_genero_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.peliculas
    ADD CONSTRAINT peliculas_genero_id_fkey FOREIGN KEY (genero_id) REFERENCES public.generos(id) ON DELETE SET NULL;


--
-- Name: resenas resenas_pelicula_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resenas
    ADD CONSTRAINT resenas_pelicula_id_fkey FOREIGN KEY (pelicula_id) REFERENCES public.peliculas(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict RSnb6tsShUGk1pDX0DUy1pW9SWNPEtb6yJyaNOBOvtIogRi1LVgAndEQLsQUfHD

