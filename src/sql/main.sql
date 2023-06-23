DELIMITER //

CREATE TABLE IF NOT EXISTS `bankkonten` (
  `konto` varchar(255) NOT NULL,
  `kontonummer` varchar(10) DEFAULT '',
  `bic` varchar(15) DEFAULT NULL,
  `blz` varchar(15) DEFAULT NULL,
  `waehrung` varchar(5) DEFAULT '',
  `last_fints_query` datetime DEFAULT NULL,
  `kostenstelle` int(11) DEFAULT 0,
  PRIMARY KEY (`konto`)
) //


CREATE TABLE IF NOT EXISTS `kontoauszuege` (
  `ID` int(11) NOT NULL,
  `bankkonto` varchar(255) NOT NULL,
  `BUCHUNGSDATUM` date DEFAULT NULL,
  `VALUTA` date DEFAULT NULL,
  `betrag` decimal(15,2) DEFAULT NULL,
  `WAEHRUNG` varchar(10) DEFAULT NULL,
  `EMPFAENGERNAME1` varchar(255) DEFAULT NULL,
  `EMPFAENGERNAME2` varchar(255) DEFAULT NULL,
  `PRIMANOTA` int(11) DEFAULT NULL,
  `blz` varchar(15) DEFAULT NULL,
  `kontonummer` varchar(30) DEFAULT NULL,
  `VERWENDUNGSZWECK1` varchar(255) DEFAULT NULL,
  `VERWENDUNGSZWECK2` varchar(255) DEFAULT NULL,
  `VERWENDUNGSZWECK3` varchar(255) DEFAULT NULL,
  `VERWENDUNGSZWECK4` varchar(255) DEFAULT NULL,
  `VERWENDUNGSZWECK5` varchar(255) DEFAULT NULL,
  `RECHNUNGSNUMMER` varchar(400) DEFAULT NULL,
  `ZAHLUNGSID` int(11) DEFAULT NULL,
  `uniqueid` varchar(255) NOT NULL,
  `kontostand` decimal(15,2) DEFAULT 0.00,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uidx_kontoauszuege_uniqueid_n` (`uniqueid`),
  KEY `idx_ka_bd` (`BUCHUNGSDATUM`),
  KEY `idx_ka_va` (`VALUTA`),
  KEY `idx_ka_e1` (`EMPFAENGERNAME1`),
  KEY `idx_ka_e2` (`EMPFAENGERNAME2`),
  KEY `idx_ka_blz` (`blz`),
  KEY `idx_ka_kno` (`kontonummer`),
  KEY `idx_ka_v1` (`VERWENDUNGSZWECK1`),
  KEY `idx_ka_v2` (`VERWENDUNGSZWECK2`),
  KEY `idx_ka_v3` (`VERWENDUNGSZWECK3`),
  KEY `idx_ka_v4` (`VERWENDUNGSZWECK4`),
  KEY `idx_ka_zi` (`ZAHLUNGSID`)
) //

call addForeignKeyIfNotExists (
    'kontoauszuege', 
    'bankkonten', 
    'fk_kontoauszuege_bankkonten',
    
    'bankkonto',
    'konto',
    
    'cascade',
    'restrict'
) //

CREATE TABLE IF NOT EXISTS `kontoauszuege_belege` (
  `id` int(11) NOT NULL DEFAULT 0,
  `belegnummer` bigint(20) NOT NULL DEFAULT 0,
  `tabellenzusatz` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`belegnummer`,`tabellenzusatz`)
) //


call addForeignKeyIfNotExists (
    'kontoauszuege_belege', 
    'kontoauszuege', 
    'fk_kontoauszuege_belege_kontoauszuege',
    'id',
    'id',
    'cascade',
    'restrict'
) //


CREATE TABLE IF NOT EXISTS `fints_accounts` (
  `id` int(11) NOT NULL,
  `url` varchar(255) NOT NULL,
  `port` int(11) DEFAULT 443,
  `code` char(8) NOT NULL,
  `banking_username` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) //