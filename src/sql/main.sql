DELIMITER //

CREATE TABLE IF NOT EXISTS `bankkonten` (
  `konto` varchar(255) NOT NULL,
  `kontonummer` varchar(10) DEFAULT '',
  `bic` varchar(15) DEFAULT NULL,
  `blz` varchar(15) DEFAULT NULL,
  `waehrung` varchar(5) DEFAULT '',
  `last_fints_query` datetime DEFAULT NULL,
  PRIMARY KEY (`konto`)
) //

alter table bankkonten rename column `KONTO` to `konto` //

call addFieldIfNotExists("bankkonten","name","varchar(100) DEFAULT ''") //
call addFieldIfNotExists("bankkonten","kontonummer","varchar(10) DEFAULT ''") //
call addFieldIfNotExists("bankkonten","bic","varchar(15) DEFAULT NULL") //
call addFieldIfNotExists("bankkonten","blz","varchar(15) DEFAULT NULL") //
call addFieldIfNotExists("bankkonten","waehrung","varchar(5) DEFAULT 'EUR'") //
call addFieldIfNotExists("bankkonten","last_fints_query","datetime DEFAULT NULL") //


create table if not exists `kontoauszuege` (
  `id` int(11) not null,
  `bankkonto` varchar(255) not null,
  `buchungsdatum` date default null,
  `valuta` date default null,
  `betrag` decimal(15,2) default null,
  `waehrung` varchar(10) default null,
  `empfaengername1` varchar(255) default null,
  `empfaengername2` varchar(255) default null,
  `primanota` int(11) default null,
  `blz` varchar(15) default null,
  `kontonummer` varchar(30) default null,
  `verwendungszweck1` varchar(255) default null,
  `verwendungszweck2` varchar(255) default null,
  `verwendungszweck3` varchar(255) default null,
  `verwendungszweck4` varchar(255) default null,
  `verwendungszweck5` varchar(255) default null,
  `rechnungsnummer` varchar(400) default null,
  `zahlungsid` int(11) default null,
  `uniqueid` varchar(255) not null,
  `kontostand` decimal(15,2) default 0.00,
  primary key (`id`),
  unique key `uidx_kontoauszuege_uniqueid_n` (`uniqueid`),
  key `idx_ka_bd` (`buchungsdatum`),
  key `idx_ka_va` (`valuta`),
  key `idx_ka_e1` (`empfaengername1`),
  key `idx_ka_e2` (`empfaengername2`),
  key `idx_ka_blz` (`blz`),
  key `idx_ka_kno` (`kontonummer`),
  key `idx_ka_v1` (`verwendungszweck1`),
  key `idx_ka_v2` (`verwendungszweck2`),
  key `idx_ka_v3` (`verwendungszweck3`),
  key `idx_ka_v4` (`verwendungszweck4`),
  key `idx_ka_zi` (`zahlungsid`)
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