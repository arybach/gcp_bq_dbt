{{ config( materialized = 'view') }}

select
	{{ get_payment_type_description('payment_type') }} as payment_type_description
from {{ source('staging', 'green') }}
where vendorid is not null