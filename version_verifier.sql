WITH
    -- configure
    conf AS (
        SELECT
            'ru'  AS conf_language_code      -- null or value like 'en', 'ru'
    ),
    -- db_family_list
    db_family_list AS (
        SELECT
            db_family
        FROM
            (VALUES
                -- vanilla
                ('PostgreSQL'),
                -- A-Z order
                ('Pangolin'),
                ('PostgresPro'),
                ('Tantor')
            ) AS t(db_family)
    ),
    -- description
    db_family_description_list AS (
        SELECT
            ROW_NUMBER() OVER (PARTITION BY db_family, description_item
                ORDER BY description_language_code ASC NULLS LAST) AS description_row_num,
            db_family, description_item, description_language_code, description_value
        FROM
            (VALUES
                -- website
                ('PostgreSQL',  'website', null, 'https://www.postgresql.org/'),
                ('Pangolin',    'website', null, 'https://pangolin.sbertech.ru/'),
                ('PostgresPro', 'website', null, 'https://postgrespro.ru/'),
                ('PostgresPro', 'website', 'en', 'https://postgrespro.com/'),
                ('Tantor',      'website', null, 'https://tantorlabs.ru/')
            ) AS t(db_family, description_item, description_language_code, description_value)
        WHERE
            description_language_code IS NULL
            OR description_language_code IN (SELECT conf_language_code FROM conf)
    ),
    -- db_family_info
    db_family_info AS (
        SELECT
            f.db_family AS db_family,
            s.description_value AS website
        FROM db_family_list AS f
            LEFT JOIN db_family_description_list AS s
                ON f.db_family = s.db_family AND s.description_row_num = 1 AND s.description_item = 'website'
    ),
    -- version list
    db_family_version_list AS (
        SELECT
            db_family,
            code::text,
            server_version_num::bigint,
            major_version::integer,
            release_date::date,
            is_final::boolean,
            vanilla_base_code::text,
            alternative_server_version_num::bigint
        FROM
            (VALUES
                -- PostgreSQL 18
                ('PostgreSQL', '18.2',   180002, 18, '2026-02-12', false, null, null),
                ('PostgreSQL', '18.1',   180001, 18, '2025-11-13', false, null, null),
                ('PostgreSQL', '18.0',   180000, 18, '2025-09-25', false, null, null),
                -- PostgreSQL 17
                ('PostgreSQL', '17.8',   170008, 17, '2026-02-12', false, null, null),
                ('PostgreSQL', '17.7',   170007, 17, '2025-11-13', false, null, null),
                ('PostgreSQL', '17.6',   170006, 17, '2025-08-14', false, null, null),
                ('PostgreSQL', '17.5',   170005, 17, '2025-05-08', false, null, null),
                ('PostgreSQL', '17.4',   170004, 17, '2025-02-20', false, null, null),
                ('PostgreSQL', '17.3',   170003, 17, '2025-02-13', false, null, null),
                ('PostgreSQL', '17.2',   170002, 17, '2024-11-21', false, null, null),
                ('PostgreSQL', '17.1',   170001, 17, '2024-11-14', false, null, null),
                ('PostgreSQL', '17.0',   170000, 17, '2024-09-26', false, null, null),
                -- PostgreSQL 16
                ('PostgreSQL', '16.12',  160012, 16, '2026-02-12', false, null, null),
                ('PostgreSQL', '16.11',  160011, 16, '2025-11-13', false, null, null),
                ('PostgreSQL', '16.10',  160010, 16, '2025-08-14', false, null, null),
                ('PostgreSQL', '16.9',   160009, 16, '2025-05-08', false, null, null),
                ('PostgreSQL', '16.8',   160008, 16, '2025-02-20', false, null, null),
                ('PostgreSQL', '16.7',   160007, 16, '2025-02-13', false, null, null),
                ('PostgreSQL', '16.6',   160006, 16, '2024-11-21', false, null, null),
                ('PostgreSQL', '16.5',   160005, 16, '2024-11-14', false, null, null),
                ('PostgreSQL', '16.4',   160004, 16, '2024-08-08', false, null, null),
                ('PostgreSQL', '16.3',   160003, 16, '2024-05-09', false, null, null),
                ('PostgreSQL', '16.2',   160002, 16, '2024-02-08', false, null, null),
                ('PostgreSQL', '16.1',   160001, 16, '2023-11-09', false, null, null),
                ('PostgreSQL', '16.0',   160000, 16, '2023-09-14', false, null, null),
                -- PostgreSQL 15
                ('PostgreSQL', '15.16',  150016, 15, '2026-02-12', false, null, null),
                ('PostgreSQL', '15.15',  150015, 15, '2025-11-13', false, null, null),
                ('PostgreSQL', '15.14',  150014, 15, '2025-08-14', false, null, null),
                ('PostgreSQL', '15.13',  150013, 15, '2025-05-08', false, null, null),
                ('PostgreSQL', '15.12',  150012, 15, '2025-02-20', false, null, null),
                ('PostgreSQL', '15.11',  150011, 15, '2025-02-13', false, null, null),
                ('PostgreSQL', '15.10',  150010, 15, '2024-11-21', false, null, null),
                ('PostgreSQL', '15.9',   150009, 15, '2024-11-14', false, null, null),
                ('PostgreSQL', '15.8',   150008, 15, '2024-08-08', false, null, null),
                ('PostgreSQL', '15.7',   150007, 15, '2024-05-09', false, null, null),
                ('PostgreSQL', '15.6',   150006, 15, '2024-02-08', false, null, null),
                ('PostgreSQL', '15.5',   150005, 15, '2023-11-09', false, null, null),
                ('PostgreSQL', '15.4',   150004, 15, '2023-08-10', false, null, null),
                ('PostgreSQL', '15.3',   150003, 15, '2023-05-11', false, null, null),
                ('PostgreSQL', '15.2',   150002, 15, '2023-02-09', false, null, null),
                ('PostgreSQL', '15.1',   150001, 15, '2022-11-10', false, null, null),
                ('PostgreSQL', '15.0',   150000, 15, '2022-10-13', false, null, null),
                -- PostgreSQL 14
                ('PostgreSQL', '14.21',  140021, 14, '2026-02-12', false, null, null),
                ('PostgreSQL', '14.20',  140020, 14, '2025-11-13', false, null, null),
                ('PostgreSQL', '14.19',  140019, 14, '2025-08-14', false, null, null),
                ('PostgreSQL', '14.18',  140018, 14, '2025-05-08', false, null, null),
                ('PostgreSQL', '14.17',  140017, 14, '2025-02-20', false, null, null),
                ('PostgreSQL', '14.16',  140016, 14, '2025-02-13', false, null, null),
                ('PostgreSQL', '14.15',  140015, 14, '2024-11-21', false, null, null),
                -- PostgreSQL 13
                ('PostgreSQL', '13.23',  130023, 13, '2025-11-13',  true, null, null),
                ('PostgreSQL', '13.22',  130022, 13, '2025-08-14', false, null, null),
                ('PostgreSQL', '13.21',  130021, 13, '2025-05-08', false, null, null),
                ('PostgreSQL', '13.20',  130020, 13, '2025-02-20', false, null, null),
                ('PostgreSQL', '13.19',  130019, 13, '2025-02-13', false, null, null),
                ('PostgreSQL', '13.18',  130018, 13, '2024-11-21', false, null, null),
                -- PostgreSQL 12
                ('PostgreSQL', '12.22',  120022, 12, '2024-11-21',  true, null, null),
                ('PostgreSQL', '12.21',  120021, 12, '2024-11-14', false, null, null),
                -- PostgreSQL 11
                ('PostgreSQL', '11.22',  110022, 11, '2023-11-09',  true, null, null),
                -- PostgreSQL 10
                ('PostgreSQL', '10.23',  100023, 10, '2022-11-10',  true, null, null)
                ---------------------------------------------------------------
            ) AS t(db_family, code, server_version_num, major_version, release_date, is_final, vanilla_base_code,
                   alternative_server_version_num)
    ),
    -- major version end of life list
    db_family_major_version_eol_list AS (
        SELECT
            db_family, major_version::integer, eol_date::date
        FROM
            (VALUES
                ('PostgreSQL', 18,  '2030-11-14'),
                ('PostgreSQL', 17,  '2029-11-08'),
                ('PostgreSQL', 16,  '2028-11-09'),
                ('PostgreSQL', 15,  '2027-11-11'),
                ('PostgreSQL', 14,  '2026-11-12'),
                ('PostgreSQL', 13,  '2025-11-13'),
                ('PostgreSQL', 12,  '2024-11-21'),
                ('PostgreSQL', 11,  '2023-11-09'),
                ('PostgreSQL', 10,  '2022-11-10')
            ) AS t(db_family, major_version, eol_date)
    ),
    -- vulnerability list
    vulnerability_list AS (
        SELECT
            code::text,
            score::numeric,
            urls::text[]
        FROM
            (VALUES
                -- CVE
                ('CVE-2026-2007',  8.2, ARRAY['https://www.postgresql.org/support/security/CVE-2026-2007/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2026-2007']),
                ('CVE-2026-2006',  8.8, ARRAY['https://www.postgresql.org/support/security/CVE-2026-2006/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2026-2006']),
                ('CVE-2026-2005',  8.8, ARRAY['https://www.postgresql.org/support/security/CVE-2026-2005/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2026-2005']),
                ('CVE-2026-2004',  8.8, ARRAY['https://www.postgresql.org/support/security/CVE-2026-2004/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2026-2004']),
                ('CVE-2026-2003',  4.3, ARRAY['https://www.postgresql.org/support/security/CVE-2026-2003/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2026-2003']),
                ('CVE-2025-12818', 5.9, ARRAY['https://www.postgresql.org/support/security/CVE-2025-12818/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2025-12818']),
                ('CVE-2025-12817', 3.1, ARRAY['https://www.postgresql.org/support/security/CVE-2025-12817/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2025-12817']),
                ('CVE-2025-8715',  8.8, ARRAY['https://www.postgresql.org/support/security/CVE-2025-8715/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2025-8715']),
                ('CVE-2025-8714',  8.8, ARRAY['https://www.postgresql.org/support/security/CVE-2025-8714/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2025-8714']),
                ('CVE-2025-8713',  3.1, ARRAY['https://www.postgresql.org/support/security/CVE-2025-8713/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2025-8713']),
                ('CVE-2025-4207',  5.9, ARRAY['https://www.postgresql.org/support/security/CVE-2025-4207/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2025-4207']),
                ('CVE-2025-1094',  8.1, ARRAY['https://www.postgresql.org/support/security/CVE-2025-1094/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2025-1094']),
                ('CVE-2024-10979', 8.8, ARRAY['https://www.postgresql.org/support/security/CVE-2024-10979/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2024-10979']),
                ('CVE-2024-10978', 4.2, ARRAY['https://www.postgresql.org/support/security/CVE-2024-10978/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2024-10978']),
                ('CVE-2024-10977', 3.1, ARRAY['https://www.postgresql.org/support/security/CVE-2024-10977/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2024-10977']),
                ('CVE-2024-10976', 4.2, ARRAY['https://www.postgresql.org/support/security/CVE-2024-10976/',
                                              'https://nvd.nist.gov/vuln/detail/CVE-2024-10976'])
            ) AS t(code, score, urls)
    ),
    -- db family vulnerability list
    db_family_vulnerability_list AS (
        SELECT
            vulnerability_code::text,
            db_family,
            -- PostgreSQL - server_version_num
            -- other - alternative_server_version_num
            fixed_in_server_version_nums::bigint[],
            affected_server_version_nums::bigint[][]
        FROM
            (VALUES
                -- PostgreSQL
                ('CVE-2026-2007',  'PostgreSQL', ARRAY[180002],
                    ARRAY[[180000, 180001]]),
                ('CVE-2026-2003',  'PostgreSQL', ARRAY[180002, 170008, 160012, 150016, 140021],
                    ARRAY[[180000, 180001], [170000, 170007], [160000, 160011], [150000, 150015], [140000, 140020]]),
                ('CVE-2026-2005',  'PostgreSQL', ARRAY[180002, 170008, 160012, 150016, 140021],
                    ARRAY[[180000, 180001], [170000, 170007], [160000, 160011], [150000, 150015], [140000, 140020]]),
                ('CVE-2026-2004',  'PostgreSQL', ARRAY[180002, 170008, 160012, 150016, 140021],
                    ARRAY[[180000, 180001], [170000, 170007], [160000, 160011], [150000, 150015], [140000, 140020]]),
                ('CVE-2026-2003',  'PostgreSQL', ARRAY[180002, 170008, 160012, 150016, 140021],
                    ARRAY[[180000, 180001], [170000, 170007], [160000, 160011], [150000, 150015], [140000, 140020]]),
                ('CVE-2025-12818', 'PostgreSQL', ARRAY[180001, 170007, 160011, 150015, 140020, 130023],
                    ARRAY[[180000, 180000], [170000, 170006], [160000, 160010], [150000, 150014], [140000, 140019], [130000, 130022]]),
                ('CVE-2025-12817', 'PostgreSQL', ARRAY[170006, 160010, 150014, 140019, 130022],
                    ARRAY[[180000, 180000], [170000, 170006], [160000, 160010], [150000, 150014], [140000, 140019], [130000, 130022]]),
                ('CVE-2025-8715',  'PostgreSQL', ARRAY[170006, 160010, 150014, 140019, 130022],
                    ARRAY[[170000, 170005], [160000, 160009], [150000, 150013], [140000, 140018], [130000, 130021]]),
                ('CVE-2025-8714',  'PostgreSQL', ARRAY[170006, 160010, 150014, 140019, 130022],
                    ARRAY[[170000, 170005], [160000, 160009], [150000, 150013], [140000, 140018], [130000, 130021]]),
                ('CVE-2025-8713',  'PostgreSQL', ARRAY[170006, 160010, 150014, 140019, 130022],
                    ARRAY[[170000, 170005], [160000, 160009], [150000, 150013], [140000, 140018], [130000, 130021]]),
                ('CVE-2025-4207',  'PostgreSQL', ARRAY[170005, 160009, 150013, 140018, 130021],
                    ARRAY[[170000, 170004], [160000, 160008], [150000, 150012], [140000, 140017], [130000, 130020]]),
                ('CVE-2025-1094',  'PostgreSQL', ARRAY[170003, 160007, 150011, 140016, 130019],
                    ARRAY[[170000, 170002], [160000, 160006], [150000, 150010], [140000, 140015], [130000, 130018]]),
                ('CVE-2024-10979', 'PostgreSQL', ARRAY[170001, 160005, 150009, 140014, 130017, 120021],
                    ARRAY[[170000, 170000], [160000, 160004], [150000, 150008], [140000, 140013], [130000, 130016], [120000, 120020]]),
                ('CVE-2024-10978', 'PostgreSQL', ARRAY[170001, 160005, 150009, 140014, 130017, 120021],
                    ARRAY[[170000, 170000], [160000, 160004], [150000, 150008], [140000, 140013], [130000, 130016], [120000, 120020]]),
                ('CVE-2024-10977', 'PostgreSQL', ARRAY[170001, 160005, 150009, 140014, 130017, 120021],
                    ARRAY[[170000, 170000], [160000, 160004], [150000, 150008], [140000, 140013], [130000, 130016], [120000, 120020]]),
                ('CVE-2024-10976', 'PostgreSQL', ARRAY[170001, 160005, 150009, 140014, 130017, 120021],
                    ARRAY[[170000, 170000], [160000, 160004], [150000, 150008], [140000, 140013], [130000, 130016], [120000, 120020]])
            ) AS t(vulnerability_code, db_family, fixed_in_server_version_nums, affected_server_version_nums)
    ),
    -- db family vulnerability list unnest
    db_family_vulnerability_list_unnest AS (
        SELECT
            t.vulnerability_code,
            t.db_family,
            t1.v::bigint AS min_server_version_num,
            t2.v::bigint AS max_server_version_num,
            vl.score,
            vl.urls
        FROM db_family_vulnerability_list AS t
            CROSS JOIN LATERAL unnest(t.affected_server_version_nums) WITH ORDINALITY AS t1(v, i)
            LEFT JOIN LATERAL unnest(t.affected_server_version_nums) WITH ORDINALITY AS t2(v, i) ON t1.i = t2.i-1
            INNER JOIN vulnerability_list AS vl ON vl.code = t.vulnerability_code
        WHERE t1.i % 2 = 1
    ),
    -- current db family
    current_db_family AS (
        SELECT
            CASE
                -- Pangolin
                WHEN (current_setting('server_se_version', true) IS NOT NULL)
                        OR (EXISTS(SELECT * FROM pg_catalog.pg_proc
                                   WHERE proname IN ('product_version', 'sber_version')))
                    THEN 'Pangolin'
                -- PostgresPro
                WHEN (current_setting('pgpro_version', true) IS NOT NULL)
                        OR (EXISTS(SELECT * FROM pg_catalog.pg_proc WHERE proname = 'pgpro_version'))
                    THEN 'PostgresPro'
                -- Tantor
                WHEN (EXISTS(SELECT * FROM pg_catalog.pg_proc WHERE proname = 'tantor_version'))
                    THEN 'Tantor'
                -- vanilla
                -- PostgreSQL
                WHEN version() like 'PostgreSQL %' THEN 'PostgreSQL'
            ELSE
                'Unknown'
            END AS db_family
    ),
    --
    current_db_major_version AS (
        SELECT
            db_family,
            CASE
                -- PostgreSQL, Pangolin, PostgresPro, Tantor
                WHEN db_family IN ('PostgreSQL', 'Pangolin', 'PostgresPro', 'Tantor') THEN
                    (current_setting('server_version_num')::integer / 10000)::integer
            ELSE
                null::integer
            END AS major_version,
            current_setting('server_version_num')::bigint AS server_version_num,
            CASE
                -- Pangolin
                WHEN db_family IN ('Pangolin') THEN current_setting('server_se_version_num', true)::bigint
            ELSE
                null::bigint
            END AS alternative_server_version_num
        FROM current_db_family
    ),
    -- current db vulnerability list
    current_db_vulnerability_list AS (
        SELECT
            vlu.vulnerability_code AS code,
            vlu.score,
            vlu.urls
        FROM db_family_vulnerability_list_unnest AS vlu
            INNER JOIN current_db_major_version AS c ON vlu.db_family = c.db_family
                AND COALESCE(c.alternative_server_version_num, c.server_version_num)
                    BETWEEN vlu.min_server_version_num AND vlu.max_server_version_num
    )
-- result
SELECT
    c.db_family,
    c.major_version,
    ver.code,
    c.server_version_num,
    (SELECT json_agg(vl) FROM (SELECT * FROM current_db_vulnerability_list) AS vl) AS vulnerability_list,
    json_build_object(
        'db_family', inf.db_family,
        'end_of_life', eol.eol_date,
        'db_family_info', inf.*,
        'version_info', ver.*
    ) AS info,
    -- recommendations
    -- end_of_life
    eol.eol_date AS end_of_life,
    CASE
        WHEN (eol.eol_date <= now()) THEN 'critical'
        WHEN (eol.eol_date <= now() + '60 days'::interval) THEN 'error'
        WHEN (eol.eol_date <= now() + '180 days'::interval) THEN 'warning'
    END AS end_of_life_level
    -- update to
FROM current_db_major_version AS c
    LEFT JOIN db_family_info AS inf ON c.db_family = inf.db_family
    LEFT JOIN db_family_version_list AS ver ON c.db_family = ver.db_family
        AND c.server_version_num = ver.server_version_num
    LEFT JOIN db_family_major_version_eol_list AS eol ON c.db_family = eol.db_family
        AND c.major_version = eol.major_version
;
