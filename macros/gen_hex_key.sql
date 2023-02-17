{% macro gen_hex_key(field_one, field_two, field_three) %}
    TO_HEX(MD5(CONCAT(CAST({{ field_one }} AS STRING), CONCAT(CAST({{ field_two }} AS STRING),CAST({{ field_three }} AS STRING)))))
{% endmacro %}
