# Create a new simulator instance
set ns [new Simulator]
# Open the NAM trace file
set nf [open sensor_network.nam w]
$ns namtrace-all $nf

# Define finish procedure to close files and run NAM
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam sensor_network.nam &
    exit 0
}

# Base Station procedures
proc BaseStation_create {} { return {} }
proc BaseStation_receive_data {base_station data ch_id} {
    lappend base_station [list $data $ch_id]
    puts "Base Station received aggregated data: $data from Cluster Head $ch_id"
    return $base_station
}
proc BaseStation_detect_intrusion {base_station} {
    foreach {data ch_id} $base_station {
        if {$data > 0.9} {
            puts "Intrusion Detected from Cluster Head $ch_id!"
        } else {
            puts "Intrusion Not Detected from Cluster Head $ch_id!"
        }
    }
}

# Cluster Head procedures
proc ClusterHead_create {ch_id} { return [list $ch_id {}] }
proc ClusterHead_receive_data {cluster_head data} {
    set ch_id [lindex $cluster_head 0]
    set aggregated_data [lindex $cluster_head 1]
    lappend aggregated_data $data
    puts "Cluster Head $ch_id received data: $data"
    return [lreplace $cluster_head 1 1 $aggregated_data]
}
proc ClusterHead_aggregate_data {cluster_head} {
    set aggregated_data [lindex $cluster_head 1]
    if {[llength $aggregated_data] > 0} {
        set aggregated_value [expr {[sum $aggregated_data] / [llength $aggregated_data]}]
        return [list $cluster_head $aggregated_value]
    }
    return [list $cluster_head {}]
}
proc ClusterHead_send_to_base_station {cluster_head base_station} {
    set result [ClusterHead_aggregate_data $cluster_head]
    set aggregated_value [lindex $result 1]
    if {$aggregated_value ne {}} {
        set ch_id [lindex $cluster_head 0]
        puts "Cluster Head $ch_id sending aggregated data to Base Station"
        BaseStation_receive_data $base_station $aggregated_value $ch_id
    }
}

# Sensor Node procedures
proc SensorNode_create {node_id cluster_head} { return [list $node_id $cluster_head {}] }
proc SensorNode_collect_data {sensor_node} {
    set node_id [lindex $sensor_node 0]
    set cluster_head [lindex $sensor_node 1]
    set data [expr {rand()}]
    puts "Sensor Node $node_id collected data: $data"
    return [lreplace $sensor_node 2 2 $data]
}
proc SensorNode_send_data {sensor_node} {
    set node_id [lindex $sensor_node 0]
    set cluster_head [lindex $sensor_node 1]
    set data [lindex $sensor_node 2]
    if {$data ne {}} {
        puts "Sensor Node $node_id sending data to Cluster Head $cluster_head"
        ClusterHead_receive_data $cluster_head $data
    }
}
proc SensorNode_run {sensor_node} {
    set sensor_node [SensorNode_collect_data $sensor_node]
    SensorNode_send_data $sensor_node
}

# Create base station node
set base_station [$ns node]

# Number of cluster heads and sensors
set num_cluster_heads 10
set num_sensors_per_cluster 10

# Arrays to store nodes
set cluster_heads {}
set sensor_nodes {}

# Create cluster heads and sensor nodes
for {set ch_id 1} {$ch_id <= $num_cluster_heads} {incr ch_id} {
    set cluster_head [$ns node]
    lappend cluster_heads $cluster_head
    for {set node_id [expr {($ch_id - 1) * $num_sensors_per_cluster}]} {$node_id < [expr {$ch_id * $num_sensors_per_cluster}]} {incr node_id} {
        set sensor_node [$ns node]
        lappend sensor_nodes $sensor_node
        $ns duplex-link $sensor_node $cluster_head 1Mb 10ms DropTail
    }
    $ns duplex-link $cluster_head $base_station 1Mb 10ms DropTail
}

# Schedule events
set time 0.1
foreach sensor_node $sensor_nodes {
    $ns at $time "$sensor_node send"
    set time [expr {$time + 0.5}]
}
foreach cluster_head $cluster_heads {
    $ns at [expr {$time + 1.0}] "$cluster_head send_to_base_station $base_station"
}
$ns at [expr {$time + 2.0}] "BaseStation_detect_intrusion $base_station"

# Dynamic cluster head selection
proc dynamic_cluster_head_selection {} {
    global cluster_heads
    set selected_chs {}
    foreach ch $cluster_heads {
        if {[expr rand() > 0.5]} {
            lappend selected_chs $ch
        }
    }
    return $selected_chs
}
proc re_evaluate_cluster_heads {} {
    global ns
    set new_ch_list [dynamic_cluster_head_selection]
    $ns at 5.0 "set ch_list $new_ch_list"
}
$ns at 5.0 "re_evaluate_cluster_heads"

# Finish simulation
$ns at 10.0 "finish"
$ns run
