-- Dropowanie tabel --

DROP TABLE IF EXISTS opiekunowie CASCADE;
DROP TABLE IF EXISTS sektory CASCADE;
DROP TABLE IF EXISTS rodzaje_klatek CASCADE;
DROP TABLE IF EXISTS klatki CASCADE;
DROP TABLE IF EXISTS gatunki CASCADE;
DROP TABLE IF EXISTS zwierzeta CASCADE;
DROP TABLE IF EXISTS rozpiska_godzinowa CASCADE;
DROP TABLE IF EXISTS dostawy_pozywienia CASCADE;
DROP TABLE IF EXISTS czyszczenie_klatek CASCADE;
DROP TABLE IF EXISTS karmienie CASCADE;
DROP TABLE IF EXISTS weterynarze CASCADE;
DROP TABLE IF EXISTS badania CASCADE;
DROP TABLE IF EXISTS choroby CASCADE;
DROP TABLE IF EXISTS sponsorzy CASCADE;
DROP TABLE IF EXISTS donacje CASCADE;
DROP TABLE IF EXISTS sklep CASCADE;


-- Tworzenie tabel --

CREATE TABLE opiekunowie (
  id_opiekuna INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  imie VARCHAR(100) NOT NULL,
  nazwisko VARCHAR(100) NOT NULL,
  data_zatrudnienia DATE NOT NULL,
  czy_moze_byc_kierownikiem BOOLEAN NOT NULL
);

CREATE TABLE sektory (
  id_sektora INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_kierownika INTEGER UNIQUE NOT NULL REFERENCES opiekunowie(id_opiekuna) ON DELETE RESTRICT ON UPDATE CASCADE,
  rodzaj_klimatu TEXT,
  zadaszenie BOOLEAN NOT NULL
);

CREATE TABLE rodzaje_klatek (
  rodzaj_klatki TEXT PRIMARY KEY
);

CREATE TABLE klatki (
  id_klatki  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_sektora INTEGER NOT NULL REFERENCES sektory(id_sektora) ON DELETE CASCADE ON UPDATE CASCADE,
  rodzaj_klatki TEXT NOT NULL REFERENCES rodzaje_klatek(rodzaj_klatki) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE gatunki (
  gatunek TEXT PRIMARY KEY
);

CREATE TABLE zwierzeta (
  id_zwierzecia INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_klatki INTEGER NOT NULL REFERENCES klatki(id_klatki) ON DELETE RESTRICT ON UPDATE CASCADE,
  imie VARCHAR(50) NOT NULL,
  gatunek TEXT NOT NULL REFERENCES gatunki(gatunek) ON DELETE RESTRICT ON UPDATE CASCADE,
  plec VARCHAR(6) CHECK (plec IN ('samiec', 'samica')) NOT NULL,
  pochodzenie VARCHAR(50),
  data_urodzin DATE NOT NULL
);

CREATE TABLE rozpiska_godzinowa (
  pora VARCHAR(5) PRIMARY KEY CHECK (pora ~ '^[0-9]{2}:[0-9]{2}$')
);

CREATE TABLE dostawy_pozywienia (
  rodzaj_jedzenia TEXT PRIMARY KEY,
  dzien_dostawy VARCHAR(12) NOT NULL
);

CREATE TABLE karmienie (
  id_klatki INTEGER REFERENCES klatki(id_klatki) ON DELETE CASCADE ON UPDATE CASCADE, 
  pora_karmienia VARCHAR(5) REFERENCES rozpiska_godzinowa(pora) ON DELETE CASCADE ON UPDATE CASCADE,
  id_opiekuna INTEGER NOT NULL REFERENCES opiekunowie(id_opiekuna) ON DELETE RESTRICT ON UPDATE CASCADE,
  rodzaj_jedzenia TEXT NOT NULL REFERENCES dostawy_pozywienia(rodzaj_jedzenia) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (id_klatki, pora_karmienia)
);

CREATE TABLE czyszczenie_klatek (
  id_klatki INTEGER REFERENCES  klatki(id_klatki) ON DELETE CASCADE ON UPDATE CASCADE,
  pora_czyszczenia VARCHAR(5) REFERENCES rozpiska_godzinowa(pora) ON DELETE CASCADE ON UPDATE CASCADE,
  id_opiekuna INTEGER NOT NULL REFERENCES opiekunowie(id_opiekuna) ON DELETE RESTRICT ON UPDATE CASCADE,
  PRIMARY KEY (id_klatki, pora_czyszczenia)
);

CREATE TABLE weterynarze (
  id_weterynarza INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  imie VARCHAR(100) NOT NULL,
  nazwisko VARCHAR(100) NOT NULL,
  specjalizacja VARCHAR(100)
);

CREATE TABLE badania(
  id_badania TIMESTAMP PRIMARY KEY,
  id_weterynarza INTEGER REFERENCES weterynarze(id_weterynarza) ON DELETE SET NULL ON UPDATE CASCADE,
  id_zwierzecia INTEGER NOT NULL REFERENCES zwierzeta(id_zwierzecia) ON DELETE CASCADE ON UPDATE CASCADE,
  typ_badania TEXT NOT NULL CHECK (typ_badania IN ('profilaktyczne', 'leczenie')),
  choroba TEXT
);


CREATE TABLE sponsorzy (
  id_sponsora INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nazwa_firmy TEXT,
  imie VARCHAR(100),
  nazwisko VARCHAR(100)
);

CREATE TABLE donacje (
  czas_donacji TIMESTAMP PRIMARY KEY,
  id_sponsora INTEGER REFERENCES sponsorzy(id_sponsora) ON DELETE SET NULL ON UPDATE CASCADE,
  id_zwierzecia INTEGER REFERENCES zwierzeta(id_zwierzecia) ON DELETE SET NULL ON UPDATE CASCADE,
  kwota NUMERIC CHECK (kwota > 0) NOT NULL
);

CREATE TABLE sklep (
  gatunek TEXT REFERENCES gatunki(gatunek) ON DELETE RESTRICT ON UPDATE CASCADE,
  rodzaj_pamiatki TEXT,
  ilosc INTEGER CHECK (ilosc >= 0) NOT NULL,
  PRIMARY KEY (gatunek, rodzaj_pamiatki)
);


-- INSERTy --

-- Inserty opiekunowie --

INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Jan', 'Kowalski', '1995-07-15', true);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Anna', 'Nowak', '2000-02-28', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Jakub', 'Milosz', '2022-09-12', true);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Maria', 'Wojciechowska', '2010-08-22', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Grzegorz', 'Dabrowski', '2015-04-17', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Ewa', 'Kaminska', '2020-01-05', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Piotr', 'Lewandowski', '2005-11-10', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Iwona', 'Szymanska', '1998-06-30', true);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Krzysztof', 'Kowalczyk', '2003-03-25', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Jolanta', 'Glowacka', '2008-12-18', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Marek', 'Jankowski', '2013-10-08', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Agata', 'Malinowska', '2018-05-03', true);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Rafal', 'Michalski', '2023-02-20', true);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Agnieszka', 'Kaczmarek', '1997-09-14', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Tomasz', 'Piotrowski', '2002-04-07', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Monika', 'Lukasik', '2007-11-01', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Lukasz', 'Witkowski', '2012-07-24', true);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Karolina', 'Mazur', '2017-03-19', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Marcin', 'Jablonski', '2021-10-13', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Natalia', 'Brzezinska', '1996-08-06', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Dawid', 'Olszewski', '2001-05-28', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Beata', 'Klimek', '2006-02-15', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Szymon', 'Borowski', '2011-09-09', false);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Patrycja', 'Czarnecka', '2016-06-04', true);
INSERT INTO opiekunowie(imie, nazwisko, data_zatrudnienia, czy_moze_byc_kierownikiem) VALUES('Wojciech', 'Szczepanski', '2024-01-10', true);


-- Inserty sektory --

INSERT INTO sektory(id_kierownika, rodzaj_klimatu, zadaszenie) VALUES(3, 'umiarkowany', FALSE); 
INSERT INTO sektory(id_kierownika, rodzaj_klimatu, zadaszenie) VALUES(25, 'tropikalny', FALSE); 
INSERT INTO sektory(id_kierownika, rodzaj_klimatu, zadaszenie) VALUES(8, 'umiarkowany', FALSE); 
INSERT INTO sektory(id_kierownika, rodzaj_klimatu, zadaszenie) VALUES(17, 'umiarkowany', FALSE); 
INSERT INTO sektory(id_kierownika, rodzaj_klimatu, zadaszenie) VALUES(12, 'tropikalny', TRUE); 
INSERT INTO sektory(id_kierownika, rodzaj_klimatu, zadaszenie) VALUES(1, 'polarny', FALSE); 
INSERT INTO sektory(id_kierownika, rodzaj_klimatu, zadaszenie) VALUES(24, 'pustynny', FALSE); 
INSERT INTO sektory(id_kierownika, rodzaj_klimatu, zadaszenie) VALUES(13, 'polarny', FALSE); 


-- Inserty rodzaje_klatek --

INSERT INTO rodzaje_klatek(rodzaj_klatki) VALUES ('wybieg z wysokim plotem');
INSERT INTO rodzaje_klatek(rodzaj_klatki) VALUES ('wybieg z szyba');
INSERT INTO rodzaje_klatek(rodzaj_klatki) VALUES ('klatka');
INSERT INTO rodzaje_klatek(rodzaj_klatki) VALUES ('akwarium');
INSERT INTO rodzaje_klatek(rodzaj_klatki) VALUES ('akwarium z wybiegiem');


-- Inserty klatki --

INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (1, 'wybieg z wysokim plotem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (2, 'wybieg z wysokim plotem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (2, 'wybieg z wysokim plotem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (1, 'wybieg z wysokim plotem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (3, 'klatka');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (3, 'klatka');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (2, 'wybieg z wysokim plotem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (4, 'klatka');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (2, 'klatka');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (5, 'akwarium');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (5, 'akwarium z wybiegiem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (5, 'akwarium');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (6, 'akwarium z wybiegiem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (7, 'wybieg z szyba');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (1, 'wybieg z wysokim plotem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (7, 'wybieg z wysokim plotem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (3, 'wybieg z wysokim plotem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (8, 'wybieg z szyba');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (1, 'wybieg z wysokim plotem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (6, 'akwarium z wybiegiem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (3, 'klatka');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (8, 'wybieg z szyba');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (8, 'wybieg z wysokim plotem');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (3, 'klatka');
INSERT INTO klatki(id_sektora, rodzaj_klatki) VALUES (5, 'akwarium z wybiegiem');


-- Inserty gatunki --

INSERT INTO gatunki(gatunek) VALUES('kapibara wielka');
INSERT INTO gatunki(gatunek) VALUES('slon afrykanski');
INSERT INTO gatunki(gatunek) VALUES('slon indyjski');
INSERT INTO gatunki(gatunek) VALUES('zyrafa sawannowa');
INSERT INTO gatunki(gatunek) VALUES('zebra Chapmana');
INSERT INTO gatunki(gatunek) VALUES('strus czerwonoskory');
INSERT INTO gatunki(gatunek) VALUES('panda wielka');
INSERT INTO gatunki(gatunek) VALUES('panda mala');
INSERT INTO gatunki(gatunek) VALUES('nosorozec indyjski');
INSERT INTO gatunki(gatunek) VALUES('tygrys sumatrzanski');
INSERT INTO gatunki(gatunek) VALUES('lew angolski');
INSERT INTO gatunki(gatunek) VALUES('manat karaibski');
INSERT INTO gatunki(gatunek) VALUES('hipopotam nilowy');
INSERT INTO gatunki(gatunek) VALUES('rekin szary');
INSERT INTO gatunki(gatunek) VALUES('pingwin cesarski'); 
INSERT INTO gatunki(gatunek) VALUES('dikdik'); 
INSERT INTO gatunki(gatunek) VALUES('gwanako andyjskie'); 
INSERT INTO gatunki(gatunek) VALUES('wielblad jednogarbny'); 
INSERT INTO gatunki(gatunek) VALUES('kangur szary'); 
INSERT INTO gatunki(gatunek) VALUES('manul stepowy'); 
INSERT INTO gatunki(gatunek) VALUES('alpaka'); 
INSERT INTO gatunki(gatunek) VALUES('foka pospolita'); 
INSERT INTO gatunki(gatunek) VALUES('lemur katta'); 
INSERT INTO gatunki(gatunek) VALUES('wilk polarny'); 
INSERT INTO gatunki(gatunek) VALUES('niedzwiedz polarny'); 
INSERT INTO gatunki(gatunek) VALUES('siersciogon dzunglowy'); 
INSERT INTO gatunki(gatunek) VALUES('krokodyl rozancowy');


-- Inserty zwierzeta --

INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (1, 'Bogdan', 'kapibara wielka', 'samiec', 'Polska', '2012-12-31');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (1, 'Caramba', 'kapibara wielka', 'samica', 'Wenezuela' , '2018-04-05');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (1, 'Samba', 'kapibara wielka', 'samica', 'Wenezuela' , '2019-07-20');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (2, 'Zara', 'slon afrykanski', 'samica', 'Kenia' , '2017-07-14');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (2, 'Kito', 'slon afrykanski', 'samiec', NULL , '2010-01-08');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (2, 'Jabari', 'slon afrykanski', 'samiec', 'Tanzania' , '2001-11-03');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (2, 'Ananya', 'slon indyjski', 'samica', 'Indie' , '1999-03-12');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (2, 'Arjun', 'slon indyjski', 'samiec', 'Indie' , '1998-02-22');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (2, 'Jamil', 'zyrafa sawannowa', 'samiec', 'Kenia' , '2008-12-27');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (2, 'Kwame', 'zyrafa sawannowa', 'samiec', 'Egipt' , '2001-08-14');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (2, 'Rafiki', 'zyrafa sawannowa', 'samiec', 'Tanzania' , '2005-02-05');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (2, 'Giza', 'zyrafa sawannowa', 'samica', 'Sudan' , '1999-10-30');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (2, 'Amara', 'zyrafa sawannowa', 'samica', 'Ghana' , '2003-09-24');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (3, 'Zefir', 'zebra Chapmana', 'samiec', 'Republika Poludniowej Afryki', '2001-06-27');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (3, 'Zinnia', 'zebra Chapmana', 'samica', 'Republika Poludniowej Afryki', '2007-11-23');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (3, 'Zeus', 'zebra Chapmana', 'samiec', 'Republika Poludniowej Afryki', '2007-11-23');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (3, 'Zelda', 'zebra Chapmana', 'samica', 'Republika Poludniowej Afryki', '1999-12-01');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (3, 'Ziggy', 'zebra Chapmana', 'samiec', 'Republika Poludniowej Afryki', '2010-05-07');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (4, 'Olivia', 'strus czerwonoskory', 'samica', 'Senegal', '1989-02-17');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (4, 'Oscar', 'strus czerwonoskory', 'samiec', 'Nigeria', '1997-01-02');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (4, 'Odette', 'strus czerwonoskory', 'samica', 'Sudan', '2002-10-04');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (5, 'Yang Yang', 'panda wielka', 'samica', 'Chiny', '1997-09-09');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (5, 'Yuan Yuan', 'panda wielka', 'samiec', 'Chiny', '1996-08-14');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (6, 'Livi', 'panda mala', 'samica', 'Niemcy', '2021-06-07');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (6, 'Rufus', 'panda mala', 'samiec', 'Polska', '2019-03-21');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (7, 'Rocco', 'nosorozec indyjski', 'samiec', 'Pakistan', '1995-07-30');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (7, 'Titan', 'nosorozec indyjski', 'samiec', 'Pakistan', '2008-06-20');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (7, 'Zofia', 'nosorozec indyjski', 'samica', 'Indie', '2000-08-10');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (8, 'Rajesh', 'tygrys sumatrzanski', 'samiec', 'Indonezja', '2005-12-14');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (8, 'Kaida', 'tygrys sumatrzanski', 'samica', 'Indonezja', '2009-01-23');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (9, 'Nala', 'lew angolski', 'samica', 'Angola', '2012-07-21');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (9, 'Simba', 'lew angolski', 'samiec', 'Angola', '2015-03-06');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (10, 'Gumlle', 'manat karaibski', 'samiec', 'Dania', '2013-08-13');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (10, 'Amstrong', 'manat karaibski', 'samiec', 'Dania', '2013-08-13');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (10, 'Abel', 'manat karaibski', 'samica', 'Singapur', '2010-02-28');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (10, 'Ling', 'manat karaibski', 'samica', 'Singapur', '2017-04-08');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (10, 'Lavia', 'manat karaibski', 'samica', 'Polska', '2018-03-01');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (11, 'Tucker', 'hipopotam nilowy', 'samiec', 'Stany Zjednoczone', '2003-05-18');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (11, 'Fritz', 'hipopotam nilowy', 'samiec', 'Stany Zjednoczone', '2022-08-03');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (11, 'Bibi', 'hipopotam nilowy', 'samica', 'Stany Zjednoczone', '1999-02-01');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (11, 'Fiona', 'hipopotam nilowy', 'samica', 'Stany Zjednoczone', '2017-01-24');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (12, 'Mia', 'rekin szary', 'samica', 'Sri Lanka', '2006-09-20');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (13, 'Petra', 'pingwin cesarski', 'samica', 'Antarktyda', '2010-04-03');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (13, 'Piotr', 'pingwin cesarski', 'samiec', 'Antarktyda', '2012-07-14');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (13, 'Zuzia', 'pingwin cesarski', 'samica', 'Antarktyda', '2008-09-22');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (13, 'Zygmunt', 'pingwin cesarski', 'samiec', 'Antarktyda', '2015-11-08');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (13, 'Helena', 'pingwin cesarski', 'samica', 'Antarktyda', '2007-03-05');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (13, 'Henryk', 'pingwin cesarski', 'samiec', 'Antarktyda', '2019-12-19');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (14, 'Daisy', 'dikdik', 'samica', 'Somalia', '2021-04-15');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (14, 'Dexter', 'dikdik', 'samiec', 'Somalia', '2022-02-28');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (14, 'Delilah', 'dikdik', 'samica', 'Tanzania', '2021-09-10');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (14, 'Darwin', 'dikdik', 'samiec', 'Tanzania', '2023-01-08');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (15, 'Baltazar', 'gwanako andyjskie', 'samiec', 'Argentyna', '2003-05-22');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (15, 'Isabella', 'gwanako andyjskie', 'samica', 'Chile', '2001-11-14');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (15, 'Maximus', 'gwanako andyjskie', 'samiec', 'Peru', '2005-08-30');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (15, 'Olivia', 'gwanako andyjskie', 'samica', 'Argentyna', '2007-07-09');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (15, 'Hernan', 'gwanako andyjskie', 'samiec', 'Chile', '2002-04-18');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (16, 'Amira', 'wielblad jednogarbny', 'samica', 'Egipt', '1995-08-12');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (16, 'Rashid', 'wielblad jednogarbny', 'samiec', 'Arabia Saudyjska', '1993-04-25');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (16, 'Nala', 'wielblad jednogarbny', 'samica', 'Oman', '1998-12-07');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (16, 'Khalid', 'wielblad jednogarbny', 'samiec', 'Yemen', '1990-11-03');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (17, 'Cooper', 'kangur szary', 'samiec', 'Papua-Nowa Gwinea', '2008-11-30');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (17, 'Matilda', 'kangur szary', 'samica', 'Australia', '2007-07-14');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (17, 'Buddy', 'kangur szary', 'samiec', 'Papua-Nowa Gwinea', '2012-05-02');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (17, 'Ruby', 'kangur szary', 'samica', 'Australia', '2015-08-23');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (17, 'Jack', 'kangur szary', 'samiec', 'Papua-Nowa Gwinea', '2009-12-10');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (17, 'Kara', 'kangur szary', 'samica', 'Australia', '2010-02-18');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (18, 'Tatiana', 'manul stepowy', 'samica', 'Kazachstan', '2016-08-14');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (18, 'Boris', 'manul stepowy', 'samiec', 'Iran', '2015-11-27');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (18, 'Nadia', 'manul stepowy', 'samica', 'Pakistan', '2018-05-03');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (18, 'Ivan', 'manul stepowy', 'samiec', 'Kazachstan', '2017-02-18');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (19, 'Pablo', 'alpaka', 'samiec', 'Boliwia', '2010-08-22');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (19, 'Sophie', 'alpaka', 'samica', 'Peru', '2008-04-14');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (19, 'Felipe', 'alpaka', 'samiec', 'Chile', '2012-01-30');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (19, 'Maria', 'alpaka', 'samica', 'Boliwia', '2007-07-09');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (19, 'Diego', 'alpaka', 'samiec', 'Peru', '2015-02-28');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (19, 'Luna', 'alpaka', 'samica', 'Chile', '2009-11-15');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (20, 'Aiden', 'foka pospolita', 'samiec', 'Portugalia', '1995-06-18');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (20, 'Aria', 'foka pospolita', 'samica', 'Kanada', '1983-12-04');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (20, 'Sebastian', 'foka pospolita', 'samiec', 'Meksyk', '1990-08-22');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (20, 'Luna', 'foka pospolita', 'samica', 'Chiny', '2005-03-11');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (20, 'Finn', 'foka pospolita', 'samiec', 'Portugalia', '2010-10-28');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (20, 'Mila', 'foka pospolita', 'samica', 'Kanada', '1998-07-15');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (20, 'Leo', 'foka pospolita', 'samiec', 'Meksyk', '1988-04-02');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Xander', 'lemur katta', 'samiec', 'Madagaskar', '2012-03-14');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Zane', 'lemur katta', 'samica', 'Madagaskar', '2011-09-28');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Willow', 'lemur katta', 'samica', 'Madagaskar', '2014-05-02');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Felix', 'lemur katta', 'samiec', 'Madagaskar', '2017-11-11');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Nina', 'lemur katta', 'samica', 'Madagaskar', '2013-08-06');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Owen', 'lemur katta', 'samiec', 'Madagaskar', '2015-02-19');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Zoey', 'lemur katta', 'samica', 'Madagaskar', '2016-06-30');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Jaxon', 'lemur katta', 'samiec', 'Madagaskar', '2010-12-17');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Layla', 'lemur katta', 'samica', 'Madagaskar', '2018-09-23');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Julian', 'lemur katta', 'samiec', 'Madagaskar', '2019-04-08');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Elijah', 'lemur katta', 'samica', 'Madagaskar', '2010-07-22');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Harper', 'lemur katta', 'samica', 'Madagaskar', '2011-01-14');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (21, 'Lucy', 'lemur katta', 'samica', 'Madagaskar', '2013-04-27');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (22, 'Shadow', 'wilk polarny', 'samiec', 'Rosja', '2013-04-15');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (22, 'Lala', 'wilk polarny', 'samica', 'Stany Zjednoczone', '2011-11-28');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (22, 'Rogue', 'wilk polarny', 'samiec', 'Kanada', '2014-07-02');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (22, 'Aria', 'wilk polarny', 'samica', 'Rosja', '2016-02-19');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (23, 'Snow', 'niedzwiedz polarny', 'samiec', 'Stany Zjednoczone', '1995-08-12');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (23, 'Aurora', 'niedzwiedz polarny', 'samica', 'Kanada', '1998-03-24');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (24, 'Rubin', 'siersciogon dzunglowy', 'samiec', 'Filipiny', '2019-05-17');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (24, 'Mango', 'siersciogon dzunglowy', 'samica', 'Filipiny', '2018-08-29');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (24, 'Cocoa', 'siersciogon dzunglowy', 'samiec', 'Filipiny', '2020-12-10');
INSERT INTO zwierzeta(id_klatki, imie, gatunek, plec, pochodzenie, data_urodzin) VALUES (25, 'Kroko', 'krokodyl rozancowy', 'samiec', 'Indie', '2007-10-04');


-- Inserty rozpiska_godzinowa --

INSERT INTO rozpiska_godzinowa(pora) VALUES ('09:00');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('09:30');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('10:00');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('10:30');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('11:00');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('11:30');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('12:00');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('12:30');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('13:00');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('13:30');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('14:00');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('14:30');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('15:00');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('15:30');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('16:00');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('16:30');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('17:00');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('17:30');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('18:00');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('18:30');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('19:00');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('19:30');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('20:00');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('20:30');
INSERT INTO rozpiska_godzinowa(pora) VALUES ('21:00');


-- Inserty dostawy_pozywienia --

INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('swieza trawa', 'poniedzialek');
INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('orzechy', 'wtorek');
INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('owoce', 'sroda');
INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('warzywa', 'czwartek');
INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('rosliny wodne', 'piatek');
INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('bambus', 'sobota');
INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('ryby', 'niedziela');
INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('siano', 'poniedzialek');
INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('liscie akacji', 'wtorek');
INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('kora', 'sroda');
INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('zboza', 'czwartek');
INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('mieso', 'piatek');
INSERT INTO dostawy_pozywienia (rodzaj_jedzenia, dzien_dostawy) VALUES('mieso-gryzonie', 'sobota');


-- Inserty karmienie --

INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (1, '09:00', 1, 'swieza trawa');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (1, '17:00', 3, 'swieza trawa');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (2, '09:30', 2, 'swieza trawa');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (2, '11:30', 5, 'liscie akacji');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (2, '19:00', 22, 'swieza trawa');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (2, '14:00', 22, 'owoce');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (2, '19:30', 23, 'liscie akacji');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (3, '09:00', 2, 'kora');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (3, '18:30', 21, 'swieza trawa');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (4, '10:00', 4, 'zboza');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (4, '20:30', 25, 'zboza');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (5, '09:30', 12, 'bambus');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (5, '15:30', 12, 'bambus');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (5, '18:30', 10, 'bambus');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (6, '09:30', 1, 'orzechy');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (6, '19:00', 17, 'bambus');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (7, '10:00', 6, 'siano');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (7, '19:00', 6, 'swieza trawa');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (8, '09:00', 8, 'mieso');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (8, '16:00', 9, 'mieso');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (9, '09:30', 8, 'mieso');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (9, '16:30', 7, 'mieso');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (10, '09:00', 18, 'rosliny wodne');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (10, '15:00', 18, 'warzywa');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (10, '21:00', 18, 'rosliny wodne');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (11, '11:00', 3, 'swieza trawa');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (11, '16:00', 3, 'owoce');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (11, '20:30', 11, 'rosliny wodne');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (12, '14:30', 20, 'ryby');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (12, '20:30', 20, 'ryby');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (13, '13:30', 20, 'ryby');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (13, '21:00', 20, 'ryby');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (14, '15:30', 14, 'siano');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (14, '19:30', 14, 'swieza trawa');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (15, '10:30', 13, 'siano');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (15, '15:30', 15, 'siano');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (16, '10:30', 15, 'siano');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (16, '17:30', 13, 'siano');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (17, '10:00', 16, 'swieza trawa');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (17, '14:00', 16, 'owoce');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (17, '19:00', 16, 'siano');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (18, '15:00', 24, 'mieso-gryzonie');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (19, '10:00', 13, 'siano');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (19, '17:00', 15, 'siano');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (20, '12:00', 21, 'ryby');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (20, '20:00', 21, 'ryby');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (21, '13:00', 2, 'kora');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (21, '18:30', 2, 'owoce');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (22, '10:00', 8, 'mieso');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (22, '20:00', 9, 'mieso');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (23, '10:30', 8, 'mieso');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (23, '20:30', 9, 'mieso');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (24, '09:00', 12, 'owoce');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (24, '19:00', 12, 'orzechy');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (25, '10:00', 2, 'mieso');
INSERT INTO karmienie(id_klatki, pora_karmienia, id_opiekuna, rodzaj_jedzenia) VALUES (25, '18:00', 7, 'ryby');


-- Inserty czyszczenie_klatek --

INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (1, '15:00', 1);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (2, '13:00', 3);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (3, '10:30', 2);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (4, '14:30', 24);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (5, '10:00', 3);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (6, '15:00', 25);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (7, '09:30', 4);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (8, '14:30', 4);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (9, '10:00', 5);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (10, '16:00', 5);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (11, '09:00', 6);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (12, '14:00', 23);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (13, '12:00', 7);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (14, '21:00', 7);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (15, '18:30', 8);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (16, '20:30', 8);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (17, '17:30', 9);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (18, '20:30', 22);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (19, '18:00', 10);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (20, '21:00', 10);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (21, '17:30', 11);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (22, '18:00', 11);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (23, '18:30', 25);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (24, '21:00', 12);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (25, '12:00', 19);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (1, '19:00', 13);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (2, '21:00', 13);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (4, '19:30', 21);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (5, '17:30', 15);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (6, '20:30', 15);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (7, '18:00', 16);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (8, '21:00', 21);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (9, '17:30', 17);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (10, '20:30', 17);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (11, '18:30', 18);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (12, '20:00', 18);
INSERT INTO czyszczenie_klatek (id_klatki, pora_czyszczenia, id_opiekuna) VALUES (13, '17:00', 19);


-- Inserty weterynarze --

INSERT INTO weterynarze (imie, nazwisko, specjalizacja) VALUES ('Anna', 'Wisniewska-Kowalska', NULL);
INSERT INTO weterynarze (imie, nazwisko, specjalizacja) VALUES ('Tomasz', 'Emilianowicz', 'chirurg zwierzat malych');
INSERT INTO weterynarze (imie, nazwisko, specjalizacja) VALUES ('Jan', 'Kowalski', 'dentysta');
INSERT INTO weterynarze (imie, nazwisko, specjalizacja) VALUES ('Maria', 'Wesolowska', NULL);
INSERT INTO weterynarze (imie, nazwisko, specjalizacja) VALUES ('Artur', 'Kulesza', 'chirurg zwierzat duzych');
INSERT INTO weterynarze (imie, nazwisko, specjalizacja) VALUES ('Marcin', 'Kot', NULL);


-- Inserty badania --

INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2020-10-30 08:32:15', 2, 1, 'leczenie', 'biegunka');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2019-05-17 16:55:20', 1, 17, 'profilaktyczne', 'impotencja');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2020-04-15 12:45:30', 3, 25, 'leczenie', 'bol zeba trzonowego');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2012-11-28 09:15:00', 4, 53, 'profilaktyczne', 'swiad');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2018-07-02 18:30:45', 5, 74, 'leczenie', 'zapalenie spojowek');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2013-09-19 15:10:20', 6, 89, 'profilaktyczne', 'zakazenie układu oddechowego');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2015-03-08 07:55:00', 1, 10, 'profilaktyczne', NULL);
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2022-12-05 14:22:30', 1, 35, 'profilaktyczne', 'choroba dziasel');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2023-06-17 10:00:15', 3, 52, 'leczenie', 'parazytoza');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2019-05-22 16:40:00', 4, 68, 'profilaktyczne', NULL);
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2006-02-14 22:17:45', 5, 81, 'leczenie', 'choroba układu sercowo-naczyniowego');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2019-10-01 11:05:00', 6, 93, 'profilaktyczne', 'biegunka');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2010-08-26 19:30:30', 1, 5, 'leczenie', 'zlamana kosc');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2021-12-14 02:12:00', 2, 49, 'profilaktyczne', 'cukrzyca');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2007-12-10 08:45:15', 3, 63, 'leczenie', 'wada zgryzu');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2014-06-03 17:20:00', 4, 79, 'profilaktyczne', 'choroba układu sercowo-naczyniowego');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2016-09-28 23:32:45', 5, 98, 'leczenie', 'nadkruszony zab');
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2019-01-20 13:55:00', 6, 105, 'profilaktyczne', NULL);
INSERT INTO badania(id_badania, id_weterynarza, id_zwierzecia, typ_badania, choroba) VALUES ('2020-03-21 14:12:25', 5, 94, 'leczenie', 'infekcja bakteryjna');



-- Inserty sponsorzy --

INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('Stonka', NULL, NULL);
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('Zaklad Krawiecki Przy Moscie', 'Roman', 'Malenczuk');
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES(NULL, 'Adam', 'Malysz');
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('BMW Wroclaw', NULL, NULL);
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('Cukiernia u Renaty', 'Renata', 'Wisniewska');
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('Zaklad Mechaniczny Dluga 5', 'Mariusz', 'Wojcik');
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('Biuro Rachunkowe EB', 'Ewa', 'Blada');
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('Szkola Rysunku OLOWEK', 'Wiktoria', 'Sokolowska');
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('Lotnisko we Wroclawiu', NULL, NULL);
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES(NULL, 'Anna', 'Wozniak');
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('Biuro Maklerskie', 'Jakub', 'Madry');
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('Biuro Podrozy Tropiki', NULL, 'Kaminscy');
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('Apteka z Gestem', 'Malgorzata', 'Sekowska');
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('Klub szachowy w Zlotym Stoku', 'Miroslaw', 'Zielinski'); 
INSERT INTO sponsorzy(nazwa_firmy, imie, nazwisko) VALUES('Szkola nr 4 w Sochawczewie', NULL, NULL);


-- Inserty donacje --

INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2023-09-01 10:00:00', 11, 1, 10000);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2021-02-19 17:01:20', 7, 54, 700);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2023-09-28 14:37:22', 9, 22, 3000);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2020-07-12 10:45:18', 12, 23, 3000);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2023-12-06 18:59:07', 15, 24, 5500);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2023-08-31 09:00:22', 4, 38, 7000);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2023-08-31 09:02:12', 4, 39, 10000);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2023-08-31 09:05:17', 4, 40, 6000);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2023-08-31 09:07:48', 4, 41, 4000);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2022-06-30 15:42:30', 14, 71, 1200);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2022-04-11 12:35:39', 8, 36, 3400);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2021-01-13 19:02:05', 5, 63, 2900);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2020-02-25 11:50:23', 6, 92, 3100);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2021-03-20 08:27:46', 3, 103, 5555);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2022-10-29 10:08:09', 13, 12, 2340);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2021-11-24 17:16:29', 10, 4, 7500);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2020-12-09 07:58:55', 2, 60, 4350);
INSERT INTO donacje(czas_donacji, id_sponsora, id_zwierzecia, kwota) VALUES ('2021-01-23 14:42:56', 1, 84, 2200);


-- Inserty sklep --

INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('kapibara wielka', 'kubek', 240);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('kapibara wielka', 'koszulka', 50);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('kapibara wielka', 'dlugopis', 100);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('kapibara wielka', 'magnes', 20);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('kapibara wielka', 'przytulanka', 50);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('slon indyjski', 'magnes', 30);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('slon indyjski', 'pocztowka', 70);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('slon indyjski', 'koszulka', 10);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('zyrafa sawannowa', 'dlugopis', 45);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('zyrafa sawannowa', 'kubek', 60);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('panda wielka', 'kubek', 90);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('panda wielka', 'magnes', 150);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('panda wielka', 'przytulanka', 80);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('panda wielka', 'przytulanka z termoforem', 123);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('panda wielka', 'dlugopis', 50);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('panda wielka', 'koszulka', 200);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('panda mala', 'przytulanka', 30);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('panda mala', 'pocztowka', 70);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('tygrys sumatrzanski', 'kubek', 27);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('tygrys sumatrzanski', 'bransoletka', 14);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('lew angolski', 'brelok', 50);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('lew angolski', 'dlugopis', 17);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('lew angolski', 'przytulanka', 31);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('manat karaibski', 'kubek', 15);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('manat karaibski', 'przytulanka z termoforem', 149);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('manat karaibski', 'manges', 126);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('manat karaibski', 'zeszyt', 46);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('hipopotam nilowy', 'brelok', 78);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('hipopotam nilowy', 'przytulanka z termoforem', 209);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('hipopotam nilowy', 'pocztowka', 173);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('hipopotam nilowy', 'magnes', 97);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('pingwin cesarski', 'zeszyt', 29);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('pingwin cesarski', 'magnes', 84);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('foka pospolita', 'kubek', 67);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('foka pospolita', 'przytulanka', 38);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('lemur katta', 'magnes', 29);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('lemur katta', 'pocztowka', 76);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('lemur katta', 'brelok', 55);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('wilk polarny', 'brelok', 24);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('wilk polarny', 'przytulanka z termoforem', 75);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('wilk polarny', 'kubek', 32);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('niedzwiedz polarny', 'magnes', 15);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('niedzwiedz polarny', 'przytulanka z termoforem', 35);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('niedzwiedz polarny', 'dlugopis', 15);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('siersciogon dzunglowy', 'pocztowka', 45);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('siersciogon dzunglowy', 'brelok', 32);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('siersciogon dzunglowy', 'przytulanka', 91);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('siersciogon dzunglowy', 'zeszyt', 44);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('krokodyl rozancowy', 'brelok', 23);
INSERT INTO sklep(gatunek, rodzaj_pamiatki, ilosc) VALUES ('krokodyl rozancowy', 'przytulanka z termoforem', 46);





-- FUNKCJE/WYZWALACZE --

-- Ta sama klatka nie moze byc karmiona w trakcie czyszczenia czyszczona --

DROP FUNCTION IF EXISTS blokuj_dodanie_karmienia_o_tej_samej_porze_co_czyszczenie CASCADE;

CREATE OR REPLACE FUNCTION blokuj_dodanie_karmienia_o_tej_samej_porze_co_czyszczenie()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT *
        FROM czyszczenie_klatek
        WHERE czyszczenie_klatek.id_klatki = NEW.id_klatki
          AND czyszczenie_klatek.pora_czyszczenia = NEW.pora_karmienia
    ) THEN
        RAISE EXCEPTION 'Klatka nie moze byc nakarmiona o tej porze, trwa czyszczenie!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trigg_blokuj_dodanie_karmienia_o_tej_samej_porze_co_czyszczenie ON karmienie;

CREATE TRIGGER trigg_blokuj_dodanie_karmienia_o_tej_samej_porze_co_czyszczenie 
	BEFORE INSERT OR UPDATE ON karmienie 
	FOR EACH ROW EXECUTE PROCEDURE blokuj_dodanie_karmienia_o_tej_samej_porze_co_czyszczenie();



-- Ta sama klatka nie moze byc czyszczona w trakcie karmienia --

DROP FUNCTION IF EXISTS blokuj_dodanie_czyszczenia_o_tej_samej_porze_co_karmienie;

CREATE OR REPLACE FUNCTION blokuj_dodanie_czyszczenia_o_tej_samej_porze_co_karmienie()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT * 
        FROM karmienie 
        WHERE (karmienie.id_klatki = NEW.id_klatki AND 
		karmienie.pora_karmienia = NEW.pora_czyszczenia)
    ) THEN
        RAISE EXCEPTION 'Klatka nie moze byc czyszczona o tej porze, trwa karmienie!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trigg_blokuj_dodanie_czyszczenia_o_tej_samej_porze_co_karmienie ON czyszczenie_klatek;

CREATE TRIGGER trigg_blokuj_dodanie_czyszczenia_o_tej_samej_porze_co_karmienie 
	BEFORE INSERT OR UPDATE ON czyszczenie_klatek 
	FOR EACH ROW EXECUTE PROCEDURE blokuj_dodanie_czyszczenia_o_tej_samej_porze_co_karmienie();



-- Ten sam opiekun nie moze rownoczesnie karmic kilku klatek --

DROP FUNCTION IF EXISTS blokuj_dublowanie_karmiacego_opiekuna CASCADE;

CREATE OR REPLACE FUNCTION blokuj_dublowanie_karmiacego_opiekuna()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT *
		FROM karmienie
		WHERE (karmienie.pora_karmienia = NEW.pora_karmienia AND 
		karmienie.id_opiekuna = NEW.id_opiekuna AND 
		karmienie.id_klatki != NEW.id_klatki)
    ) THEN
        RAISE EXCEPTION 'Dwie klatki nie moga byc karmione jednoczesnie przez tego samego opiekuna!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trigg_blokuj_dublowanie_karmiacego_opiekuna ON karmienie;

CREATE TRIGGER trigg_blokuj_dublowanie_karmiacego_opiekuna 
	BEFORE INSERT OR UPDATE ON karmienie 
	FOR EACH ROW EXECUTE PROCEDURE blokuj_dublowanie_karmiacego_opiekuna();





-- Ten sam opiekun nie moze rownoczesnie czyscic kilku klatek --

DROP FUNCTION IF EXISTS blokuj_dublowanie_czyszczacego_opiekuna CASCADE;

CREATE OR REPLACE FUNCTION blokuj_dublowanie_czyszczacego_opiekuna()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT *
        FROM czyszczenie_klatek 
		WHERE (czyszczenie_klatek.pora_czyszczenia = NEW.pora_czyszczenia AND 
		czyszczenie_klatek.id_opiekuna = NEW.id_opiekuna)
    ) THEN
        RAISE EXCEPTION 'Dwie klatki nie moga byc czyszczone jednoczesnie przez tego samego opiekuna!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trigg_blokuj_dublowanie_czyszczacego_opiekuna ON czyszczenie_klatek;

CREATE TRIGGER trigg_blokuj_dublowanie_czyszczacego_opiekuna 
	BEFORE INSERT OR UPDATE ON czyszczenie_klatek 
	FOR EACH ROW EXECUTE PROCEDURE blokuj_dublowanie_czyszczacego_opiekuna();



-- Ten sam opiekun nie moze czyscic w trakcie karmienia --

DROP FUNCTION IF EXISTS blokuj_czyszczenie_gdy_opiekun_karmi CASCADE;

CREATE OR REPLACE FUNCTION blokuj_czyszczenie_gdy_opiekun_karmi()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT *
        FROM karmienie
        WHERE (karmienie.id_opiekuna = NEW.id_opiekuna AND 
		karmienie.pora_karmienia = NEW.pora_czyszczenia)
    ) THEN
        RAISE EXCEPTION 'Klatka nie moze byc czyszczona o tej porze, ten opiekun wlasnie karmi!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trigg_blokuj_czyszczenie_gdy_opiekun_karmi ON czyszczenie_klatek;

CREATE TRIGGER trigg_blokuj_czyszczenie_gdy_opiekun_karmi 
	BEFORE INSERT OR UPDATE ON czyszczenie_klatek 
	FOR EACH ROW EXECUTE PROCEDURE blokuj_czyszczenie_gdy_opiekun_karmi();



-- Ten sam opiekun nie moze karmic w trakcie czyszczenia --

DROP FUNCTION IF EXISTS blokuj_karmienie_gdy_opiekun_czysci;

CREATE OR REPLACE FUNCTION blokuj_karmienie_gdy_opiekun_czysci()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT *
        FROM czyszczenie_klatek
        WHERE (czyszczenie_klatek.id_opiekuna = NEW.id_opiekuna AND 
		czyszczenie_klatek.pora_czyszczenia = NEW.pora_karmienia)
    ) THEN
        RAISE EXCEPTION  'Klatka nie moze byc karmiona o tej porze, ten opiekun wlasnie czysci!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trigg_blokuj_karmienie_gdy_opiekun_czysci ON karmienie;

CREATE TRIGGER trigg_blokuj_karmienie_gdy_opiekun_czysci 
	BEFORE INSERT OR UPDATE ON karmienie 
	FOR EACH ROW EXECUTE PROCEDURE blokuj_karmienie_gdy_opiekun_czysci();



-- Opiekun, ktory nie ma uprawnien do bycia kierownikiem sektoru nie moze nim byc -- 

DROP FUNCTION IF EXISTS blokuj_opiekuna_bez_uprawnien;

CREATE OR REPLACE FUNCTION blokuj_opiekuna_bez_uprawnien()
RETURNS TRIGGER AS $$
DECLARE
	czy_moze_byc_kier BOOLEAN;
BEGIN
    SELECT opiekunowie.czy_moze_byc_kierownikiem INTO czy_moze_byc_kier
		FROM opiekunowie
        WHERE opiekunowie.id_opiekuna = NEW.id_kierownika;
    IF (NOT czy_moze_byc_kier) THEN
        RAISE EXCEPTION  'Ten opiekun nie moze zostac kierownikiem!';
    ELSE
		RETURN NEW;
	END IF;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS trigg_blokuj_opiekuna_bez_uprawnien ON sektory;

CREATE TRIGGER trigg_blokuj_opiekuna_bez_uprawnien
	BEFORE INSERT OR UPDATE ON sektory 
	FOR EACH ROW EXECUTE PROCEDURE blokuj_opiekuna_bez_uprawnien();



-- Opiekun nie moze byc zatruniony z przyszla data --

DROP FUNCTION IF EXISTS data_nie_z_przyszlosci_opiekunowie;

CREATE OR REPLACE FUNCTION data_nie_z_przyszlosci_opiekunowie()
RETURNS TRIGGER AS $$
BEGIN
    IF (CURRENT_DATE < NEW.data_zatrudnienia)
    THEN
        RAISE EXCEPTION  'Nie mozna wybrac daty zatrudnienia z przyszlosci!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trigg_data_nie_z_przyszlosci_opiekunowie ON opiekunowie;

CREATE TRIGGER trigg_data_nie_z_przyszlosci_opiekunowie
	BEFORE INSERT OR UPDATE ON opiekunowie 
	FOR EACH ROW EXECUTE PROCEDURE data_nie_z_przyszlosci_opiekunowie();



-- Zwierze (ktore jest w bazie) nie moze urodzic sie w przyszlosci -- 

DROP FUNCTION IF EXISTS data_nie_z_przyszlosci_zwierzeta;

CREATE OR REPLACE FUNCTION data_nie_z_przyszlosci_zwierzeta()
RETURNS TRIGGER AS $$
BEGIN
    IF (CURRENT_DATE < NEW.data_urodzin)
    THEN
        RAISE EXCEPTION  'Nie mozna wybrac daty urodzin z przyszlosci!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trigg_data_nie_z_przyszlosci_zwierzeta ON zwierzeta;

CREATE TRIGGER trigg_data_nie_z_przyszlosci_zwierzeta
	BEFORE INSERT OR UPDATE ON zwierzeta 
	FOR EACH ROW EXECUTE PROCEDURE data_nie_z_przyszlosci_zwierzeta();



-- Badanie (ktore jest w bazie) nie moze byc zrobine w przyszlosci -- 

DROP FUNCTION IF EXISTS ts_nie_z_przyszlosci_badanie;

CREATE OR REPLACE FUNCTION ts_nie_z_przyszlosci_badanie()
RETURNS TRIGGER AS $$
BEGIN
    IF (CURRENT_TIMESTAMP < NEW.id_badania)
    THEN
        RAISE EXCEPTION  'Nie mozna wybrac daty i godziny badania z przyszlosci!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trigg_ts_nie_z_przyszlosci_badanie ON badania;

CREATE TRIGGER trigg_ts_nie_z_przyszlosci_badanie
	BEFORE INSERT OR UPDATE ON badania 
	FOR EACH ROW EXECUTE PROCEDURE ts_nie_z_przyszlosci_badanie();



-- Donacja (ktora jest w bazie) nie moze byc zrobiona w przyszlosci -- 

DROP FUNCTION IF EXISTS ts_nie_z_przyszlosci_donacje;

CREATE OR REPLACE FUNCTION ts_nie_z_przyszlosci_donacje()
RETURNS TRIGGER AS $$
BEGIN
    IF (CURRENT_TIMESTAMP < NEW.czas_donacji)
    THEN
        RAISE EXCEPTION  'Nie mozna wybrac daty i godziny donacji z przyszlosci!';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER IF EXISTS trigg_ts_nie_z_przyszlosci_donacje ON donacje;

CREATE TRIGGER trigg_ts_nie_z_przyszlosci_donacje
	BEFORE INSERT OR UPDATE ON donacje 
	FOR EACH ROW EXECUTE PROCEDURE ts_nie_z_przyszlosci_donacje();



-- Widoki --

CREATE VIEW karta_pacjenta AS
	SELECT z.id_zwierzecia, z.imie, z.gatunek, b.id_badania, w.id_weterynarza 
		FROM zwierzeta z, badania b, weterynarze w 
		WHERE b.id_zwierzecia=z.id_zwierzecia AND b.id_weterynarza=w.id_weterynarza;

 

 CREATE VIEW operacje_na_klatkach AS
	(SELECT id_klatki, pora_karmienia, 'karmienie' AS operacja 
		FROM karmienie)
	UNION
	(SELECT id_klatki, pora_czyszczenia, 'czyszczenie'  AS operacja 
		FROM czyszczenie_klatek)
	ORDER BY id_klatki;

 

CREATE VIEW zajecia_opiekunow AS
	(SELECT opiekunowie.id_opiekuna, opiekunowie.imie, opiekunowie.nazwisko, 
	karmienie.id_klatki, karmienie.pora_karmienia, 'karmienie' AS operacja
		FROM opiekunowie, karmienie
		WHERE opiekunowie.id_opiekuna=karmienie.id_opiekuna)
	UNION
	(SELECT opiekunowie.id_opiekuna, opiekunowie.imie, opiekunowie.nazwisko, 
	czyszczenie_klatek.id_klatki, czyszczenie_klatek.pora_czyszczenia, 'czyszczenie' AS operacja
		FROM opiekunowie, czyszczenie_klatek
		WHERE opiekunowie.id_opiekuna=czyszczenie_klatek.id_opiekuna)
	ORDER BY id_opiekuna;

