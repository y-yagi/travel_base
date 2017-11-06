SELECT
  id AS place_id,
  CONCAT(name, address, memo) AS value
FROM places;
