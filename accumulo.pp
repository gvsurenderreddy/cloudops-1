
file { "/etc/hadoop/conf/hadoop-env.sh" :
   owner => root,
   group => hadoop,
   source => "/home/ubuntu/cloudops/configs/hadoop-env.sh",
   mode => 644
}

file { "/etc/hadoop/conf/core-site.xml" :
   owner => root,
   group => hadoop,
   mode => 644,
   content => template("/home/ubuntu/cloudops/configs/core-site.erb")
}

file { "/etc/hadoop/conf/hdfs-site.xml" :
   owner => root,
   group => hadoop,
   mode => 644,
   source => "/home/ubuntu/cloudops/configs/hdfs-site.xml"
}

file { "/etc/hadoop/conf/mapred-site.xml" :
   owner => root,
   group => hadoop,
   mode => 644,
   content => template("/home/ubuntu/cloudops/configs/mapred-site.erb")
}

file { "/etc/zookeeper/zoo.cfg" :
   owner => root,
   group => root,
   mode => 644,
   source => "/home/ubuntu/cloudops/configs/zoo.cfg"
}

file { "/home/ubuntu/accumulo/conf/accumulo-env.sh" :
   owner => ubuntu,
   group => ubuntu,
   mode => 644,
   source => "/home/ubuntu/cloudops/configs/accumulo-env.sh"
}

file { "/home/ubuntu/accumulo/conf/accumulo-site.xml" :
   owner => ubuntu,
   group => ubuntu,
   mode => 644,
   content => template("/home/ubuntu/cloudops/configs/accumulo-site.erb")
}




