---
    title: juniper srx 更改默认ssh端口
    date: 2016-10-04 18:16:00
    updated: 2016-10-04 18:16:00
    abbrlink: 5930855
    tags:
    categories:
    ---
    <p>juniper srx系列防火墙默认ssh管理的端口是无法更改的，但要想使用其它端口实现ssh管理，可通过将外网的其它端口映射到环回接口的22端口实现</p>
<p>思路：</p>
<p>1.新建环回接口并配置IP地址</p>
<p>2.将环回接口划入到loopback_zone 这个安全域，并在接口层面开放ssh管理</p>
<p>3.配置端口映射，将外网端口22222映射环回接口端口22上</p>
<p>4.放行untrust到loopbaco_zone ssh的流量</p>
<p>&nbsp;</p>
<p>实验配置：</p>
<div class="cnblogs_Highlighter">
<pre class="brush:bash;gutter:true;">set version 12.1X47-D20.7
set system root-authentication encrypted-password "$1$Cu1r32.n$ivA34PWVEXK9lNKzaf1"
set system services ssh
set interfaces ge-0/0/0 unit 0 family inet address 192.168.2.200/24
set interfaces lo0 unit 0 family inet address 1.1.1.1/24
set security nat destination pool ssh_manage address 1.1.1.1/32
set security nat destination pool ssh_manage address port 22
set security nat destination rule-set ssh_manage from zone untrust
set security nat destination rule-set ssh_manage rule 1 match source-address 0.0.0.0/0
set security nat destination rule-set ssh_manage rule 1 match destination-address 192.168.2.200/32
set security nat destination rule-set ssh_manage rule 1 match destination-port 22222
set security nat destination rule-set ssh_manage rule 1 then destination-nat pool ssh_manage
set security policies from-zone untrust to-zone loopback_zone policy untrust-to-loopback match source-address any
set security policies from-zone untrust to-zone loopback_zone policy untrust-to-loopback match destination-address ssh-manage-address
set security policies from-zone untrust to-zone loopback_zone policy untrust-to-loopback match application junos-ssh
set security policies from-zone untrust to-zone loopback_zone policy untrust-to-loopback then permit
set security zones security-zone untrust interfaces ge-0/0/0.0 host-inbound-traffic system-services ping
set security zones security-zone loopback_zone address-book address ssh-manage-address 1.1.1.1/32
set security zones security-zone loopback_zone interfaces lo0.0 host-inbound-traffic system-services ssh
</pre>
</div>
<p>　　</p>
<p>&nbsp;</p>
<div class="cnblogs_code">
<pre>version <span style="color: #800080;">12</span>.1X47-D20.<span style="color: #800080;">7</span><span style="color: #000000;">;
system {
    root</span>-<span style="color: #000000;">authentication {
        encrypted</span>-password <span style="color: #800000;">"</span><span style="color: #800000;">$1$Cu1r32.n$ivACpMVEXK9lNKzaf1</span><span style="color: #800000;">"</span>; ## SECRET-<span style="color: #000000;">DATA
    }
    services {
        ssh;
    }
}
interfaces {
    ge</span>-<span style="color: #800080;">0</span>/<span style="color: #800080;">0</span>/<span style="color: #800080;">0</span><span style="color: #000000;"> {
        unit </span><span style="color: #800080;">0</span><span style="color: #000000;"> {
            family inet {
                address </span><span style="color: #800080;">192.168</span>.<span style="color: #800080;">2.200</span>/<span style="color: #800080;">24</span><span style="color: #000000;">;
            }
        }
    }
    lo0 {
        unit </span><span style="color: #800080;">0</span><span style="color: #000000;"> {
            family inet {
                address </span><span style="color: #800080;">1.1</span>.<span style="color: #800080;">1.1</span>/<span style="color: #800080;">24</span><span style="color: #000000;">;
            }
        }
    }
}
security {
    nat {
        destination {
            pool ssh_manage {
                address </span><span style="color: #800080;">1.1</span>.<span style="color: #800080;">1.1</span>/<span style="color: #800080;">32</span> port <span style="color: #800080;">22</span><span style="color: #000000;">;
            }
            rule</span>-<span style="color: #0000ff;">set</span><span style="color: #000000;"> ssh_manage {
                </span><span style="color: #0000ff;">from</span><span style="color: #000000;"> zone untrust;
                rule </span><span style="color: #800080;">1</span><span style="color: #000000;"> {
                    match {
                        source</span>-address <span style="color: #800080;">0.0</span>.<span style="color: #800080;">0.0</span>/<span style="color: #800080;">0</span><span style="color: #000000;">;
                        destination</span>-address <span style="color: #800080;">192.168</span>.<span style="color: #800080;">2.200</span>/<span style="color: #800080;">32</span><span style="color: #000000;">;
                        destination</span>-<span style="color: #000000;">port {
                            </span><span style="color: #800080;">22222</span><span style="color: #000000;">;
                        }
                    }
                    then {
                        destination</span>-<span style="color: #000000;">nat {
                            pool {
                                ssh_manage;
                            }
                        }
                    }
                }
            }
        }
    }
    policies {
        </span><span style="color: #0000ff;">from</span>-zone untrust to-<span style="color: #000000;">zone loopback_zone {
            policy untrust</span>-to-<span style="color: #000000;">loopback {
                match {
                    source</span>-<span style="color: #000000;">address any;
                    destination</span>-address ssh-manage-<span style="color: #000000;">address;
                    application junos</span>-<span style="color: #000000;">ssh;
                }
                then {
                    permit;
                }
            }
        }
    }
    zones {
        security</span>-<span style="color: #000000;">zone untrust {
            interfaces {
                ge</span>-<span style="color: #800080;">0</span>/<span style="color: #800080;">0</span>/<span style="color: #800080;">0.0</span><span style="color: #000000;"> {
                    host</span>-inbound-<span style="color: #000000;">traffic {
                        system</span>-<span style="color: #000000;">services {
                            ping;
                        }
                    }
                }
            }
        }
        security</span>-<span style="color: #000000;">zone loopback_zone {
            address</span>-<span style="color: #000000;">book {
                address ssh</span>-manage-address <span style="color: #800080;">1.1</span>.<span style="color: #800080;">1.1</span>/<span style="color: #800080;">32</span><span style="color: #000000;">;
            }
            interfaces {
                lo0.</span><span style="color: #800080;">0</span><span style="color: #000000;"> {
                    host</span>-inbound-<span style="color: #000000;">traffic {
                        system</span>-<span style="color: #000000;">services {
                            ssh;
                        }
                    }
                }
            }
        }
    }
}</span></pre>
</div>
<p>&nbsp;</p>
    