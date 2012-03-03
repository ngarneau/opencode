# Hadoop
export HADOOP_INSTALL=/Users/Nicolas/Documents/web-development/hadoop2
export PATH=$PATH:$HADOOP_INSTALL/bin

# Cassandra
export PATH+=:/Users/Nicolas/Documents/web-development/apache-cassandra-1.0.7/bin
export CASSANDRA_HOME=/Users/Nicolas/Documents/web-development/apache-cassandra-1.0.7-src

# PIG
export PIG_HOME=/Users/Nicolas/Documents/web-development/pig-0.9.2
export PIG_INSTALL=/Users/Nicolas/Documents/web-development/pig-0.9.2
export PATH=$PATH:$PIG_INSTALL/bin
export PIG_CONF_DIR=$HADOOP_INSTALL/conf
export PIG_CLASSPATH=$HADOOP_INSTALL/conf
export PIG_INITIAL_ADDRESS=localhost
export PIG_RPC_PORT=9160
export PIG_PARTITIONER=org.apache.cassandra.dht.RandomPartitioner

export JAVA_HOME=/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
