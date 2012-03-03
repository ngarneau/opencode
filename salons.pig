/*
* Get the correlation between the number of attendants during a salon and the amount of sales
*/
-- Cassandra needed librabries
register /Users/Nicolas/Documents/web-development/pig-0.9.2/pig-0.9.2-withouthadoop.jar; 
register /Users/Nicolas/Documents/web-development/pig-0.9.2/pig-0.9.2.jar; 
register /Users/Nicolas/Documents/web-development/pig-0.9.2/contrib/piggybank/java/piggybank.jar
register /Users/Nicolas/Documents/web-development/apache-cassandra-1.0.7-src/lib/avro-1.4.0-fixes.jar; 
register /Users/Nicolas/Documents/web-development/apache-cassandra-1.0.7-src/lib/avro-1.4.0-sources-fixes.jar; 
register /Users/Nicolas/Documents/web-development/apache-cassandra-1.0.7-src/lib/libthrift-0.6.jar;

-- Pygmalion libraries & init
register 'pygmalion-1.0.0.jar';
define FromCassandraBag org.pygmalion.udf.FromCassandraBag();
define ToCassandraBag org.pygmalion.udf.ToCassandraBag();

-- Loading salons
raw_salons =  LOAD 'cassandra://salons/Salons' USING CassandraStorage() AS (key:chararray, columns:bag {column:tuple (name, value)});
salons = FOREACH raw_salons GENERATE key, FLATTEN( (tuple(int,double,int)) FromCassandraBag('id, attendants, year', columns)) AS (
	id:int,
	attendants:double,
	year:int
);

-- loading commandes
raw_orders =  LOAD 'cassandra://salons/Commandes' USING CassandraStorage() AS (key:chararray, columns:bag {column:tuple (name, value)});
orders = FOREACH raw_orders GENERATE key, FLATTEN( (tuple(int,double)) FromCassandraBag('salon, amount', columns)) AS (
	salon:int,
	amount:double
);

-- we group the orders by salons
orders_by_salon = group orders by salon;

-- we sum all the orders for each salon
orders_summed = foreach orders_by_salon generate group as salon, SUM(orders.amount) as total;

-- then we join the summed orders by salon to each of the salons
jnd = join salons by id, orders_summed by salon;

-- filter the salons by date input
jnd = filter jnd by year == $YEAR;

-- we do a little cleanup so we only carry attendants and the total amount of revenues
cleanup = foreach jnd generate attendants,total;

-- we group all our dataset (COR specific operation)
grpd = group cleanup all;

-- calculate the correlation for our given dataset
cor = foreach grpd generate COR(cleanup.attendants,cleanup.total);

dump cor;
