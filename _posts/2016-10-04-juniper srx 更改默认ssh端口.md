---
layout: post
title: juniper srx 更改默认ssh端口
keywords: junipe, srx, ssh端口
description: juniper srx 更改默认ssh端口
categories: juniper
---

juniper srx系列防火墙默认ssh管理的端口是无法更改的，但要想使用其它端口实现ssh管理，可通过将外网的其它端口映射到环回接口的22端口实现

思路：

1.新建环回接口并配置IP地址

2.将环回接口划入到loopbackzone 这个安全域，并在接口层面开放ssh管理

3.配置端口映射，将外网端口22222映射环回接口端口22上

4.放行untrust到loopbacozone ssh的流量

<p>实验配置：</p>

	set version 12.1X47-D20.7
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


<p></p>
<p></p>

	
	version 12.1X47-D20.7;
	system {
	    root-authentication {
	        encrypted-password "$1$Cu1r32.n$ivACpMVEXK9lNKzaf1"; ## SECRET-DATA
	    }
	    services {
	        ssh;
	    }
	}
	interfaces {
	    ge-0/0/0 {
	        unit 0 {
	            family inet {
	                address 192.168.2.200/24;
	            }
	        }
	    }
	    lo0 {
	        unit 0 {
	            family inet {
	                address 1.1.1.1/24;
	            }
	        }
	    }
	}
	security {
	    nat {
	        destination {
	            pool ssh_manage {
	                address 1.1.1.1/32 port 22;
	            }
	            rule-set ssh_manage {
	                from zone untrust;
	                rule 1 {
	                    match {
	                        source-address 0.0.0.0/0;
	                        destination-address 192.168.2.200/32;
	                        destination-port {
	                            22222;
	                        }
	                    }
	                    then {
	                        destination-nat {
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
	        from-zone untrust to-zone loopback_zone {
	            policy untrust-to-loopback {
	                match {
	                    source-address any;
	                    destination-address ssh-manage-address;
	                    application junos-ssh;
	                }
	                then {
	                    permit;
	                }
	            }
	        }
	    }
	    zones {
	        security-zone untrust {
	            interfaces {
	                ge-0/0/0.0 {
	                    host-inbound-traffic {
	                        system-services {
	                            ping;
	                        }
	                    }
	                }
	            }
	        }
	        security-zone loopback_zone {
	            address-book {
	                address ssh-manage-address 1.1.1.1/32;
	            }
	            interfaces {
	                lo0.0 {
	                    host-inbound-traffic {
	                        system-services {
	                            ssh;
	                        }
	                    }
	                }
	            }
	        }
	    }
	}
    
