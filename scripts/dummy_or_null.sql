/* Returns a dummy variable or null */

CREATE OR REPLACE FUNCTION dummy_or_null
    (value integer, yes_if integer, no_if integer)
RETURNS integer AS $$
BEGIN
    IF value = yes_if THEN
        RETURN 1;
    ELSEIF value = no_if THEN
        RETURN 0;
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION dummy_or_null
    (value text, yes_if integer, no_if integer)
RETURNS integer AS $$
DECLARE
    value_int integer;
BEGIN
    value_int := value::integer;
    
    RETURN dummy_or_null(value_int, yes_if, no_if);
END;
$$ LANGUAGE plpgsql;