-- Azerbaijani language names were inconsistent: most read "<X> dili"
-- ("Fransız dili", "Yapon dili") but three used the adverb form
-- ("İndoneziyaca"), which reads oddly as a fact value. Align them.
update public.destinations
set language = jsonb_set(language, '{az}', '"İndoneziya dili"')
where language->>'az' = 'İndoneziyaca';

update public.destinations
set language = jsonb_set(language, '{az}', '"İtalyan dili"')
where language->>'az' = 'İtalyanca';

update public.destinations
set language = jsonb_set(language, '{az}', '"Portuqal dili"')
where language->>'az' = 'Portuqalca';
