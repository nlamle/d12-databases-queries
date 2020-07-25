--1
SELECT COUNT (u_id) AS total_num_users FROM users;

--2
SELECT COUNT (transfer_id) AS num_cfa_transfers FROM transfers WHERE send_amount_currency = 'CFA';

--3
SELECT DISTINCT COUNT (u_id) AS unique_cfa_transfers FROM transfers WHERE send_amount_currency = 'CFA';

--4
SELECT COUNT(atx_id) FROM agent_transactions WHERE EXTRACT(Year FROM when_created) = 2018 GROUP BY EXTRACT (month FROM when_created);

--5


--6


--7


--8


--9


--10
SELECT source_wallet_id, send_amount_scalar FROM transfers WHERE (send_amount_currency = 'CFA') AND (send_amount_scalar > 10000000) AND (transfers.when_created > (NOW() - INTERVAL '1 month'))