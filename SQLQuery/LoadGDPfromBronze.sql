SELECT
    -- Behåll existerande värden för övriga kolumner
    freq,
    [Time frequency],
    s_adj,
    [Seasonal adjustment],
    geo,
    [Geopolitical entity (reporting)],

    -- Konvertera '2024-Q1' till date första dagen i kvartalet
    DATEFROMPARTS(
        CAST(LEFT(TIME_PERIOD,4) AS INT),
        CASE RIGHT(TIME_PERIOD,2)
            WHEN 'Q1' THEN  1
            WHEN 'Q2' THEN  4
            WHEN 'Q3' THEN  7
            WHEN 'Q4' THEN 10
        END,
        1
    ) AS Date,

    -- Exempel på värdekonvertering (OBS_VALUE * 1 000 000)
    CAST(CAST(OBS_VALUE AS DECIMAL(18,4)) * 1000000 AS BIGINT) AS OBS_VALUE,

    -- Här sätter vi 'a' där OBS_FLAG är NULL eller tomsträng
    COALESCE(NULLIF(OBS_FLAG, ''), 'a') AS OBS_FLAG,

    -- Här sätter vi 'actual' där beskrivningen är NULL eller tomsträng
    COALESCE(NULLIF([Observation status (Flag) V2 structure], ''), 'actual')
      AS [Observation status (Flag) V2 structure],

    CreatedBronzeAt

FROM dbo.gdp_raw;
