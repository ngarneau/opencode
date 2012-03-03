# Big data

This is just a small introduction to big data and 3 useful tools really cool to work with; [Cassandra][http://cassandra.apache.org/], [Hadoop][http://hadoop.apache.org/] and [Pig][http://pig.apache.org/].
Of course you'll need to install these three softwares on you machine so here's how you can do it.


# Install Hadoop
First download [Hadoop][http://www.apache.org/dyn/closer.cgi/hadoop/common/] and follow these [instructions][http://hadoop.apache.org/common/docs/stable/single_node_setup.html] for the installation process it is pretty straigthforward.


# Install Cassandra & Pig

Install Cassandra & Pig altogether is a little touchy.
I suggest you download the source, so you will have the Cassandra-pig interpreter installed:
[http://www.apache.org/dyn/closer.cgi?path=/cassandra/1.0.8/apache-cassandra-1.0.8-src.tar.gz]

Then you got to build Cassandra, by going into the folder you just downloaded and run

	ant

Then you got to get [Pig][http://www.apache.org/dyn/closer.cgi/pig].
Set `export PIG_HOME=/home/ngarneau/pig-0.9.0` and `export CASSANDRA_HOME=/home/ngarneau/cassandra-1.0.7` within your profile.
Start cassandra by running

	cd $CASSANDRA_HOME
	sudo bin/cassandra -f

Then, build the integration code.

	cd $CASSANDRA_HOME/contrib/pig
	ant

Before running with Pig and Cassandra, you need to inform Pig how to contact Cassandra. You'll need to give it three pieces of information: an initial address to reach Cassandra, a port on that address, and the partitioner you are using with Cassandra. You need to set these either as environment variables or Hadoop variables.
So add these configs within your profile;

	export PIG_INITIAL_ADDRESS=localhost
	export PIG_RPC_PORT=9160
	export PIG_PARTITIONER=org.apache.cassandra.dht.RandomPartitioner

Now you will be able to run Pig with the Cassandra interpreter;

	cd $CASSANDRA_HOME/contrib/pig
	bin/pig_cassandra -x local

Please refer to the [profile][.profile] file in the repo for a complete list of PATHS to set.


# Tutorial
The tutorial includes a little fake dataset and a Pig Latin script. You can fill up a Cassandra Keyspace by running the dataset file within the Cassandra-cli, on a valid Keyspace, and these column-families set;

	create column family Salons with comparator=UTF8Type and default_validation_class=UTF8Type and key_validation_class=UTF8Type;
	create column family Commandes with comparator=UTF8Type and default_validation_class=UTF8Type and key_validation_class=UTF8Type;

Now that we've got or data set, let me explain the use case. Remember that all the data is fake, so the use case too.
Here at duProprio.com we want to know if there's a correlation between people attending the 'Salons' and the total amount (in cash) generated by these.
This will help our guys at the marketing to decide if we filter people attending to have good prospects or to let the doors wide open.

So you can run the script by running

	cd $CASSANDRA_HOME/contrib/pig
	bin/pig_cassandra salon.pig

This doesn't show much of what's going on so I suggest you go check the code of salon.pig to get a clear view of what's under the hood :).
