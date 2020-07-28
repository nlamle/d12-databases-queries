--1
SELECT COUNT (u_id) AS total_num_users FROM users;

--2
SELECT COUNT (transfer_id) AS num_cfa_transfers FROM transfers WHERE send_amount_currency = 'CFA';

--3
SELECT DISTINCT COUNT (u_id) AS unique_cfa_transfers FROM transfers WHERE send_amount_currency = 'CFA';

--4
SELECT COUNT(atx_id) FROM agent_transactions WHERE EXTRACT(Year FROM when_created) = 2018 GROUP BY EXTRACT (month FROM when_created);

--5
SELECT
	
	CASE 
		WHEN net_value > 0 THEN 'num_net_withdrawers'
    	ELSE 'num_net_depositors'
    END,
	
	COUNT(agent_id) AS net_count 
	FROM (SELECT agent_id, SUM(amount) AS net_value FROM agent_transactions
	WHERE (amount != 0) AND (agent_transactions.when_created > (NOW() - INTERVAL '1 week'))
	GROUP BY agent_id 
	GROUP BY net_value > 0 )
	AS withdrawers_and_depositors;


--6
SELECT City, Volume
INTO atx_volume_city_summary 
	FROM ( SELECT agents.city AS city, COUNT(agent_transactions.atx_id) AS volume FROM agents 
	INNER JOIN agent_transactions ON agents.agent_id = agent_transactions.agent_id
	WHERE (agent_transactions.when_created > (NOW() - INTERVAL '1 week'))
	GROUP BY agents.city) as atx_volume_summary;

--7
SELECT City, Volume, Country
	INTO atx_volume_city_summary_with_Country
	FROM ( SELECT agents.city AS city, agents.country AS country, COUNT(agent_transactions.atx_id) AS volume FROM agents 
	INNER JOIN agent_transactions ON agents.agent_id = agent_transactions.agent_id
	WHERE (agent_transactions.when_created > (NOW() - INTERVAL '1 week'))
	GROUP BY agents.country,agents.city) as atx_volume_summary_with_country;

--8
SELECT
	INTO send_Volume_by_Country_and_Kind
	FROM transfers.kind AS transfer_kind, wallets.ledger_location AS country, SUM(transfers.send_amount_scalar) AS volume FROM transfers 
	INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id
	WHERE (transfers.when_created > (NOW() - INTERVAL '1 week'))
	GROUP BY wallets.ledger_location, transfers.kind) as send_volume_by_country_and_kind; 

--9
SELECT 
	COUNT(transfers.source_wallet_id) AS unique_senders, COUNT(transfer_id) AS transaction_count, transfers.kind AS transfer_kind, wallets.ledger_location AS country, 
SUM(transfers.send_amount_scalar) AS volume 
	FROM transfers 
	INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id
	WHERE (transfers.when_created > (NOW() - INTERVAL '1 week'))	
	GROUP BY wallets.ledger_location, transfers.kind;

--10
SELECT source_wallet_id, send_amount_scalar FROM transfers WHERE (send_amount_currency = 'CFA') AND (send_amount_scalar > 10000000) AND (transfers.when_created > (NOW() - INTERVAL '1 month'))